import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'couter/counter_screen.dart';
import 'list_colors/change_notifier/favorites.dart';
import 'list_colors/list_colors_screen.dart';
import 'list_colors/widgets/favorites_page.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // if (kReleaseMode)
    if (kDebugMode) {
      // exit(1);
    }
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: MaterialApp(
        title: 'Test Driver sample',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          ListColorsScreen.routeName: (context) => const ListColorsScreen(),
          FavoritesPage.routeName: (context) => const FavoritesPage(),
        },
        initialRoute: HomePage.routeName,
        // home: const MyHomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final int initialIndex;
  static String routeName = '/';

  const HomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing'),
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('List colors'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Counter'),
              ),
            ],
            padding: EdgeInsets.only(bottom: 10),
          ),
        ),
        body: const TabBarView(
          children: [
            ListColorsScreen(),
            CounterScreen(),
          ],
        ),
      ),
    );
  }
}
