import 'package:flutter/material.dart';
import 'package:meal_app/models/recipe_model.dart';


class FavoritesService extends ChangeNotifier {
  final List<Recipe> _favorites = [];

  List<Recipe> get favorites => _favorites;

  bool isFavorite(Recipe recipe) {
    return _favorites.any((f) => f.name == recipe.name);
  }

  void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe)){
      _favorites.removeWhere((f) => f.name == recipe.name);
    } else {
      _favorites.add(recipe);
    }

    notifyListeners();
  }



}