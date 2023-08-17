import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/data/categories.dart';

import 'package:shop_app/models/grocery_item.dart';
import 'package:shop_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

//to fetch the data when my app runs for the first time
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

// I want to send a get request when I open this screen for the first time
  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep-1816d-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    // print(response.body);

    // will contain the new parsed objects
    final List<GroceryItem> loadedItems = [];

    // to convert json string to normal string
    final Map<String, dynamic> listData = json.decode(response.body);

    // to loop through the listData map
    for (final item in listData.entries) {
      final newCategory = categories.entries 
          .firstWhere(
              (catItem) => catItem.value.catTitle == item.value['category'])
          .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: newCategory,
        ),
      );
    }

    setState(() {
      _groceryItems = loadedItems;
    });
  }

  void _addItem() async {
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (_) => const NewItem(),
      ),
    );
    _loadItems();
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
