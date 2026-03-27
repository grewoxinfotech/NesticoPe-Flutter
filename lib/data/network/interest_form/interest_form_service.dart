import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';

import '../../../widgets/messages/snack_bar.dart';
import 'interest_form_model.dart';

class InterestFormService {
  final String baseUrl = ApiConstants.interestForm;
  var isSubmitting = false.obs;

  /// Get headers with token
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Add new interest form
  Future<String?> addInterestForm(InterestFormModel form) async {
    isSubmitting.value = true;
    try {
      final uri = Uri.parse(baseUrl);

      debugPrint("➡️ Submitting Interest Form: ${uri.toString()}");
      debugPrint("Payload: ${jsonEncode(form.toJson())}");

      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(form.toJson()),
      );

      debugPrint("Interest Form Response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract the ID from response: data["data"]["id"]
        final String? createdId = data["data"]?["id"];

        if (createdId != null) {
          final jsonData = json.decode(response.body);
          // final jsonData = json.decode(response.body);
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Success',
            message: jsonData['message'],
            contentType: ContentType.success,
          );
          debugPrint("✅ Interest form created with ID: $createdId");
          return createdId;
        } else {
          final jsonData = json.decode(response.body);
          // final jsonData = json.decode(response.body);
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Failed',
            message: jsonData['message'],
            contentType: ContentType.failure,
          );
          debugPrint("⚠️ Response did not contain an ID");
          return null;
        }
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        debugPrint("❌ Failed to submit form: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      debugPrint("⚠️ Error submitting interest form: $e");
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<List<InterestFormModel>?> getInterestFormByPropertyAndReseller({
    required String propertyId,
    required String resellerId,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl").replace(
        queryParameters: {"propertyId": propertyId, "resellerId": resellerId},
      );

      debugPrint("🔍 Fetching Interest Form: ${uri.toString()}");

      final response = await http.get(uri, headers: await headers());
      debugPrint("Interest Form Fetch Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true && data["data"] != null) {
          // final InterestFormModel form = InterestFormModel.fromJson(
          //   data["data"],
          // );
          debugPrint("✅ Interest Form fetched successfully");
          return data
              .map((e) => InterestFormModel.fromJson(e["data"]))
              .toList();
        } else {
          debugPrint("⚠️ No Interest Form found for given IDs");
          return null;
        }
      } else {
        debugPrint("❌ Failed to fetch interest form: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching interest form: $e");
      return null;
    }
  }
}
