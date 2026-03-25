<<<<<<< HEAD
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ranke_mobile/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RankeApp()));
    await tester.pumpAndSettle();
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ranke_mobile/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RankeApp()));
    await tester.pumpAndSettle();
    expect(find.text('APEX'), findsOneWidget);
>>>>>>> 88d3438 (good progress)
  });
}
