# App Store Readiness Checklist

Use this checklist before every production submission.

## 2.1 App Completeness

- All primary flows are functional end-to-end (auth, discover, create, submit, moderation).
- No placeholder or dead-end screens in production builds.
- Empty/error states are user-friendly and actionable.

## 4.0 Design

- Visual hierarchy is consistent across tabs and detail screens.
- Body text remains readable with iOS accessibility font scaling.
- Tap targets are at least 44pt.
- Contrast ratio is acceptable on dark surfaces.

## 4.2 Minimum Functionality

- Core value proposition is clear: collaborative ranking and verified submissions.
- Features are not just a wrapped website.
- Onboarding explains unique product value in under 3 screens.

## 5.1.1 Privacy

- Privacy Policy URL is live and accessible.
- Terms of Service URL is live and accessible.
- Data collection categories are accurately declared in App Privacy.
- Account deletion request path exists and is documented.

## Authentication

- Sign in with Apple works on-device and in production environment.
- Logout clears secure tokens and local sensitive state.
- Expired session flow returns user to login safely.

## Networking and Reliability

- API base URL points to production backend in production builds.
- Token refresh logic is validated under concurrent requests.
- Offline/network failure messaging is clear.

## Legal and Monetization

- No external payment links for digital goods.
- If monetized, Apple IAP is used for eligible digital content.
- Third-party service attributions and licenses are included.

## Release Operations

- Build number incremented.
- Version label updated.
- Crash reporting and analytics release markers enabled.
- TestFlight smoke test passed on latest iOS versions.
