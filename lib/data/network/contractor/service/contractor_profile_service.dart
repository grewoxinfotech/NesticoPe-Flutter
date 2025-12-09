import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:http/http.dart' as http;

import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/app/widgets/snack_bar/custom_snackbar.dart';

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
  // Future<Contractor?> fetchContractorById(String contractorId) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse("$baseUrl/$contractorId"),
  //       headers: await headers(),
  //     );
  //
  //     debugPrint("Get Contractor by ID Response: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       final parsed = TopContractorsResponse.fromJson(data);
  //
  //       if (parsed.data.contractors.isNotEmpty) {
  //         return parsed.data.contractors.first;
  //       }
  //     } else {
  //       debugPrint("Failed to get contractor: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     debugPrint("Exception in fetchContractorById: $e");
  //   }
  //   return null;
  // }
}
