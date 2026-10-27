//! Pure functions from protobuf bytes to protobuf bytes, shared by the server, the apps and the viewer (ADR-0004).
#![forbid(unsafe_code)]
#![deny(
    clippy::disallowed_methods,
    clippy::disallowed_types,
    clippy::print_stdout,
    clippy::print_stderr,
    clippy::dbg_macro
)]

mod blob;
mod capture_time;
pub mod cluster;
mod develop;
mod edit;
mod faces;
mod geo;
mod keys;
mod live_photo;
mod local;
mod logs;
mod map;
mod metadata;
mod ml;
mod opaque;
mod query;
mod recipe;
mod recovery;
mod share;
mod thumb_hash;

#[allow(clippy::all)]
pub mod proto {
    pub mod kernel {
        pub mod v1 {
            include!("gen/photolib.kernel.v1.rs");
        }
    }
    pub mod model {
        pub mod v1 {
            include!("gen/photolib.model.v1.rs");
        }
    }
}

use prost::{Message, encoding};
use proto::kernel::v1::{
    CallError, CallErrorCode, CallResponse, KeyResponse, Method, ParseQueryRequest, call_response,
};
use std::collections::BTreeMap;
use std::convert::Infallible;
use zeroize::{Zeroize, Zeroizing};

/// Runs the kernel function `method_id` (a `Method`) on `request`, the encoding of its request message, with an empty
/// keyring, and returns an encoded `CallResponse`.
pub fn call(method_id: u32, request: &[u8]) -> Vec<u8> {
    Keyring::default().call(method_id, request)
}

/// A method id that only panics, so that each binding can test that a panic fails just its call.
pub const PANIC_PROBE: u32 = 0x7fff_ffff;

/// The encoded `CallResponse` of a call that panicked (kernel.panic), for the bindings that catch panics.
pub fn panicked() -> Vec<u8> {
    failure(error(CallErrorCode::Panic, &[]))
}

/// 32 bytes of key material, boxed so that the keyring moves only the pointer and the one copy is zeroized on drop.
type Secret = Box<Zeroizing<[u8; 32]>>;

/// The keys of one holder, such as an app's data isolate. Keys enter it by import, derivation or unwrapping and leave
/// it only as handles; dropping the keyring zeroizes them all, as locking the app does.
#[derive(Default)]
pub struct Keyring {
    keys: BTreeMap<u32, Secret>,
    last: u32,
    /// Map indexes (design doc 14) by handle: positions, not keys, living as long as the keyring.
    maps: BTreeMap<u32, cluster::ClusterIndex>,
    last_map: u32,
    /// Places packs (ADR-0405) by handle: public data, held as long as the keyring.
    packs: BTreeMap<u32, geo::Pack>,
    last_pack: u32,
}

impl Keyring {
    /// Runs a kernel function, as `call`, with the keys of this keyring.
    pub fn call(&mut self, method_id: u32, request: &[u8]) -> Vec<u8> {
        self.dispatch(method_id, request).unwrap_or_else(failure)
    }

    /// Opens a stream, as `Stream::open`, with the keys of this keyring.
    pub fn open_stream(&self, method_id: u32, request: &[u8]) -> Stream {
        Stream(match method(method_id) {
            Some(Method::EncryptBlob) => decode(request)
                .and_then(|r| blob::Encryptor::new(self, r))
                .map(Pipe::Encrypt),
            Some(Method::DecryptBlob) => decode(request)
                .and_then(|r| blob::Decryptor::new(self, r))
                .map(Pipe::Decrypt),
            None if method_id == PANIC_PROBE => panic!("the panic probe"),
            _ => Err(error(CallErrorCode::UnknownMethod, &[])),
        })
    }

    /// The encoded `CallResponse` of a call, or its error.
    fn dispatch(&mut self, method_id: u32, request: &[u8]) -> Result<Vec<u8>, CallError> {
        Ok(match method(method_id) {
            Some(Method::ResolveCaptureTime) => reply(capture_time::resolve(&decode(request)?)),
            Some(Method::ParseQuery) => reply(query::parse(&decode::<ParseQueryRequest>(request)?.query)),
            Some(Method::ReadMetadata) => reply(metadata::read(&decode(request)?)),
            Some(Method::ReadHeif) => reply(metadata::read_heif(&decode(request)?)),
            Some(Method::ImportKey) => reply(keys::import(self, decode(request)?)?),
            Some(Method::DropKey) => reply(keys::drop(self, decode(request)?)?),
            Some(Method::DeriveKey) => reply(keys::derive(self, decode(request)?)?),
            Some(Method::DerivePasswordKey) => reply(keys::derive_password(self, decode(request)?)?),
            Some(Method::CheckKdfParams) => reply(keys::check_params(decode(request)?)?),
            Some(Method::EncryptBlob) => blob::encrypt(self, decode(request)?)?,
            Some(Method::DecryptBlob) => blob::decrypt(self, decode(request)?)?,
            Some(Method::WrapKey) => reply(keys::wrap(self, decode(request)?)?),
            Some(Method::UnwrapKey) => reply(keys::unwrap(self, decode(request)?)?),
            Some(Method::SealLockbox) => reply(local::seal_lockbox(self, decode(request)?)?),
            Some(Method::ReadLockbox) => reply(local::read_lockbox(decode(request)?)?),
            Some(Method::OpenLockbox) => reply(local::open_lockbox(self, decode(request)?)?),
            Some(Method::InboxPublicKey) => reply(local::inbox_public_key(self, decode(request)?)?),
            Some(Method::SealJournalEntry) => reply(local::seal_entry(decode(request)?)?),
            Some(Method::OpenJournalEntry) => reply(local::open_entry(self, decode(request)?)?),
            Some(Method::PairLivePhotos) => reply(live_photo::pair(&decode(request)?)),
            Some(Method::PublicKey) => reply(share::public_key(self, decode(request)?)?),
            Some(Method::ShareKey) => reply(share::share(self, decode(request)?)?),
            Some(Method::AcceptKey) => reply(share::accept(self, decode(request)?)?),
            Some(Method::SignEntry) => reply(logs::sign(self, decode(request)?)?),
            Some(Method::VerifyIdentityLog) => reply(logs::verify_identity(decode(request)?)?),
            Some(Method::VerifyMembershipLog) => reply(logs::verify_membership(decode(request)?)?),
            Some(Method::SafetyNumber) => reply(logs::safety_number(decode(request)?)?),
            Some(Method::EpochCode) => reply(logs::epoch_code(decode(request)?)?),
            Some(Method::DedupToken) => reply(keys::dedup_token(self, decode(request)?)?),
            Some(Method::LinkKeys) => reply(keys::link_keys(self, decode(request)?)?),
            Some(Method::LinkFragment) => reply(keys::link_fragment(decode(request)?)?),
            Some(Method::OpaqueRegister) => reply(opaque::register(decode(request)?)?),
            Some(Method::OpaqueLogin) => reply(opaque::login(decode(request)?)?),
            Some(Method::OpaqueServerRegister) => reply(opaque::server_register(decode(request)?)?),
            Some(Method::OpaqueServerLogin) => reply(opaque::server_login(decode(request)?)?),
            Some(Method::Develop) => reply(develop::develop(decode(request)?)?),
            Some(Method::DatabaseKey) => reply(local::database_key(self, decode(request)?)?),
            Some(Method::PrepareImage) => reply(ml::prepare_image(&decode(request)?)?),
            Some(Method::EncodeThumbHash) => reply(thumb_hash::encode(&decode(request)?)?),
            Some(Method::RecoveryPhrase) => reply(recovery::phrase(decode(request)?)?),
            Some(Method::RecoveryKey) => reply(recovery::key(self, decode(request)?)?),
            Some(Method::EditCopy) => reply(edit::edit_copy(decode(request)?)?),
            Some(Method::MapIndexBuild) => reply(map::build(self, decode(request)?)?),
            Some(Method::MapQuery) => reply(map::query(self, &decode(request)?)?),
            Some(Method::MapAssets) => reply(map::assets(self, &decode(request)?)?),
            Some(Method::MapIndexDrop) => reply(map::forget(self, decode(request)?)?),
            Some(Method::GeoLoad) => reply(geo::load(self, &decode(request)?)?),
            Some(Method::GeoResolve) => reply(geo::resolve(self, &decode(request)?)?),
            Some(Method::GeoTimezone) => reply(geo::timezone(self, &decode(request)?)?),
            Some(Method::GeoDrop) => reply(geo::drop_pack(self, decode(request)?)?),
            Some(Method::PrepareFaceDetection) => reply(faces::prepare_detection(&decode(request)?)?),
            Some(Method::AlignFace) => reply(faces::align_face(&decode(request)?)?),
            Some(Method::NormalizeFaceEmbedding) => reply(faces::normalize_embedding(&decode(request)?)?),
            Some(Method::MapFaces) => reply(faces::map_faces(&decode(request)?)?),
            Some(Method::DecodeFaces) => reply(faces::decode_faces(&decode(request)?)?),
            Some(Method::ResolveRecipe) => reply(recipe::resolve(decode(request)?)?),
            Some(Method::MapRegions) => reply(recipe::map_regions(decode(request)?)?),
            Some(Method::CompareRecipes) => reply(recipe::compare(decode(request)?)?),
            Some(Method::RecipeFromDevelop) => reply(recipe::from_develop(decode(request)?)?),
            Some(Method::RenderRecipe) => reply(recipe::render(decode(request)?)?),
            None if method_id == PANIC_PROBE => panic!("the panic probe"),
            _ => return Err(error(CallErrorCode::UnknownMethod, &[])),
        })
    }

    /// The key behind a handle; `field` names the request field in the error when there is none.
    fn key(&self, handle: u32, field: &str) -> Result<&[u8; 32], CallError> {
        self.keys
            .get(&handle)
            .map(|key| &***key)
            .ok_or_else(|| invalid_request(field))
    }

    fn insert(&mut self, secret: Secret) -> KeyResponse {
        self.last += 1;
        let key_id = keys::key_id(&secret).to_vec();
        self.keys.insert(self.last, secret);
        KeyResponse { key: self.last, key_id }
    }
}

/// The caller's randomness, drawn in order: the kernel has no generator of its own. Each function takes exactly the
/// bytes it draws; past them, which only a rejected draw such as an all-zero scalar reaches, it gives ones.
struct Randomness(Zeroizing<Vec<u8>>, usize);

impl Randomness {
    /// Takes the request's `length` bytes, zeroizing its copy, after `skip` zeros for a draw whose bytes go unused.
    fn take(bytes: &mut Vec<u8>, length: usize, skip: usize) -> Result<Self, CallError> {
        if bytes.len() != length {
            return Err(invalid_request("randomness"));
        }
        let mut taken = Zeroizing::new(Vec::with_capacity(skip + length));
        taken.resize(skip, 0);
        taken.extend_from_slice(bytes);
        bytes.zeroize();
        Ok(Self(taken, 0))
    }

    fn fill(&mut self, out: &mut [u8]) {
        for byte in out {
            *byte = self.0.get(self.1).copied().unwrap_or(1);
            self.1 += 1;
        }
    }

    fn word<const N: usize>(&mut self) -> [u8; N] {
        let mut word = [0; N];
        self.fill(&mut word);
        word
    }
}

impl rand_core::TryRng for Randomness {
    type Error = Infallible;

    fn try_next_u32(&mut self) -> Result<u32, Infallible> {
        Ok(u32::from_le_bytes(self.word()))
    }

    fn try_next_u64(&mut self) -> Result<u64, Infallible> {
        Ok(u64::from_le_bytes(self.word()))
    }

    fn try_fill_bytes(&mut self, out: &mut [u8]) -> Result<(), Infallible> {
        self.fill(out);
        Ok(())
    }
}

impl rand_core::TryCryptoRng for Randomness {}

/// A streaming call, for input too large to pass at once (chunked crypto): open it with the request, push the input
/// in pieces and finish it. Each step returns an encoded `CallResponse` whose response is the raw output of that step;
/// after an error, every later step returns the same error.
pub struct Stream(Result<Pipe, CallError>);

enum Pipe {
    Encrypt(blob::Encryptor),
    Decrypt(blob::Decryptor),
}

impl Stream {
    /// Opens a stream, as `Keyring::open_stream`, with an empty keyring.
    pub fn open(method_id: u32, request: &[u8]) -> Stream {
        Keyring::default().open_stream(method_id, request)
    }

    /// A stream whose every step fails with kernel.panic, for a binding that caught a panic while opening one.
    pub fn panicked() -> Stream {
        Stream(Err(error(CallErrorCode::Panic, &[])))
    }

    pub fn push(&mut self, input: &[u8]) -> Vec<u8> {
        let result = match &mut self.0 {
            Ok(Pipe::Encrypt(pipe)) => pipe.push(input, raw_frame),
            Ok(Pipe::Decrypt(pipe)) => pipe.push(input, raw_frame),
            Err(error) => Err(error.clone()),
        };
        if let Err(error) = &result {
            self.0 = Err(error.clone());
        }
        result.unwrap_or_else(failure)
    }

    pub fn finish(self) -> Vec<u8> {
        self.0
            .and_then(|pipe| match pipe {
                Pipe::Encrypt(pipe) => pipe.finish(raw_frame),
                Pipe::Decrypt(pipe) => pipe.finish(raw_frame),
            })
            .unwrap_or_else(failure)
    }
}

fn decode<M: Message + Default>(request: &[u8]) -> Result<M, CallError> {
    M::decode(request).map_err(|_| error(CallErrorCode::InvalidRequest, &[]))
}

fn method(method_id: u32) -> Option<Method> {
    Method::try_from(i32::try_from(method_id).ok()?).ok()
}

/// Starts the encoded `CallResponse` whose response is the `length` bytes the caller appends, so that they are written
/// once, into the buffer the binding receives: a stream step's raw output.
type Frame = fn(usize) -> Vec<u8>;

fn raw_frame(length: usize) -> Vec<u8> {
    let mut out = Vec::with_capacity(1 + encoding::encoded_len_varint(length as u64) + length);
    encoding::encode_key(1, encoding::WireType::LengthDelimited, &mut out);
    encoding::encode_varint(length as u64, &mut out);
    out
}

/// A `Frame` for a response message whose field 1 holds the bytes, such as `DecryptBlobResponse`.
fn message_frame(length: usize) -> Vec<u8> {
    if length == 0 {
        return raw_frame(0);
    }
    let mut out = raw_frame(1 + encoding::encoded_len_varint(length as u64) + length);
    encoding::encode_key(1, encoding::WireType::LengthDelimited, &mut out);
    encoding::encode_varint(length as u64, &mut out);
    out
}

/// The encoded `CallResponse` carrying `message`.
fn reply(message: impl Message) -> Vec<u8> {
    let mut out = raw_frame(message.encoded_len());
    message.encode(&mut out).expect("a Vec grows to fit");
    out
}

fn failure(error: CallError) -> Vec<u8> {
    CallResponse {
        result: Some(call_response::Result::Error(error)),
    }
    .encode_to_vec()
}

/// A failure with its code and parameters, never prose, so that callers can localise it.
fn error(code: CallErrorCode, params: &[(&str, &str)]) -> CallError {
    CallError {
        code: code.into(),
        params: params.iter().map(|(k, v)| (k.to_string(), v.to_string())).collect(),
    }
}

fn invalid_request(field: &str) -> CallError {
    error(CallErrorCode::InvalidRequest, &[("field", field)])
}

/// A reader's failure, with the error code of the crypto specification as its reason.
fn reject(reason: &str) -> CallError {
    let code = match reason {
        "commitment_mismatch" | "auth_failed" => CallErrorCode::DecryptionFailed,
        _ => CallErrorCode::InvalidInput,
    };
    error(code, &[("reason", reason)])
}
