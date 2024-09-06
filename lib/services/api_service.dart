import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final String baseUrl = 'https://t2210m-flutter.onrender.com/products';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    // Log response status and body for debugging
    print('Delete response status: ${response.statusCode}');
    print('Delete response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product: ${response.reasonPhrase}');
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'price': product.price.toInt(),
        'name': product.name,
        'description': product.description,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add product: ${response.reasonPhrase}');
    }
  }

  Future<void> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'price': product.price.toInt(),
        'name': product.name,
        'description': product.description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.reasonPhrase}');
    }
  }
}
