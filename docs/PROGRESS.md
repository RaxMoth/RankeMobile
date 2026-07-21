# PROGRESS

Auto-maintained dashboard for the hourly codebase-improvement loop across both
Ranke repos (RankeMobile Flutter app + RankeBE Go backend). Feature state lives
in [`FEATURES.md`](./FEATURES.md); release notes in [`CHANGELOG.md`](./CHANGELOG.md).

---

## Status

- **Last run:** 2026-07-15T00:20:00+0200
- **Branch:** main (both repos)
- **Mobile build:** `flutter analyze` → ✅ No issues found (after this run's changes).
- **Backend build:** untouched this run; working tree **clean**. Verified this run: `go build ./...` ✅ / `go vet ./...` ✅.
- **Working tree (mobile):** dirty — this run's changes (`activity_screen.dart`, `manage_members_screen.dart`, `strings.dart`) + prior uncommitted run + tracking docs (`FEATURES.md`, `CHANGELOG.md`, `PROGRESS.md`). All new changes awaiting human review.
- **Awaiting direction — no planned features queued.** `FEATURES.md` § In progress and § Planned are both empty. This run did an in-pass Step-2 UX fix (routed two transient-load error states through `ErrorView` with RETRY) + dead-code cleanup. Suggested next steps to promote Ideas → Planned:
  1. **First integration test** — `integration_test` happy path (login → create list → submit entry → view leaderboard) to establish the zero → one test baseline both repos lack. Effort: M. **Highest structural value now that the accessibility + error-UX sweeps are complete.**
  2. **Backend index migration + handler tests** — add the two hot-path indexes (see Open suggestions) and the first `internal/handler` table-driven tests. Needs a migration + `sqlc generate` check. Effort: M.
  3. **`auth_provider` cold-start session restore** — `_load` doesn't restore a session from the stored token on cold start, so users re-auth every launch even with a valid token (`auth_provider.dart:26` TODO). Most user-visible of the 3 open TODOs. Effort: S.

## Last run summary

One verified in-pass UX/error-handling fix from the Step-2 audit + dead-code cleanup + tracker update. `flutter analyze` green after the changes; backend untouched but re-verified (`go build`/`go vet` both ✅).

**Changed this run (verified, uncommitted — mobile):**
- **Error states → `ErrorView` + RETRY (2 screens).** [`activity_screen.dart`](lib/features/activity/presentation/activity_screen.dart) and [`manage_members_screen.dart`](lib/features/lists/presentation/manage_members_screen.dart) previously rendered a static `Center(Text('FAILED TO LOAD…'))` with no recovery path. Both now route their `.when` error branch through the shared [`ErrorView`](lib/shared/widgets/error_view.dart) — typed `ApiError.userMessage` + a RETRY button. Activity retries via `listsProvider.refresh()` (its derived source); members via `ref.invalidate(membersProvider(listId))`. Both notifiers `throw` the `ApiError` directly, so `e` is already typed (with the `e is ApiError ? e : ApiUnknownError(error: e)` guard for safety, matching Home/Discover).
- **Dead-string cleanup.** Removed now-orphaned `S.failedToLoad` and `S.failedToLoadMembers` from [`strings.dart`](lib/core/strings.dart) — their only call sites now render `userMessage`.

**Audit findings this run:**
- **Open-suggestion "7 ad-hoc error states" was partly stale** — Home (`home_screen.dart:161`) and Discover (`discover_screen.dart:169`) *already* use `ErrorView` (fixed a prior run). This run converted the two genuinely-transient remaining ones (activity, members). Remaining: `list_detail` (already offers GO BACK) — a candidate to *add* RETRY, not replace.
- **Terminal-error screens deliberately skipped** — Invite preview ("invalid invite / expired", `invite_preview_screen.dart:58`) and User profile ("user not found", `user_profile_screen.dart:31`) are not transient loads; a RETRY button there would be misleading, so they keep their bespoke terminal layout with GO HOME / GO BACK. Not a gap.
- **Backend re-verified** — `go build ./...` + `go vet ./...` both clean; working tree clean. No new mobile-adjacent quick wins surfaced. `gin.H` ad-hoc responses + missing indexes remain in Open suggestions.

**Audited but deliberately not changed:**
- **`list_detail` error state** — offers GO BACK already; adding RETRY is a nice-to-have, folded into Open suggestions (not urgent, and the detail view's retry wiring is heavier than the two flat lists converted this run).
- **Dependency upgrades** — unchanged; still gated on a test suite existing before autonomously bumping the lockfile.
- **Backend** — no code change; `gin.H` ad-hoc responses + missing indexes remain in Open suggestions.

## Open suggestions

Improvements found but not actioned (need design, or larger than a single safe pass).

**Backend (owner: BE)**
- **[MED] Missing indexes.** Add `idx_refresh_tokens_user_revoked (user_id, revoked)` for bulk revocation on reuse detection, and confirm/`idx_entries_list_user (list_id, user_id)` for the upsert lookup path. New migration file. Effort: S — needs a migration + `sqlc generate` check.
- **[LOW] `gin.H` ad-hoc responses** in ~11 spots vs. the typed `dto` package used elsewhere. Add a `dto.SimpleMessage{Message}` and route the `{"message": …}` responses through it. Effort: S.
- **[LOW] Test coverage.** Only `internal/server/server_test.go` exists. No unit tests for handlers, middleware, the entries value-type sentinels, or the Apple verifier. Effort: M.

**Mobile (owner: FE)**
- **`ErrorView` error-state sweep — nearly done.** Transient-load error branches now route through the shared `ErrorView` (typed message + RETRY): Home, Discover (prior run), **Activity, Manage members (this run)**. **Remaining:** `list_detail_screen.dart:36` already offers GO BACK — could *add* a RETRY (heavier retry wiring than a flat list, so deferred). Intentionally excluded (terminal, non-transient errors): `invite_preview_screen.dart:58` ("invalid invite"), `user_profile_screen.dart:31` ("user not found") — RETRY would be misleading there. Effort: S for the `list_detail` add.
- **3 open `TODO`s in real flows.** `auth_interceptor.dart:66` (on 401 refresh-failure, redirect to login via GoRouter — currently the interceptor just fails the request), `auth_provider.dart:26` (`_load` doesn't restore a session from the stored token on cold start → user re-auths every launch even with a valid token), `list_detail_screen.dart:1237` (social links are inert — `url_launcher` not wired). The `auth_provider` one is the most user-visible. Each needs a small design decision. Effort: S each.
- **Tooltip/`Semantics` coverage on icon-only controls** — the composed-*row* Semantics sweep is now complete (leaderboard rows, board tiles, activity rows). Next accessibility layer: audit standalone `IconButton`/`GestureDetector` taps app-wide for missing `tooltip`/labels (nav icons, FAB, avatar menu, back/close buttons). Not yet surveyed. Effort: S once surveyed.
- **Retry on `list_detail`.** Detail screen error state offers GO BACK (fine); could add RETRY too. Folds into the ad-hoc-error-states pass above. Effort: S.
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
- ~~`0 Semantics` app-wide (composed rows)~~ — **closed** for composed rows: leaderboard `_StandingRow`, `BoardTile`, and activity `_ActivityTile` all announce as single labelled units. Remaining accessibility layer: standalone icon-only controls (see Open suggestions).

---

### How this file is used
Rewritten each loop run. `FEATURES.md` owns feature state; move an idea to
FEATURES § Planned to queue it for the next pass. Never committed by the loop —
changes are left in the working tree for human review.
