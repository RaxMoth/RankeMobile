# Ranke — Feature Tracker

Canonical wanted-feature list for the Ranke (Apex) iOS app + Go backend.
Maintained by the hourly codebase-improvement loop and by hand. Source of
truth for "what's shipped vs. planned". See also [`CHANGELOG.md`](./CHANGELOG.md)
(release history) and [`PROGRESS.md`](./PROGRESS.md) (per-run dashboard).

---

## Shipped

Full v1 spec (per `Instructor.md` / `CLAUDE.md`) is shipped.

### Architecture / infra
- **Clean architecture per feature** — `domain/` → `data/` → `presentation/` boundary respected across all modules.
- **DI** — GetIt for infrastructure (repos + use cases), Riverpod for UI state (`lib/core/di/injection.dart`).
- **Networking** — Dio + `AuthInterceptor` with mutex-protected JWT refresh (`lib/core/network/auth_interceptor.dart`).
- **Error handling** — `ApiError` sealed class + `Either<ApiError, T>` via fpdart (`lib/core/network/api_error.dart`).
- **Navigation** — GoRouter with auth-guard redirect + `StatefulShellRoute` (4 tabs), deep link `rankapp://invite/<token>` → `/invite/:token`.
- **Secure storage** — `flutter_secure_storage` for tokens, keys via `AppConstants`.
- **Dev mode** — in-memory mock repos, 7 seeded boards, toggled via `--dart-define=USE_MOCK=true` (`lib/core/dev/dev_config.dart`).

### Screens / features
- **Auth** — login + register screens, Sign in with Apple.
- **Home** — board list with segmented filter pill + icon-only bottom nav.
- **Discover** — public board search.
- **List detail** — ranked leaderboard with own-row highlight.
- **Create / edit list** — bottom sheets with type-aware config.
- **Submit entry** — type-aware input (number / `DurationPicker` / text).
- **Invite preview** — deep-link invite acceptance screen.
- **Manage members** — role management (owner/admin/member).
- **Profile** — own profile + public user profile + settings screen.
- **Activity feed** — extra polish beyond spec.
- **Onboarding** — first-run flow, extra polish beyond spec.
- **Bookmarks** — board bookmarking (`bookmark_provider.dart`).

### iOS polish
- **Haptic feedback pass** — `HapticFeedback` across key interactions: submit entry, create list, bookmark toggle, board-tile long-press, FAB, avatar menu, onboarding, home filter pill, and (2026-07-06) bottom-nav **tab switch** via both tap and swipe. Idea → Shipped.
- **Native share sheets** — `SharePlus` for invite links (list detail + manage members) and board sharing (`board_tile.dart`) via the native iOS share sheet. Idea → Shipped (share_plus already a direct dependency).

### Accessibility
- **Leaderboard row VoiceOver labels** (2026-07-14) — each `_StandingRow` on List Detail now announces as one merged unit (`MergeSemantics` + composed `S.standingSemantic(...)` label + `ExcludeSemantics` on the visual children) instead of reading as disconnected fragments ("zero one", a stray avatar initial, name, value). First `Semantics` usage in the app; establishes the pattern for other composed rows.
- **Board tile VoiceOver labels** (2026-07-14) — `BoardTile` (Home / Discover / Profile / bookmarks) now announces as one labelled button via `S.boardTileSemantic(...)` ("MOVIE NIGHT board, 12 members, your rank 3") with the fragmented title/count/entry-preview `Text` nodes wrapped in `ExcludeSemantics`. The nested bookmark toggle is left un-excluded and given its own `Semantics(button, label: 'Remove bookmark')` so it stays independently focusable — the case that had blocked this in prior passes. Layout unchanged.

### Backend
- **Contract alignment (Phase 2A/2B)** — central `ApiPaths`, envelope helpers, camelCase contract, moderation endpoints, server-side `previous_rank`.
- **Production hardening (Phase 2C)** — request ID + slog, IP rate limit on `/auth/*`, body-size cap, HTTP timeouts, refresh-token reuse detection, JWT secret strength check, Apple S2S notification handler, account deletion (App Store 5.1.1(v)).

### Compliance
- **Sign in with Apple** — required social-login parity (App Store).
- **Account deletion** — in-app account deletion (App Store 5.1.1(v)).

## In progress

_(none)_

## Planned

Prioritized. Nothing here is started; the loop picks the top item when In progress is empty.

_(none currently promoted from Ideas — see Ideas parking lot)_

## Ideas

Parking lot — not approved for build. Move an item up to **Planned** to queue it.

- **Riverpod codegen migration** — providers are hand-rolled (`Provider(...)`, `AsyncNotifierProvider(...)`). Migrate to `@riverpod` codegen for free `keepAlive`/`autoDispose` + less family boilerplate. Effort: M.
- **`RestorableProperty` for filter/tab state** — preserve Home filter, nav index, create-sheet step across iOS process suspension/restoration via `RestorationMixin`. Effort: S.
- **`Sliver*` migration for List Detail leaderboard** — `CustomScrollView` + `SliverList.builder` + `SliverPersistentHeader` podium for smoother scroll with hundreds of entries. Effort: M.
- **`SelectableText` for entry notes** — let users copy a note without custom long-press menu. Effort: S.
- **Semantics pass — activity-feed rows** — `BoardTile` and the leaderboard are now done (see Shipped § Accessibility). Remaining composed-row target: the activity-feed rows (`_ActivityRow`), which read as fragmented name/rank/timestamp pieces. Apply the same `S.*Semantic(...)` + `ExcludeSemantics` pattern. Effort: S.
- **Integration test harness** — `integration_test` package; one happy-path test (login → create list → submit entry → view leaderboard). Effort: M.

## Backend ideas

- **Handler test coverage** — no `*_test.go` under `internal/handler/`; add table-driven tests for auth + entries. Effort: M.
- **Index audit** — verify indexes exist for hot query shapes (entries by list_id, membership lookups). Effort: S once query shapes confirmed.
