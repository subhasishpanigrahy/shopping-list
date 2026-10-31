import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/main.dart';

void main() {
  testWidgets('SmartListApp loads properly smoke test', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SmartListApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Shopping List'), findsOneWidget);
    expect(find.text('Universal Store & Web Aggregator'), findsOneWidget);
  });
}
