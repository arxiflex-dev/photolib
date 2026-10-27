//! API keys (M2-06, ADR-0055): credentials for scripts, the CLI and other programs, each scoped to some of its
//! account's actions, with an expiry, its last use and a rate of its own. Creating and revoking one is audited.

use std::{
    collections::HashMap,
    sync::Mutex,
    time::{Instant, SystemTime, UNIX_EPOCH},
};

use buffa::EnumValue;
use photolib_authz::{Action, Principal, Role, Scopes};
use photolib_proto::proto::photolib::api::v1::ApiKey;
use sqlx::PgPool;
use uuid::Uuid;

use crate::{
    accounts::{from_db, timestamp, to_db},
    db::DbError,
    secret::random_hex,
};

/// What every secret starts with, so that secret scanners and the API tell it from a session token.
pub const PREFIX: &str = "plk_";
const DEFAULT_PER_MINUTE: u32 = 600;

/// The scopes as `api_keys.scopes` names them, and the actions they allow.
const SCOPES: [(&str, Action); 8] = [
    ("view", Action::View),
    ("download", Action::Download),
    ("contribute", Action::Contribute),
    ("edit", Action::Edit),
    ("delete", Action::Delete),
    ("share", Action::Share),
    ("manage_users", Action::ManageUsers),
    ("manage_server", Action::ManageServer),
];

const COLUMNS: &str = "id::text, name, scopes, (extract(EPOCH FROM expires_at) * 1e6)::bigint, requests_per_minute,
    (extract(EPOCH FROM created_at) * 1e6)::bigint, (extract(EPOCH FROM last_used_at) * 1e6)::bigint,
    (extract(EPOCH FROM revoked_at) * 1e6)::bigint";
type Row = (String, String, Vec<String>, i64, i32, i64, Option<i64>, Option<i64>);

#[derive(Debug)]
pub enum KeyError {
    /// The named field has a value a key cannot take.
    Invalid(&'static str),
    NotFound,
    /// The key made its requests of the minute.
    RateLimited,
    Db(DbError),
}

impl From<DbError> for KeyError {
    fn from(error: DbError) -> Self {
        KeyError::Db(error)
    }
}

impl From<sqlx::Error> for KeyError {
    fn from(error: sqlx::Error) -> Self {
        KeyError::Db(error.into())
    }
}

pub struct ApiKeys {
    pool: PgPool,
    limits: RateLimits,
}

impl ApiKeys {
    pub fn new(pool: PgPool) -> Self {
        ApiKeys {
            pool,
            limits: RateLimits::default(),
        }
    }

    /// Creates a key of `user` with the name, scopes, expiry and rate of `key`; returns it and its secret.
    pub async fn create(&self, user: Uuid, key: ApiKey) -> Result<(ApiKey, String), KeyError> {
        let name = key.name.trim();
        if name.is_empty() || name.chars().count() > 100 || name.chars().any(char::is_control) {
            return Err(KeyError::Invalid("name"));
        }
        let mut scopes: Vec<String> = key
            .scopes
            .iter()
            .map(|scope| to_db(scope, "API_KEY_SCOPE_").ok_or(KeyError::Invalid("scopes")))
            .collect::<Result<_, _>>()?;
        scopes.sort_by_key(|name| SCOPES.iter().position(|(scope, _)| scope == name));
        scopes.dedup();
        if scopes.is_empty() {
            return Err(KeyError::Invalid("scopes"));
        }
        let now = SystemTime::now().duration_since(UNIX_EPOCH).unwrap_or_default();
        let expires = key.expires_at.as_option().map(|at| (at.seconds, at.nanos));
        // Up to 9999-12-31T23:59:59Z, the last instant of a protobuf timestamp.
        let future = now.as_secs() as i64 + 1..=253_402_300_799;
        let Some((seconds, nanos)) = expires.filter(|(seconds, _)| future.contains(seconds)) else {
            return Err(KeyError::Invalid("expires_at"));
        };
        let per_minute = match key.requests_per_minute {
            0 => DEFAULT_PER_MINUTE,
            rate @ 1..=60_000 => rate,
            _ => return Err(KeyError::Invalid("requests_per_minute")),
        };
        let secret = format!("{PREFIX}{}", random_hex());
        let mut tx = self.pool.begin().await?;
        let row: Row = sqlx::query_as(&format!(
            "INSERT INTO api_keys (id, user_id, name, token_hash, scopes, expires_at, requests_per_minute)
             VALUES ($1::uuid, $2::uuid, $3, sha256(convert_to($4, 'UTF8')), $5,
                 to_timestamp($6::float8 + $7::float8 / 1e9), $8)
             RETURNING {COLUMNS}"
        ))
        .bind(Uuid::now_v7().to_string())
        .bind(user.to_string())
        .bind(name)
        .bind(&secret)
        .bind(&scopes)
        .bind(seconds as f64)
        .bind(f64::from(nanos))
        .bind(per_minute as i32)
        .fetch_one(&mut *tx)
        .await?;
        audit(&mut tx, &user.to_string(), "api_key.create", &row.0).await?;
        tx.commit().await?;
        Ok((from_row(row)?, secret))
    }

    /// The keys of `user`, newest first.
    pub async fn list(&self, user: Uuid) -> Result<Vec<ApiKey>, DbError> {
        let rows: Vec<Row> = sqlx::query_as(&format!(
            "SELECT {COLUMNS} FROM api_keys WHERE user_id = $1::uuid ORDER BY id DESC"
        ))
        .bind(user.to_string())
        .fetch_all(&self.pool)
        .await?;
        rows.into_iter().map(from_row).collect()
    }

    /// Revokes the key `id` of `user`, unless it is revoked already.
    pub async fn revoke(&self, user: Uuid, id: &str) -> Result<ApiKey, KeyError> {
        let id: Uuid = id.parse().map_err(|_| KeyError::Invalid("api_key_id"))?;
        let (id, user) = (id.to_string(), user.to_string());
        let mut tx = self.pool.begin().await?;
        let revoked = sqlx::query(
            "UPDATE api_keys SET revoked_at = now()
             WHERE id = $1::uuid AND user_id = $2::uuid AND revoked_at IS NULL",
        )
        .bind(&id)
        .bind(&user)
        .execute(&mut *tx)
        .await?;
        if revoked.rows_affected() > 0 {
            audit(&mut tx, &user, "api_key.revoke", &id).await?;
        }
        let row: Option<Row> = sqlx::query_as(&format!(
            "SELECT {COLUMNS} FROM api_keys WHERE id = $1::uuid AND user_id = $2::uuid"
        ))
        .bind(&id)
        .bind(&user)
        .fetch_optional(&mut *tx)
        .await?;
        tx.commit().await?;
        Ok(from_row(row.ok_or(KeyError::NotFound)?)?)
    }

    /// Who a request that carries `secret` comes from: the key's account within its scopes, or nobody when the key is
    /// unknown, revoked or expired or its account inactive. Records the use, and refuses a request beyond the rate.
    pub async fn principal(&self, secret: &str) -> Result<Principal, KeyError> {
        let key: Option<(String, String, String, Vec<String>, i32)> = sqlx::query_as(
            "WITH key AS (
                SELECT k.id, k.user_id, u.role, k.scopes, k.requests_per_minute
                FROM api_keys k JOIN users u ON u.id = k.user_id
                WHERE k.token_hash = sha256(convert_to($1, 'UTF8')) AND k.revoked_at IS NULL
                    AND k.expires_at > now() AND u.status = 'active'
            ), used AS (
                UPDATE api_keys SET last_used_at = now() WHERE id IN (SELECT id FROM key)
                    AND (last_used_at IS NULL OR last_used_at < now() - interval '1 minute')
            )
            SELECT id::text, user_id::text, role, scopes, requests_per_minute FROM key",
        )
        .bind(secret)
        .fetch_optional(&self.pool)
        .await?;
        let Some((id, user, role, scopes, per_minute)) = key else {
            return Ok(Principal::Anonymous);
        };
        if !self.limits.admit(&id, per_minute as u32, Instant::now()) {
            return Err(KeyError::RateLimited);
        }
        let role = role_named(&role);
        let scopes = SCOPES
            .iter()
            .filter(|(name, _)| scopes.iter().any(|scope| scope == name))
            .map(|&(_, action)| action);
        let user = user.parse().map_err(|_| KeyError::Db("a stored id".into()))?;
        Ok(Principal::Key(user, role, scopes.collect::<Scopes>()))
    }
}

/// `photolibd admin api-key <handle>`: an API key for an active account, made on the host by no OPAQUE sign-in, so that
/// a script (`curl`, `photolib upload`) can start; the secret is shown once.
pub async fn host_api_key(
    config: &crate::config::Config,
    handle: &str,
    name: &str,
    scopes: &[String],
    days: u32,
) -> Result<String, String> {
    use photolib_proto::proto::photolib::api::v1::ApiKeyScope;
    let url = config.database.url.as_ref().ok_or("database.url is not set")?;
    let scopes = scopes
        .iter()
        .map(|scope| from_db::<ApiKeyScope>(scope, "API_KEY_SCOPE_").map_err(|_| format!("{scope} is not a scope")))
        .collect::<Result<Vec<_>, _>>()?;
    let pool = PgPool::connect(url.expose())
        .await
        .map_err(|error| format!("cannot connect to the database: {error}"))?;
    let handle = handle.trim().to_lowercase();
    let account: Option<String> =
        sqlx::query_scalar("SELECT id::text FROM users WHERE (handle = $1 OR email = $1) AND status = 'active'")
            .bind(&handle)
            .fetch_optional(&pool)
            .await
            .map_err(|error| format!("cannot read the accounts: {error}"))?;
    let user = account.ok_or_else(|| format!("no active account is {handle}"))?;
    let user = user.parse().map_err(|_| "an account id is not a uuid")?;
    let expires = SystemTime::now() + std::time::Duration::from_secs(u64::from(days) * 86_400);
    let key = ApiKey {
        name: name.into(),
        scopes,
        expires_at: Some(expires.into()).into(),
        ..Default::default()
    };
    let (_, secret) = ApiKeys::new(pool)
        .create(user, key)
        .await
        .map_err(|error| format!("cannot make the key: {error:?}"))?;
    Ok(format!(
        "An API key for {handle}, valid for {days} days; it is shown once:\n{secret}"
    ))
}

/// The role `users.role` names; an unknown one gets the fewest rights.
pub(crate) fn role_named(name: &str) -> Role {
    match name {
        "admin" => Role::Admin,
        "user" => Role::User,
        _ => Role::Viewer,
    }
}

async fn audit(tx: &mut sqlx::PgConnection, user: &str, action: &str, id: &str) -> Result<(), sqlx::Error> {
    sqlx::query("SELECT audit_append($1::uuid, $2, jsonb_build_object('api_key_id', $3::text), NULL)")
        .bind(user)
        .bind(action)
        .bind(id)
        .execute(tx)
        .await
        .map(drop)
}

fn from_row(row: Row) -> Result<ApiKey, DbError> {
    let (id, name, scopes, expires_at, per_minute, created_at, last_used_at, revoked_at) = row;
    Ok(ApiKey {
        api_key_id: id,
        name,
        scopes: scopes
            .iter()
            .map(|scope| from_db(scope, "API_KEY_SCOPE_"))
            .collect::<Result<Vec<EnumValue<_>>, _>>()?,
        expires_at: Some(timestamp(expires_at)).into(),
        requests_per_minute: per_minute as u32,
        created_at: Some(timestamp(created_at)).into(),
        last_used_at: last_used_at.map(timestamp).into(),
        revoked_at: revoked_at.map(timestamp).into(),
        ..Default::default()
    })
}

/// Each key's requests: a bucket that holds a minute's worth and refills at the key's rate. Each API process counts
/// its own.
#[derive(Default)]
struct RateLimits(Mutex<HashMap<String, (Instant, f64)>>);

impl RateLimits {
    fn admit(&self, key: &str, per_minute: u32, now: Instant) -> bool {
        let rate = f64::from(per_minute);
        let mut buckets = self.0.lock().unwrap_or_else(|poisoned| poisoned.into_inner());
        let (at, tokens) = buckets.entry(key.into()).or_insert((now, rate));
        let refilled = now.saturating_duration_since(*at).as_secs_f64() * rate / 60.0;
        (*at, *tokens) = (now, (*tokens + refilled).min(rate));
        let admitted = *tokens >= 1.0;
        if admitted {
            *tokens -= 1.0;
        }
        admitted
    }
}

#[cfg(test)]
mod tests {
    use std::time::Duration;

    use super::*;

    #[test]
    fn a_key_makes_a_minute_of_requests_at_once_then_more_at_its_rate() {
        let (limits, start) = (RateLimits::default(), Instant::now());
        let at = |seconds: u64| start + Duration::from_secs(seconds);
        let admitted = [0, 0, 0, 0, 19, 21, 21, 61, 61, 61, 600, 600, 600, 600]
            .map(|seconds| u8::from(limits.admit("a", 3, at(seconds))));
        assert_eq!(admitted, [1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0]);
        assert!(limits.admit("b", 3, at(600)), "each key has its own");
    }
}
