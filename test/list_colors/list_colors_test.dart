import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_driver_sample/list_colors/change_notifier/favorites.dart';
import 'package:test_driver_sample/list_colors/widgets/favorites_page.dart';
import 'package:test_driver_sample/main.dart';

Widget createHomeScreen({int initialIndex = 0}) => ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: MaterialApp(
        home: HomePage(
          initialIndex: initialIndex,
        ),
      ),
    );

Widget createMyApp() => ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: const MyApp(),
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
  bool skip = true;

  const durationAction = Duration(seconds: 1);

  group('Home Page Widget Tests', () {
    testWidgets('TabBarView action', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.byType(TabBarView), findsOneWidget);

      //swipe to counter
      await tester.fling(find.byType(TabBarView), const Offset(-800, 0), 1000);
      await tester.pumpAndSettle(durationAction);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
      await tester.pumpAndSettle(durationAction);
      //swipe to list colors
      await tester.fling(find.byType(TabBarView), const Offset(800, 0), 1000);
      await tester.pumpAndSettle(durationAction);
      expect(find.byType(ListView), findsOneWidget);

      await tester.fling(find.byType(ListView), const Offset(0, -200), 1000);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(durationAction);
      expect(find.text('Item 5'), findsNothing);
    }, skip: skip);

    // BEGINNING OF NEW CONTENT
    testWidgets('Testing if ListView shows up', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      await tester.pumpAndSettle();
    }, skip: !skip);
    // END OF NEW CONTENT

    testWidgets('Testing Scrolling', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.fling(find.byType(ListView), const Offset(0, -200),3000);
      await tester.pumpAndSettle( durationAction);
      expect(find.text('Item 12'), findsNothing);
      await tester.pumpAndSettle( durationAction);
      expect(find.text('Item 12'), findsNothing);
      await tester.fling(find.byType(ListView), const Offset(0, 400), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsNothing);
    }, skip: !skip);

    testWidgets('Testing IconButtons', (tester) async {
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
      await tester.pumpAndSettle(durationAction);
    });
  }, skip: skip);

  group('Favorites Page Widget Tests', () {
    testWidgets('Test if ListView shows up', (tester) async {
      await tester.pumpWidget(createFavoritesScreen());
      addItems();
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    }, skip: skip);

    testWidgets('Testing Scrolling', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text('Item 0'), findsOneWidget);
      await tester.fling(find.byType(ListView), const Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsNothing);
    }, skip: skip);

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
  }, skip: skip);
}
