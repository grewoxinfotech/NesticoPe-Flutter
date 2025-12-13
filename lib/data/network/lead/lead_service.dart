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

  /// Fetch paginated leads with property_id filter support
  Future<PaginationResponse<LeadItem>> fetchLeads({
    int page = 1,
    String? userId,
    Map<String, String>? filters,
    bool fromReseller = false,
  }) async {
    final user = await SecureStorage.getUserData();
    try {
      Map<String, String> queryParameters = {};

      if (page == 1) {
        // First page: include all filters including property_id
        queryParameters = {
          'page': page.toString(),
          if (userId != null) 'created_by': userId,
          if (filters != null) ...filters,
        };
      } else {
        // Subsequent pages: include all filters including property_id
        queryParameters = {if (filters != null) ...filters, 'limit': 'all'};
      }

      // Build the base URL
      final baseUri =
          fromReseller
              ? baseUrl
              : "$baseUrl/sellerleads/${user?.user?.id ?? ''}";

      final uri = Uri.parse(baseUri).replace(queryParameters: queryParameters);

      print("Leads API URL: $uri");
      print("Query Parameters: $queryParameters");

      final response = await http.get(uri, headers: await headers());
      print("Leads API response status: ${response.statusCode}");
      print("Leads API response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

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

  /// get Lead By Property Id
  Future<PaginationResponse<LeadItem>> getLeadsByProperty({
    int page = 1,
    String? userId,
    Map<String, String>? filters,
    required String propertyId,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'property_id': propertyId,
        if (filters != null) ...filters,
      };
      final response = await http.get(
        Uri.parse(baseUrl).replace(queryParameters: queryParameters),
        headers: await headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

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
}
