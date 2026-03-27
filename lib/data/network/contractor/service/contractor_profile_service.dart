import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:http/http.dart' as http;

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';

import '../model/contractor_profile_model/contractor_profile_model.dart';

class TopContractorsService {
  final String baseUrl = ApiConstants.topContractor; // Set your endpoint here

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  ///==================== Fetch Top Contractors ====================
  Future<PaginationResponse<Contractor>> fetchTopContractors({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

      debugPrint("Fetching Top Contractors: $uri");

      final response = await http.get(uri, headers: await headers());

      debugPrint("Top Contractors API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaginationResponse<Contractor>.fromJson(
          data,
          (json) => Contractor.fromJson(json),
        );
      } else {
        debugPrint("Failed to fetch contractors: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to load contractors",
          type: SnackBarType.error,
        );
        throw Exception("Failed to load contractors");
      }
    } catch (e) {
      debugPrint("Exception in fetchTopContractors: $e");
      rethrow;
    }
  }


  ///==================== Fetch Single Contractor (If Required) ====================
  Future<Contractor?> fetchContractorById(String contractorId) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.getUserProfile}/$contractorId"),
        headers: await headers(),
      );

      debugPrint("Get Contractor by ID Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode ==201) {
        final data = jsonDecode(response.body);

        final parsed = data['data'];

       return Contractor.fromJson(parsed);
      } else {
        debugPrint("Failed to get contractor: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception in fetchContractorById: $e");
    }
    return null;
  }

  Future<User> fetchUserModelById(String userId) async {
    try {
      final uri = Uri.parse('${ApiConstants.user}/$userId');
      print("uri: $uri");
      final response = await http.get(uri, headers: await headers());

      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("USER DATA: $data");

        return User.fromJson(data['data']);
      } else {
        print("Failed to load user model: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load user model");
      }
    } catch (e) {
      print("Exception in fetchUserModelById: $e");
      rethrow;
    }
  }
}
