import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shop_app/data/categories.dart';
import 'package:shop_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  // final Function(GroceryItem groceryItem) addGroceryItem;

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // late TextEditingController nameController;
  // late TextEditingController quantityController;

  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  // @override
  // void initState() {
  //   super.initState();
  //   nameController = TextEditingController();
  //   quantityController = TextEditingController();
  // }

  // @override
  // void dispose() {
  //   nameController;
  //   quantityController;
  //   super.dispose();
  // }

  void _addGroceryItem() {
    // I think when validate runs, it acts on the validation method in the form field
    // and checks my condition there if it is true or false
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //POST_____________________
      final url = Uri.https
        'flutter-prep-1816d-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );
      http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory.catTitle,
        }),
        //------------------------
      );
      // Navigator.of(context).pop(
      //   GroceryItem(
      //     id: DateTime.now().toIso8601String(),
      //     name: _enteredName,
      //     quantity: _enteredQuantity,
      //     category: _selectedCategory,
      //   ),
      // );
    }

    // _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item Screen'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              // controller: nameController,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) {
                // value is the input
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return 'Must be between 1 and 50 characters.';
                }
                return null;
                // to tell flutter that value is valid
              },
              onSaved: (value) {
                _enteredName = value!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    // controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Quantity'),
                    ),
                    initialValue: _enteredQuantity.toString(),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return 'Must be a valid positive number.';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _enteredQuantity = int.parse(value!);
                      // I did't used tryParse cos I already checked for null
                      // and I also know at this point it cannot be null
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField(
                    value: _selectedCategory,
                    // the list of objects is will show
                    items: [
                      for (final category in categories.entries)
                        DropdownMenuItem(
                          value: category.value,
                          child: Row(
                            children: [
                              Container(
                                height: 16,
                                width: 16,
                                color: category.value.color,
                              ),
                              const SizedBox(width: 8),
                              Text(category.value.catTitle)
                            ],
                          ),
                        )
                    ],
                    // triggered when a new selection is made
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _formKey.currentState!.reset();
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // _formKey.currentState!.validate();
                    _addGroceryItem();
                  },
                  child: const Text('Add Item'),
                )
                // ElevatedButton(
                //   onPressed: () => widget.addGroceryItem(
                //     GroceryItem(
                //       id: id,
                //       name: name,
                //       quantity: quantity,
                //       category: category,
                //     ),
                //   ),
                //   child: const Text('Add Item'),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
