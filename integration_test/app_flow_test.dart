// Happy-path end-to-end flow against the in-memory mock repositories:
//
//   login → create board → submit entry → approve it (owner moderation)
//   → see it ranked on the leaderboard
//
// Run on a booted iOS simulator (no backend needed):
//
//   flutter test integration_test --dart-define=USE_MOCK=true
//
// Widgets are located by `AppKeys` or by semantics label, never by visible
// copy or layout position, so UI text changes don't break the test.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ranke_mobile/core/app_keys.dart';
import 'package:ranke_mobile/core/dev/dev_config.dart';
import 'package:ranke_mobile/core/di/injection.dart';
import 'package:ranke_mobile/core/router/router.dart';
import 'package:ranke_mobile/features/auth/domain/entities/user.dart';
import 'package:ranke_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:ranke_mobile/main.dart';

/// Mock mode normally auto-logs-in the dev user. Start signed out instead so
/// the real login screen is exercised; `login()` still goes through GetIt's
/// LoginUseCase → MockAuthRepository.
class _SignedOutAuthNotifier extends AuthNotifier {
  @override
  Future<User?> build() async => null;
}

/// Pumps frames until [finder] matches or [timeout] elapses.
///
/// Mock repositories answer after a real `Future.delayed`, which doesn't
/// schedule frames, so `pumpAndSettle` can return before data arrives.
/// Polling for the widget we actually need is the reliable alternative.
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out after $timeout waiting for $finder');
}

/// Pumps frames until [finder] matches nothing or [timeout] elapses.
Future<void> pumpUntilGone(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isEmpty) return;
  }
  throw TestFailure('Timed out after $timeout waiting for $finder to vanish');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'login → create board → submit entry → approve → ranked on leaderboard',
    (tester) async {
      expect(
        DevConfig.useMocks,
        isTrue,
        reason: 'Run with --dart-define=USE_MOCK=true',
      );
      final semantics = tester.ensureSemantics();

      await setupDI();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            authProvider.overrideWith(_SignedOutAuthNotifier.new),
          ],
          child: const RankeApp(),
        ),
      );

      // ── Login ────────────────────────────────────────────────
      await pumpUntilFound(tester, find.byKey(AppKeys.loginEmail));
      await tester.enterText(find.byKey(AppKeys.loginEmail), 'max@ranked.app');
      await tester.enterText(find.byKey(AppKeys.loginPassword), 'password123');
      await tester.tap(find.byKey(AppKeys.loginSubmit));

      // ── Create a number board ────────────────────────────────
      await pumpUntilFound(tester, find.byKey(AppKeys.createFab));
      await tester.tap(find.byKey(AppKeys.createFab));

      await pumpUntilFound(tester, find.byKey(AppKeys.createTypeCard('number')));
      await tester.tap(find.byKey(AppKeys.createTypeCard('number')));

      // Type tap auto-advances to the identity step.
      await pumpUntilFound(tester, find.byKey(AppKeys.createTitle));
      await tester.pumpAndSettle();
      const boardTitle = 'E2E Board';
      await tester.enterText(find.byKey(AppKeys.createTitle), boardTitle);

      // identity → rules → share → create
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byKey(AppKeys.createPrimary));
        await tester.pumpAndSettle();
      }

      // ── Open the new board from Home ─────────────────────────
      final boardTile = find.bySemanticsLabel(RegExp('^$boardTitle board'));
      await pumpUntilFound(tester, find.byKey(AppKeys.createFab));
      await tester.scrollUntilVisible(
        boardTile,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(boardTile);

      // ── Submit an entry ──────────────────────────────────────
      await pumpUntilFound(tester, find.byKey(AppKeys.submitEntryButton));
      await tester.tap(find.byKey(AppKeys.submitEntryButton));

      await pumpUntilFound(tester, find.byKey(AppKeys.entryNumberField));
      await tester.enterText(find.byKey(AppKeys.entryNumberField), '42');
      await tester.tap(find.byKey(AppKeys.entrySubmit));

      await pumpUntilFound(tester, find.byKey(AppKeys.entryDone));
      await tester.tap(find.byKey(AppKeys.entryDone));
      await tester.pumpAndSettle();

      // ── Approve it as the board owner ────────────────────────
      await tester.tap(find.byKey(AppKeys.listDetailTab('admin')));
      await pumpUntilFound(tester, find.byKey(AppKeys.pendingApprove));
      await tester.tap(find.byKey(AppKeys.pendingApprove));
      await pumpUntilGone(tester, find.byKey(AppKeys.pendingApprove));

      // ── The entry is now ranked #1 and marked as ours ────────
      await tester.tap(find.byKey(AppKeys.listDetailTab('standings')));
      await pumpUntilFound(
        tester,
        find.bySemanticsLabel(RegExp(r'^Rank 1, your entry, ')),
      );
      expect(
        find.bySemanticsLabel(RegExp(r'^Rank 1, your entry, ')),
        findsOneWidget,
      );

      semantics.dispose();
    },
  );
}
