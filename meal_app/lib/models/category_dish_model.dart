class CategoryDish{
  int id;
  String name;
  String img;

  CategoryDish({
    required this.id,
    required this.name,
    required this.img,
  });

  CategoryDish.fromJson(Map<String, dynamic> data)
    : id = int.parse(data['idMeal']),
      name = data['strMeal'],
      img = data['strMealThumb'];

}