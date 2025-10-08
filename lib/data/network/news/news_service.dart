import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:http/http.dart' as http;

import 'news_model.dart';

class NewsService {
  final String baseUrl = ApiConstants.news; // Adjust endpoint if needed

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Fetch News Articles (Paginated) ====================
  Future<PaginationResponse<NewsItem>> fetchNews({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      debugPrint("Fetching News from: $uri");

      final response = await http.get(uri, headers: await headers());

      debugPrint("News API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<NewsItem>.fromJson(
          data,
          (json) => NewsItem.fromJson(json),
        );
      } else {
        debugPrint("Failed to fetch news: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to load news articles",
          type: SnackBarType.error,
        );

        throw Exception("Failed to load news articles");
      }
    } catch (e) {
      debugPrint("Exception in fetchNews: $e");
      rethrow;
    }
  }

  ///==================== Get Single News by ID ====================
  Future<NewsItem?> getNewsById(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );

      debugPrint("Get news by ID response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NewsModel.fromJson(jsonData).data?.items?.first;
      } else {
        debugPrint("Failed to get news by ID: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Get news by ID exception: $e");
    }
    return null;
  }
}
