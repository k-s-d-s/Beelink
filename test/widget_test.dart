import 'package:flutter_test/flutter_test.dart';
import 'package:beelink/main.dart';

void main() {
  testWidgets('BeeLink app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BeeLinkApp());
    expect(find.text('BeeLink'), findsOneWidget);
  });
}
