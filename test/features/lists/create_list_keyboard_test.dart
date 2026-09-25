import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ranke_mobile/core/app_keys.dart';
import 'package:ranke_mobile/features/lists/presentation/create_list_sheet.dart';

/// Regression: the create-board screen used to pad its bottom bar with the
/// keyboard inset on top of the Scaffold's own keyboard avoidance, counting
/// the keyboard twice and collapsing the step pages to 0pt — the title field
/// vanished while typing into it.
void main() {
  testWidgets('step content stays visible above the keyboard', (tester) async {
    // iPhone 15 Pro logical size, safe-area insets and keyboard height.
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    tester.view.viewInsets = const FakeViewPadding(bottom: 336);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: CreateListScreen())),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull, reason: 'layout overflowed');
    expect(
      tester.getSize(find.byType(PageView)).height,
      greaterThan(200),
      reason: 'step pages collapsed behind the keyboard',
    );
    expect(find.byKey(AppKeys.createPrimary), findsOneWidget);
  });
}
