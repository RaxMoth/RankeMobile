# PROGRESS

Auto-maintained dashboard for the hourly codebase-improvement loop across both
Ranke repos (RankeMobile Flutter app + RankeBE Go backend). Feature state lives
in [`FEATURES.md`](./FEATURES.md); release notes in [`CHANGELOG.md`](./CHANGELOG.md).

---

## Status

- **Last run:** 2026-07-14T21:05:00+0200
- **Branch:** main (both repos)
- **Mobile build:** `flutter analyze` → ✅ No issues found (after this run's change)
- **Backend build:** untouched this run; working tree **clean** (human committed prior backend edits). Last known: `go build ./...` ✅ / `go vet ./...` ✅.
- **Working tree (mobile):** dirty — this run's changes (`board_tile.dart`, `strings.dart`, `api_error.dart`, `error_view.dart`, `login_screen.dart`, `register_screen.dart`) + prior runs' still-uncommitted mobile changes (`app_shell.dart`, `home_screen.dart`, `discover_screen.dart`, `list_detail_screen.dart`) + tracking docs. All awaiting human review.
- **Awaiting direction — no planned features queued.** `FEATURES.md` § In progress and § Planned are both empty. This run executed the top standing proposal (BoardTile semantics — proposal #1 for two consecutive runs) as an in-pass Step-2 fix rather than promoting an Idea. Suggested next steps to promote Ideas → Planned:
  1. **Activity-feed row semantics** — the composed-label pattern is now proven on both `_StandingRow` and `BoardTile`. `_ActivityRow` is the last fragmented composed row. Straightforward, no sub-button complication. Effort: S.
  2. **First integration test** — `integration_test` happy path (login → create list → submit entry → view leaderboard) to establish the zero → one test baseline both repos lack. Effort: M.
  3. **Backend index migration + handler tests** — add the two hot-path indexes (see Open suggestions) and the first `internal/handler` table-driven tests. Needs a migration + `sqlc generate` check. Effort: M.

## Last run summary

Accessibility fix (Step-2 audit, top standing proposal) + tracker update. `flutter analyze` green after the change; backend untouched (working tree already clean).

**Changed this run (verified, uncommitted — mobile):**
- **Board tile VoiceOver labels [accessibility].** [`board_tile.dart`](lib/shared/widgets/board_tile.dart) — wrapped `BoardTile` in `Semantics(button: true, label: …)` with a new composed [`S.boardTileSemantic(...)`](lib/core/strings.dart) label ("MOVIE NIGHT board, 12 members, your rank 3"). The fragmented visual `Text` nodes (title, member count, own-rank, and each `_EntryPreviewRow`) are individually wrapped in `ExcludeSemantics` so VoiceOver stops reading them as disconnected pieces. **Solved the case that blocked this in two prior passes:** the nested bookmark toggle in `_buildTrailing` is deliberately left un-excluded and given its own `Semantics(button, label: S.removeBookmarkAction)`, so it remains an independently focusable sub-button inside the tile-button. The decorative chevron (non-bookmark trailing) is `ExcludeSemantics`-wrapped. Chose per-node exclusion over a single blanket `ExcludeSemantics` specifically to keep the sub-button accessible **and** preserve the exact visual layout (a structural pull-out of the toggle would have shifted the value column / narrowed the preview rows). `dart format` applied. `BoardTile` is the app's single most-repeated interactive element (Home list, Discover results, Profile, bookmarks), so this closes the highest-fanout item in the "0 Semantics app-wide" audit thread.

**Audit findings this run:**
- **BoardTile semantics (proposal #1, deferred twice)** — **fixed** (above). The prior blocker ("blanket `ExcludeSemantics` would break the nested bookmark toggle") is resolved via per-node exclusion + a dedicated toggle `Semantics` node.
- **Semantics coverage** — after this run, `Semantics` is used in `list_detail_screen.dart` (leaderboard rows) and `board_tile.dart` (tiles). Remaining fragmented composed row: activity-feed `_ActivityRow` (now proposal #1 in Status / Idea in FEATURES).
- A broader read-only string/accessibility/magic-number audit (background agent) was in flight at run end; any concrete new items it surfaced should be triaged into Open suggestions next run.

**Audited but deliberately not changed:**
- **Layout-preserving vs. structural refactor of `BoardTile`** — considered pulling the trailing toggle out to a top-level Row sibling for a single-`ExcludeSemantics` solution; rejected because it would reposition the value column / narrow preview rows on tiles with entry previews. Per-node exclusion keeps pixels identical.
- **Dependency upgrades** — unchanged; still gated on a test suite existing before autonomously bumping the lockfile.
- **Backend** — no new mobile-adjacent quick wins; `gin.H` ad-hoc responses + missing indexes remain in Open suggestions.

## Open suggestions

Improvements found but not actioned (need design, or larger than a single safe pass).

**Backend (owner: BE)**
- **[MED] Missing indexes.** Add `idx_refresh_tokens_user_revoked (user_id, revoked)` for bulk revocation on reuse detection, and confirm/`idx_entries_list_user (list_id, user_id)` for the upsert lookup path. New migration file. Effort: S — needs a migration + `sqlc generate` check.
- **[LOW] `gin.H` ad-hoc responses** in ~11 spots vs. the typed `dto` package used elsewhere. Add a `dto.SimpleMessage{Message}` and route the `{"message": …}` responses through it. Effort: S.
- **[LOW] Test coverage.** Only `internal/server/server_test.go` exists. No unit tests for handlers, middleware, the entries value-type sentinels, or the Apple verifier. Effort: M.

**Mobile (owner: FE)**
- **Activity-feed row semantics.** Last fragmented composed row after this run's BoardTile fix. Apply `S.*Semantic(...)` + `ExcludeSemantics` to `_ActivityRow`. No sub-button complication (simpler than BoardTile was). Effort: S.
- **Retry on `list_detail`.** Detail screen error state offers GO BACK (fine); could add RETRY too. Effort: S.
- **Riverpod codegen migration** (see FEATURES § Ideas) — providers are hand-rolled; `@riverpod` would cut family boilerplate. Effort: M. Architectural — write up before building.
- **`flutter pub outdated` in the loop** — not run automatically; add to the audit step to catch newer compatible deps. Effort: XS.
- **Integration test harness** (`integration_test`) — zero widget/integration tests today. One happy-path flow would catch most regressions. Effort: M.

## Tech debt watchlist

- **No automated tests, either repo** — 1 backend integration test, 0 mobile tests. Highest structural risk; every change is verified only by `analyze`/`build`/`vet`.
- **Discover pagination** — `SearchPublicLists` is a hardcoded `LIMIT 100` full scan; needs cursor-based pagination before the board count grows. Needs design.
- **No hot-path index audit** — membership + entry-upsert lookups run without confirmed covering indexes (see Open suggestions § Missing indexes).
- **Hand-rolled Riverpod providers** — works, but diverges from the spec's `riverpod_annotation` flavor; family key boilerplate is the cost.
- ~~Backend observability gaps~~ — **resolved** (all 20 500-paths now log correlated `slog.Error`).
- ~~Stringly-typed service errors (entries)~~ — **resolved** (typed sentinels + `errors.Is`).
- ~~`0 Semantics` app-wide~~ — **substantially closed** (leaderboard rows + board tiles labelled; activity rows remain, tracked as an Idea).

---

### How this file is used
Rewritten each loop run. `FEATURES.md` owns feature state; move an idea to
FEATURES § Planned to queue it for the next pass. Never committed by the loop —
changes are left in the working tree for human review.
