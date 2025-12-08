import 'dart:convert';

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../model/contractot_service_model/contractor_category_model.dart';
import '../model/contractot_service_model/contractor_service_model.dart';

class ContractorMyService {
  ContractorMyService._();

  static ContractorMyService contractorMyService = ContractorMyService._();
  final _baseUrl = ApiConstants.contractorService;
  final _baseCategory = ApiConstants.contractorServiceCategory;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<ContractorServiceCategory> getContractorByIDCategory({
    int page = 1,
    int limit = 10,
    required String fields,
  }) async {
    try {
      // Build query parameters
      // final queryParams = {
      //   'fields': fields, // Will be URL encoded automatically by Uri
      // };

      final uri = Uri.parse('$_baseCategory/$fields');

      print("Category API URI: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Category data fetched successfully: $data");
        return ContractorServiceCategory.fromMap(data['data']);
      } else {
        print("Failed to load Categories: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Categories");
      }
    } catch (e) {
      print("Exception in getContractorCategory: $e");
      return ContractorServiceCategory.fromMap({});
    }
  }

  Future<PaginationResponse<ContractorServiceItem>> fetchContractorService({
    int page = 1,
    Map<String, String>? filters,
    required String id,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,
        "contractor_id": id,
      };

      final uri = Uri.parse("$_baseUrl").replace(queryParameters: queryParams);
      print("Review URI: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Review data: $data");

        return PaginationResponse<ContractorServiceItem>.fromJson(
          data,
          (json) => ContractorServiceItem.fromJson(json),
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

  Future<void> changeActiveToInActive(String id, bool isActive) async {
    final uri = Uri.parse('$_baseUrl/$id');
    try {
      final response = await http.put(
        uri,
        headers: await headers(),
        body: jsonEncode({"isActive": isActive}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Change the active and Inactive: $data");
      } else {
        print("Failed to load Active: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Active");
      }
    } catch (e) {
      print("Response body: ${e}");
    }
  }

  Future<bool> deletedService(String id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    try {
      final response = await http.delete(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Service deleted Successfully: $data");
        return data['success'];
      } else {
        print("Failed to load deleted: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to deleted");
      }
    } catch (e) {
      print("Response body: ${e}");
      return false;
    }
  }

  Future<Map<String, dynamic>> getContractorCategory() async {
    final uri = Uri.parse('$_baseCategory');
    try {
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print("Failed to load Active: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Active");
      }
    } catch (e) {
      print("Response body: ${e}");
      return {};
    }
  }

  Future<bool> createService(Map<String, dynamic> data) async {
    final uri = Uri.parse('$_baseUrl');
    try {
      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode({'data': data}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        print("Change the active and Inactive: $data");
        return data['success'];
      } else {
        print("Failed to load Active: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Active");
      }
    } catch (e) {
      print("Response body: ${e}");
      return false;
    }
  }

  Future<bool> updateContractorService(
    Map<String, dynamic> service,
    String id,
  ) async {
    final uri = Uri.parse('$_baseUrl/$id');
    try {
      final response = await http.put(
        uri,
        headers: await headers(),
        body: jsonEncode(service),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Service Updated Successfully: $data");
        return data['success'];
      } else {
        print("Failed to update service: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to update service");

      }
    } catch (e) {
      print("Response body for update service: ${e}");
      return false;
    }
  }
}
