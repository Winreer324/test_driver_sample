import 'package:flutter/material.dart';
import 'package:test_driver_sample/list_colors/widgets/favorites_page.dart';
import 'package:test_driver_sample/list_colors/widgets/item_tile.dart';

class ListColorsScreen extends StatefulWidget {
  const ListColorsScreen({Key? key}) : super(key: key);

  static const String routeName = '/listColorsScreen';

  @override
  _ListColorsScreenState createState() => _ListColorsScreenState();
}

class _ListColorsScreenState extends State<ListColorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 100,
        cacheExtent: 20.0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) => ItemTile(itemNo: index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, FavoritesPage.routeName);
        },
        tooltip: 'action route to favorites page',
        child: const Icon(Icons.favorite_border),
      ),
    );
  }
}
