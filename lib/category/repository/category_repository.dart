import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category_model.dart';

class CategoryRepository {
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

    final token =
        prefs.getString('token') ?? '';

    return {
      'Content-Type':
          'application/json',
      'Authorization':
          'Bearer $token',
    };
  }

  /// ===========================
  /// GET ALL CATEGORY
  /// ===========================
  Future<List<CategoryModel>>
      getCategories() async {
    final client =
        _buildClient();

    try {
      final headers =
          await _getHeaders();

      final response =
          await client.get(
        Uri.parse(
          '$_baseUrl/categories',
        ),
        headers: headers,
      );

      if (response.statusCode ==
          200) {
        final decoded =
            json.decode(
          response.body,
        );

        List<dynamic> data =
            [];

        if (decoded is List) {
          data = decoded;
        } else if (decoded
                is Map &&
            decoded.containsKey(
              'data',
            )) {
          data =
              decoded['data'] ??
                  [];
        }

        return data
            .map(
              (e) =>
                  CategoryModel
                      .fromJson(
                e,
              ),
            )
            .toList();
      }

      throw Exception(
        'Gagal memuat kategori',
      );
    } finally {
      client.close();
    }
  }

  /// ===========================
  /// CREATE CATEGORY
  /// ===========================
  Future<void> createCategory({
    required String name,
    required String description,
  }) async {
    final client =
        _buildClient();

    try {
      final headers =
          await _getHeaders();

      final response =
          await client.post(
        Uri.parse(
          '$_baseUrl/categories',
        ),
        headers: headers,
        body: json.encode({
          "data": {
            "name": name,
            "description":
                description,
          }
        }),
      );

      if (response.statusCode !=
              200 &&
          response.statusCode !=
              201) {
        throw Exception(
          'Gagal membuat kategori: ${response.body}',
        );
      }
    } finally {
      client.close();
    }
  }

  /// ===========================
  /// UPDATE CATEGORY
  /// ===========================
  Future<void> updateCategory({
    required int id,
    required String name,
    required String description,
  }) async {
    final client =
        _buildClient();

    try {
      final headers =
          await _getHeaders();

      final response =
          await client.put(
        Uri.parse(
          '$_baseUrl/categories/$id',
        ),
        headers: headers,
        body: json.encode({
          "data": {
            "name": name,
            "description":
                description,
          }
        }),
      );

      if (response.statusCode !=
          200) {
        throw Exception(
          'Gagal update kategori: ${response.body}',
        );
      }
    } finally {
      client.close();
    }
  }

  /// ===========================
  /// DELETE CATEGORY
  /// ===========================
  Future<void>
      deleteCategory(
    int id,
  ) async {
    final client =
        _buildClient();

    try {
      final headers =
          await _getHeaders();

      final response =
          await client.delete(
        Uri.parse(
          '$_baseUrl/categories/$id',
        ),
        headers: headers,
      );

      if (response.statusCode !=
              200 &&
          response.statusCode !=
              204) {
        throw Exception(
          'Gagal menghapus kategori',
        );
      }
    } finally {
      client.close();
    }
  }
}