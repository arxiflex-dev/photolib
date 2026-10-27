# ADR-0384 — The map view: kernel clustering on the device, raster tiles on consent, area as a search filter

* **Status**: **Proposed — owner to confirm** (roadmap M1-45 "Map view with clustering and timeline integration", MAP-12).
* **Requirements**: F-11. **Design**: docs/14-maps-places-memories.md (not in this repository; read conservatively).

## Context

The map belongs to the standalone gallery (the owner, 2026-10-23): it runs on the device's replica and needs no
server. It has to hold a million located photos and videos and pan smoothly on a phone. The design document the item
cites, and the M3-16 tile server, are not in this repository, so the item was built on its most conservative reading.

## Decision

We will build:

1. **Clustering in the kernel** (`kernel/src/cluster.rs`), pure Rust: Web Mercator, one Morton-keyed 64 px grid per
   zoom 0 to 15, each built from the finer one in a linear pass; zoom 16 and deeper return single assets. A viewport
   query is a handful of binary searches (a million assets index in about half a second, a query takes milliseconds).
2. **The index lives in a `Keyring`** (`map.proto`, methods 44 to 47: build, query, assets, drop), named by a handle
   like keys are, so that every binding (C ABI, WebAssembly) offers it without a new entry point. A time range and a
   lasso polygon filter a query by a scan of the leaves instead of a lookup.
3. **The app runs the index off the UI isolate** (`openMapKernel`: an isolate of its own natively, the page in a
   browser), packs its build request by hand, and reads the located items from the replica as the timeline shows them
   (`geoPoints`), so no schema changes.
4. **The background is OpenStreetMap's raster tiles, on consent**: nothing is requested until the user taps *Show the
   background* (the existing `Settings.maps`); the client names the app and gives up on a tile after 10 s. The
   privacy manifest's *Map tiles* row lists the host. Vector tiles with a theme come with the offline packs.
5. **The map as a search filter is the viewport's (or the lasso's bounding) box**: `LocalQuery.area`, a chip in Search.
6. **GPX tracks** (MAP-12) are read in the app (`xml`, a DOCTYPE refused, 32 MB at most) and drawn by activity colour.

The page, in Chrome's phone emulation over a million synthetic located photos
(`app/benchmark/map_web.dart`, screenshots cropped to the page, made for this ADR from that build; no tile loaded):
the world as clusters, a zoom to single photos, the heatmap, and a lasso around one.

![The world at a million photos](assets/0384/world-1m.jpg) ![Zoomed to single photos](assets/0384/zoomed.jpg)
![Heatmap](assets/0384/heatmap.jpg) ![A lasso](assets/0384/lasso.jpg)

## Consequences

Panning needs no network and no server. A new filter is a field of `MapFilter`. The lasso filters the map and its
grid exactly, but a search by the lasso is its bounding box. The tile host and policy are one constant and one
manifest row to change. Its speed is held by the `map-pan` budget ([ADR-0403](0403-map-pan-budget.md)).

## Options considered

* **Clustering in Dart or SQL**: slower at a million items and written twice for the server's M2-50; rejected.
* **A stateless call carrying the points each time**: megabytes per pan; rejected for the keyring handle.
* **Tiles on by default**: reveals the viewed area; rejected, the manifest requires an opt-in.
* **Exact polygon search**: needs the matching ids in the query; the box is simpler and reversible.
