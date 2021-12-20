import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
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
  const durationAction = Duration(seconds: 1);
  bool skip = true;
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized() as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    testWidgets('Scrolling test', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      final listFinder = find.byType(ListView);

      await binding.watchPerformance(() async {
        await tester.fling(listFinder, Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');
    },skip: skip);

    testWidgets('Favorites operations test', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle(durationAction);
      await tester.tap(find.byKey(const ValueKey('icon_1')));
      await tester.pumpAndSettle(durationAction);
      await tester.pumpWidget(createFavoritesScreen());
      // await tester.tap(find.byTooltip('action route to favorites page'));
      await tester.pumpAndSettle(durationAction);

      return;

      final iconKeys = List.generate(10, (index) => 'icon_$index');
      final listFinder = find.byType(ListView);
      for (var icon in iconKeys) {
        await tester.tap(find.byKey(ValueKey(icon)));
        await tester.pumpAndSettle(const Duration(milliseconds: 200));
        await tester.fling(listFinder, const Offset(0, -75), 100);
      }
      await tester.pumpAndSettle();
      // expect(find.text('Added to favorites.'), findsOneWidget);

      await tester.tap(find.byTooltip('action route to favorites page'));
      await tester.pumpAndSettle(durationAction);

      final removeIconKeys = [
        'icon_0',
        'icon_1',
        'icon_2',
      ];

      // for (final _ in removeIconKeys) {
      // // for (final iconKey in removeIconKeys) {
      //   // await tester.tap(find.byKey(ValueKey(iconKey)));
      //   await tester.tap(find.byIcon(Icons.favorite).first);
      //
      //   await tester.pumpAndSettle(const Duration(seconds: 1000));
      //
      //   expect(find.text('Removed from favorites.'), findsOneWidget);
      // }
    });

    testWidgets('Open favorites page', (tester) async {
      await tester.pumpWidget(createFavoritesScreen());
      addItems();
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      await tester.pumpAndSettle(durationAction);

      final listFinder = find.byType(ListView);

      await binding.watchPerformance(() async {
        await tester.fling(listFinder, Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');
      await tester.pumpAndSettle(durationAction);
    },skip: skip);
  });
}
