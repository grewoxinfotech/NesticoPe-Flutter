import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/lead/model/lead_visit_model.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;

import '../../../modules/seller/module/lead_screen/model/lead_model.dart';
import 'model/lead_property_inquiry_model.dart';
import 'model/lead_property_price_negotiable.dart';

class LeadService {
  final String baseUrl = "${ApiConstants.leads}";
  final String baseInquiryUrl = "${ApiConstants.propertyInquiry}";
  final String baseGetByIdInquiryUrl = "${ApiConstants.propertyByIDInquiry}";

  final String baseLeadVisitUrl = "${ApiConstants.leadVisit}";
  final String baseLeadNegotiablePriceUrl =
      "${ApiConstants.leadNegotiablePrice}";

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

      // if (page == 1) {
      // First page: include all filters including property_id
      queryParameters = {
        'page': page.toString(),
        if (userId != null) 'reseller_id': userId,
        if (filters != null) ...filters,
      };
      // } else {
      //   // Subsequent pages: include all filters including property_id
      //   queryParameters = {
      //     if (filters != null) ...filters,
      //     // 'limit': 'all'
      //   };
      // }

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
        AppLogger.structured("Lead from the ", data);

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

  Future<PaginationResponse<NewUpdatedLeadModel>> fetchContractorById({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    final user = await SecureStorage.getUserData();
    final username = user?.user?.username ?? '';
    try {
      Map<String, String> queryParameters = {};

      if (page == 1) {
        // First page: include all filters including property_id
        queryParameters = {
          'page': page.toString(),
          'name': username,
          if (filters != null) ...filters,
        };
      } else {
        // Subsequent pages: include all filters including property_id
        queryParameters = {if (filters != null) ...filters, 'limit': 'all'};
      }

      // Build the base URL
      final baseUri = baseUrl;

      final uri = Uri.parse(baseUri).replace(queryParameters: queryParameters);

      print("My Contractor Profile API URL: $uri");
      print("Query Parameters: $queryParameters");

      final response = await http.get(uri, headers: await headers());
      print(
        "My Contractor Profile API response status: ${response.statusCode}",
      );
      print("My Contractor Profile API response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<NewUpdatedLeadModel>.fromJson(
          data,
          (json) => NewUpdatedLeadModel.fromJson(json),
        );
      } else {
        print("My Contractor Profile to load leads: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("My Contractor Profile to load leads");
      }
    } catch (e) {
      print("Exception in fetchLeads: $e");
      rethrow;
    }
  }

  Future<PaginationResponse<PropertyInquireItem>> fetchInquiry({
    int page = 1,
    int? userId,
    Map<String, String>? filters,
  }) async {
    try {
      Map<String, String> queryParameters = {};

      if (page == 1) {
        // First page: include all filters including property_id
        queryParameters = {
          'page': page.toString(),
          if (userId != null) 'id': userId.toString(),

          if (filters != null) ...filters,
        };
      } else {
        // Subsequent pages: include all filters including property_id
        queryParameters = {if (filters != null) ...filters, 'limit': 'all'};
      }

      // Build the base URL
      final baseUri = "$baseInquiryUrl";

      final uri = Uri.parse(baseUri).replace(queryParameters: queryParameters);

      print("Property Inquiry API URL: $uri");
      print("Query Parameters: $queryParameters");

      final response = await http.get(uri, headers: await headers());
      print("Property Inquiry API response status: ${response.statusCode}");
      print("Property Inquiry API response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<PropertyInquireItem>.fromJson(
          data,
          (json) => PropertyInquireItem.fromMap(json),
        );
      } else {
        print("Failed to load Property Inquiry: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Property Inquiry");
      }
    } catch (e) {
      print("Exception in fetch Property Inquiry: $e");
      rethrow;
    }
  }

  Future<PropertyInquireItem?> getInquiryById(String inquiryId) async {
    try {
      final uri = Uri.parse("$baseGetByIdInquiryUrl/$inquiryId");
      print("Get Inquiry by ID API URL: $uri");

      final response = await http.get(uri, headers: await headers());

      print("Get Inquiry by ID response status: ${response.statusCode}");
      print("Get Inquiry by ID response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Depending on your API, it might return either `data` or `data['item']`
        // Adjust this line based on your actual response shape.
        final inquiryData = data['data'] ?? data;

        return PropertyInquireItem.fromMap(inquiryData);
      } else {
        print("Failed to fetch inquiry by ID: ${response.statusCode}");
        throw Exception("Failed to fetch inquiry by ID");
      }
    } catch (e) {
      print("Exception in getInquiryById: $e");
      rethrow;
    }
  }

  Future<bool> updateStatusOfNegotiable(
    Map<String, dynamic> data,
    String id,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseLeadNegotiablePriceUrl/$id"),
        headers: await headers(),
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Update lead exception: $e");
      return false;
    }
  }

  Future<bool> updateRejectOfNegotiable(
    Map<String, dynamic> data,
    String id,
  ) async {
    try {
      final url = Uri.parse("$baseLeadNegotiablePriceUrl");
      final headerData = await headers();

      print("📤 Sending POST request to: $url");
      print("📦 Payload: $data");

      final response = await http.post(
        url,
        headers: headerData,
        body: jsonEncode(data),
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print(
          "❌ Failed to update negotiable price. Status: ${response.statusCode}",
        );
        return false;
      }
    } on SocketException catch (e) {
      print("🌐 Network error: $e");
      return false;
    } on FormatException catch (e) {
      print("⚠️ Invalid response format: $e");
      return false;
    } catch (e, stackTrace) {
      print("🔥 Unexpected exception in updateRejectOfNegotiable: $e");
      print(stackTrace);
      return false;
    }
  }

  Future<PaginationResponse<NegotiableItem>> fetchLeadPrice({
    int page = 1,
    String? userId,
    String? buyerId,
    Map<String, String>? filters,
  }) async {
    try {
      Map<String, String> queryParameters = {};

      if (page == 1) {
        // First page: include all filters including property_id
        queryParameters = {
          'page': page.toString(),
          if (userId != null) 'propertyId': userId.toString(),
          if (buyerId != null) 'buyerId': buyerId.toString(),

          if (filters != null) ...filters,
        };
      } else {
        // Subsequent pages: include all filters including property_id
        queryParameters = {if (filters != null) ...filters, 'limit': 'all'};
      }

      // Build the base URL
      final baseUri = "$baseLeadNegotiablePriceUrl";

      final uri = Uri.parse(baseUri).replace(queryParameters: queryParameters);

      print("Property Negotiable Price API URL: $uri");
      print("Query Parameters: $queryParameters");

      final response = await http.get(uri, headers: await headers());
      print(
        "Property Negotiable Price API response status: ${response.statusCode}",
      );
      print("Property Negotiable Price API response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<NegotiableItem>.fromJson(
          data,
          (json) => NegotiableItem.fromMap(json),
        );
      } else {
        print(
          "Failed to load Property Negotiable Price: ${response.statusCode}",
        );
        print("Response body: ${response.body}");
        throw Exception("Failed to load Property Negotiable Price");
      }
    } catch (e) {
      print("Exception in fetch Property Negotiable Price: $e");
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

  Future<NewUpdatedLeadModel> getLeadDataByID(String id) async {
    print("Get lead data by ID: $id");
    try {
      final uri = Uri.parse("$baseUrl/$id");
      print("Lead Data URI: $uri");
      final response = await http.get(uri, headers: await headers());
      print("Lead Data response status: ${response.statusCode}");
      print("Lead Data response body: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return NewUpdatedLeadModel.fromJson(data['data']);
      } else {
        print("Failed to load lead data: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load lead data");
      }
    } catch (e) {
      print("Exception in getLeadDataByID: $e");
      rethrow;
    }
  }

  Future<PaginationResponse<LeadVisitItem>> fetchLeadVisitData({
    int page = 1,
    String? buyerId,
    String? propertyId,
    Map<String, String>? filters,
  }) async {
    try {
      Map<String, String> queryParameters = {};

      if (page == 1) {
        // First page: include all filters and property_id if present
        queryParameters = {
          'page': page.toString(),
          if (buyerId != null && buyerId.isNotEmpty) 'buyer_id': buyerId,
          if (propertyId != null && propertyId.isNotEmpty)
            'property_id': propertyId,
          if (filters != null) ...filters,
        };
      } else {
        // Subsequent pages: include filters only, with limit
        queryParameters = {if (filters != null) ...filters, 'limit': 'all'};
      }

      log("Selected QueryParameter: $queryParameters");

      // Build the base URL
      final baseUri = "$baseLeadVisitUrl";
      final uri = Uri.parse(baseUri).replace(queryParameters: queryParameters);

      print("Property LeadVisitData API URL: $uri");
      print("Query Parameters: $queryParameters");

      final response = await http.get(uri, headers: await headers());

      print(
        "Property LeadVisitData API response status: ${response.statusCode}",
      );
      print("Property LeadVisitData API response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<LeadVisitItem>.fromJson(
          data,
          (json) => LeadVisitItem.fromMap(json),
        );
      } else {
        print("Failed to load Property LeadVisitData: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Property LeadVisitData");
      }
    } catch (e) {
      print("Exception in fetch Property LeadVisitData: $e");
      rethrow;
    }
  }

  Future<bool> updateTheVisitedData(
    Map<String, dynamic> user,
    String id,
  ) async {
    try {
      log("Chnage datae ${user}");
      final response = await http.put(
        Uri.parse('$baseLeadVisitUrl/$id'),
        headers: await headers(),
        body: jsonEncode(user),
      );
      debugPrint("Update lead visit response: ${response.body}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Lead visit data updated successfully.");
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        print("Failed to update lead visit data: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Create lead visit exception: $e");
      return false;
    }
  }
}
