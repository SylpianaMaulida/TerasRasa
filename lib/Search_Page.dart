import 'package:flutter/material.dart';
import '../services/ApiService.dart'; // Pastikan Anda mengimpor ApiService yang benar
import 'RecipeDetailPage.dart'; // Pastikan Anda mengimpor RecipeDetailPage dengan benar

class SearchPage extends StatelessWidget {
  final String query;
  const SearchPage({super.key, required this.query});  // pastikan query sudah didefinisikan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Pencarian untuk "$query"'),
        
        backgroundColor: const Color.fromRGBO(180, 122, 92, 1), // Menambahkan warna untuk AppBar
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService().searchFood(query),  // memastikan future menerima tipe yang sesuai
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada hasil ditemukan.'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var meal = snapshot.data![index];
                return buildSearchResultCard(context, meal);
              },
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk menampilkan kartu resep yang dapat diklik
  Widget buildSearchResultCard(BuildContext context, dynamic meal) {
    return InkWell(
      onTap: () {
        // Arahkan ke halaman detail resep
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
        shadowColor: Colors.black.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar makanan
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
                  : const SizedBox.shrink(), // Menangani jika gambar tidak tersedia
            ),
            // Deskripsi makanan
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 144, 92, 71),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal['strMeal'] ?? 'Nama tidak tersedia',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        meal['strCategory'] ?? 'Kategori tidak diketahui',
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
