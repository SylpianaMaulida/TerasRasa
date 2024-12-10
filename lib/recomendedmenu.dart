import 'package:flutter/material.dart';
import '../services/ApiService.dart'; // Sesuaikan path dengan lokasi file ApiService Anda
import 'build_recommended_menu_card.dart'; // Import fungsi buildRecommendedMenuCard jika ada di file terpisah

class RecommendedMenu extends StatelessWidget {
  final int count;

  const RecommendedMenu({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService().getRandomMeals(count),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available.'));
        }

        final meals = snapshot.data!;

        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return buildRecommendedMenuCard(
              imageUrl: meal['strMealThumb'],
              title: meal['strMeal'],
              rating: 4.5,
              reviews: '1.2k+ reviews',
              description: 'Easy & Delicious',
            );
          },
        );
      },
    );
  }
}
