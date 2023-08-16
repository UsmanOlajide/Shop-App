import 'package:flutter/material.dart';

import 'package:shop_app/models/grocery_item.dart';
import 'package:shop_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    // push returns a Future that holds the data that might be returned by the screen which I pushed to.
    // newItem is null because we might not return anything from that screen
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (_) => const NewItem(),
      ),
    );

    if (newItem == null) return;
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _deleteItem(GroceryItem groceryItem) {
    setState(() {
      _groceryItems.remove(groceryItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('NO ITEMS ADDED YET'));
    
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (ctx, index) {
          return Dismissible(
            // key to identify an item uniquely
            key: UniqueKey(),
            onDismissed: (direction) {
              _deleteItem(_groceryItems[index]);
            },
            child: ListTile(
              leading: Container(
                height: 30,
                width: 30,
                color: _groceryItems[index].category.color,
              ),
              title: Text(
                _groceryItems[index].name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Text('${_groceryItems[index].quantity}'),
            ),
          );
        },
        itemCount: _groceryItems.length,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
