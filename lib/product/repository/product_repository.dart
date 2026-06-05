import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

class ProductRepository {
  static const String _baseUrl =
      'https://api.ppb.widiarrohman.my.id/api';

  /// SSL bypass
  http.Client _buildClient() {
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }

  /// Headers + Token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ===========================
  // GET ALL PRODUCTS
  // ===========================
  Future<List<ProductModel>> getProducts() async {
    final client = _buildClient();
    try {
      final headers = await _getHeaders();
      final response = await client.get(
        Uri.parse('$_baseUrl/products'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> data = [];
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          data = decoded['data'] ?? [];
        }
        return data.map((e) => ProductModel.fromJson(e)).toList();
      }
      throw Exception('Gagal memuat produk');
    } finally {
      client.close();
    }
  }

  // ===========================
  // CREATE PRODUCT
  // ===========================
  Future<void> createProduct(ProductModel product) async {
    final client = _buildClient();
    try {
      final headers = await _getHeaders();
      final response = await client.post(
        Uri.parse('$_baseUrl/products'),
        headers: headers,
        body: json.encode({'data': product.toJson()}),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal membuat produk: ${response.body}');
      }
    } finally {
      client.close();
    }
  }

  // ===========================
  // UPDATE PRODUCT
  // ===========================
  Future<void> updateProduct(ProductModel product) async {
    final client = _buildClient();
    try {
      final headers = await _getHeaders();
      final response = await client.put(
        Uri.parse('$_baseUrl/products/${product.id}'),
        headers: headers,
        body: json.encode({'data': product.toJson()}),
      );
      if (response.statusCode != 200) {
        throw Exception('Gagal update produk: ${response.body}');
      }
    } finally {
      client.close();
    }
  }

  // ===========================
  // DELETE PRODUCT
  // ===========================
  Future<void> deleteProduct(int id) async {
    final client = _buildClient();
    try {
      final headers = await _getHeaders();
      final response = await client.delete(
        Uri.parse('$_baseUrl/products/$id'),
        headers: headers,
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Gagal menghapus produk');
      }
    } finally {
      client.close();
    }
  }
}