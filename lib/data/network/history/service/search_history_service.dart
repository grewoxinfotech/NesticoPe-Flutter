import 'dart:convert';
import 'dart:developer';

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/confige/helper/api_helper.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class SearchHistoryService {
  // Add your methods and properties here

  SearchHistoryService._();

  static SearchHistoryService service = SearchHistoryService._();

  final String baseUrl = ApiConstants.searchHistory;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<bool> addSearchHistory(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await headers(),
        body: jsonEncode(data),
      );
      try {
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          return data['success'];
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchSearchHistory() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user/history"),
        headers: await headers(),
      );
      try {
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          return data;
        } else {
          return {};
        }
      } catch (e) {
        return {};
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deletedSearchHistory() async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/clear/history"),
        headers: await headers(),
      );
      try {
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          return data['success'];
        } else {
          return false;
        }
      } catch (e) {
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }
}
