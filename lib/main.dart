import 'package:flutter/material.dart';
import 'dessert_page.dart';
import 'sarapan_page.dart';
import 'snack_page.dart';
import 'utama_page.dart';
import 'kids_meal.dart';
import '../services/ApiService.dart';
import 'Search_Page.dart';
import 'Seafood.dart';
import 'diet_page.dart';
import '../services/ApiService.dart'; 
import 'RecipeDetailPage.dart'; 







void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/sarapan': (context) => SarapanPage(),
        '/utama': (context) => const UtamaPage(),
        '/dessert': (context) => const DessertPage(),
        '/snack': (context) => const SnackPage(),
        '/KidsMeal': (context) => const KidsMeal(),
        '/seafood': (context) => const SeafoodPage(),
        '/Diet': (context) => const DietPage(),
        '/kidsmeal': (context) => const KidsMeal(),
        '/search': (context) => const SearchPage(query: 'some query'), 

      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> searchResults = [];
  bool isLoading = false;

  void search(String query) async {
  setState(() {
    isLoading = true;
  });

  try {
    final results = await ApiService().searchFood(query);

    if (results.isEmpty) {
      // Jika tidak ada hasil ditemukan
      setState(() {
        searchResults = [];
      });
    } else {
      setState(() {
        searchResults = results;
      });
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeaderImage(),
                  buildCategoryRow(context),
                  buildSectionTitle("Recommendation menu"),
                  buildRecommendedMenuCard(),
                  buildSectionTitle("Other Information"),
                  buildInfoList(context),
                ],
              ),
            ),
    );
    
  }

 AppBar buildAppBar() {
  return AppBar(
    backgroundColor: const Color(0xFFB47A5C),
    elevation: 5,
    title: Row(
      children: [
        Expanded(child: buildSearchField()),
      ],
    ),
  );
}


  Widget buildSearchField() {
  return Container(
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: TextField(
      onSubmitted: (value) {
        search(value);  // Panggil fungsi pencarian
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(query: value),
          ),
        );
      },
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        hintText: 'what do you want to cook today',
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
      ),
    ),
  );
}


  Widget buildHeaderImage() {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/kitchen.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Teras Rasa',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: 'IslandMoments',
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCategoryItem(context, Icons.local_cafe, "Breakfast", '/sarapan'),
          buildCategoryItem(context, Icons.dinner_dining, "Main Menu", '/utama'),
          buildCategoryItem(context, Icons.cake, "Dessert", '/dessert'),
          buildCategoryItem(context, Icons.fastfood, "Snack", '/snack'),
          buildCategoryItem(context, Icons.anchor_sharp, "Seafood", '/seafood'),
       ],
      ),
    );
  }

  Widget buildCategoryItem(
      BuildContext context, IconData icon, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFB47A5C),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B4226),
        ),
      ),
    );
  }

Widget buildRecommendedMenuCard() {
  return FutureBuilder<List<dynamic>>(
    future: ApiService().fetchRecommendedMenu(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('Tidak ada menu rekomendasi ditemukan.'));
      } else {
        // Batasi jumlah item menjadi 10
        List<dynamic> limitedData = snapshot.data!.take(5).toList();
        return ListView.builder(
          shrinkWrap: true, // Agar tidak memotong widget
          physics: const NeverScrollableScrollPhysics(), // Tidak scroll terpisah
          padding: const EdgeInsets.all(8),
          itemCount: limitedData.length,
          itemBuilder: (context, index) {
            var meal = limitedData[index];
            return buildRecommendedCard(context, meal);
          },
        );
      }
    },
  );
}



// Fungsi untuk menampilkan kartu menu utama yang dapat diklik
Widget buildRecommendedCard(BuildContext context, dynamic meal) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailPage(mealId: meal['idMeal']),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: meal['strMealThumb'] != null
                ? Image.network(
                    meal['strMealThumb'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Center(child: Text('Gambar tidak tersedia')),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['strMeal'] ?? 'Nama tidak tersedia',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  meal['strCategory'] ?? 'Kategori tidak tersedia',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}



  Widget buildInfoList(BuildContext context) {
    return Column(
      children: [
       // Ubah pada bagian buildInfoList:
buildInfoCard(
  imagePath: 'assets/oatmeal.jpg',
  title: 'Diet food recommendations',
  onTap: () => Navigator.pushNamed(context, '/Diet'), 
),
buildInfoCard(
  imagePath: 'assets/makanansehat.jpg',
  title: 'Healthy food recommendations for children',
  onTap: () => Navigator.pushNamed(context, '/KidsMeal'), 
),

      ],
    );
  }

  Widget buildInfoCard(
      {required String imagePath,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
