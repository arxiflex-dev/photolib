//! The route rules (ADR-0038): every procedure passes its rule before its handler runs, a procedure without one is
//! refused, and the handler finds the admitted `Principal` among its request's extensions. Handlers never check
//! permissions themselves: they ask `photolib_authz::can` about what a request names and list through
//! `photolib_authz::scope`.

use std::sync::Arc;

use connectrpc::{
    ConnectError, ErrorCode, Interceptor, Next, NextStream, PayloadStream, RequestContext,
    interceptor::{StreamRequest, StreamResponse, UnaryRequest, UnaryResponse},
};
use photolib_authz::{Action, Principal, Rule};
use uuid::Uuid;

use super::{ApiError, Users};

/// Procedures, as `/package.Service/Method`, and their rules.
pub type Routes = &'static [(&'static str, Rule)];

/// The rule of every procedure; `every_procedure_has_a_rule` keeps it in step with `proto/`.
pub const ROUTES: Routes = &[
    ("/photolib.api.v1.ServerInfoService/GetServerInfo", Rule::Anyone),
    // The one-time setup token in the request is its credential.
    ("/photolib.api.v1.SetupService/CreateFirstAdmin", Rule::Anyone),
    ("/photolib.api.v1.UserService/ListUsers", USERS),
    ("/photolib.api.v1.UserService/CreateUser", USERS),
    ("/photolib.api.v1.UserService/UpdateUser", USERS),
    ("/photolib.api.v1.UserService/DeleteUser", USERS),
    ("/photolib.api.v1.UserService/CreatePasswordSetup", USERS),
    ("/photolib.api.v1.ApiKeyService/ListApiKeys", KEYS),
    ("/photolib.api.v1.ApiKeyService/CreateApiKey", KEYS),
    ("/photolib.api.v1.ApiKeyService/RevokeApiKey", KEYS),
    // An account's own private-mode keys, which no API key manages either.
    ("/photolib.api.v1.KeyService/GetKeys", KEYS),
    ("/photolib.api.v1.KeyService/CreateKeys", KEYS),
    ("/photolib.api.v1.KeyService/PutUnlockPath", KEYS),
    ("/photolib.api.v1.KeyService/VerifyRecoveryKit", KEYS),
    ("/photolib.api.v1.AdminService/GetStatus", SERVER),
    ("/photolib.api.v1.AdminService/ListStores", SERVER),
    ("/photolib.api.v1.AdminService/ListJobs", SERVER),
    ("/photolib.api.v1.AdminService/RetryJob", SERVER),
    ("/photolib.api.v1.AdminService/CancelJob", SERVER),
    // Maintenance types also need `Action::PauseMaintenance`, which the handler asks about the type it names.
    ("/photolib.api.v1.AdminService/PauseJobType", SERVER),
    ("/photolib.api.v1.AdminService/ResumeJobType", SERVER),
    ("/photolib.api.v1.AdminService/Reprocess", SERVER),
    ("/photolib.api.v1.AdminService/ListAuditEvents", SERVER),
    ("/photolib.api.v1.AdminService/TailLogs", SERVER),
    ("/photolib.api.v1.AdminService/GetSettings", SERVER),
    ("/photolib.api.v1.AdminService/UpdateSettings", SERVER),
    ("/photolib.api.v1.AdminService/GetPolicy", SERVER),
    ("/photolib.api.v1.AdminService/UpdatePolicy", SERVER),
    ("/photolib.api.v1.AdminService/ApplyPreset", SERVER),
    ("/photolib.api.v1.AdminService/GetDiagnostics", SERVER),
    ("/photolib.api.v1.AdminService/CreateExternalLibrary", SERVER),
    ("/photolib.api.v1.AdminService/ScanLibrary", SERVER),
    ("/photolib.api.v1.AdminService/BackUpNow", SERVER),
    ("/photolib.api.v1.AdminService/RestoreBackup", SERVER),
    ("/photolib.api.v1.AdminService/ConfirmScan", SERVER),
    ("/photolib.api.v1.AdminService/HintPaths", SERVER),
    ("/photolib.api.v1.AdminService/RelocateLibrary", SERVER),
    ("/photolib.api.v1.AdminService/SetRenditionQuality", SERVER),
    // A password, a password setup token, a second factor, a passkey or the calling session is the credential, which
    // the handler checks; the session procedures act only on the caller's own session, devices and factors.
    ("/photolib.api.v1.AuthService/StartPasswordSetup", Rule::Anyone),
    ("/photolib.api.v1.AuthService/FinishPasswordSetup", Rule::Anyone),
    ("/photolib.api.v1.AuthService/StartLogin", Rule::Anyone),
    ("/photolib.api.v1.AuthService/FinishLogin", Rule::Anyone),
    ("/photolib.api.v1.AuthService/RotateSession", Rule::Anyone),
    ("/photolib.api.v1.AuthService/ListDevices", Rule::Anyone),
    ("/photolib.api.v1.AuthService/RevokeDevice", Rule::Anyone),
    ("/photolib.api.v1.AuthService/ReportBackup", Rule::Anyone),
    // The provider vouches for whoever completes; linking needs the caller's session.
    ("/photolib.api.v1.AuthService/StartOidc", Rule::Anyone),
    ("/photolib.api.v1.AuthService/CompleteOidc", Rule::Anyone),
    // Each stream passes `can` before it reads, and each row `scope`.
    ("/photolib.api.v1.SyncService/Sync", VIEW),
    ("/photolib.api.v1.SyncService/GetTimelineSummary", VIEW),
    // Reads only the caller's own assets, through `scope`.
    ("/photolib.api.v1.SyncService/CheckHashes", VIEW),
    // Each mutation passes `can` for what it changes: viewing for one's own state of an asset, else editing,
    // trashing or contributing.
    ("/photolib.api.v1.SyncService/PushMutations", VIEW),
    // Only the caller's own trashed assets, through `scope` for deleting.
    ("/photolib.api.v1.SyncService/EmptyTrash", VIEW),
    ("/photolib.api.v1.AuthService/FinishSecondFactor", Rule::Anyone),
    ("/photolib.api.v1.AuthService/StartPasskeyLogin", Rule::Anyone),
    ("/photolib.api.v1.AuthService/FinishPasskeyLogin", Rule::Anyone),
    ("/photolib.api.v1.AuthService/StartPasskeySetup", Rule::Anyone),
    ("/photolib.api.v1.AuthService/FinishPasskeySetup", Rule::Anyone),
    ("/photolib.api.v1.AuthService/StartTotpSetup", Rule::Anyone),
    ("/photolib.api.v1.AuthService/FinishTotpSetup", Rule::Anyone),
    ("/photolib.api.v1.AuthService/ListSecondFactors", Rule::Anyone),
    ("/photolib.api.v1.AuthService/DeletePasskey", Rule::Anyone),
    ("/photolib.api.v1.AuthService/DeleteTotp", Rule::Anyone),
    ("/photolib.api.v1.AuthService/CreateRecoveryCodes", Rule::Anyone),
    ("/photolib.api.v1.AuthService/StartStepUp", Rule::Anyone),
    ("/photolib.api.v1.AuthService/FinishStepUp", Rule::Anyone),
    ("/photolib.api.v1.UserService/ResetSecondFactors", USERS),
    // Each event passes `scope`, as a sync row does.
    ("/photolib.api.v1.EventService/ListEvents", VIEW),
    // Each hit passes `scope`, as a sync row does.
    ("/photolib.api.v1.SearchService/SearchText", VIEW),
    ("/photolib.api.v1.SearchService/GetText", VIEW),
    // Only the account signed in, never a key, so that a leaked key cannot set up a lasting leak.
    ("/photolib.api.v1.WebhookService/ListWebhooks", KEYS),
    ("/photolib.api.v1.WebhookService/CreateWebhook", KEYS),
    ("/photolib.api.v1.WebhookService/DeleteWebhook", KEYS),
    // The consent is the account's alone, never a key's; the faces of an asset pass `can` for the asset and the library's
    // face stream.
    ("/photolib.api.v1.FaceService/GetFaceConsent", KEYS),
    ("/photolib.api.v1.FaceService/SetFaceConsent", KEYS),
    ("/photolib.api.v1.FaceService/ListFaces", VIEW),
];

const USERS: Rule = Rule::Server(Action::ManageUsers);
const KEYS: Rule = Rule::Server(Action::ManageKeys);
const SERVER: Rule = Rule::Server(Action::ManageServer);
const VIEW: Rule = Rule::Account(Action::View);

/// Applies `routes` to every call, unary or streaming; `users` says who signs a request, nobody without it.
pub(super) struct Authorize {
    pub routes: Routes,
    pub users: Option<Arc<Users>>,
}

impl Authorize {
    async fn admit(&self, ctx: &mut RequestContext) -> Result<(), ConnectError> {
        let procedure = ctx.path().unwrap_or_default();
        let Some(&(_, rule)) = self.routes.iter().find(|(path, _)| *path == procedure) else {
            tracing::error!(procedure, "a procedure without an authorization rule was refused");
            return Err(ApiError::new(ErrorCode::PermissionDenied, "route.no_rule").into());
        };
        let who = match &self.users {
            Some(users) => users.principal(ctx.headers()).await?,
            None => Some(Principal::Anonymous),
        };
        // A session that must enrol a second factor reaches only what anyone may call, where it enrols (ADR-0088).
        let who = match (who, rule) {
            (Some(who), _) => who,
            (None, Rule::Anyone) => Principal::Anonymous,
            (None, _) => {
                return Err(ApiError::new(ErrorCode::PermissionDenied, "second_factor.required").into());
            }
        };
        if !rule.admits(who) {
            return Err(match who {
                Principal::Anonymous => ApiError::new(ErrorCode::Unauthenticated, "session.required"),
                Principal::Key(user, role, _) if rule.admits(Principal::User(user, role)) => {
                    ApiError::new(ErrorCode::PermissionDenied, "api_key.scope_missing")
                }
                // Every rule that refuses a signed-in principal yet needs an administrator.
                _ => ApiError::new(ErrorCode::PermissionDenied, "user.admin_required"),
            }
            .into());
        }
        ctx.extensions_mut().insert(who);
        Ok(())
    }
}

#[connectrpc::async_trait]
impl Interceptor for Authorize {
    async fn intercept_unary(&self, mut request: UnaryRequest, next: Next<'_>) -> Result<UnaryResponse, ConnectError> {
        self.admit(&mut request.ctx).await?;
        next.run(request).await
    }

    async fn intercept_streaming(
        &self,
        mut request: StreamRequest,
        inbound: PayloadStream,
        next: NextStream<'_>,
    ) -> Result<StreamResponse, ConnectError> {
        self.admit(&mut request.ctx).await?;
        next.run(request, inbound).await
    }
}

/// The principal the rules admitted, and the account it acts for.
pub(super) fn principal(ctx: &RequestContext) -> Result<(Principal, Uuid), ConnectError> {
    let who = ctx.extensions().get().copied().unwrap_or(Principal::Anonymous);
    Ok((who, actor(ctx)?))
}

/// The account the rules admitted, itself or through a key, which a handler names as the actor of a change.
pub(super) fn actor(ctx: &RequestContext) -> Result<Uuid, ConnectError> {
    match ctx.extensions().get() {
        Some(Principal::User(id, _) | Principal::Key(id, ..)) => Ok(*id),
        _ => Err(ApiError::new(ErrorCode::Internal, "server.internal").into()),
    }
}

#[cfg(test)]
mod tests {
    use std::{collections::HashMap, fs, path::Path};

    use axum::{
        body::Body,
        http::{Request, StatusCode},
    };
    use buffa::Enumeration;
    use connectrpc::{Response, ServiceStream, streaming_handler_fn};
    use photolib_proto::proto::photolib::api::v1::{
        ApiKeyScope, GetServerInfoRequest, GetServerInfoResponse, User, UserRole,
    };
    use serde_json::json;
    use tower::ServiceExt;
    use uuid::Uuid;

    use opaque_ke::ServerSetup;
    use rand_core::OsRng;

    use super::*;
    use crate::{
        auth::token_hash,
        keys::{ApiKeys, PREFIX},
        rpc::{
            Auth, api_with,
            keys::tests::key,
            serve,
            users::tests::{app, call, denied, person, stream as streamed, with_admin},
        },
    };

    /// The authz matrix of the API: what every procedure answers each kind of caller before its handler runs, and
    /// the auth service once it has checked the credential it carries. `ok` is admitted (the handler may still refuse
    /// the request), `401` asks to sign in, `403` is refused to the account, `scope` to an API key without the scope,
    /// `2fa` to a session that must enrol a second factor and `step` to one that proved its person more than five
    /// minutes ago (M2-43): every session but `fresh`'s, a user's that just did. `userkey` is the user's API key with
    /// every scope; the admin's are `adminkey`, with every scope, `oldkey`, the same but expired, `viewkey`, with
    /// `view` only, and `serverkey`, with `manage_server` only: a key does what its scopes allow,
    /// never manages keys, and never pauses maintenance, which `PauseJobType` refuses (ADR-0063). The instance requires
    /// a second factor, TOTP, which every account has but `enrolling`, a user.
    const MATRIX: &str = "
                                   nobody stranger invited disabled deleted viewer user enrolling fresh oldkey viewkey userkey admin adminkey serverkey
ServerInfoService/GetServerInfo    ok     ok       ok      ok       ok      ok     ok   ok        ok    ok     ok      ok      ok    ok       ok
SetupService/CreateFirstAdmin      ok     ok       ok      ok       ok      ok     ok   ok        ok    ok     ok      ok      ok    ok       ok
UserService/ListUsers              401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       scope
UserService/CreateUser             401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       scope
UserService/UpdateUser             401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       scope
UserService/DeleteUser             401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       scope
UserService/CreatePasswordSetup    401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       scope
ApiKeyService/ListApiKeys          401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
ApiKeyService/CreateApiKey         401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
ApiKeyService/RevokeApiKey         401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
KeyService/GetKeys                 401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
KeyService/CreateKeys              401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
KeyService/PutUnlockPath           401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
KeyService/VerifyRecoveryKit       401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
AdminService/GetStatus             401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/ListStores            401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/ListJobs              401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/RetryJob              401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/CancelJob             401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/PauseJobType          401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/ResumeJobType         401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/Reprocess             401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/ListAuditEvents       401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/TailLogs              401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/GetSettings           401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/UpdateSettings        401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/GetPolicy             401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/UpdatePolicy          401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/ApplyPreset           401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/GetDiagnostics        401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/CreateExternalLibrary 401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/ScanLibrary           401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/BackUpNow             401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/RestoreBackup         401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/ConfirmScan           401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/HintPaths             401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/RelocateLibrary       401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
AdminService/SetRenditionQuality   401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       ok
SyncService/Sync                   401    401      401     401      401     ok     ok   2fa       ok    401    ok      ok      ok    ok       scope
SyncService/GetTimelineSummary     401    401      401     401      401     ok     ok   2fa       ok    401    ok      ok      ok    ok       scope
SyncService/CheckHashes            401    401      401     401      401     ok     ok   2fa       ok    401    ok      ok      ok    ok       scope
SyncService/PushMutations          401    401      401     401      401     ok     ok   2fa       ok    401    ok      ok      ok    ok       scope
SyncService/EmptyTrash             401    401      401     401      401     ok     ok   2fa       ok    401    ok      ok      ok    ok       scope
EventService/ListEvents            401    401      401     401      401     ok     ok   2fa       ok    401    ok      ok      ok    ok       scope
SearchService/SearchText           401    401      401     401      401     ok     ok   2fa       ok    401    ok      ok      ok    ok       scope
SearchService/GetText              401    401      401     401      401     ok     ok   2fa       ok    401    ok      ok      ok    ok       scope
WebhookService/ListWebhooks        401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
FaceService/GetFaceConsent         401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
FaceService/SetFaceConsent         401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
FaceService/ListFaces              401    401      401     401      401     ok     ok   2fa       ok    401    ok      ok      ok    ok       scope
WebhookService/CreateWebhook       401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
WebhookService/DeleteWebhook       401    401      401     401      401     ok     ok   2fa       ok    401    scope   scope   ok    scope    scope
AuthService/StartPasswordSetup     401    401      401     401      401     step   step ok        ok    401    401     401     step  401      401
AuthService/FinishPasswordSetup    401    401      401     401      401     step   step ok        ok    401    401     401     step  401      401
AuthService/StartLogin             ok     ok       ok      ok       ok      ok     ok   ok        ok    ok     ok      ok      ok    ok       ok
AuthService/FinishLogin            ok     ok       ok      ok       ok      ok     ok   ok        ok    ok     ok      ok      ok    ok       ok
AuthService/FinishSecondFactor     ok     ok       ok      ok       ok      ok     ok   ok        ok    ok     ok      ok      ok    ok       ok
AuthService/StartPasskeyLogin      ok     ok       ok      ok       ok      ok     ok   ok        ok    ok     ok      ok      ok    ok       ok
AuthService/FinishPasskeyLogin     ok     ok       ok      ok       ok      ok     ok   ok        ok    ok     ok      ok      ok    ok       ok
AuthService/ListDevices            401    401      401     401      401     ok     ok   ok        ok    401    401     401     ok    401      401
AuthService/RevokeDevice           401    401      401     401      401     ok     ok   ok        ok    401    401     401     ok    401      401
AuthService/ReportBackup           401    401      401     401      401     ok     ok   ok        ok    401    401     401     ok    401      401
AuthService/StartPasskeySetup      401    401      401     401      401     step   step ok        ok    401    401     401     step  401      401
AuthService/FinishPasskeySetup     401    401      401     401      401     ok     ok   ok        ok    401    401     401     ok    401      401
AuthService/StartTotpSetup         401    401      401     401      401     step   step ok        ok    401    401     401     step  401      401
AuthService/FinishTotpSetup        401    401      401     401      401     ok     ok   ok        ok    401    401     401     ok    401      401
AuthService/ListSecondFactors      401    401      401     401      401     ok     ok   ok        ok    401    401     401     ok    401      401
AuthService/CreateRecoveryCodes    401    401      401     401      401     step   step step      ok    401    401     401     step  401      401
UserService/ResetSecondFactors     401    401      401     401      401     403    403  2fa       403   401    scope   403     ok    ok       scope
AuthService/DeletePasskey          401    401      401     401      401     step   step step      ok    401    401     401     step  401      401
AuthService/DeleteTotp             401    401      401     401      401     step   step step      ok    401    401     401     step  401      401
AuthService/StartStepUp            401    401      401     401      401     ok     ok   ok        ok    401    401     401     ok    401      401
AuthService/FinishStepUp           401    401      401     401      401     ok     ok   ok        ok    401    401     401     ok    401      401
AuthService/RotateSession          401    401      401     401      401     ok     ok   ok        ok    401    401     401     ok    401      401
AuthService/StartOidc              ok     ok       ok      ok       ok      ok     ok   ok        ok    ok     ok      ok      ok    ok       ok
AuthService/CompleteOidc           ok     ok       ok      ok       ok      ok     ok   ok        ok    ok     ok      ok      ok    ok       ok
";

    #[tokio::test]
    async fn every_procedure_answers_every_caller_as_the_matrix_says() {
        let (api, root) = with_admin().await;
        let actor = root.user_id.parse().unwrap();
        let stranger = User {
            user_id: Uuid::now_v7().to_string(),
            ..Default::default()
        };
        let mut callers = HashMap::from([("nobody", None), ("stranger", Some(stranger))]);
        for (name, role, status) in [
            ("invited", UserRole::USER_ROLE_USER, "invited"),
            ("disabled", UserRole::USER_ROLE_ADMIN, "disabled"),
            ("deleted", UserRole::USER_ROLE_ADMIN, "deleted"),
            ("viewer", UserRole::USER_ROLE_VIEWER, "active"),
            ("user", UserRole::USER_ROLE_USER, "active"),
            ("enrolling", UserRole::USER_ROLE_USER, "active"),
            ("fresh", UserRole::USER_ROLE_USER, "active"),
        ] {
            let user = api.accounts.create(actor, person(name, role)).await.unwrap();
            sqlx::query(
                "UPDATE users SET status = $1, purge_at = CASE $1 WHEN 'deleted' THEN now() END WHERE handle = $2",
            )
            .bind(status)
            .bind(name)
            .execute(&api.pool)
            .await
            .unwrap();
            callers.insert(name, Some(user));
        }
        let target = callers["user"].as_ref().unwrap().user_id.clone();
        let (all, user) = (&ApiKeyScope::values()[1..], callers["user"].clone().unwrap());
        for (name, owner, scopes) in [
            ("oldkey", &root, all),
            ("viewkey", &root, &[ApiKeyScope::API_KEY_SCOPE_VIEW][..]),
            ("userkey", &user, all),
            ("adminkey", &root, all),
            ("serverkey", &root, &[ApiKeyScope::API_KEY_SCOPE_MANAGE_SERVER][..]),
        ] {
            callers.insert(name, Some(key(&api.pool, owner, scopes).await));
        }
        sqlx::query("UPDATE api_keys SET expires_at = now() WHERE token_hash = sha256(convert_to($1, 'UTF8'))")
            .bind(&callers["oldkey"].as_ref().unwrap().user_id)
            .execute(&api.pool)
            .await
            .unwrap();
        callers.insert("admin", Some(root));
        // photolibd's wiring: the auth service, with passkeys, signs requests in, and every account has a session whose
        // token is its id, which `call` sends. RotateSession comes last, as it replaces that token.
        let auth = Auth::new(api.pool.clone(), ServerSetup::new(&mut OsRng));
        let auth = Arc::new(auth.with_passkeys(Some(crate::webauthn::tests::rp())));
        let keys = ApiKeys::new(api.pool.clone());
        let users = Users::start(api.accounts.clone(), keys, auth.clone()).await.unwrap();
        let app = app(users, Some(auth), &api.pool, &api.data, &api.tail);
        let accounts = callers.values().flatten();
        for user in accounts.filter(|user| !user.user_id.starts_with(PREFIX)) {
            sqlx::query(
                "WITH device AS (
                    INSERT INTO devices (id, user_id, name, platform)
                    SELECT gen_random_uuid(), id, 'phone', 'android' FROM users WHERE id = $1::uuid RETURNING id
                )
                INSERT INTO sessions (id, device_id, token_hash, expires_at, proved_at)
                SELECT gen_random_uuid(), d.id, $2, now() + interval '1 hour',
                    CASE WHEN u.handle = 'fresh' THEN now() ELSE now() - interval '5 minutes' END
                FROM device d JOIN users u ON u.id = $1::uuid",
            )
            .bind(&user.user_id)
            .bind(token_hash(&user.user_id))
            .execute(&api.pool)
            .await
            .unwrap();
        }
        sqlx::query(
            "WITH policy AS (UPDATE instance_settings SET require_two_factor = true)
             INSERT INTO totp_secrets (user_id, secret, last_step) SELECT id, '\\x00', 0 FROM users
             WHERE handle <> 'enrolling'",
        )
        .execute(&api.pool)
        .await
        .unwrap();
        let mut lines = MATRIX.trim().lines();
        let columns: Vec<&str> = lines.next().unwrap().split_whitespace().collect();
        let rows: Vec<Vec<&str>> = lines.map(|line| line.split_whitespace().collect()).collect();
        let mut procedures: Vec<String> = rows.iter().map(|row| format!("/photolib.api.v1.{}", row[0])).collect();
        procedures.sort();
        assert_eq!(procedures, ruled(), "the matrix has a row for every procedure");
        let mut wrong = vec![];
        for (at, column) in columns.iter().enumerate() {
            let before = api.accounts.list().await.unwrap();
            for row in &rows {
                // What the procedure would change if it ran: an escalation, unless the caller is an administrator.
                let body = match row[0] {
                    "UserService/CreateUser" => {
                        json!({ "user": { "handle": "x", "displayName": "X", "role": "USER_ROLE_ADMIN" } })
                    }
                    "UserService/UpdateUser" => {
                        json!({ "user": { "userId": target, "role": "USER_ROLE_ADMIN" }, "updateMask": "role" })
                    }
                    "UserService/DeleteUser" | "UserService/CreatePasswordSetup" | "UserService/ResetSecondFactors" => {
                        json!({ "userId": target })
                    }
                    _ => json!({}),
                };
                let caller = callers[column].as_ref();
                let answered = match row[0] {
                    "SyncService/Sync" => streamed(&app, row[0], caller, body).await,
                    _ => call(&app, row[0], caller, body).await,
                };
                let answer = match answered {
                    (StatusCode::UNAUTHORIZED, error) if error == denied("unauthenticated", "session.required") => {
                        "401"
                    }
                    (StatusCode::FORBIDDEN, error) if error == denied("permission_denied", "user.admin_required") => {
                        "403"
                    }
                    (StatusCode::FORBIDDEN, error) if error == denied("permission_denied", "api_key.scope_missing") => {
                        "scope"
                    }
                    (StatusCode::FORBIDDEN, error)
                        if error == denied("permission_denied", "second_factor.required") =>
                    {
                        "2fa"
                    }
                    (StatusCode::FORBIDDEN, error) if error == denied("permission_denied", "step_up.required") => {
                        "step"
                    }
                    _ => "ok",
                };
                if answer != row[at + 1] {
                    wrong.push(format!("{} by {column}: {answer}, expected {}", row[0], row[at + 1]));
                }
            }
            if !column.starts_with("admin") {
                assert_eq!(api.accounts.list().await.unwrap(), before, "{column} changed nothing");
            }
        }
        assert!(wrong.is_empty(), "{wrong:#?}");
    }

    #[tokio::test]
    async fn a_procedure_without_a_rule_is_refused() {
        let app = api_with(Uuid::now_v7().to_string(), None, None, None, &[], &[], None);
        assert_eq!(
            call(&app, "ServerInfoService/GetServerInfo", None, json!({})).await,
            (StatusCode::FORBIDDEN, denied("permission_denied", "route.no_rule"))
        );
    }

    const WATCH: &str = "/photolib.api.v1.ServerInfoService/Watch";

    /// The body of a server stream at `WATCH` under `routes`, as text.
    async fn stream(routes: Routes) -> String {
        let handler = streaming_handler_fn(|_, _: GetServerInfoRequest| async {
            let messages: ServiceStream<GetServerInfoResponse> =
                Box::pin(futures::stream::iter([Ok(GetServerInfoResponse::default())]));
            Ok(Response::new(messages))
        });
        let services =
            connectrpc::Router::new().route_server_stream("photolib.api.v1.ServerInfoService", "Watch", handler);
        let request = Request::post(WATCH)
            .header("content-type", "application/connect+json")
            .body(Body::from(&b"\0\0\0\0\x02{}"[..]))
            .unwrap();
        let response = serve(services, routes, None, &[]).oneshot(request).await.unwrap();
        let body = axum::body::to_bytes(response.into_body(), 1 << 20).await;
        String::from_utf8_lossy(&body.unwrap()).into_owned()
    }

    #[tokio::test]
    async fn a_stream_passes_its_rule_before_it_starts() {
        let open = stream(&[(WATCH, Rule::Anyone)]).await;
        assert!(!open.contains("error"), "{open}");
        let denied = stream(&[(WATCH, USERS)]).await;
        assert!(denied.contains(r#""code":"unauthenticated""#), "{denied}");
        let unruled = stream(&[]).await;
        assert!(unruled.contains(r#""code":"permission_denied""#), "{unruled}");
    }

    fn ruled() -> Vec<String> {
        let mut ruled: Vec<String> = ROUTES.iter().map(|(path, _)| path.to_string()).collect();
        ruled.sort();
        ruled
    }

    fn word<'a>(line: &'a str, keyword: &str) -> Option<&'a str> {
        line.strip_prefix(keyword)?.split([' ', ';', '(']).next()
    }

    /// Every procedure declared under `dir`, as `/package.Service/Method`.
    fn procedures(dir: &Path, found: &mut Vec<String>) {
        for entry in fs::read_dir(dir).unwrap() {
            let path = entry.unwrap().path();
            if path.is_dir() {
                procedures(&path, found);
            } else if path.extension().is_some_and(|extension| extension == "proto") {
                let text = fs::read_to_string(&path).unwrap();
                let (mut package, mut service) = ("", "");
                for line in text.lines().map(str::trim) {
                    package = word(line, "package ").unwrap_or(package);
                    service = word(line, "service ").unwrap_or(service);
                    if let Some(method) = word(line, "rpc ") {
                        found.push(format!("/{package}.{service}/{method}"));
                    }
                }
            }
        }
    }

    #[test]
    fn every_procedure_has_a_rule() {
        let mut declared = vec![];
        let proto = Path::new(env!("CARGO_MANIFEST_DIR")).join("../../../proto/photolib");
        procedures(&proto, &mut declared);
        declared.sort();
        assert_eq!(ruled(), declared, "ROUTES names each procedure of proto/ once");
    }
}
