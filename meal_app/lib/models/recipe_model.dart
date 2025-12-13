class Recipe {
  late 
  String name;
  String img;
  String instructions;
  List<String> ingredients;
  String? youtubeLink;

  Recipe ({
    required this.name,
    required this.img,
    required this.instructions,
    required this.ingredients,
    this.youtubeLink,
  });

  Recipe.fromJson(Map<String, dynamic> data)
    : name = data['strMeal'],
      img = data['strMealThumb'],
      instructions = data['strInstructions'],
      youtubeLink = data['strYoutube'] ?? '',
      ingredients = data.entries
        .where((entry) => entry.key.startsWith('strIngredient'))
        .map((entry) => entry.value as String)
        .where((value) => value.isNotEmpty)
        .toList();
      
  
  
}