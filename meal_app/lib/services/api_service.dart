import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meal_app/models/category_model.dart';
import 'package:meal_app/models/category_dish_model.dart';
import 'package:meal_app/models/recipe_model.dart';


class ApiService {
    Future<List<Category>> loadCategoryList() async {
        List<Category> categoryList = [];
 
        final response = await http.get(
                Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
        );

        if (response.statusCode == 200){
            final responseData = json.decode(response.body);
            final List<dynamic>? categoriesJson = responseData['categories'] as List<dynamic>?;
            categoryList = categoriesJson!.map(
                (x) => Category.fromJson(x as Map<String, dynamic>)
            ).toList();
        } 

        return categoryList;
    }

    
    Future<List<CategoryDish>> loadCategoryDishList(String category) async {
      List<CategoryDish> categoryDishList = [];

      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'),
      );

      if (response.statusCode == 200){
        final responseData = json.decode(response.body);
        final List<dynamic>? categoryDishesJson = responseData['meals'] as List<dynamic>?;
        categoryDishList = categoryDishesJson!.map(
          (x) => CategoryDish.fromJson(x as Map<String, dynamic>)
        ).toList();
      }

    return categoryDishList;
    }

    Future<Recipe?> loadRecipe(int? id) async {
      final response;
      
      if(id != null){
        response = await http.get(
          Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
        );
      }
      else{
        response = await http.get(
          Uri.parse("https://www.themealdb.com/api/json/v1/1/random.php")
        );
      }
       

      if (response.statusCode == 200){
        final responseData = json.decode(response.body);
        final meals = responseData['meals'] as List<dynamic>;

        return Recipe.fromJson(meals.first);
      }

      return null;
    }

    
}