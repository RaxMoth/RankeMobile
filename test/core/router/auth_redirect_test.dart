import 'package:flutter_test/flutter_test.dart';

import 'package:ranke_mobile/core/router/auth_redirect.dart';

void main() {
  late AuthRedirect guard;

  String? go(
    String location, {
    bool onboardingDone = true,
    bool sessionResolved = true,
    bool signedIn = false,
  }) => guard(
    location: Uri.parse(location),
    onboardingDone: onboardingDone,
    sessionResolved: sessionResolved,
    signedIn: signedIn,
  );

  setUp(() => guard = AuthRedirect());

  group('launch', () {
    test('waits on the splash screen while the session restores', () {
      expect(go('/splash', sessionResolved: false), isNull);
      expect(go('/home', sessionResolved: false), '/splash');
    });

    test('leaves the splash screen once the session is known', () {
      expect(go('/splash', signedIn: true), '/home');
      expect(go('/splash'), '/login');
      expect(go('/splash', onboardingDone: false), '/onboarding');
    });
  });

  group('signed out', () {
    test('protected routes go to login; auth screens stay', () {
      expect(go('/lists/abc'), '/login');
      expect(go('/login'), isNull);
      expect(go('/register'), isNull);
    });

    test('first launch shows onboarding before anything else', () {
      expect(go('/home', onboardingDone: false), '/onboarding');
      expect(go('/onboarding', onboardingDone: false), isNull);
    });
  });

  group('signed in', () {
    test('auth screens forward to home, app screens stay', () {
      expect(go('/login', signedIn: true), '/home');
      expect(go('/lists/abc', signedIn: true), isNull);
    });

    test('onboarding is not skipped until it is completed', () {
      expect(go('/onboarding', signedIn: true, onboardingDone: false), isNull);
    });
  });

  group('deep links', () {
    test(
      'an invite opened on a cold start resumes after the session restores',
      () {
        expect(go('/invite/tok', sessionResolved: false), '/splash');
        expect(go('/splash', signedIn: true), '/invite/tok');
      },
    );

    test('an invite opened while signed out resumes after login', () {
      expect(go('/invite/tok'), '/login');
      expect(go('/register'), isNull); // the user registers instead
      expect(go('/register', signedIn: true), '/invite/tok');
      // Only once.
      expect(go('/login', signedIn: true), '/home');
    });

    test('an invite survives onboarding', () {
      expect(go('/invite/tok', onboardingDone: false), '/onboarding');
      expect(go('/onboarding'), isNull);
      expect(go('/login', signedIn: true), '/invite/tok');
    });

    test('the full app URL resolves to its path and query', () {
      expect(go('rankapp://app/invite/tok?ref=share'), '/login');
      expect(guard.pendingLocation, '/invite/tok?ref=share');
    });

    test('where the user was when their session ended is not resumed', () {
      expect(go('/settings', signedIn: true), isNull);
      expect(go('/settings'), '/login'); // signed out / expired / deleted
      expect(go('/login', signedIn: true), '/home');
    });
  });
}
