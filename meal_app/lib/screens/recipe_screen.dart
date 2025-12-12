import 'package:flutter/material.dart';
import 'package:meal_app/models/recipe_model.dart';
import 'package:meal_app/screens/favorites_screen.dart';
import 'package:meal_app/services/api_service.dart';

class RecipeScreen extends StatefulWidget {

  RecipeScreen({
    super.key,
    this.id,
    });

    final int? id;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late final Recipe? _recipeDetails;
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  bool isFavorite = false;
    void toggleFavorite(){
      setState(() {
        isFavorite = !isFavorite;
      });

      print("favorite kopceto se smeni vo $isFavorite");
    }


  @override
  void initState() {
    super.initState();
    _loadRecipeDetails();
  }

  @override
  Widget build(BuildContext context) {

    IconData icon = Icons.favorite_border;
    


    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: Text('Recipe',),
         backgroundColor: Colors.amber,
         actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: 
                    (BuildContext context) => FavoritesScreen()
                  ),
                );
              }, 
              icon: Icon(Icons.favorite)
              ),
          ),
         ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _recipeDetails == null
          ? Center(child: Text('Recipe not found.'),)
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // picture of the meal
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_recipeDetails!.img),
                  ),
                  SizedBox(height: 10,),

                  // title of the meal
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _recipeDetails.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),

                  // heart icon to save recipe
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        toggleFavorite();
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_outline,
                        color: Colors.red
                      ), 
                      label: Text("Save recipe")
                    ),
                  ),
                  SizedBox(height: 30,),

                  // cooking instructions
                  Text(
                    _recipeDetails.instructions,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20,),

                  // ingredients
                  Text(
                    "Ingredients:", 
                    style: TextStyle(fontSize: 26,),
                  ),
                  SizedBox(height: 10,),

                  for(var i = 0; i<_recipeDetails.ingredients.length; i++)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_box_outline_blank),
                        Text(
                          _recipeDetails.ingredients[i],
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ]
                    ),
                  SizedBox(height: 20,),

                  // youtube link
                  if(_recipeDetails.youtubeLink!.isNotEmpty)
                    Text(
                      "YouTube video link:",
                      style: TextStyle(fontSize: 26,),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      child: Text(
                        _recipeDetails.youtubeLink!,
                        style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 0, 84, 154),
                          ),
                        ),
                        onTap: () => Navigator(),
                      ),

                ], 
              ),
              

            
          ),
    );
  }

  void _loadRecipeDetails() async {
    final _recipeData = await _apiService.loadRecipe(widget.id);

    setState(() {
      _recipeDetails = _recipeData;
      _isLoading = false;
    });
  }
}