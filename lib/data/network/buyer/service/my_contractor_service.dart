import 'dart:convert';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../../app/constants/api_constants.dart';
import '../model/my_contractor_model.dart';

class ContractorProjectService {
  final String baseUrl = "${ApiConstants.contractorProject}";

  var isInitialLoaded = false.obs;

  /// Common headers
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// ✅ Fetch Contractor Projects (Paginated)
  Future<PaginationResponse<ContractorProjectItem>> fetchContractorProjects({
    int page = 1,
    int limit = 10,
    Map<String, String>? filters,
    String? email,
  }) async {
    try {
      Map<String, String> queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (email != null) 'clientEmail': email,
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

      print("📡 Contractor Projects API URL: $uri");
      print("📦 Query Parameters: $queryParameters");

      final response = await http.get(uri, headers: await headers());

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final result = PaginationResponse<ContractorProjectItem>.fromJson(
          decoded,
          (json) => ContractorProjectItem.fromJson(json),
        );

        isInitialLoaded.value = true;

        return result;
      } else {
        print("❌ Failed to fetch contractor projects");
        throw Exception(
          "Failed to load contractor projects: ${response.statusCode}",
        );
      }
    } catch (e, stack) {
      print("💥 Exception in fetchContractorProjects: $e");
      print(stack);
      rethrow;
    }
  }

  /// ✅ Fetch Contractor Project By ID (optional helper)
  Future<ContractorProjectItem?> fetchProjectById(String id) async {
    try {
      final uri = Uri.parse("$baseUrl/$id");

      print("📡 Project By ID API URL: $uri");

      final response = await http.get(uri, headers: await headers());

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        return ContractorProjectItem.fromJson(decoded['data'] ?? {});
      } else {
        throw Exception("Failed to fetch project by ID");
      }
    } catch (e) {
      print("💥 Exception in fetchProjectById: $e");
      rethrow;
    }
  }
}
