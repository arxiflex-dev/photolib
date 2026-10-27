# ADR-0397 — M1-51's amendments to the design repository, as text to apply

* **Status**: **Proposed — owner to confirm**.
* **Requirements**: R-APP-5, LIB-11, ORG-02. **Design**: roadmap M1-15, M2-18, M3-19; docs/10 §5.2; amends nothing
  here, completes [ADR-0290](0290-one-source-tree.md).

## Context

ADR-0290 lists amendments "in the design repository", and PHO-199 asks for them. Agents cannot edit that repository
(`git ls-files | grep -c workitem` is 0 here, `find / -name workitem.py` finds nothing, `gh api
repos/arxiflex-dev/photolib-design` answers 404). The text is therefore kept here for the owner to apply.

## Decision

The design files take these amendments verbatim.

**Roadmap.**

* M1-15 (folders view) reuses `SourceTree` (`app/lib/ui/source_tree.dart`) over `sourceTree` (`photolib_data`): one
  nested tree with an eye per node, as in Settings › Library.
* M2-18 (backup selection) reuses the same `SourceTree` as a second per-node column: back up, don't, inherit. It builds
  no widget of its own.
* M3-19 (server folder browser) reuses `SourceTree` for the folders of server libraries.

**docs/10 §5.2.** `device_folder` holds the folders of every local source: MediaStore buckets and the folders above
them, and the directories of desktop and browser folder roots, their root as `volume`. Each row has an own
`visibility` (`shown`, `hidden`, `inherit`); a node shows what the nearest node at or above it with its own value
says, else the device's mode. `SourceTree` is the one widget that shows and edits it.

**Gate fix (`tools/agent/workitem.py`, unverified here).** Before the item gate runs the app's `flutter test`, it
rebuilds the kernel the way `tools/check.sh`'s `kernel_artifacts` does
(`python3 tools/kernel/build.py --out app/build/kernel linux-x64`), so a kernel changed on main is never tested against
a stale `app/build/kernel`. Test: a gate run on a tree whose kernel sources are newer than `app/build/kernel` must
rebuild it first.

## Consequences

The owner applies the text to the design repository; no code here changes. The gate fix stays unverified until
that file can be edited.

## Options considered

* **Leave the amendments in ADR-0290's list**: they stay a list without wording, and PHO-199 cannot be ticked.
