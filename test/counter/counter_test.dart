// https://pub.dev/packages/test#tagging-tests // run by tag test dart test test/widget_test.dart --tags -x test

import 'package:flutter_test/flutter_test.dart';
import 'package:test_driver_sample/main.dart';
import 'package:test_driver_sample/resources/keys.dart';

void main() {
  group('Counter', () {
    testWidgets('Counter increments smoke test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that our counter starts at 0.
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      final Finder iconAdd = find.byKey(KeysDebug.widgetIncrement);
      final Finder iconAddSecond = find.byTooltip('Increment');

      // Tap the '+' icon and trigger a frame.
      await tester.tap(iconAdd);
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(iconAdd);
      await tester.tap(iconAdd);
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('1'), findsNothing);
      expect(find.text('3'), findsOneWidget);
      //  second icon tap
      await tester.tap(iconAddSecond);
      await tester.pump();

      // expect(find.text('1'), findsNothing);
      expect(find.text('4'), findsOneWidget);
    }, tags: 'alpha');
  });
}
