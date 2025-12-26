import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ProductService {
  // Helper: Ambil Header Token untuk otorisasi
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // 1. GET: Ambil Semua Produk
  Future<List<Map<String, dynamic>>> getProducts() async {
    final url = Uri.parse(ApiConstants.productsEndpoint);
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => {
          'id': item['id'],
          'title': item['title'],
          'subtitle': item['subtitle'] ?? 'Coffee',
          'price': item['price'],
          'image': item['image'] ?? 'assets/images/product1.jpg', // Default image jika null
          'category': item['category'],
        }).toList();
      } else {
        throw Exception('Gagal mengambil data produk: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }

  // 2. POST: Tambah Produk Baru
  Future<bool> addProduct(String title, double price, String category) async {
    final url = Uri.parse(ApiConstants.productsEndpoint);
    final headers = await _getHeaders();

    final body = jsonEncode({
      'title': title,
      'price': price,
      'category': category,
      'subtitle': 'New Arrival', 
      'image': 'assets/images/product1.jpg'
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 3. PUT: Update Produk (Edit)
  Future<bool> updateProduct(int id, String title, double price, String category) async {
    final url = Uri.parse('${ApiConstants.productsEndpoint}/$id');
    final headers = await _getHeaders();
    
    final body = jsonEncode({
      'title': title,
      'price': price,
      'category': category,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 4. DELETE: Hapus Produk
  Future<bool> deleteProduct(int id) async {
    final url = Uri.parse('${ApiConstants.productsEndpoint}/$id');
    final headers = await _getHeaders();

    try {
      final response = await http.delete(url, headers: headers);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}