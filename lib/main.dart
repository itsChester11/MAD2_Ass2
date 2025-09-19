import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nerona_assignment_2/shopping_list_screen.dart';
void main() async
{
  //initialize hive
  await Hive.initFlutter();

  runApp(const ShoppingList());
}

class ShoppingList extends StatelessWidget {
  const ShoppingList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Shoppinglist + Hive",
      home: const ShoppingListScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.indigo),
        )
    );
  }
}