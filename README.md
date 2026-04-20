# Ranke Mobile (Apex)

Production-focused iOS Flutter app for collaborative ranked boards.

Ranke helps groups create leaderboards with typed values (number, duration, text), validate submissions, and compete with clear ownership and moderation roles.

## Current Product Direction

- Platform: iOS first (minimum iOS 16)
- Brand language: Apex
- Visual direction: dark terminal aesthetic with modern high-contrast typography
- Navigation model: 4-tab shell (HOME, DISCOVER, CREATE, PROFILE)

## Core Feature Set

- Ranked boards with configurable value type and rank order
- Real-time standings and rank movement
- Public board discovery with search
- Invite-based membership and role-based moderation
- Entry submission with optional notes/evidence context
- Admin queue for pending approvals/rejections
- Native Sign in with Apple support

## Architecture

This repository uses Clean Architecture per feature:

- domain: entities, repository contracts, use cases
- data: remote/mock data sources, repository implementations
- presentation: Riverpod state + Flutter UI

High-level structure:

```
lib/
	core/
		config/      # Runtime app config via --dart-define
		constants/   # Shared constants
		dev/         # Dev mode + in-memory repos
		di/          # GetIt registrations
		network/     # Dio, interceptors, API helpers/errors
		router/      # GoRouter + auth/onboarding guards
		theme/       # Colors, text styles, app theme
	features/
		auth/
		entries/
		lists/
		onboarding/
		profile/
		shell/
	shared/widgets/
```

## Tech Stack

- Flutter
- Riverpod
- GetIt
- GoRouter
- Dio
- Freezed + json_serializable
- fpdart Either-based error handling

## Environment Configuration

Runtime app config is driven by --dart-define values in [lib/core/config/app_config.dart](lib/core/config/app_config.dart).

Available defines:

- APP_ENV (dev | staging | production)
- API_BASE_URL
- APP_DISPLAY_NAME
- APP_VERSION_LABEL
- PRIVACY_POLICY_URL
- TERMS_OF_SERVICE_URL
- SUPPORT_EMAIL

Example:

```bash
flutter run \
	--dart-define=APP_ENV=staging \
	--dart-define=API_BASE_URL=https://staging-api.ranke.app \
	--dart-define=APP_DISPLAY_NAME=Apex \
	--dart-define=APP_VERSION_LABEL='RANKE v1.1.0'
```

## Local Development

```bash
# Install dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Static analysis
flutter analyze

# Run app (simulator)
flutter run
```

Dev-mode mocks are toggled in [lib/core/dev/dev_config.dart](lib/core/dev/dev_config.dart).

## Scalability & Maintainability Standards

- Centralized runtime config (avoid hardcoded environment values)
- Idempotent DI bootstrap to support test and hot-restart workflows
- Typed API errors with explicit Either handling in repositories
- Shared design tokens and typography for consistent UI behavior
- Feature-first folder boundaries and strict layer separation

Detailed engineering guidance:

- [docs/engineering-playbook.md](docs/engineering-playbook.md)
- [docs/app-store-readiness-checklist.md](docs/app-store-readiness-checklist.md)
- [docs/production-feature-gaps.md](docs/production-feature-gaps.md)

## App Store Readiness

The app is designed around Apple App Store requirements:

- Sign in with Apple support
- Functional flows (no placeholder screens)
- Privacy policy and terms links included in app settings
- In-app-first core experience

Use the checklist in [docs/app-store-readiness-checklist.md](docs/app-store-readiness-checklist.md) before each release.

## Requirements

- Flutter 3.35+
- Dart 3.11+
- Xcode 15+
- iOS 16+
