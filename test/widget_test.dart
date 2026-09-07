import 'package:flutter_test/flutter_test.dart';

import 'package:counter_test/main.dart';

void main() {
  testWidgets('Workspace loads with sidebar and page', (WidgetTester tester) async {
    await tester.pumpWidget(const AtlasApp());
    expect(find.text('Acme'), findsOneWidget);
    expect(find.text('Getting started'), findsWidgets);
  });
}
