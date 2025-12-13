import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';

import '../model/property_approval_history.dart';

class ApprovalHistoryService {
  final String baseUrlProperty = ApiConstants.property;
  final String baseUrlProject = ApiConstants.builderProject;
  final String approval = "approval-history";

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// ==================== Fetch Approval History ====================
  Future<List<ApprovalHistory>> fetchApprovalHistory(
    String propertyId, {
    bool isProject = false,
  }) async {
    try {
      final uri =
          isProject
              ? Uri.parse("$baseUrlProject/$propertyId/$approval")
              : Uri.parse("$baseUrlProperty/$propertyId/$approval");
      debugPrint("Fetching Approval History: $uri");

      final response = await http.get(uri, headers: await headers());
      debugPrint("Approval History Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        final parsed = ApprovalHistoryResponse.fromJson(jsonBody);

        return parsed.data;
      } else {
        debugPrint("Failed to fetch approval history: ${response.statusCode}");
        throw Exception("Failed to load approval history");
      }
    } catch (e) {
      debugPrint("Exception in fetchApprovalHistory: $e");

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Unable to fetch approval history",
        contentType: ContentType.failure,
      );

      return [];
    }
  }
}
