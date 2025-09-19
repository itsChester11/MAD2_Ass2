import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _itemcontroller = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  void addItem() async {
    final item = _itemcontroller.text;
    if (item.isEmpty) return;

    final shoppinglist = Hive.box('shoppinglist');
    await shoppinglist.put(item, {'name': item, 'checked': false});

    setState(() {
      _items.add({'name': item, 'checked': false});
      _itemcontroller.clear();
    });
  }

  void toggleCheck(int index) async {
    final shoppinglist = Hive.box('shoppinglist');
    final currentItem = _items[index];
    final updatedItem = {
      'name': currentItem['name'],
      'checked': !currentItem['checked'],
    };
    
    await shoppinglist.put(currentItem['name'], updatedItem);
    setState(() {
      _items[index] = updatedItem;
    });
  }

  void deleteCheckedItems() async {
    final shoppinglist = Hive.box('shoppinglist');
    _items.removeWhere((item) {
      if (item['checked']) {
        shoppinglist.delete(item['name']);
        return true;
      }
      return false;
    });
    setState(() {});
  }

  void initializeList() async {
    await Hive.openBox("shoppinglist").then((value) {
      final list = value.values.toList();
      setState(() {
        _items = List<Map<String, dynamic>>.from(list);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.check_circle_outline_rounded),
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            onPressed: deleteCheckedItems,
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _itemcontroller,
                    decoration: const InputDecoration(
                      hintText: 'Input Text',
                      label: Text('Item'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: addItem,
                      child: const Text(
                        'ADD',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Card(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (_, index) {
                    final item = _items[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          item['name'],
                          style: TextStyle(
                            decoration: item['checked']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: item['checked'],
                              onChanged: (_) => toggleCheck(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
