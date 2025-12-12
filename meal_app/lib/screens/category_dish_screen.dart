import 'package:flutter/material.dart';
import 'package:meal_app/models/category_dish_model.dart';
import 'package:meal_app/screens/favorite_screen.dart';
import 'package:meal_app/screens/recipe_screen.dart';
import '../services/api_service.dart';

class CategoryDishScreen extends StatefulWidget {
  
  CategoryDishScreen({
    super.key,
    required this.title,
    });

    final String title;

  @override
  State <CategoryDishScreen> createState() =>  _CategoryDishScreenState();

  static fromJson(Map<String, dynamic> x) {}
}

class  _CategoryDishScreenState extends State<CategoryDishScreen> {

  late final List<CategoryDish> _categoryDishes;
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  // search
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<CategoryDish> _filteredCategoryDish = [];

  @override
  void initState() {
    super.initState();
    _loadCategoryDishList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,

        actions: [
          // heart icon leading to all saved (favorite) recipes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                //print("Favorites icon");
                Navigator.of(context).push(
                  MaterialPageRoute(builder: 
                    (BuildContext context) => FavoriteScreen()
                  ),
                );
              }, 
              icon: Icon(Icons.favorite)
              ),
          ),
          
          // dice icon leading to a random recipe
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                MaterialPageRoute(builder: 
                (BuildContext context) => RecipeScreen())
                );
              }, 
              icon: Icon(Icons.restaurant)
            ),
          ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // searchbar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Seach for dishes...",
                    fillColor: Colors.white,

                  ),
                  onChanged: (search) {
                    _filterCategoryDish(search);
                  },
                ),
              ),

              // dishes list
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    //crossAxisSpacing: 8.0,
                    //mainAxisSpacing: 8.0,
                    ), 
                  itemCount: _filteredCategoryDish.length,
                  itemBuilder: (context, index) {
                    final categoryDish = _filteredCategoryDish[index];
                
                    return InkWell(
                      onTap: () => 
                      //print("Category id: ${categoryDish.id}"),
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: 
                        (BuildContext context) => RecipeScreen(id: categoryDish.id,))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: GridTile(
                            footer: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                color: Colors.white.withValues(alpha: 0.7),
                                child: Text(
                                  categoryDish.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                categoryDish.img,
                                fit: BoxFit.cover,
                                height: 150,
                                //width: double.infinity,
                                ),
                        
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                
                ),
              ),
            ]
        )
    );
  }


  void _loadCategoryDishList() async {
    final _categoryDishList = await _apiService.loadCategoryDishList(widget.title);
  
    setState(() {
      _categoryDishes = _categoryDishList;
      _isLoading = false;
      _filteredCategoryDish = _categoryDishList;
    });
  }

  void _filterCategoryDish(String query) {

    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCategoryDish = _categoryDishes;
      } else {
        _filteredCategoryDish = _categoryDishes
          .where((categoryDish) => categoryDish.name.toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
      }
    });
  }

}