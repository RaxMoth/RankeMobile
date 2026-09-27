/// Route guard for sign-in state, onboarding and deep links.
///
/// Pure logic (no Flutter/Riverpod) so every rule is unit-tested in
/// `test/core/router/auth_redirect_test.dart`.
///
/// Deep links: a protected location reached while signed out — e.g. an
/// invite link opened from Messages, possibly on a cold start — is kept in
/// [pendingLocation] and resumed right after sign-in, whether the user
/// signs in, registers, or finishes onboarding first. Locations the user
/// was on when their session *ended* (sign-out, expiry, deletion) are not
/// resumed.
class AuthRedirect {
  static const splash = '/splash';
  static const home = '/home';
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const publicPaths = {login, '/register', onboarding, splash};

  /// Where to go after the next sign-in, if the user was sent to sign in
  /// on the way to somewhere else.
  String? pendingLocation;

  bool _wasSignedIn = false;

  /// Returns the location to redirect to, or null to stay on [location].
  ///
  /// [sessionResolved] is false only while a stored session is being
  /// restored at launch; the app waits on [splash] until it is known.
  String? call({
    required Uri location,
    required bool onboardingDone,
    required bool sessionResolved,
    required bool signedIn,
  }) {
    final sessionEnded = _wasSignedIn && !signedIn;
    _wasSignedIn = signedIn;
    if (sessionEnded) pendingLocation = null;

    final path = location.path;
    final target = Uri(
      path: path,
      query: location.hasQuery ? location.query : null,
    ).toString();
    final isPublic = publicPaths.contains(path);

    void remember() {
      if (!isPublic && !sessionEnded) pendingLocation = target;
    }

    if (!sessionResolved) {
      remember();
      return path == splash ? null : splash;
    }
    if (!onboardingDone) {
      remember();
      return path == onboarding ? null : onboarding;
    }
    if (!signedIn) {
      remember();
      return isPublic && path != splash ? null : login;
    }
    if (isPublic) {
      final resume = pendingLocation;
      pendingLocation = null;
      return resume ?? home;
    }
    return null;
  }
}
