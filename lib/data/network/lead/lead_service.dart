import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/lead/model/lead_visit_model.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;

import '../../../modules/seller/module/lead_screen/model/lead_model.dart';
import '../../../widgets/messages/snack_bar.dart';
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

  Future<bool?> importLeadDataExcelFile(
      List<int> bytes,
      String fileName,
      ) async {
    try {
      print("📦 Uploading file: $fileName");
      print("📦 Bytes length: ${bytes.length}");

      if (bytes.isEmpty) {
        print("❌ File bytes are empty");
        return null;
      }

      final uri = Uri.parse("$baseUrl/import");
      final request = http.MultipartRequest("POST", uri);

      /// 🔹 Add headers (REMOVE content-type!)
      final authHeaders = await headers();
      request.headers.addAll(authHeaders);

      /// 🔹 Attach Excel file
      request.files.add(
        http.MultipartFile.fromBytes(
          "file", // Make sure backend expects this field name
          bytes,
          filename: fileName,
        ),
      );

      /// 🔹 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Successfully',
            message: decoded['message'],
            contentType: ContentType.success,
          );
          print("✅ Import successful");
          return true;
        } else {
          print("❌ Backend says failed: ${decoded["message"]}");
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Fail',
            message: decoded['message'],
            contentType: ContentType.success,
          );
          return null;
        }
      } else {
        print("❌ HTTP Error: ${response.body}");
        return null;
      }
    } catch (e, stack) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Fail',
        message: stack.toString(),
        contentType: ContentType.success,
      );
      print("💥 Import Error: $e");
      print(stack);
      return null;
    }
  }

  /*Future<bool?> importLeadDataExcelFile(
      List<int> bytes,
      String fileName,
      ) async {
    try {
      print("📦 Uploading file: $fileName");
      print("📦 Bytes length: ${bytes.length}");

      if (bytes.isEmpty) {
        print("❌ File bytes are empty");
        return null;
      }

      final uri = Uri.parse("$baseUrl/import");
      final request = http.MultipartRequest("POST", uri);

      /// 🔹 Add headers (without content-type)
      final authHeaders = await headers();
      request.headers.addAll(authHeaders);

      /// 🔹 Attach Excel file with proper content type
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          bytes,
          filename: fileName,
          contentType: http.MediaType(
            'application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          ),
        ),
      );

      print("📤 Sending multipart request...");
      print("📤 Files count: ${request.files.length}");
      print("📤 File field name: ${request.files.first.field}");
      print("📤 File length: ${request.files.first.length}");

      /// 🔹 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          print("✅ Import successful");
          return true;
        } else {
          print("❌ Backend says failed: ${decoded["message"]}");
          return null;
        }
      } else {
        print("❌ HTTP Error: ${response.body}");
        return null;
      }
    } catch (e, stack) {
      print("💥 Import Error: $e");
      print(stack);
      return null;
    }
  }
*/

  /// Fetch paginated leads with property_id filter support
  Future<PaginationResponse<LeadItem>> fetchLeads({
    int page = 1,
    String? userId,
    int limit = 10,
    Map<String, String>? filters,
    bool fromReseller = false,
    String? module
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
        if (module != null) "module":module,
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

      print("Leads dgjfdkggrthugjrtuigPI URL: $uri");
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return true;
      }
      final jsonData = json.decode(response.body);
      // final jsonData = json.decode(response.body);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Failed',
        message: jsonData['message'],
        contentType: ContentType.failure,
      );
      return false;
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
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
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return true;
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print(
          "❌ Failed to update negotiable price. Status: ${response.statusCode}",
        );
        return false;
      }
    } on SocketException catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "$e",
        contentType: ContentType.failure,
      );
      print("🌐 Network error: $e");
      return false;
    } on FormatException catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "$e",
        contentType: ContentType.failure,
      );
      print("⚠️ Invalid response format: $e");
      return false;
    } catch (e, stackTrace) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
      }

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
      }
      return response.statusCode == 200;
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
      } else {
        final data = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: data['message'],
          contentType: ContentType.failure,
        );
      }
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Delete lead exception: $e");
      return false;
    }
  }

  /// get Lead By Property Id
  Future<PaginationResponse<LeadItem>> getLeadsByProperty({
    int page = 1,
    String? userId,
    String? module,
    Map<String, String>? filters,
    required String propertyId,

  }) async {
    try {
      final Map<String, String> queryParameters;
      if (UserHelper.isReseller) {
        final user = await SecureStorage.getUserData();
        final userId = user?.user?.id ?? '';
        queryParameters = {
          'page': page.toString(),
          'property_id': propertyId,
          if (userId.isNotEmpty) 'reseller_id': userId,

          if (filters != null) ...filters,
        };
      } else {
        queryParameters = {
          'page': page.toString(),
          'property_id': propertyId,
          if (filters != null) ...filters,
        };
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      print("Lead Datfdkokodfkodfkoa URI: $uri");
      final response = await http.get(uri, headers: await headers());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppLogger.structured("Lead Data from seller", data);
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
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Failed to update lead visit data: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Create lead visit exception: $e");
      return false;
    }
  }
}
