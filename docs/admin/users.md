# Accounts and the first administrator

photolibd has no default account and no default password. The choices behind this page are
[ADR-0035](../adr/0035-accounts-and-first-run.md) and [ADR-0052](../adr/0052-password-login-and-sessions.md).

## First run

When an API process starts and no administrator exists, it logs a one-time setup token at `WARN`:

```json
{"level":"WARN","fields":{"message":"no administrator exists: create the first one with this one-time setup token","setup_token":"3f9c…"}}
```

Whoever presents that token creates the first administrator, and gets a password setup token for them (below); then
setup is closed. In the apps, *Add a server* then *Set up a new server* does all of this: paste the token, choose a
sign-in name and a password, and the app signs you in. Then make a second person an administrator, so that the
server does not depend on you alone: the console's *Accounts* asks for one while there is only one
([admin-succession kit](backups.md#the-admin-succession-kit)). A restart logs a new token and
invalidates the old one. Each API process logs its own token, so set up through the process whose log you read.

```sh
curl -H 'Content-Type: application/json' http://127.0.0.1:8080/photolib.api.v1.SetupService/CreateFirstAdmin \
  -d '{"setupToken":"3f9c…","user":{"handle":"ann","displayName":"Ann","email":"ann@example.org"}}'
```

## A library to back up into

Every account that may upload — any role but `viewer` — gets its managed library *Photos* on the store
[`placement.libraries`](configuration.md#settings) names, as its upload destination: the apps back up into it. A
`worker:io` process creates it moments after the account, or after a viewer gets another role, through the
`library-create` job the account's creation or role change queues; the scheduler queues that job every 15 minutes too,
so that accounts from before libraries came with accounts, and those whose job failed, get theirs. Its id is in the
[admin console](console.md)'s list of libraries, for `photolib upload --library`.

## Roles and statuses

| Role | Can |
|---|---|
| `admin` | Manage the server and its accounts. |
| `user` | Back up and organise their own photos. |
| `viewer` | Browse what others share with them; never upload. |

An account is `active`, `disabled` (cannot sign in), `invited` (never signed in) or `deleted`. A deleted account is
purged seven days later; giving it another status before then restores it. The last active administrator cannot be
demoted, disabled or deleted. Signed-in administrators manage accounts in the [admin console](console.md)
(`UserService`).

Every request passes one authorization policy ([ADR-0038](../adr/0038-authorization-policy.md)): an account sees its
own photos and what libraries, albums, partner shares and public links share with it, never what the owner locked or
trashed; only whoever may delete a photo sees it in the trash and may restore it. A viewer only views and downloads;
an administrator sees no one else's photos.

## Passwords and sign-in

The server never sees a password: apps sign in with OPAQUE, so it stores only a record that checks nothing without
the key file below. People set their own password with a one-time password setup token, valid for seven days: an
administrator makes one in the console (*Password setup link* on an account, `UserService.CreatePasswordSetup`) for a
new account or a forgotten password, the old password working until a new one is set, and sends its link or QR code,
which carry the server's address and the token, by any channel (by e-mail too, once photolibd sends mail). The person
follows the link, whose page on photolibd opens it in the app (*Open in Photolib*), or pastes it into the app's *Add a
server*, and sets the password on their own device; nobody else learns it. For an
account with private libraries, the app says first that a new password does not reopen them: the recovery kit, a
passkey or a device still signed in does.

When the only administrator forgot the password, or setup stopped before their password was set, whoever runs the host
makes the token with the configuration and the database: `photolibd admin password-setup <handle>` prints it, as a
link once `public_url` is set, else as a token that *Set a password* on the app's server page takes; a handle or an
email names the account.

People sign in with their handle or their email. After five attempts on one, the next waits 30 seconds, then twice
as long each time up to an hour; a successful sign-in or a day without attempts resets it. Unknown handles and emails
behave the same, so attempts reveal no accounts. A device that signed in before proves it with the secret its last
sign-in gave it and counts its attempts apart, so someone guessing at a handle locks out only themselves. Other
attempts also count per address (IPv6 per /64): thirty are free, then the same pauses. Behind a proxy that address is
the client's only when the proxy is in `trusted_proxies`, else the proxy's, which every client behind it shares;
loopback and a trusted proxy that names no client are not counted.

Each sign-in is a session of a device. Sessions last 90 days and the apps renew them at a start once fewer than 60 of
the 90 days are left, so a device in use never expires and a lost one does after 90 days; a renewed session's old token
works until the new one is first used, or for 24 hours, so a lost answer signs no device out. Sessions end at the next
request when their device is signed out from any device of the account (*Your devices* on the app's server page,
`AuthService.RevokeDevice`) or the account is disabled or deleted. Sign-ins, password changes and revocations are
audited.

## Single sign-on with OpenID Connect

People can sign in through Authentik, Keycloak, Authelia or a cloud provider such as Google
([ADR-0087](../adr/0087-oidc-single-sign-on.md)). Register photolibd there as a client of the authorization code flow
with PKCE (S256) and the redirect URIs of your apps (`app.photolib:/oidc`) and web app, then add it to the
[configuration](configuration.md#settings):

```yaml
oidc:
  home:                       # the id apps sign in with: a-z, 0-9, - and _
    name: Home SSO            # what the sign-in button says
    issuer: https://sso.example.org/realms/home
    client_id: photolib       # the secret goes in PHOTOLIB_OIDC__HOME__CLIENT_SECRET; none for a public client
    scopes: [openid, profile, email, groups]
    provision: true           # create an account for a person who has none
    link_by_email: false      # sign a person in to the active account with their verified email
    roles: {claim: groups, admin: [photolib-admins], user: [family], viewer: [guests]}
```

A person is the provider's issuer and subject, never their email. They sign in to the account that identity is linked
to; else `link_by_email` links it to the account with their verified email; else `provision` creates one (handle from
their username or email, a suffix if taken); else the sign-in fails with `oidc.not_allowed`. Signed-in people link
more providers to their account. With `roles`, the role follows the claim at every sign-in, whoever maps to no role is
refused, and the last administrator stays one. Disabling an account stops these sign-ins too, and no OIDC sign-in
unlocks a private library.

photolibd checks the provider's issuer, the ID token's signature, audience, nonce and expiry, and the type and size of
each claim it reads: a malformed claim fails that sign-in (`oidc.claim_invalid` names it) and nothing else. Pictures
are never fetched, and a `data:` one is refused. photolibd contacts the provider only while someone signs in, over
HTTPS (HTTP only on localhost), 10 seconds per request; add a private CA to the system's roots or to `SSL_CERT_FILE`.

| Provider | Settings | Checked |
|---|---|---|
| Keycloak 26.8 | Confidential client, standard flow, PKCE method S256; a *Group Membership* mapper `groups` (full paths: `/family`) | A recorded sign-in, replayed by every gate run |
| Authelia 4.39 | `require_pkce: true`, `pkce_challenge_method: S256`, `public: true` or `client_secret_basic`; scope `groups`; profile claims come from userinfo | A recorded sign-in, replayed by every gate run |
| Authentik | OAuth2/OpenID provider with a signing key (RS256; HS256 is refused); the issuer ends with `/` | Its claims, modelled in tests |
| Google | An OAuth client; no groups, so no `roles` | Its claims, modelled in tests |

## Second factors and passkeys

People add second factors through `AuthService` ([ADR-0088](../adr/0088-passkeys-and-totp.md)): a passkey, which needs
[`public_url`](configuration.md#settings) and is bound to its host, or TOTP from an authenticator app. The first one
comes with ten recovery codes, each good once; `AuthService.CreateRecoveryCodes` replaces them. An account with a second
factor finishes every password sign-in with it or a recovery code; five wrong answers end the attempt, and the handle's
lockout above counts until a second factor answers. A passkey that verifies its user (PIN or biometrics) signs in on its
own. Apps run passkey prompts on `/passkey` beneath [`base_path`](configuration.md#settings) in the system browser, so
make sure the proxy passes that path. Changes to second factors and every recovery code used are audited.

Removing a passkey, turning TOTP off, replacing it or the recovery codes, adding a passkey and changing the password
with a session need the session to have proved its person within the last five minutes
([ADR-0242](../adr/0242-step-up.md)): a password or passkey sign-in counts, an OIDC one does not, else the app asks for
the password, an authenticator code or a recovery code first, so a stolen unlocked device cannot strip the account's
second factor or add its own. A first authenticator app, and a first passkey or password of an account that has
nothing to prove itself with, need no proof. Each proof is audited as `session.step_up` and counts towards the lockout.

An administrator can require a second factor in the [admin console](console.md)'s policies (`requireTwoFactor` of
`AdminService.UpdateSettings`). From the next request on, accounts without one, administrators included, can do nothing
but add one; API keys keep working.
For someone who lost every factor and code, `UserService.ResetSecondFactors` removes them, and the password alone signs
in again.

## The OPAQUE key file

`opaque_key_file` holds the server's OPAQUE keys, outside the database so that a leaked database dump cannot be used to
guess passwords: `opaque.key` beside the configuration file unless set, never in `data_dir`, which is synced, shared and
copied and holds the pre-upgrade dumps in `<data_dir>/backups`; photolibd refuses a key there. Without a configuration
file set `PHOTOLIB_OPAQUE_KEY_FILE`, which may name a Docker secret; the compose bundle keeps it in `keys/`. photolibd
creates it (mode 0600) on its first start. **Back it up apart from the database dumps**: without it no password signs
in, and photolibd refuses to start while accounts have passwords; with both, a thief could test guesses offline.

## API keys

Scripts, the CLI and other programs sign requests with an API key instead of a session
([ADR-0055](../adr/0055-scoped-api-keys.md)). A signed-in account creates its keys through `ApiKeyService`; a key
never creates keys. Each key has scopes (`view`, `download`, `contribute`, `edit`, `delete`, `share` and, for an
administrator, `manage_users` and `manage_server`) and does only what both its scopes and its account allow; other
calls fail with `api_key.scope_missing`. It has a required expiry and a rate (600 requests per minute unless set,
`api_key.rate_limited` beyond it, counted per API process); the list shows when it was last used, to the minute. The
secret is shown once:

```sh
curl -H 'Authorization: Bearer plk_3f9c…' -H 'Content-Type: application/json' \
  http://127.0.0.1:8080/photolib.api.v1.UserService/ListUsers -d '{}'
```

Scripts have no OPAQUE client, so whoever runs the host makes the first key:
`photolibd admin api-key <handle> [--scope view --scope contribute …] [--days 365]` prints one, shown once.

Revoking a key, disabling or deleting its account, or its expiry stops it at once. Creating and revoking keys are
audited.

## Audit log

Every change to an account — through photolibd or directly in the database — adds an event to `audit_events` in the
same transaction: who made it (`actor_user_id`, empty for changes made around photolibd), the account and the changed
fields. Handles, names and emails are named, never copied. Events are hash-chained, so a removed or edited event
breaks the chain.

## Privacy on a shared server

Tell the people you create accounts for: standard libraries are files on your disks, so whoever operates the server
can read them; only private (end-to-end encrypted) libraries cannot be read by the operator.
