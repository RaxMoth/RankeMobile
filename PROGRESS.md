# Progress Tracker

Last loop run: 2026-06-12T14:44:15+0200
Stack: flutter

This file is **owned by `/loop`**. It is reconciled against the codebase on
every iteration. Don't hand-edit "Done" — move items between sections instead.

The source spec is [`Instructor.md`](./Instructor.md).

---

## Done

All v1 spec items shipped per `Instructor.md`:

- [x] Clean architecture per feature (`domain/` → `data/` → `presentation/`) — every feature module respects the layer boundary
- [x] DI: GetIt for infrastructure, Riverpod for UI state — `lib/core/di/injection.dart`
- [x] Dio + AuthInterceptor with mutex-protected refresh — `lib/core/network/auth_interceptor.dart`
- [x] `ApiError` sealed class + `Either<ApiError, T>` via fpdart — `lib/core/network/api_error.dart`
- [x] GoRouter with auth-guard redirect + `StatefulShellRoute` — `lib/core/router/router.dart`
- [x] Deep link `rankapp://invite/<token>` → `/invite/:token`
- [x] `flutter_secure_storage` for tokens, keys via `AppConstants`
- [x] Sign in with Apple (login + register screens)
- [x] Auth screens (`login_screen.dart`, `register_screen.dart`)
- [x] Home screen with filter bar (compact segmented pill) + bottom-nav (icon-only)
- [x] Discover screen for public board search
- [x] List detail with ranked leaderboard + own-row highlight
- [x] Create / edit list bottom sheets
- [x] Submit entry sheet with type-aware input (number / `DurationPicker` / text)
- [x] Invite preview screen
- [x] Manage members screen
- [x] Profile screen + public user profile screen + settings screen
- [x] Activity feed feature (extra polish beyond spec)
- [x] Onboarding flow (extra polish beyond spec)
- [x] Shared widgets: `app_button`, `app_text_field`, `value_type_badge`, `error_view`, `board_tile`, `create_fab`, `bottom_sheet_handle`, `sheet_action_row`, `shimmer_loading`, `user_avatar_menu`
- [x] freezed entities for `RankedList`, `RankedEntry`, `User`, `EntryInput`
- [x] Mock dev mode (`lib/core/dev/dev_config.dart`) toggled via `--dart-define=USE_MOCK=true`
- [x] **Backend alignment (Phase 2A/2B)** — central `ApiPaths`, envelope helpers, camelCase contract, moderation endpoints, server-side `previous_rank`
- [x] **Backend production hardening (Phase 2C)** — request ID + slog, IP rate limit on `/auth/*`, body-size cap, HTTP timeouts, refresh-token reuse detection, JWT secret strength check, Apple S2S notification handler, account deletion (App Store 5.1.1(v))

## In Progress

_(none)_

## Backlog (from spec, not started)

_(none — full v1 spec is shipped)_

## Proposed (NOT approved — do not implement)

Add ideas here only with the `(NOT approved)` marker. The loop never builds these
until a human moves them to Backlog or marks them approved.

- [ ] Riverpod codegen migration — every provider in `lib/features/` is hand-rolled (`Provider(...)`, `AsyncNotifierProvider(...)`). Spec calls for `riverpod_annotation`. Migration would consolidate over `@riverpod` annotations, give us free `keepAlive`/`autoDispose` ergonomics, and eliminate the family-key boilerplate in `lists_provider.dart`. **Effort: M.** **Native features:** `riverpod_generator`, `@Riverpod(keepAlive:...)`. Status: _awaiting review_.
- [ ] `RestorableProperty` for filter/tab state — Home filter, bottom-nav index and create-list sheet step are all `Provider`/local state. Wiring them through `RestorableProperty` would preserve them across iOS process suspension/restoration. **Effort: S.** **Native features:** `RestorationMixin`, `RestorableInt`. Status: _awaiting review_.
- [ ] `Sliver*` migration for List Detail leaderboard — currently a `ListView`; with hundreds of entries the `SliverList.builder` + `SliverPersistentHeader` for the rank-1 podium would deliver visibly smoother scrolling on iPhone 12-class devices. **Effort: M.** **Native features:** `SliverList`, `SliverPersistentHeader`, `CustomScrollView`. Status: _awaiting review_.
- [ ] `SelectableText` for entry notes — entry rows currently use `Text` for the optional note. `SelectableText` lets users copy a note without long-press menus we'd have to build ourselves. **Effort: S.** **Native features:** `SelectableText.rich`. Status: _awaiting review_.
- [ ] Integration test harness via `integration_test` package — there are no widget or integration tests today. A single happy-path test (login → create list → submit entry → view leaderboard) would catch most regressions. **Effort: M.** **Native features:** `integration_test`, `WidgetTester`, `find.bySemanticsLabel`. Status: _awaiting review_.

## Tech Debt / Improvements

Audit findings from this iteration. The loop addresses one item per pass.

- [x] `MediaQuery.of(context).viewInsets` in three sheets → migrate to `MediaQuery.viewInsetsOf(context)` for granular rebuild subscription (Flutter 3.10+ native feature). _Done this iteration._
- [ ] **Hand-rolled providers everywhere.** 8+ files declare `Provider(...)` / `AsyncNotifierProvider(...)` / `FamilyAsyncNotifierProvider(...)`. Spec specifies `riverpod_annotation` codegen flavor. Migration would eliminate the typing boilerplate around families. _Not actioned (see Proposed)._
- [ ] **Low `dispose()` coverage.** Only ~10 files call `dispose()` while ~9 use `TextEditingController`/`ScrollController`/`AnimationController`. Audit each controller-owning widget to confirm correct lifecycle and prevent leaks. **Effort: S.** _Open._
- [ ] **`flutter pub outdated` not run in CI.** Detect packages with newer compatible versions on every loop pass. **Effort: XS.** _Open._
- [ ] **No `flutter test` coverage at all.** Zero unit / widget tests. Even one smoke test per feature would catch the most disruptive regressions. _Open (see Proposed for integration test harness)._
- [ ] **Hardcoded animation durations.** `Duration(milliseconds: 180)` is duplicated across screens though `lib/core/theme/animations.dart` already exists with `AppAnimations.short`. Sweep + replace. **Effort: S.** _Open._

---

## How to use this file

- **/loop** automatically runs through Sync → Audit → Pick one task → Verify → Update this file → Report.
- To approve a Proposed idea, move it to **Backlog** (delete the `(NOT approved)` marker) and the next loop will pick it up by priority.
- To mark something as in-progress manually, move it from Backlog into **In Progress** before invoking /loop.
- Don't expect /loop to ship more than one task per invocation — by design.
