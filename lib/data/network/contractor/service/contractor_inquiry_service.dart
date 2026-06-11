import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import '../../../../utils/logger/app_logger.dart';
import '../../../../widgets/messages/snack_bar.dart';
import 'subscription/subscription_limit_guard.dart';
import '../model/contractor_quotation/contractor_quotation.dart';
import '../model/contractot_service_model/contractor_inquiry_model.dart';

class ContractorInquiryService {
  ContractorInquiryService._();
  static ContractorInquiryService contractorInquiryService =
      ContractorInquiryService._();
  final _baseUrl = ApiConstants.contractorInquiry;
  final _baseUrlQutation = ApiConstants.contractorInquiryQuotation;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ContractorInquiryItem>> fetchContractorInquiry({
    int page = 1,
    Map<String, String>? filters,
    required String id,
  }) async {
    log("USer $id");
    try {
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse("$_baseUrl").replace(queryParameters: queryParams);

      log("Contractor Inquiry Url $uri");
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Inquiry data: $data");

        return PaginationResponse<ContractorInquiryItem>.fromJson(
          data,
          (json) => ContractorInquiryItem.fromMap(json),
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

  Future<PaginationResponse<ContractorQuotation>> fetchContractorQuotation({
    int page = 1,
    Map<String, String>? filters,
    required String id,
  }) async {
    log("USer $id");
    try {
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(
        "$_baseUrlQutation",
      ).replace(queryParameters: queryParams);

      log("Contractor Quotation Url $uri");
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Quotation data: $data");

        return PaginationResponse<ContractorQuotation>.fromJson(
          data,
          (json) => ContractorQuotation.fromMap(json),
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

  Future<bool> updateStatusOfInquiry(String id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: await headers(),
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Inquiry Status Change : $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      } else {
        print("Failed to Change Status: ${response.statusCode}");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Response body: ${response.body}");
        throw Exception("Failed to Change Status");
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception in Status: $e");
      return false;
    }
  }

  Future<bool> updateStatusOfQuotation(String id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrlQutation/$id'),
        headers: await headers(),
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Quotation Status Change : $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      } else {
        print("Failed to Change Status: ${response.statusCode}");
        print("Response body: ${response.body}");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        throw Exception("Failed to Change Status");
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception in Status: $e");
      return false;
    }
  }

  Future<bool> deleteInquiry(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await headers(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Inquiry Deleted : $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );

        return data['success'];
      } else {
        print("Failed to Delete Inquiry: ${response.statusCode}");
        print("Response body: ${response.body}");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        throw Exception("Failed to Delete Inquiry");
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception in Delete Inquiry: $e");
      return false;
    }
  }

  Future<bool> deleteQuotation(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrlQutation/$id'),
        headers: await headers(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Quotation Deleted : $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      } else {
        print("Failed to Delete Quotation: ${response.statusCode}");
        print("Response body: ${response.body}");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        throw Exception("Failed to Delete Quotation");
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception in Delete Quotation: $e");
      return false;
    }
  }

  Future<bool> getQuotation(String id) async {
    try {
      final uri = Uri.parse('$_baseUrlQutation/$id/download-pdf');
      final response = await http.get(
        uri,
        headers: await headers(),
      );

      debugPrint("Get Quotation Response: $uri - status:${response.statusCode}");

      final bytes = response.bodyBytes;
      final contentType = response.headers['content-type'] ?? '';

      if (response.statusCode == 200) {
        // Check if the response is a PDF (content-type or PDF magic header)
        final isPdf = contentType.contains('application/pdf') ||
            (bytes.length >= 4 && bytes[0] == 0x25 && bytes[1] == 0x50 && bytes[2] == 0x44 && bytes[3] == 0x46);
        if (isPdf) {
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/quotation_$id.pdf');
          await file.writeAsBytes(bytes, flush: true);
          // Try to open the file (optional)
          try {
            await OpenFilex.open(file.path);
          } catch (e) {
            print('Could not open PDF: $e');
          }
          NesticoPeSnackBar.showAwesomeSnackbar(   
            title: 'Success',
            message: 'PDF downloaded',
            contentType: ContentType.success,
          );
          return true;
        }

        // If not a PDF, try to parse as JSON and show message
        final bodyString = utf8.decode(bytes);
        final data = jsonDecode(bodyString);
        print('Contractor Quotation Response : $data');
        final jsonData = json.decode(bodyString);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'] ?? 'Success',
          contentType: ContentType.success,
        );
        return data['success'] ?? true;
      } else {
        print("Failed to get Quotation: ${response.statusCode}");
        final bodyString = utf8.decode(bytes);
        print("Response body: $bodyString");
        try {
          final jsonData = json.decode(bodyString);
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Failed',
            message: jsonData['message'],
            contentType: ContentType.failure,
          );
        } catch (_) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Failed',
            message: 'Failed to download quotation',
            contentType: ContentType.failure,
          );
        }
        throw Exception('Failed to get Quotation');
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Something went wrong',
        contentType: ContentType.failure,
      );
      print("Exception in getQuotation: $e");
      return false;
    }
  }

  Future<bool> convertInquiryIntoLead(Map<String, dynamic> lead) async {
    try {
      debugPrint("Lead Data to Convert: $lead");
      debugPrint("Lead Data JSON: ${jsonEncode(lead)}");
      final response = await http.post(
        Uri.parse(ApiConstants.leads),
        headers: await headers(),
        body: jsonEncode(lead),
      );
      debugPrint("Checj skjdsjjd dfsdgsfd ${ApiConstants.leads} ");
      debugPrint(
        "Convert Inquiry Into Lead Response: ${response.statusCode} - ${response.body} ",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Contractor Inquiry Convert Into Lead : $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      } else {
        final handled = await SubscriptionLimitGuard.handlePlanLimitResponse(
          response,
        );
        if (handled) return false;

        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Failed to convert Into Lead: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception Convert Into Lead $e");
      return false;
    }
  }

  Future<bool> convertInquiryQuotation(Map<String, dynamic> quotation) async {
    try {
      print("Quotation Convert: $quotation");
      final response = await http.post(
        Uri.parse(_baseUrlQutation),
        headers: await headers(),
        body: jsonEncode(quotation),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        print("Contractor Inquiry Send Quotation : $data");
        return data['success'];
      } else {
        final handled = await SubscriptionLimitGuard.handlePlanLimitResponse(
          response,
        );
        if (handled) return false;

        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Failed to Send Quotation: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception Convert Into Lead $e");
      return false;
    }
  }

  Future<bool> updateQuotation(Map<String, dynamic> quotation) async {
    try {
      AppLogger.structured("Quotation Update:", quotation);
      final response = await http.put(
        Uri.parse('$_baseUrlQutation/${quotation['id']}'),
        headers: await headers(),
        body: jsonEncode(quotation),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        print("Contractor Inquiry Send Quotation : $data");
        return data['success'];
      } else {
        final handled = await SubscriptionLimitGuard.handlePlanLimitResponse(
          response,
        );
        if (handled) return false;

        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Failed to Send Quotation: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception Convert Into Lead $e");
      return false;
    }
  }
}
