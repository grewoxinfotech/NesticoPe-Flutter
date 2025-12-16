import 'dart:convert';

import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';
import 'package:http/http.dart' as http;

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import '../models/property_model.dart';

class SellerProjectService {
  final String baseUrl = ApiConstants.builderProject;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ProjectItem>> fetchProject({
    int page = 1,
    required String sellerId,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'created_by': sellerId,
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      print("uri: $uri");
      final response = await http.get(uri, headers: await headers());

      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("data: $data");

        return PaginationResponse<ProjectItem>.fromJson(
          data,
          (json) => ProjectItem.fromJson(json),
        );
      } else {
        print("Failed to load properties: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load properties");
      }
    } catch (e) {
      print("Exception in fetchProperties: $e");
      rethrow;
    }
  }
}
