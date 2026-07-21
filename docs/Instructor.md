# INSTRUCTOR.md — Flutter App (iOS)

## Purpose

This file is the single source of truth for implementing the Flutter iOS app for the Ranked Lists app.
Read it fully before writing any code. Every architectural decision is intentional.

---

## Tech Stack

| Concern              | Choice                                            |
| -------------------- | ------------------------------------------------- |
| Platform             | iOS only (min iOS 16)                             |
| State management     | Riverpod (code-gen flavor: `riverpod_annotation`) |
| Navigation           | GoRouter                                          |
| DI / service locator | GetIt                                             |
| HTTP client          | Dio + custom interceptor                          |
| Secure storage       | `flutter_secure_storage`                          |
| Auth                 | Sign in with Apple (`sign_in_with_apple` package) |

---

## Project Structure

```
lib/
├── main.dart                     # App entry, GetIt init, ProviderScope
├── core/
│   ├── di/
│   │   └── injection.dart        # GetIt registration — runs before runApp
│   ├── network/
│   │   ├── api_client.dart       # Dio instance factory
│   │   ├── auth_interceptor.dart # JWT attach + 401 → refresh + retry
│   │   └── api_error.dart        # Typed API error from error envelope
│   ├── router/
│   │   └── router.dart           # GoRouter config, deep link handling
│   └── theme/
│       ├── app_theme.dart
│       ├── colors.dart
│       └── text_styles.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_remote_data_source.dart
│   │   │   └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── auth_repository.dart    # abstract interface
│   │   │   ├── entities/user.dart
│   │   │   └── use_cases/             # login, register, apple_sign_in, logout
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       └── providers/auth_provider.dart
│   ├── lists/
│   │   ├── data/
│   │   │   ├── lists_remote_data_source.dart
│   │   │   └── lists_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── lists_repository.dart
│   │   │   ├── entities/           # RankedList, ListSummary, ListMember
│   │   │   └── use_cases/
│   │   └── presentation/
│   │       ├── home_screen.dart
│   │       ├── list_detail_screen.dart
│   │       ├── create_list_sheet.dart
│   │       ├── invite_preview_screen.dart
│   │       ├── manage_members_screen.dart
│   │       └── providers/
│   ├── entries/
│   │   ├── data/
│   │   │   └── entries_remote_data_source.dart
│   │   ├── domain/
│   │   │   ├── entities/entry.dart
│   │   │   └── use_cases/
│   │   └── presentation/
│   │       ├── submit_entry_sheet.dart
│   │       └── widgets/
│   │           ├── entry_row.dart
│   │           └── duration_picker.dart
│   └── profile/
│       └── presentation/
│           ├── profile_screen.dart
│           └── providers/profile_provider.dart
└── shared/
    └── widgets/
        ├── app_button.dart
        ├── app_text_field.dart
        ├── value_type_badge.dart
        └── error_view.dart
```

---

## Architecture Rules

This is Clean Architecture. The layers are hard boundaries:

### `domain/`

- Pure Dart. Zero Flutter imports. Zero dependencies on `data/` or `presentation/`.
- Contains: abstract repository interfaces, entity classes (immutable, use `freezed`), use case classes.
- Use cases are simple: one public `call()` method, one responsibility.

### `data/`

- Implements domain interfaces.
- Contains: remote data sources (Dio calls), repository implementations, DTO → entity mapping.
- DTOs are JSON-mapped classes (use `json_serializable`). Entities are never JSON-aware.
- Mapping happens in the repository implementation, not in the data source.

### `presentation/`

- Flutter widgets + Riverpod providers/notifiers.
- Providers call use cases (injected via GetIt or passed directly).
- Screens are dumb: they read providers and dispatch events. No business logic.

---

## Dependency Injection (GetIt + Riverpod)

GetIt handles infrastructure (Dio, data sources, repositories, use cases).  
Riverpod handles UI-layer state (AsyncNotifiers, StreamProviders).

### Setup in `injection.dart`

Register in this order:

1. `ApiClient` (Dio instance)
2. Remote data sources
3. Repository implementations (registered as their abstract interface)
4. Use cases

```dart
// Example shape — fill in all registrations
void setupDI() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerFactory<LoginUseCase>(() => LoginUseCase(sl<AuthRepository>()));
  // … etc
}
```

Call `setupDI()` before `runApp()` in `main.dart`.

### Riverpod providers access GetIt

```dart
final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => GetIt.instance<LoginUseCase>(),
);
```

This keeps Riverpod focused on reactive state, GetIt on object graph.

---

## Networking

### Dio Setup (`api_client.dart`)

```dart
// Base URL from flavor/env config
// Timeout: connect 10s, receive 30s
// Add AuthInterceptor
// Add LogInterceptor (debug builds only)
```

### Auth Interceptor (`auth_interceptor.dart`)

On every request:

1. Read access token from `flutter_secure_storage`.
2. Attach `Authorization: Bearer <token>`.

On 401 response:

1. Read refresh token from secure storage.
2. Call `POST /auth/refresh` (using a **separate** Dio instance with no interceptor — avoid infinite loop).
3. If refresh succeeds: save new tokens, retry original request once.
4. If refresh fails (401 or network error): clear tokens → redirect to login via GoRouter.

> **Critical:** Use a lock (e.g., `Mutex` from the `mutex` package) so that if multiple requests 401 simultaneously, only one refresh call is made. All others wait and then retry with the new token.

### Error Handling

Define `ApiError` as a sealed class:

```dart
sealed class ApiError {
  const ApiError();
}

class ApiNetworkError extends ApiError { ... }    // no connectivity
class ApiServerError extends ApiError {           // known error envelope
  final String code;
  final String message;
  final int statusCode;
}
class ApiUnknownError extends ApiError { ... }
```

Every repository method returns `Either<ApiError, T>` (use `fpdart` or `dartz`) or throws typed exceptions — pick one pattern and apply it everywhere. Do not mix.

> Recommendation: use `Either` from `fpdart`. It makes the presentation layer explicit about error states.

---

## Navigation (GoRouter)

### Routes

```
/                         → redirect based on auth state
/login                    → LoginScreen
/register                 → RegisterScreen
/home                     → HomeScreen
/lists/:id                → ListDetailScreen
/lists/:id/members        → ManageMembersScreen
/invite/:token            → InvitePreviewScreen
/profile                  → ProfileScreen
```

### Deep Link (Invite)

iOS requires URL scheme registration in `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array><string>rankapp</string></array>
  </dict>
</array>
```

GoRouter catches `rankapp://invite/<token>` via `redirect` logic and routes to `/invite/:token`.

### Auth Guard

Use a `redirect` callback on GoRouter that checks the auth state provider:

- If not logged in and route is not `/login` or `/register` → redirect to `/login`.
- If logged in and route is `/login` → redirect to `/home`.

---

## Secure Token Storage

Use `flutter_secure_storage` for both tokens. Use named constants for keys:

```dart
const kAccessTokenKey = 'access_token';
const kRefreshTokenKey = 'refresh_token';
```

On logout: delete both keys. On Apple sign-in revocation: also call `POST /auth/logout` before clearing.

---

## State Management Patterns

Use `AsyncNotifier` for screens that load + mutate data.

```dart
// Example shape for ListDetailNotifier
@riverpod
class ListDetail extends _$ListDetail {
  @override
  Future<RankedList> build(String listId) async {
    return ref.watch(getListDetailUseCaseProvider).call(listId);
  }

  Future<void> submitEntry(EntryInput input) async {
    // optimistic update or just invalidate after success
    await ref.read(submitEntryUseCaseProvider).call(listId, input);
    ref.invalidateSelf();
  }
}
```

Rules:

- `ref.invalidateSelf()` after a mutation — re-fetch from server. No manual cache merging in v1.
- Show `AsyncValue.when(data, error, loading)` in every screen. Never ignore `loading` or `error` states.
- Never call use cases directly from widget `build()`. Use `ref.read(provider.notifier).method()` inside callbacks.

---

## Screens Reference

### Login / Register

- Email + password fields with validation.
- "Sign in with Apple" button using `sign_in_with_apple` package.
- On Apple: call `SignInWithApple.getAppleIDCredential(...)` → extract `identityToken` → send to `/auth/apple`.

### Home Screen

- Flat list of `ListSummary` items.
- Each card shows: title, `ValueTypeBadge`, member count, own rank (if entered, e.g. "#3").
- FAB or top-right `+` → opens `CreateListSheet` as modal bottom sheet.
- Pull to refresh.

### List Detail Screen

- Full ranked leaderboard. `EntryRow` widgets in a `ListView`.
- Highlight the current user's row (colored background or badge).
- FAB → opens `SubmitEntrySheet`.
- If user is owner/admin: top-right menu with "Share invite link", "Manage members".
- Share invite: use `Share.share('rankapp://invite/<token>')` (share_plus package).

### Create List Sheet

- Bottom sheet (not a full screen).
- Fields: title (required), description (optional), value type picker (number / duration / text), rank order toggle (high→low / low→high), public/private toggle.
- Disable rank_order toggle for `text` type (always manual).

### Submit Entry Sheet

- Bottom sheet.
- Value input adapts to `value_type`:
    - `number` → `TextFormField` with numeric keyboard.
    - `duration` → `DurationPicker` widget (hh:mm:ss, see below).
    - `text` → `TextFormField` with text keyboard.
- Optional note field (max 200 chars).
- Submit calls `PUT /lists/:id/entries/me`.

### DurationPicker Widget

A custom widget with three `TextFormField`s for hours, minutes, seconds.
On submit, computes `totalMs = (h * 3600 + m * 60 + s) * 1000` and passes to the entry use case.
On display, formats from ms: `String formatDuration(int ms)` → `"1:23:04"`.

### Invite Preview Screen

- Shown when deep link is opened (`/invite/:token`).
- Loads from `GET /lists/invite/:token` (no membership required).
- Shows: list title, value type, top 3 entries, member count.
- "Join" button → calls `POST /lists/invite/:token/join` → on success navigate to `ListDetailScreen`.
- If user is already a member, show "Already joined — View list" instead.

### Manage Members Screen

- List of members with role badges (Owner / Admin / Member).
- Owner can: long-press or swipe → promote to admin, demote to member, remove.
- Cannot remove or demote the owner themselves.

### Profile Screen

- Display name (editable inline or via sheet).
- Stats: lists created count, lists joined count.
- "Sign out" button → calls `POST /auth/logout` → clears tokens → navigates to `/login`.

---

## Value Type Badge Widget

Reusable chip widget used on home screen cards:

```dart
// Usage: ValueTypeBadge(valueType: list.valueType)
// Renders: colored pill with icon — 🔢 Number / ⏱ Duration / 🔤 Text
```

---

## Data Model (Entities — Domain Layer)

```dart
// Use freezed for all entities

@freezed
class RankedList with _$RankedList {
  const factory RankedList({
    required String id,
    required String title,
    String? description,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
    String? inviteToken,       // only present for owner/admin
    required List<RankedEntry> entries,
    required int memberCount,
  }) = _RankedList;
}

@freezed
class RankedEntry with _$RankedEntry {
  const factory RankedEntry({
    required String id,
    required String userId,
    required String displayName,
    required int rank,
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    int? manualRank,
    String? note,
    required DateTime submittedAt,
  }) = _RankedEntry;
}

enum ValueType { number, duration, text }
enum RankOrder { asc, desc }
```

---

## iOS-Specific Requirements

### `Info.plist` additions

- URL scheme for deep links: `rankapp`
- Sign in with Apple capability: add in Xcode → Signing & Capabilities → Sign In with Apple
- Required by App Store: NSUserTrackingUsageDescription (only if analytics added later)

### `sign_in_with_apple` setup

Follow the package README for iOS: add the Associated Domains capability if using web-based redirect, or use `ASAuthorizationAppleIDProvider` natively (the package handles this).

---

## Packages (pubspec.yaml)

```yaml
dependencies:
    flutter_riverpod: ^2.x
    riverpod_annotation: ^2.x
    go_router: ^14.x
    get_it: ^7.x
    dio: ^5.x
    flutter_secure_storage: ^9.x
    sign_in_with_apple: ^6.x
    freezed_annotation: ^2.x
    json_annotation: ^4.x
    fpdart: ^1.x # Either type for error handling
    share_plus: ^10.x # Sharing invite links
    mutex: ^3.x # Lock for refresh token concurrency

dev_dependencies:
    build_runner: ^2.x
    riverpod_generator: ^2.x
    freezed: ^2.x
    json_serializable: ^6.x
```

---

## Code Generation

Run after any entity, DTO, or provider change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Generated files (`*.freezed.dart`, `*.g.dart`, `*.gr.dart`) are committed to the repo.

---

## Out of Scope for v1

- Android support
- Push notifications
- Avatar upload / image picker
- Offline mode / local caching
- Strava / Apple Health integration
- Premium/paid features
- Dark mode (implement theme, leave toggle for later)

The feature structure and DI layer are intentionally extensible. New features get their own `features/<name>/` folder.
