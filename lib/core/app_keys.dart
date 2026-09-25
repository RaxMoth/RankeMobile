import 'package:flutter/foundation.dart';

/// Stable widget keys for controls driven by `integration_test/`.
///
/// Tests find widgets by these keys (or by semantics label) instead of by
/// visible text or layout position, so copy and layout changes don't break
/// them. Keys carry no runtime cost and no behaviour.
abstract class AppKeys {
  // ── Login ────────────────────────────────────────────────────
  static const loginEmail = Key('login.email');
  static const loginPassword = Key('login.password');
  static const loginSubmit = Key('login.submit');

  // ── Home ─────────────────────────────────────────────────────
  static const createFab = Key('home.createFab');

  // ── Create board flow ────────────────────────────────────────
  static Key createTypeCard(String valueType) =>
      ValueKey('create.type.$valueType');
  static const createTitle = Key('create.title');
  static const createPrimary = Key('create.primary');

  // ── List detail ──────────────────────────────────────────────
  static Key listDetailTab(String tab) => ValueKey('listDetail.tab.$tab');
  static const submitEntryButton = Key('listDetail.submitEntry');
  static const pendingApprove = Key('listDetail.pendingApprove');

  // ── Submit entry sheet ───────────────────────────────────────
  static const entryNumberField = Key('entry.number');
  static const entrySubmit = Key('entry.submit');
  static const entryDone = Key('entry.done');
}
