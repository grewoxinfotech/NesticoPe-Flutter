import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';

import 'package:http/http.dart' as http;

import 'package:nesticope_app/app/constants/api_constants.dart';

import '../../../../widgets/messages/snack_bar.dart';
import '../model/property_report_model.dart';

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

  Future<PaginationResponse<PropertyReportItem>> fetchPropertyReports({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(
        '$baseUrl',
      ).replace(queryParameters: queryParameters);

      print("uri: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("data: $data");

        return PaginationResponse<PropertyReportItem>.fromJson(
          data,
          (json) => PropertyReportItem.fromJson(json),
        );
      } else {
        print("Failed to load property reports: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load property reports");
      }
    } catch (e) {
      print("Exception in fetchPropertyReports: $e");
      rethrow; // Let the controller handle it
    }
  }
}
