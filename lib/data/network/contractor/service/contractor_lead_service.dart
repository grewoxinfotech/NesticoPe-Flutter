import 'dart:convert';
import 'dart:developer';

import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/confige/helper/api_helper.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../../widgets/messages/snack_bar.dart';
import '../model/contractor_lead_model/contractor_lead_model.dart';

class ContractorLeadService {
  ContractorLeadService._();
  final _basurl = ApiConstants.leads;
  static ContractorLeadService contractorLeadService =
      ContractorLeadService._();

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ContractorLeadItem>> fetchContractorLead({
    int page = 1,
    Map<String, String>? filter,
    required String id,
    required bool isConverted,
  }) async {
    try {
      final query = {
        'page': page.toString(),
        if (filter != null) ...filter,
        'reseller_id': id,
        "customFields.isConvertedToProject": isConverted.toString(),
      };
      final uri = Uri.parse(_basurl).replace(queryParameters: query);

      final response = await http.get(uri, headers: await header());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return PaginationResponse<ContractorLeadItem>.fromJson(
          data,
          (json) => ContractorLeadItem.fromMap(json),
        );
      } else {
        throw Exception("Failed to load Contractor lead Response");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteContractorLead(String id) async {
    try {
      final uri = Uri.parse('$_basurl/$id');
      final headers = await header();

      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );

        return false;
      }
    } catch (e, stack) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );

      return false;
    }
  }

  Future<bool> convertIntoProject(Map<String, dynamic> project) async {
    try {
      final uri = Uri.parse('${ApiConstants.contractorProject}');
      final headers = await header();

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(project),
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

        return data['success'];
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );

        return false;
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );

      return false;
    }
  }

  Future<bool> updateTheLeadStatusAndStage(
    Map<String, dynamic> stage,
    String id,
  ) async {
    try {
      final uri = Uri.parse('${ApiConstants.leads}/$id');
      final headers = await header();

      // 🟦 Log the request details

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(stage),
      );

      // 🟩 Log response details

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        final success = data['success'] ?? false;

        return success;
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );

        return false;
      }
    } catch (e, stack) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );

      return false;
    }
  }

  /// 🔹 Update Full Lead Details (PUT /leads/:id)
  Future<bool> updateContractorLead(
    String id,
    Map<String, dynamic> payload,
  ) async {
    try {
      final uri = Uri.parse('${ApiConstants.leads}/$id');
      final headers = await header();

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);

        final success = data['success'] == true;
        if (success) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Success',
            message: jsonData['message'],
            contentType: ContentType.success,
          );
        } else {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Failed',
            message: jsonData['message'],
            contentType: ContentType.failure,
          );
        }

        return success;
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );

        return false;
      }
    } catch (e, stack) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );

      return false;
    }
  }
}
