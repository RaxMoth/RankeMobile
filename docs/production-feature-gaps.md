# Production Feature Gaps and Requests

This backlog captures what should be added to make Ranke fully production-ready for scale and App Store operations.

## High Priority

- Crash reporting pipeline
    - Integrate Firebase Crashlytics or Sentry for release builds.
    - Add structured non-fatal error reporting for API/domain failures.
- Analytics with privacy-safe events
    - Define event taxonomy per core funnel (onboarding, auth, create board, submit entry).
    - Add opt-out and privacy-compliant defaults.
- Push notifications
    - Invite accepted, entry approved/rejected, rank changed, board updates.
- Remote config / feature flags
    - Enable staged rollouts and kill switches for risky features.
- Full legal/account controls
    - In-app account deletion request flow.
    - Data export and privacy controls page.

## Medium Priority

- Moderation tooling
    - Audit trail for admin actions.
    - Report/flag abusive content.
    - Role escalation protections.
- Search and feed scalability
    - Debounced server-side search with pagination.
    - Caching strategy for board summaries.
- Accessibility
    - Screen reader labels for ranking components.
    - Reduced motion mode support.

## Reliability and Developer Experience

- Add test layers
    - Unit tests for use cases.
    - Repository tests with Dio adapter mocks.
    - Widget tests for critical onboarding/auth/list flows.
- CI/CD
    - Automated analyze/test/build pipeline.
    - Fastlane lanes for TestFlight and App Store submission metadata.
- Environment separation
    - Dedicated dev/staging/prod API and secrets management.

## UX/Style Trends to Adopt (2026)

- More expressive typography pairing (display + readable body).
- Layered depth on dark UI with subtle elevation and ambient gradients.
- Motion system with purposeful transitions (sheet transitions, list reveal cadence).
- Clear status-first surfaces (pending, approved, rejected) with semantic color accents.
- Content density tuned for thumb reach and one-handed usage.
