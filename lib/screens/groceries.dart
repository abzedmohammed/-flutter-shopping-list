import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/grocery.dart';
import 'package:shopping_list/widgets/new_item.dart';

import 'package:http/http.dart' as http;

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  final List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>>? _loadedItems;
  String? _error;

  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
        'flutter-fe251-default-rtdb.firebaseio.com', 'shopping-list.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Failed to load items');
    }

    if (response.body == 'null') return [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<GroceryItem> loadedItems = [];

    extractedData.forEach((key, value) {
      final category = categories.entries
          .firstWhere((catItem) => catItem.value.title == value['category'])
          .value;

      loadedItems.add(GroceryItem(
          id: key,
          name: value['name'],
          quantity: value['quantity'],
          category: category));
    });

    return loadedItems;
  }

  void addItem() async {
    final newwItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewItem()));

    if (newwItem == null) return;

    setState(() {
      _groceryItems.add(newwItem);
    });
  }

  void deleteItem(GroceryItem groceryItem) async {
    final index = _groceryItems.indexOf(groceryItem);

    setState(() {
      _groceryItems.remove(groceryItem);
    });

    final url = Uri.https('flutter-fe251-default-rtdb.firebaseio.com',
        'shopping-list/${groceryItem.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, groceryItem);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget view = Center(
      child: Text('No items added yet!'),
    );

    if (_groceryItems.isNotEmpty) {
      view = Padding(
        padding: EdgeInsets.all(15.0),
        child: ListView.builder(
          itemBuilder: (ctx, index) => Grocery(
            groceryItem: _groceryItems[index],
            deleteItem: deleteItem,
          ),
          itemCount: _groceryItems.length,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: addItem,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _loadedItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return view;
            }
          }),
    );
  }
}
