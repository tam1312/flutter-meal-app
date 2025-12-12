import 'package:flutter/material.dart';
import 'package:meal_app/screens/recipe_screen.dart';

class FavoritesScreen extends StatefulWidget {
    FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Favorite recipes"),
        backgroundColor: Colors.amber,

        // go to random recipe
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                MaterialPageRoute(builder: 
                (BuildContext context) => RecipeScreen())
                );
              }, 
              icon: Icon(Icons.casino)
            ),
          ),
        ],
      ),
    );
  }
}