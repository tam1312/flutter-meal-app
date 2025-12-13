class Recipe {
  String id;
  String name;
  String img;
  String instructions;
  List<String> ingredients;
  String? youtubeLink;

  Recipe ({
    required this.id,
    required this.name,
    required this.img,
    required this.instructions,
    required this.ingredients,
    this.youtubeLink,
  });

  Recipe.fromJson(Map<String, dynamic> data)
    : id = data['idMeal'],
      name = data['strMeal'],
      img = data['strMealThumb'],
      instructions = data['strInstructions'],
      youtubeLink = data['strYoutube'] ?? '',
      ingredients = data.entries
        .where((entry) => entry.key.startsWith('strIngredient'))
        .map((entry) => entry.value as String)
        .where((value) => value.isNotEmpty)
        .toList();
      
  
  
}