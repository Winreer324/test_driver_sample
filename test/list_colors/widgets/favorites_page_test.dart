import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_driver_sample/list_colors/change_notifier/favorites.dart';
import 'package:test_driver_sample/list_colors/widgets/favorites_page.dart';

late Favorites favoritesList;

Widget createFavoritesScreen() => ChangeNotifierProvider<Favorites>(
      create: (context) {
        favoritesList = Favorites();
        return favoritesList;
      },
      child: const MaterialApp(
        home: FavoritesPage(),
      ),
    );

void addItems({int? length}) {
  if (length == null) {
    for (var i = 0; i < 5; i += 1) {
      favoritesList.add(i);
    }
  } else {
    for (var i = length; i < length+5; i += 1) {
      favoritesList.add(i);
    }
  }
}

void main() {
  const durationAction = Duration(seconds: 1);
  group('Favorites Page Widget Tests', () {
    testWidgets('Test if ListView shows up', (tester) async {
      await tester.pumpWidget(createFavoritesScreen());
      addItems();
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    }, skip: true);

    testWidgets('Testing Scrolling', (tester) async {
      await tester.pumpWidget(createFavoritesScreen());
      expect(find.text('Item 0'), findsOneWidget);
      await tester.fling(find.byType(ListView), const Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsNothing);
    }, skip: true);

    testWidgets('Testing Remove Button', (tester) async {
      await tester.pumpWidget(createFavoritesScreen());
      addItems();
      await tester.pumpAndSettle();
      int totalItems = tester.widgetList(find.byIcon(Icons.close)).length;
      for (var i = 0; i < totalItems / 2; ++i) {
        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();
      }
      expect(
        tester.widgetList(find.byIcon(Icons.close)).length,
        lessThan(totalItems),
      );

      /// добавление новых значений

      await tester.pumpAndSettle();
      addItems(length: totalItems);
      await tester.pumpAndSettle(durationAction);
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();


      /// на второй заход
      await tester.pumpAndSettle(durationAction);
      int totalItemsAfterActions = tester.widgetList(find.byIcon(Icons.close)).length;
      for (var i = 0; i < totalItemsAfterActions - 1; ++i) {
        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();
      }
      await tester.pumpAndSettle();
      expect(
        tester.widgetList(find.byIcon(Icons.close)).length,
        lessThan(totalItemsAfterActions),
      );
      expect(find.text('Removed from favorites.'), findsOneWidget);
    });
  });
}
