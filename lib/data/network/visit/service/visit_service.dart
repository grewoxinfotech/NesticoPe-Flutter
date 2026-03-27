import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';

import '../../../../widgets/messages/snack_bar.dart';
import '../model/visit_model.dart';

class VisitService {
  final String baseUrl = ApiConstants.visit;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Fetch Visits (Paginated) ====================
  Future<PaginationResponse<VisitItem>> fetchVisits({
    int page = 1,
    Map<String, String>? filters,
    String? buyerId,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'buyer_id': buyerId ?? '',
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

      debugPrint("Fetch Visits URI: $uri");

      final response = await http.get(uri, headers: await headers());

      debugPrint("Fetch Visits Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<VisitItem>.fromJson(
          data,
          (json) => VisitItem.fromJson(json),
        );
      } else {
        debugPrint("Failed to load visits: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        throw Exception("Failed to load visits");
      }
    } catch (e) {
      debugPrint("Exception in fetchVisits: $e");
      rethrow; // Controller handles error
    }
  }
}


