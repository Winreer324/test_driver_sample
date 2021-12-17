import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_driver_sample/list_colors/change_notifier/favorites.dart';

class ItemTile extends StatelessWidget {
  final int itemNo;

  const ItemTile({Key? key, required this.itemNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var favoritesList = Provider.of<Favorites>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[itemNo % Colors.primaries.length],
        ),
        title: Text(
          'Item $itemNo',
          key: Key('text_$itemNo'),
        ),
        trailing: IconButton(
          key: Key('icon_$itemNo'),
          icon: favoritesList.items.contains(itemNo) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          onPressed: () {
            if (!favoritesList.items.contains(itemNo)) {
              favoritesList.add(itemNo);
            } else {
              favoritesList.remove(itemNo);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(favoritesList.items.contains(itemNo) ? 'Added to favorites.' : 'Removed from favorites.'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
