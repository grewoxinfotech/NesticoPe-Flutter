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
        // 'page': page.toString(),
        'limit': '10', // You can adjust the limit as needed
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaginationResponse<Contractor>.fromJson(
          data,
          (json) => Contractor.fromJson(json),
        );
      } else {
        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to load contractors",
          type: SnackBarType.error,
        );
        throw Exception("Failed to load contractors");
      }
    } catch (e) {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final parsed = data['data'];

        return Contractor.fromJson(parsed);
      } else {}
    } catch (e) {}
    return null;
  }

  Future<User> fetchUserModelById(String userId) async {
    try {
      final uri = Uri.parse('${ApiConstants.user}/$userId');
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return User.fromJson(data['data']);
      } else {
        throw Exception("Failed to load user model");
      }
    } catch (e) {
      rethrow;
    }
  }
}
