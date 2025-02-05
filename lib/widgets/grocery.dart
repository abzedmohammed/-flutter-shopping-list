import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class Grocery extends StatelessWidget {
  const Grocery({super.key, required this.groceryItem, required this.deleteItem});

  final GroceryItem groceryItem;
  final void Function(GroceryItem grocery) deleteItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(groceryItem.id),
      onDismissed: (direction) => deleteItem(groceryItem),
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: ListTile(
        title: Text(groceryItem.name),
        leading: Container(
          width: 25,
          height: 25,
          color: groceryItem.category.color,
        ),
        trailing: Text(groceryItem.quantity.toString()),
      ),
    );
  }
}





// Padding(
//       padding: const EdgeInsets.only(bottom: 30.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         key: ValueKey(groceryItem.id),
//         children: [
//           Container(
//             width: 35,
//             height: 35,
//             color: groceryItem.category.color,
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Text(groceryItem.name),
//           Spacer(),
//           Text(groceryItem.quantity.toString()),
//         ],
//       ),
//     );