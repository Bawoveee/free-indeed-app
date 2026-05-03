import 'package:flutter_test/flutter_test.dart';
import 'package:free_indeed/main.dart';

void main() {
  testWidgets('Free Indeed smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FreeIndeedApp());
    expect(find.text('Free Indeed'), findsOneWidget);
  });
}