# Ranke (Apex)

A competitive leaderboard app for iOS where users create, join, and compete on ranked boards with typed entries (numbers, durations, or text).

## Features

- **Ranked Boards** — Create and manage leaderboards with customizable value types (number, duration, text) and rank ordering
- **Real-time Standings** — Live ranked standings with automatic sorting and rank assignment
- **Board Discovery** — Search and browse public boards by category
- **Moderation Tools** — Owners and admins can manage members, delete entries, and edit board settings
- **Communication Links** — Boards support Telegram, WhatsApp, and Discord group links
- **Bookmarks** — Save boards to follow without joining
- **Apple Sign In** — Native authentication with Sign in with Apple

## Architecture

Clean Architecture with feature-based modules:

```
lib/
├── core/           # DI, networking, routing, theme, dev mode
├── features/
│   ├── auth/       # Authentication (domain/data/presentation)
│   ├── entries/    # Entry submission and display
│   ├── lists/      # Boards, discovery, detail views
│   ├── profile/    # User profile and stats
│   └── shell/      # Bottom navigation shell
├── shared/         # Reusable widgets
└── main.dart
```

**Stack**: Flutter · Riverpod · GoRouter · GetIt · Dio · Freezed · fpdart

## Development

```bash
# Run with dev mode (mock data, no backend needed)
flutter run

# Regenerate Freezed models
dart run build_runner build --delete-conflicting-outputs

# Analyze
flutter analyze

# Build for iOS simulator
flutter build ios --simulator
```

Toggle dev mode in `lib/core/dev/dev_config.dart`.

## Requirements

- Flutter 3.x
- iOS 16+
- Xcode 15+
