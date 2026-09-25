# Changelog

All notable changes to the Ranke (Apex) iOS app are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project has not yet cut a public release; everything to date lives under Unreleased.

## [Unreleased]

### Added
- **First integration test** (`integration_test/app_flow_test.dart`): the happy path login → create a number board → submit an entry → approve it as owner → entry ranked #1 on the leaderboard, run against the mock repos on the iOS simulator (`flutter test integration_test --dart-define=USE_MOCK=true`). Widgets are found via new stable `AppKeys` (`lib/core/app_keys.dart`) or semantics labels, never by copy or layout. Passes on an iPhone 15 Pro simulator (iOS 18) in ~13s.
- Regression widget test `test/features/lists/create_list_keyboard_test.dart` guarding the create-flow keyboard fix below.
- `FEATURES.md` canonical feature tracker and this `CHANGELOG.md` (hourly improvement loop bootstrap).
- Retry affordance on failed loads: Home and Discover error states now use the shared `ErrorView` (typed message + RETRY button) instead of a dead-end error label / raw exception dump.
- Retry affordance extended to the **Activity feed** and **Manage members** screens: both now route their `.when` error branch through the shared `ErrorView` (typed `ApiError.userMessage` + RETRY) instead of a static "FAILED TO LOAD" label. Activity retries via `listsProvider.refresh()` (its source), members via `ref.invalidate(membersProvider(listId))`. The intentionally-terminal error screens (Invite preview "invalid invite", User profile "user not found") are left as-is — those aren't transient loads and RETRY would be misleading.
- Accessibility: VoiceOver `tooltip`/semantic label on the Discover search "clear" icon button.
- iOS polish: haptic feedback (`HapticFeedback.selectionClick()`) on bottom-nav **tab switch** — both the tap path and the swipe-to-switch gesture in `app_shell.dart`. Completes the haptic-feedback pass (submit / create / bookmark / filter pill were already covered); tab switch was the last uncovered key interaction.
- Accessibility: leaderboard standing rows (`_StandingRow` in `list_detail_screen.dart`) now announce as a single VoiceOver unit via `MergeSemantics` + a composed `S.standingSemantic(...)` label ("Rank 3, JANE, 42, note: …") with `ExcludeSemantics` on the visual children. Previously the row read as disconnected fragments — the padded rank digits as "zero one", the decorative avatar initial as a stray letter, then name and value separately. First `Semantics` usage in the codebase.
- Accessibility: board tiles (`BoardTile`, used on Home / Discover / Profile / bookmarks) now announce as a single labelled VoiceOver button via a composed `S.boardTileSemantic(...)` label ("MOVIE NIGHT board, 12 members, your rank 3"), with the fragmented title / member-count / entry-preview `Text` nodes wrapped in `ExcludeSemantics`. The nested bookmark toggle is kept un-excluded with its own `Semantics(button, label: 'Remove bookmark')` so it remains an independently focusable control — the sub-button-inside-a-button case that had blocked this fix in prior passes. Visual layout unchanged.
- Accessibility: activity-feed rows (`_ActivityTile` in `activity_screen.dart`) now announce as a single VoiceOver button via a composed `S.activitySemantic(...)` label ("JANE submitted at rank #3, in MOVIE NIGHT, 5 minutes ago"), with the headline / board-name / timestamp `Text` nodes and the decorative kind-icon wrapped in `ExcludeSemantics`. The terse all-caps visual timestamp ("5D AGO") is expanded to natural language in the spoken label via new `S.dAgoSpoken`/`hAgoSpoken`/`mAgoSpoken`/`justNowSpoken` helpers. Completes the composed-row Semantics sweep — leaderboard rows, board tiles, and activity rows are now all single-unit announcements.

### Changed
- Migrated stray hardcoded `Duration(milliseconds: 180)` tap-state animations to `AppAnimations.short` + `AppAnimations.curve` (`create_list_sheet.dart`, `home_screen.dart`).
- Migrated `MediaQuery.of(context).viewInsets` → `MediaQuery.viewInsetsOf(context)` in bottom sheets for granular rebuild subscription.
- **Backend observability:** every server-side 500 path now logs a correlated `slog.Error` (request_id + operation + cause) before returning the opaque body. Added `InternalErrorLog(c, op, err)` helper and wired all 20 previously-silent `InternalError(c)` sites across `lists.go`, `entries.go`, and `users.go` — a prod 500 now leaves a debuggable trail instead of vanishing.
- **Backend:** entries service now returns typed sentinel errors (`ErrInvalidValueType`, `ErrListLocked`) matched with `errors.Is`, replacing the fragile `err.Error()` string switch in the handler (following the `auth.go` sentinel pattern).
- **Backend:** `apple/verify.go` `containsString` helper replaced with stdlib `slices.Contains` (Go 1.21+).

### Fixed
- **Create-board flow collapsed behind the keyboard.** The bottom bar added `viewInsets.bottom` padding read from a context *above* the Scaffold, on top of the Scaffold's own keyboard avoidance — the keyboard was counted twice and the step pages collapsed to 0pt, so the title field vanished while typing into it. Removed the redundant inset (`create_list_sheet.dart`). Found by the new integration test.
- **Login screen overflowed (~104pt) with the keyboard up.** The form was a fixed `Column`; it's now a `SingleChildScrollView` that stays vertically centred when there's room (`login_screen.dart`). Found by the new integration test.
- Auth error SnackBars leaked raw developer text to users. `login_screen.dart` and `register_screen.dart` showed `next.error.toString()` — e.g. `ApiServerError(401): INVALID_CREDENTIALS — …` — on failed sign-in/registration. They now render the localized `ApiError.userMessage` (falling back to `S.genericError` for non-`ApiError` failures such as the Apple identity-token path). Added a reusable `ApiErrorMessage` extension (`api_error.dart`) and routed `ErrorView` through it too, de-duplicating the previously-inlined `ApiError` → message switch.
- **Backend:** `RequireListRole` middleware ran its `GetListMember` DB query on `context.Background()`, dropping request deadline/cancellation propagation on every role-protected request. Now uses `c.Request.Context()`.

### Security
- **Backend (defense-in-depth):** added `max=` binding bounds on unbounded free-text request fields — `createList`/`updateList` `title` (255) and `description` (2000), and `updateMe` `displayName` (60, matching registration). Caps payload bloat / oversized-row writes.

### Removed
- Dead `containsString` helper in `apple/verify.go` (replaced by stdlib `slices.Contains`).
- Dead string constants `S.failedToLoad` and `S.failedToLoadMembers` (their only call sites now render `ApiError.userMessage` through `ErrorView`).

---

## History (pre-changelog)

Prior to the changelog bootstrap, the app reached full v1 feature parity with `Instructor.md`:

- **Backend production hardening (Phase 2C)** — request ID + slog, IP rate limit on `/auth/*`, body-size cap, HTTP timeouts, refresh-token reuse detection, JWT secret strength check, Apple S2S notifications, account deletion.
- **Backend contract alignment (Phase 2A/2B)** — central `ApiPaths`, envelope helpers, camelCase contract, moderation endpoints, server-side `previous_rank`.
- **Full app architecture** — clean architecture per feature, GoRouter `StatefulShellRoute`, Dio + mutex refresh, fpdart `Either`, freezed entities, GetIt + Riverpod, Sign in with Apple, dev mock mode, and all v1 screens (auth, home, discover, list detail, create/edit, submit entry, invite, members, profile, settings, activity, onboarding).
