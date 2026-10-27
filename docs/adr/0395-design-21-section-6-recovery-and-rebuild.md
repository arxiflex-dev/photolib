# ADR-0395 — Design 21 §6 for the L1 recovery code and the rebuild of a store whose keystore key is gone

* **Status**: **Proposed — owner to confirm** (the owner asked for design 21 §6 to say this; agents cannot edit the
  design repository, so the section's text is here for the owner to apply to
  `photolib-design/docs/21-app-passcode-and-local-encryption.md`).

## Context

[ADR-0057](0057-encrypted-local-store.md) built the L1 store: every install encrypts what it stores under a device data
key (DDK) in a lockbox opened by the platform keystore's key `KS_dev` (slot 1). The owner then answered that a store
whose keystore key is gone is rebuilt rather than left dead, and that a local recovery code is offered at L1 too. Code
and tests carry both (`Vault.unlock`, `RecoveryNeeded`, `Vault.rebuilt`, `Vault.addRecoveryCode`, `localOnlyCount`;
`app/packages/photolib_data/test/vault_test.dart`), but design 21 §6 still describes the L1 store as having neither,
so the design and the product disagree.

## Decision

We will replace the L1 part of design 21 §6 with the following text.

> **§6 Losing the keystore key at L1.** The keystore can lose `KS_dev` without the user doing anything: an OEM
> Keystore wipe, a keychain reset, a changed keyring password, a plugin bug. The app never ends up dead.
>
> * **Detection.** The keystore answers but has no `KS_dev`, or one that does not open slot 1 of the lockbox (a
>   damaged lockbox counts as gone too). A keystore that fails to answer is not this case: nothing changes and the app
>   tries again later.
> * **With a local recovery code**, the lockbox has slot 4 (factor 4). Unlock waits (`RecoveryNeeded`) until the user
>   enters the 24 words or chooses to reset. A correct code opens slot 4, yields the DDK and re-seals slot 1 under a
>   new `KS_dev`; the code stays valid. A malformed code
>   (`FormatException`) or a wrong one (`KernelError`) fails and the store stays locked.
> * **Without one**, the store is erased and made anew (`Vault.rebuilt`): the replica syncs again from the server,
>   caches refill, and the library tells the user what was lost, which is only what existed on this device alone.
> * **The local recovery code.** 32 random bytes shown as 24 words of BIP-39's English list. `KEK_rec =
>   HKDF(entropy, …/kek/recovery)` wraps the DDK in slot 4. It is optional. The library offers it while anything exists
>   only on this device (`localOnlyCount`: changes not yet sent and rows no server confirmed); *Later* asks again in
>   30 days; Settings makes one at any time and replaces the previous one. It is as strong as where the user keeps it.

## Consequences

* ✅ Design and product agree; the owner's two answers are written down where the design is read.
* ⚠️ Until the owner copies the text into the design repository, §6 there is out of date; this ADR is the source.
* ⚠️ Without a recovery code, a lost keystore key loses what existed only on the device.

## Options considered

* **Leave §6 as it was**: the design would contradict the shipped behaviour.
* **Edit only ADR-0057**: it already records the decision, but the design is what readers of the passcode and
  encryption chapter see.
