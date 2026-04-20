# Engineering Playbook

This document defines how to keep Ranke Mobile scalable, maintainable, and fast to iterate on.

## Architecture Contract

- Keep feature boundaries strict: auth, lists, entries, profile, onboarding, shell.
- Enforce layer direction only: presentation -> domain -> data.
- Do not import data layer code into presentation widgets directly.
- Keep entities in domain immutable and framework-agnostic.

## Dependency Injection Rules

- Register infra and repositories in [lib/core/di/injection.dart](../lib/core/di/injection.dart).
- Always inject abstractions into use cases.
- Keep setup idempotent so tests/hot-restart do not fail due to duplicate registrations.
- Use dev-mode repositories for fast UI iteration where backend coupling slows delivery.

## State Management Rules

- Use Riverpod AsyncNotifier for async feature states.
- Keep notifier surface small: load, refresh, mutate actions only.
- Move heavy transformations out of widgets and into use cases/mappers.
- Model loading/empty/error/success explicitly.

## Networking and Error Handling

- All external requests go through Dio + interceptor stack.
- Attach access token in interceptor only.
- On 401, serialize refresh calls with mutex to avoid refresh storms.
- Return Either<ApiError, T> from repository methods consistently.
- Keep API error mapping in one place (safeApiCall + ApiError models).

## UI System Rules

- Use centralized design tokens from core/theme.
- Keep tap targets >= 44pt.
- Prefer vertical list-first mobile patterns over dense desktop layouts.
- Support dynamic text sizing and content wrapping.
- Avoid hard-coded widths for primary screen structures.

## Working in This Repo Efficiently

- Run flutter analyze before opening PRs.
- Generate code after touching freezed/json models.
- Keep one feature change per PR where possible.
- Add lightweight docs updates for any architecture changes.
- Use focused commits with clear intent:
    - feat: for user-facing features
    - fix: for bug fixes
    - refactor: for non-behavioral internal improvements
    - docs: for documentation-only changes

## Recommended CI Gates

- flutter pub get
- dart run build_runner build --delete-conflicting-outputs
- flutter analyze
- flutter test
- Optional: golden tests for key screens

## Branching and Release Flow

- main stays releasable.
- Use short-lived feature branches.
- Create release checklist issue for each App Store submission cycle.
- Tag build candidates with semantic versioning.
