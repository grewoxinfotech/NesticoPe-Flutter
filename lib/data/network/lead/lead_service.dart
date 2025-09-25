import 'dart:convert';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../../modules/seller/module/lead_screen/model/lead_model.dart';

class LeadService {
  final String baseUrl = "${ApiConstants.leads}";

  /// Common headers
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch paginated leads
  Future<PaginationResponse<LeadItem>> fetchLeads({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Leads API data: $data");

        return PaginationResponse<LeadItem>.fromJson(
          data,
              (json) => LeadItem.fromJson(json),
        );
      } else {
        print("Failed to load leads: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load leads");
      }
    } catch (e) {
      print("Exception in fetchLeads: $e");
      rethrow;
    }
  }

  /// Create new lead
  Future<bool> createLead(LeadItem lead) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await headers(),
        body: jsonEncode(lead.toJson()),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Create lead exception: $e");
      return false;
    }
  }

  /// Update lead
  Future<bool> updateLead(String id, LeadItem lead) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
        body: jsonEncode(lead.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Update lead exception: $e");
      return false;
    }
  }

  /// Delete lead
  Future<bool> deleteLead(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Delete lead exception: $e");
      return false;
    }
  }
}
