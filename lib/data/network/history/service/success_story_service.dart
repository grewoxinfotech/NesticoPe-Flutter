import 'dart:convert';

import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../model/success_story_model.dart';

class SuccessStoryService {
  SuccessStoryService._();

  static SuccessStoryService service = SuccessStoryService._();
  final _baseUrl = ApiConstants.resellerSuccessStory;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<BuyerSideResellerSuccessStoryItem>>
  fetchResellerSuccessStories({
    int page = 1,
    String? status,
    int? limit,
    String? module,
  }) async {
    try {
      final query = {
        'page': page.toString(),

        if (status != null) 'status': status,
        if (module != null) 'module': module,

        if (limit != null) 'limit': limit.toString(),
      };

      final response = await http.get(
        Uri.parse(_baseUrl).replace(queryParameters: query),
        headers: await header(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<BuyerSideResellerSuccessStoryItem>.fromJson(
          data,
          (json) => BuyerSideResellerSuccessStoryItem.fromJson(json),
        );
      } else {
        print("Failed to load Review: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Review");
      }
    } catch (e) {
      print("Exception in Review: $e");
      rethrow;
    }
  }
}
