# ML models

photolibd downloads models only from its compiled-in [registry][registry], each pinned by SHA-256 and listed with
the licence of its weights; every one of them is permissive or attribution-licensed. Models live in `ml.models_dir`,
by default `<data_dir>/models`, one `<id>@<revision>` directory each. The choices are
[ADR-0064](../adr/0064-model-registry-and-licence-gate.md) and, for running them, [ADR-0245](../adr/0245-server-ml-role.md).

## Downloading

photolibd downloads models only when told to:

```sh
photolibd --config photolib.yaml models fetch            # every model in the registry but the optional ones
photolibd --config photolib.yaml models fetch yunet sface
photolibd --config photolib.yaml models fetch auraface    # an optional model, only when named
```

It fetches the files the server runs and those devices run from the hosts the [privacy manifest](privacy.md) lists,
trying a file's next URL after 30 s without data. It keeps a download only when its SHA-256 and size match the registry
and skips what is installed. Search with SigLIP 2 takes about 1.1 GB, faces about 40 MB.

## Faces

Faces are found only for accounts that agreed to the notice in the app (*Settings › Faces and people*), whatever this
server installs or is configured to do: a switch of the account's own, which an API key cannot set
([ADR-0389](../adr/0389-face-detection-and-embeddings.md)). YuNet finds them and SFace describes them (about 40 MB);
`ml.face_embedder: auraface` describes them with AuraFace instead (Apache-2.0, 261 MB, installed with
`models fetch auraface`), and `ml.faces: false` turns the server's face jobs off. The `ml` role queues a job for each
photo of an agreeing account, and for up to 16 frames of each video, two seconds apart at least, when `ffmpeg_dir` is
set. A person who withdraws has their faces, descriptions, people and scans deleted at once, on the server and in their
apps. Embeddings of different models are never compared: switching the model scans everything again. The
`face_recognition` policy switch of the [console](console.md) still turns faces off per server, account or library.

## Devices

Signed-in apps download the files they run of installed registry models from photolibd, resuming broken downloads:
`GET /models/<id>@<revision>/<file>`. Files only the server runs and bring-your-own models are never served.

## Air-gapped servers

A bundle is a tar of `<id>@<revision>` directories. Make one on a connected machine and import it offline:

```sh
photolibd --config connected.yaml models fetch
tar -cf models.tar -C /connected/data/models .
photolibd --config photolib.yaml models import models.tar
```

Every file is checked against the registry first, and nothing is installed unless the whole bundle checks out.

## Bring your own model

A model that is not in the registry, such as InsightFace's non-commercial weights, can only be imported. Put its
files and a `manifest.json` in the registry's format in its `<id>@<revision>` directory. The import refuses it with a
warning naming its licence until you accept that licence by its SPDX id:

```sh
photolibd --config photolib.yaml models import insightface.tar --accept-licence LicenseRef-insightface-non-commercial
```

Photolib never downloads a bring-your-own model or sends it to devices; using it within its licence is up to you.
Its `manifest.json` needs a `golden` for each file, as the registry's have, or it does not run (see below).

## Running models

The `ml` role runs the installed models with [ONNX Runtime](https://onnxruntime.ai) 1.31, which photolibd loads from
`ml.runtime`: the official CPU build of its release page, or a build with this machine's accelerators (CUDA,
OpenVINO, ROCm through MIGraphX, CoreML). Without installed models it loads nothing.

At every start it runs each model's golden input on every backend the library has, the CPU first. The CPU must
reproduce the registry's golden outputs (cosine 0.999), an accelerator must come within 0.99 of them, and each model
runs on the first that does. A backend that fails or gives other outputs is disabled for that model: the log says so,
`photolib_ml_backend_disabled` counts it, `PhotolibMlBackendDisabled` alerts and the `ml` check of
[`photolibd doctor`](console.md#photolibd-doctor) and the admin console's diagnostics names it. If even the CPU
cannot reproduce them, after an ONNX Runtime upgrade for instance, the model does not run and the check fails.

## Reading text in photos

`photolibd models fetch ppocr-v5-det ppocr-v5-rec-latin ppocr-v5-rec-eslav ppocr-v5-rec-chinese` installs PP-OCRv5
(Apache-2.0): a detector of lines of text and recognisers for Latin, Cyrillic and Chinese or Japanese script (about
190 MB). A process with the `ml` role and a database then reads every image once (the `ocr` job; `ml.ocr: false`
turns it off) and keeps the text, which the apps search and show in the viewer's *Copy text*. Search matches any part
of the text in any case and needs PostgreSQL built with ICU. A remote `ml` node without a database does not read
text yet. The text is what a picture says, whoever made it: it is stored cleaned of control characters and shown only
as text.

Models load when used and unload after 5 minutes unused. Batches have 1, 8 or 32 items, and the process stays under
`ml.memory_mb` (2000 MB): a model that would not fit beside the others unloads the least recently used one first. A
process with the `ml` role restarts itself once at start with glibc's `MALLOC_ARENA_MAX`, `MALLOC_MMAP_THRESHOLD_`
and `MALLOC_TRIM_THRESHOLD_` set, so that what models free goes back to the system.

A machine with a GPU can run the role for a server without one: install photolibd, ONNX Runtime and the models there,
and give both the same `ml.token` (`openssl rand -hex 16`):

```yaml
# the GPU machine: photolibd --config ml.yaml --role ml
config_version: 1
listen: 127.0.0.1:8080
ml: {runtime: /opt/onnxruntime/lib/libonnxruntime.so, models_dir: /srv/models, server: "https://photos.example.com"}
# the server: ml: {token: ...}, or PHOTOLIB_ML__TOKEN on both
```

The node needs no database and no `data_dir`; it sends its self-test to the server every 5 minutes, and the server's
`ml` check warns of a node silent for 15 minutes. The jobs a node runs arrive with the first models that index (M5-04).
The container image cannot run models yet: its Alpine base lacks the glibc ONNX Runtime's builds need.

[registry]: https://github.com/arxiflex-dev/photolib/blob/main/server/crates/photolib-models/registry.json
