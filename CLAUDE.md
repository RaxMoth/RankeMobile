# Ranke Mobile (Apex)

You are a **principal Flutter engineer** building a production iOS app for the Apple App Store.

## Project Identity

- **Product**: Ranke — collaborative ranking/leaderboard platform
- **Brand**: Apex (used in UI)
- **Platform**: iOS only, min iOS 16
- **Theme**: Dark terminal aesthetic (#0A0A0A background, #D4A017 amber accent)

## Architecture

Clean Architecture per feature module: `domain/` → `data/` → `presentation/`

```
lib/
  core/           # DI, networking, router, theme, dev mode
  features/
    auth/         # Login, register, Apple Sign In
    lists/        # Boards: home, discover, detail, create, edit, members
    entries/      # Entry submission with typed inputs
    profile/      # User profile + stats
    shell/        # Bottom nav shell
  shared/widgets/ # Reusable UI components
```

### Stack
- **State**: Riverpod (`AsyncNotifier`, `FamilyAsyncNotifier`)
- **DI**: GetIt (repositories + use cases registered in `core/di/injection.dart`)
- **Navigation**: GoRouter with `StatefulShellRoute` (4 tabs: HOME / DISCOVER / CREATE / PROFILE)
- **Networking**: Dio + AuthInterceptor (JWT refresh with Mutex)
- **Error handling**: fpdart `Either<ApiError, T>` — sealed class pattern
- **Entities**: Freezed immutable data classes
- **Auth**: Apple Sign In required (App Store rule if any social login)

### Dev Mode
`lib/core/dev/dev_config.dart` — set `useDevMode = true` to swap real API repos with in-memory mock repos. Mock data includes 7 seeded boards with realistic entries. Toggle in `injection.dart`.

## Mobile-First Rules

This is a phone app. Every UI decision must prioritize mobile UX:

- **No horizontal scroll card lists** — use full-width vertical list tiles
- **Standard iOS patterns**: vertical lists, bottom sheets, pull-to-refresh, swipe gestures
- **Touch targets**: minimum 44pt per Apple HIG
- **Keyboard handling**: bottom sheets must account for `viewInsets.bottom`
- **SafeArea**: all screens must respect safe areas (notch, home indicator)
- **Text**: must remain readable at iOS accessibility text sizes
- **Fixed widths**: avoid hardcoded pixel widths — use `Expanded`, `Flexible`, `MediaQuery`
- **Bottom nav**: 4 tabs max (we have exactly 4)

## Apple App Store Compliance

These rules must be followed for App Store approval:

- **2.1 Completeness**: No placeholder/TODO screens in production. Every screen must be fully functional.
- **4.0 Design**: Follow Human Interface Guidelines. Dark theme must maintain WCAG contrast ratios.
- **4.2 Minimum Functionality**: App must offer value beyond a website. Our real-time leaderboards, typed entry submission, and social features qualify.
- **4.3 No Spam**: No duplicate or template-like screens.
- **5.1.1 Privacy**: Privacy policy URL required before submission. Must declare all data collection.
- **Sign in with Apple**: Required when offering any third-party social login.
- **3.1.1 In-App Purchase**: If monetizing, must use Apple IAP. No links to external payment.
- **No external browser launches for core functionality** — everything stays in-app.

## Build Commands

```bash
# Regenerate freezed/json_serializable code after entity changes
dart run build_runner build --delete-conflicting-outputs

# Analyze for errors
flutter analyze

# Run on iOS simulator
flutter run

# Build for simulator
flutter build ios --simulator
```

## Key Files

| Purpose | Path |
|---------|------|
| Entry point | `lib/main.dart` |
| DI setup | `lib/core/di/injection.dart` |
| Router | `lib/core/router/router.dart` |
| Theme | `lib/core/theme/app_theme.dart` |
| Colors | `lib/core/theme/colors.dart` |
| Text styles | `lib/core/theme/text_styles.dart` |
| Dev config | `lib/core/dev/dev_config.dart` |
| Mock lists repo | `lib/core/dev/mock_lists_repository.dart` |
| Entities | `lib/features/lists/domain/entities/ranked_list.dart` |
| Lists providers | `lib/features/lists/presentation/providers/lists_provider.dart` |
| Auth provider | `lib/features/auth/presentation/providers/auth_provider.dart` |

## Entities

- `RankedList` — id, title, description, valueType, rankOrder, isPublic, locked, entries, memberCount, currentUserRole, telegramLink, whatsappLink, discordLink
- `RankedEntry` — id, userId, displayName, rank, valueNumber, valueDurationMs, valueText, note, submittedAt
- `ListSummary` — id, title, valueType, rankOrder, isPublic, memberCount, ownRank, currentUserRole, category
- `ListMember` — userId, displayName, role
- `EntryInput` — valueNumber, valueDurationMs, valueText, note
- `User` — id, email, displayName, createdAt

Enums: `ValueType` (number, duration, text), `RankOrder` (asc, desc), `MemberRole` (owner, admin, member)
