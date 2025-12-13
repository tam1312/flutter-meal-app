import 'package:flutter/material.dart';
import 'package:meal_app/screens/recipe_screen.dart';
import 'package:meal_app/services/favorites_service.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final favoriteRecipes = context.watch<FavoritesService>().favorites;

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

      body: favoriteRecipes.isEmpty
        ? const Center(child: Text("List is empty"),)  
        : ListView.builder(
            itemCount: favoriteRecipes.length,
            itemBuilder: (context, index) {
              final recipe = favoriteRecipes[index];

              return Card(
                child: ListTile(
                  leading: Image.network(recipe.img, width: 50,),
                  title: Text(recipe.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<FavoritesService>()
                        .toggleFavorite(recipe);
                    },
                  ),
                ),
              );
            },  
          ),
    );
  }
}