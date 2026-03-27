import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import '../../../../widgets/messages/snack_bar.dart';

class FeedbackService {
  final String baseUrl = ApiConstants.property; // Define this in ApiConstants

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Create Feedback ====================
  Future<bool> createFeedback({
    required String propertyId,
    required String inquiryType,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/$propertyId/feedback");
      debugPrint("Creating Feedback at: $uri");

      final body = jsonEncode({'inquiryType': inquiryType});
      debugPrint("Feedback Body: $body");

      final response = await http.put(
        uri,
        headers: await headers(),
        body: body,
      );

      debugPrint("Feedback Response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Feedback submitted successfully",
          contentType: ContentType.success,
        );
        return true;
      } else {
        debugPrint("Failed to create feedback: ${response.statusCode}");
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: "Failed to submit feedback",
          contentType: ContentType.failure,
        );
        return false;
      }
    } catch (e) {
      debugPrint("Exception in createFeedback: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Something went wrong while submitting feedback",
        contentType: ContentType.failure,
      );
      return false;
    }
  }
}
