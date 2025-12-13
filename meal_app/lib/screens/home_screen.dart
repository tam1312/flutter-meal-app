import 'package:flutter/material.dart';
import 'package:meal_app/models/category_model.dart';
import 'package:meal_app/screens/category_dish_screen.dart';
import 'package:meal_app/screens/favorites_screen.dart';
import 'package:meal_app/screens/recipe_screen.dart';
import '../services/api_service.dart';


class MyHomePage extends StatefulWidget {

  MyHomePage({
    super.key,
    required this.title,
    });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late final List<Category> _categories;
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  // search
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Category> _filteredCategory = [];

  @override
  void initState(){
    super.initState();
    _loadCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold,),
        ),
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
                    (BuildContext context) => FavoritesScreen()
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
                //print("icon pressed");
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
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              
              // the searchbar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Seach for categories...",
                    fillColor: Colors.white,

                  ),
                  onChanged: (search) {
                    _filterCategory(search);
                  },
                ),
              ),

              // the list of categories
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: _filteredCategory.length,
                  itemBuilder: (context, index) {
                    final category = _filteredCategory[index];
                
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                
                        // category image
                        leading: Image.network(
                          category.img,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                
                        // category name
                        title: Text(category.name),
                        subtitle: Text(
                          category.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () =>
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: 
                            (BuildContext context) => CategoryDishScreen(
                              title: category.name,
                              )
                            )
                          )
                        ,
                      ),
                    );
                  },
                ),
              ),
            ],
        ),
    );
  }

  void _loadCategoryList() async {
    final _categoryList = await _apiService.loadCategoryList();

    setState(() {
      _categories = _categoryList;
      _isLoading = false;
      _filteredCategory = _categoryList;
    });
  }

  void _filterCategory(String query) {

    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCategory = _categories;
      } else {
        _filteredCategory = _categories
          .where((category) => category.name.toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
      }
    });
  }


}