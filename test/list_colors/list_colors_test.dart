import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_driver_sample/list_colors/change_notifier/favorites.dart';
import 'package:test_driver_sample/list_colors/widgets/favorites_page.dart';
import 'package:test_driver_sample/main.dart';

Widget createHomeScreen() => ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: const MaterialApp(
        home: HomePage(
          initialIndex: 1,
        ),
      ),
    );

///

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

void addItems({int length = 5}) {
  for (var i = 0; i < length; i += 1) {
    favoritesList.add(i);
  }
}

void main() {
  const durationAction = Duration(seconds: 1);

  group('Home Page Widget Tests', () {
    // BEGINNING OF NEW CONTENT
    testWidgets('Testing if ListView shows up', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.byType(ListView), findsOneWidget);
    });
    // END OF NEW CONTENT

    testWidgets('Testing Scrolling', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text('Item 0'), findsOneWidget);
      await tester.fling(find.byType(ListView), const Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsNothing);
    });

    testWidgets(
      'Testing IconButtons',
      (tester) async {
        await tester.pumpWidget(createHomeScreen());
        expect(find.byIcon(Icons.favorite), findsNothing);
        await tester.tap(find.byIcon(Icons.favorite_border).first);
        await tester.pumpAndSettle(durationAction);
        expect(find.text('Added to favorites.'), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsWidgets);
        await tester.tap(find.byIcon(Icons.favorite).first);
        await tester.pumpAndSettle(durationAction);
        expect(find.text('Removed from favorites.'), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsNothing);
      },
    );
  }, skip: true);

  group('Favorites Page Widget Tests', () {
    testWidgets('Test if ListView shows up', (tester) async {
      await tester.pumpWidget(createFavoritesScreen());
      addItems();
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    }, skip: true);

    testWidgets('Testing Scrolling', (tester) async {
      await tester.pumpWidget(createHomeScreen());
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
      for (var i = 0; i < totalItems; ++i) {
        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle();
        expect(
          tester.widgetList(find.byIcon(Icons.close)).length,
          lessThan(totalItems),
        );
      }

      await tester.pumpAndSettle();
      addItems();
      await tester.pumpAndSettle(durationAction);
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();

      expect(find.text('Removed from favorites.'), findsOneWidget);
    });
  });
}
