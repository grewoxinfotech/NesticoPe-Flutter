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
    log("Adding search history with data: $data");
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await headers(),
        body: jsonEncode(data),
      );
      try {
        log("Response status: ${Uri.parse(baseUrl)}");
        log("Response body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          AppLogger.structured(
            "Search history added successfully :",
            response.body,
          );

          final data = jsonDecode(response.body);
          return data['success'];
        } else {
          print("Failed to add search history: ${response.statusCode}");
          return false;
        }
      } catch (e) {
        print("Error parsing response: $e");
        return false;
      }
    } catch (e) {
      print("Error adding search history: $e");
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
        log("Response History Data Url: ${Uri.parse("$baseUrl/user/history")}");
        log("Response body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          AppLogger.structured(
            "Search history fetch successfully :",
            response.body,
          );

          final data = jsonDecode(response.body);
          return data;
        } else {
          print("Failed to fetch search history: ${response.statusCode}");
          return {};
        }
      } catch (e) {
        print("Error parsing response: $e");
        return {};
      }
    } catch (e) {
      print("Error adding search history: $e");
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
        log(
          "Response History Data Url: ${Uri.parse("$baseUrl/clear/history")}",
        );
        log("Response body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          AppLogger.structured(
            "Search history deleted successfully :",
            response.body,
          );

          final data = jsonDecode(response.body);
          return data['success'];
        } else {
          print("Failed to delete search history: ${response.statusCode}");
          return false;
        }
      } catch (e) {
        print("Error parsing response: $e");
        return true;
      }
    } catch (e) {
      print("Error deleting search history: $e");
      rethrow;
    }
  }
}
