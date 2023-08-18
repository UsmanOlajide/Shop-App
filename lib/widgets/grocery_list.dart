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
  var loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        // 'abc.firebaseio.com', 'shopping-list.json');
        'flutter-prep-1816d-default-rtdb.firebaseio.com', 'shopping-list.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        errorMessage =
            'Failed to load items. Please make sure you\'re connected to the internet and try again';
      });
    }

    final Map<String, dynamic> decodedData = json.decode(response.body);

    final List<GroceryItem> newList = [];

    // for in loop to use each key value pair
    for (final item in decodedData.entries) {
      final newCategory = categories.entries
          .firstWhere(
            (category) => category.value.catTitle == item.value['category'],
          )
          .value;

      newList.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: newCategory,
        ),
      );
    }
    setState(() {
      _groceryItems = newList;
      loading = false;
    });
  }

  void _addItem() async {
    final response = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (_) => const NewItem(),
      ),
    );

    if (response == null) return;

    setState(() {
      _groceryItems.add(response);
      // loading = true;
    });
    // _loadItems();
  }

  void _deleteItem(GroceryItem groceryItem) {
    setState(() {
      _groceryItems.remove(groceryItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('NO ITEMS ADDED YET'));

    if (loading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

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

    if (errorMessage != null) {
      content = Center(child: Text(errorMessage!));
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
