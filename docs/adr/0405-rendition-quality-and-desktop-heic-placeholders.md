# ADR-0405 — Rendition quality per library, and desktop HEIC placeholders that name the way out

* **Status**: **Proposed** — owner to confirm the details. The owner answered the directions on 2026-10-21 in
  [ADR-0214](0214-heic-and-hevc-without-a-system-decoder.md) (question 4: `high` by default; no codec pack, so the apps
  name connected mode or a Mac); this ADR records how they are built. Becomes *Accepted — YYYY-MM-DD*; once accepted,
  only *Superseded by ADR-NNNN* may change it.
* **Requirements**: R-APP-5. **Design**: docs/08 §4.1 (the rendition set) and §11, docs/dev/heic-without-system-decoder.md
  (M1-49, M2-49).

## Context

A HEIC or RAW still reaches clients that cannot decode it through its universal JPEG, which the server renders
(ADR-0084). It was `preview`: long side 2160, q 85, whatever the library. The owner chose `high` as the default
(the original's resolution, q about 92-95, with the gain map of ADR-0390) and `standard` for small disks. On Windows and
Linux, where no codec ships (ADR-0214), a HEIC no decoder takes showed a bare broken-image mark whose cause was a
technical string.

## Decision

* **`libraries.rendition_quality`** (`high` by default, or `standard`; migration 0036). The render specs hold both
  previews: `high` (no long-side cap, a JPEG's largest side of 65,535, q 93 with optimised coding, gain map kept) and
  `standard` (the former spec, 2160 px, q 85). A spec names the quality it is for (`only_for`); the reconciler wants a
  rendition of a library only when the spec is for the library's quality, and the `render` job makes the variant of its
  library and, as for any older spec, deletes the other preview. Thumbnails are the same for both.
* **`AdminService.SetRenditionQuality`** (server administrators, audited as `library.rendition_quality`) sets it; the
  scheduler's reconciler renders the library's previews again. `lossless` is not offered.
* **q 93 through libvips' libjpeg, not jpegli.** libvips has no jpegli encoder here; the quality sits in the owner's
  q 92-95 band and the encoder can change behind the spec's `generator_version`. See the questions of the pull request.
* **Desktop placeholders.** On Windows and Linux outside the browser, a HEIC, HEIF or HIF that every decoder refused is
  marked `noHevc`; its cell (tooltip of the mark, and the hint a screen reader reads) says "Photolib can't show HEIC
  photos on this PC / computer. Connect a Photolib server to see its copy, or open them on a Mac." in every launched
  language. It names connected mode or a Mac, never a codec to install. The web keeps its own reason (ADR-0387).

## Consequences

* A library keeps full-size JPEGs next to its originals: about 450-600 GB per 100,000 photos instead of 35 GB. Its
  administrator can choose `standard` at any time; the change renders every preview of that library again.
* Upgrading re-renders every preview once (the preview spec id changes), as any spec change does.
* No UI sets the quality yet: the admin console is reached through the API as `RelocateLibrary` is.

## Options considered

* **A server-wide setting**: one switch for every library, but the owner asked for a per-library option.
* **jpegli** through a patched libvips or a sidecar encoder: a second encoder to ship for a few percent of size.
* **Rendering `high` lazily**: a second job type and a state per library; the reconciler already does this.
