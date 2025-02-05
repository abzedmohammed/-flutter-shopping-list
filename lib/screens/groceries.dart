import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/grocery.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  final List<GroceryItem> _groceryItems = []; //groceryItems;

  void addItem() async {
    final newwItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewItem()));

    if (newwItem != null) {
      setState(() {
        _groceryItems.add(newwItem);
      });
    }
  }

  void deleteItem(GroceryItem groceryItem) {
    setState(() {
      _groceryItems.remove(groceryItem);
    });
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
      body: view,
    );
  }
}
