import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'package:housing_flutter_app/app/constants/api_constants.dart';

import '../../../widgets/messages/snack_bar.dart';
import 'model/property_report_model.dart';

class PropertyReportService {
  final String baseUrl = ApiConstants.propertyReport;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Create Property Report ====================
  Future<bool> createPropertyReport(PropertyReportModel report) async {
    try {
      final uri = Uri.parse(baseUrl);
      debugPrint("Creating Property Report at: $uri");

      final body = jsonEncode(report.toJson());
      debugPrint("Report Body: $body");

      final response = await http.post(
        uri,
        headers: await headers(),
        body: body,
      );

      debugPrint("Property Report Response: ${response.body}");
      return (response.statusCode == 201 || response.statusCode == 200);
    } catch (e) {
      debugPrint("Exception in createPropertyReport: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Something went wrong while creating report",
        contentType: ContentType.failure,
      );

      return false;
    }
  }
}
