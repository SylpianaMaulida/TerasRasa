import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeDetailPage extends StatefulWidget {
  final String mealId;

  const RecipeDetailPage({super.key, required this.mealId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Future<Map<String, dynamic>> recipeDetail;

  @override
  void initState() {
    super.initState();
    recipeDetail = fetchRecipeDetail(widget.mealId);
  }

  Future<Map<String, dynamic>> fetchRecipeDetail(String id) async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['meals'][0]; // Mendapatkan data resep pertama
    } else {
      throw Exception('Failed to load recipe detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Resep'),
        backgroundColor: const Color.fromRGBO(180, 122, 92, 1),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: recipeDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            var meal = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Resep
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        meal['strMealThumb'],
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Nama Resep
                    Text(
                      meal['strMeal'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Kategori Resep
                    Text(
                      'Kategori: ${meal['strCategory']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    // Deskripsi Resep
                    Text(
                      meal['strInstructions'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    // Bahan-bahan Resep
                    Text(
                      'Bahan-bahan:',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    for (int i = 1; i <= 20; i++)
                      if (meal['strIngredient$i'] != null && meal['strIngredient$i'] != '')
                        Text(
                          '${meal['strIngredient$i']} - ${meal['strMeasure$i']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
