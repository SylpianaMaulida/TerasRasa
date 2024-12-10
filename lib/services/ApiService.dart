import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Fungsi untuk mencari makanan berdasarkan nama
  Future<List<dynamic>> searchFood(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load search results');
    }
  }

  // Fungsi untuk mendapatkan detail resep berdasarkan mealId
  Future<Map<String, dynamic>> getRecipeDetail(String mealId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/lookup.php?i=$mealId'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['meals']?.first ?? {}; // Mengembalikan detail makanan
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  // Fungsi untuk mendapatkan menu sarapan
  Future<List<dynamic>> getBreakfastMenu() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/filter.php?c=Breakfast'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load breakfast menu');
    }
  }

  // Fungsi untuk mendapatkan menu utama (Main Course)
  Future<List<dynamic>> getMainCourseMenu() async {
    final response = await http.get(Uri.parse('$_baseUrl/filter.php?c=Beef'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load main course menu');
    }
  }

  // Fungsi untuk mendapatkan menu dessert
  Future<List<dynamic>> getDessertMenu() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/filter.php?c=Dessert'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load dessert menu');
    }
  }

  // Fungsi untuk mendapatkan menu sampingan dan minuman
  Future<List<dynamic>> getSideAndDrinksMenu() async {
    List<dynamic> allMenu = [];

    // Mendapatkan menu "Side" (Makanan ringan)
    final sideResponse =
        await http.get(Uri.parse('$_baseUrl/filter.php?c=Side'));
    if (sideResponse.statusCode == 200) {
      Map<String, dynamic> sideData = json.decode(sideResponse.body);
      allMenu.addAll(sideData['meals'] ?? []);
    } else {
      throw Exception('Failed to load side menu');
    }

    // Mendapatkan menu "Ordinary Drink" (Minuman biasa)
    final drinksResponse =
        await http.get(Uri.parse('$_baseUrl/filter.php?c=Ordinary Drink'));
    if (drinksResponse.statusCode == 200) {
      Map<String, dynamic> drinksData = json.decode(drinksResponse.body);
      allMenu.addAll(drinksData['meals'] ?? []);
    } else {
      throw Exception('Failed to load drinks menu');
    }

    return allMenu;
  }

  // Fungsi untuk mendapatkan menu seafood
  Future<List<dynamic>> getSeafoodMenu() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/filter.php?c=Seafood'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load seafood menu');
    }
  }

  // Fungsi untuk mendapatkan banyak makanan acak
  Future<List<dynamic>> getRandomMeals(int count) async {
  List<dynamic> meals = [];

  for (int i = 0; i < count; i++) {
    final response = await http.get(Uri.parse('$_baseUrl/random.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Memastikan bahwa data['meals'] ada dan tidak kosong
      if (data['meals'] != null && data['meals'].isNotEmpty) {
        meals.add(data['meals']?.first);
      } else {
        print("No meals available for random meal #$i");
      }
    } else {
      throw Exception('Failed to load random meal');
    }
  }

  return meals;
}

  // Fungsi untuk mendapatkan menu rekomendasi
Future<List<dynamic>> fetchRecommendedMenu() async {
final response = await http.get(Uri.parse('$_baseUrl/filter.php?c=Beef'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return data['meals'] ?? []; // Mengambil data dari 'meals' atau mengembalikan list kosong jika tidak ada
  } else {
    throw Exception('Failed to load recommended menu');
  }
}


  // Fungsi untuk mendapatkan menu diet
  Future<List<dynamic>> getDietFood() async {
    final response = await http.get(Uri.parse('$_baseUrl/filter.php?c=Vegan'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load diet food menu');
    }
  }

  // Fungsi untuk mendapatkan menu anak-anak
  Future<List<dynamic>> getCustomKidsMenu() async {
    List<dynamic> kidsMenu = [];

    // Tambahkan menu Soup
    final soupResponse =
        await http.get(Uri.parse('$_baseUrl/filter.php?c=Soup'));
    if (soupResponse.statusCode == 200) {
      kidsMenu.addAll(json.decode(soupResponse.body)['meals'] ?? []);
    }

    // Tambahkan menu Chicken
    final chickenResponse =
        await http.get(Uri.parse('$_baseUrl/filter.php?c=Chicken'));
    if (chickenResponse.statusCode == 200) {
      kidsMenu.addAll(json.decode(chickenResponse.body)['meals'] ?? []);
    }

    // Tambahkan menu Smoothie
    final smoothieResponse =
        await http.get(Uri.parse('$_baseUrl/search.php?s=Smoothie'));
    if (smoothieResponse.statusCode == 200) {
      kidsMenu.addAll(json.decode(smoothieResponse.body)['meals'] ?? []);
    }

    return kidsMenu;
  }
}
