import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:http/http.dart' as http;

import '../../../modules/seller/module/lead_screen/model/lead_model.dart';

class LeadService {
  final String baseUrl = "${ApiConstants.leads}";
  var isInitialLoaded = false.obs;

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
    bool fromReseller = false,
  }) async {
    final user = await SecureStorage.getUserData();
    try {
      Map<String, String> queryParameters;

      if (page == 1) {
        // First page: ignore filters
        queryParameters = {
          'page': page.toString(),
          if (filters != null) ...filters,
        };
      } else {
        // Subsequent pages: include filters if any

        queryParameters = {if (filters != null) ...filters, 'limit': 'all'};
      }
      // print('$baseUrl/sellerleads/${user?.user?.id ?? ''}');
      print('from reseller :${fromReseller}');
      final uri = Uri.parse(
        fromReseller
            ? "$baseUrl"
            : "$baseUrl/sellerleads/${user?.user?.id ?? ''}",
      ).replace(queryParameters: queryParameters);
      print("Leads API URL: $uri");
      final response = await http.get(uri, headers: await headers());
      print("Leads API response: ${response.body}");

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
      debugPrint("Create lead response: ${response.body}");
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
