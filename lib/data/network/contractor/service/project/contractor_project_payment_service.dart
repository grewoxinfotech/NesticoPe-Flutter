import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';

import '../../model/contractor_project_model/contractor_project_payment_model.dart';

class MilestonePaymentService {
  MilestonePaymentService._();

  static final MilestonePaymentService instance =
  MilestonePaymentService._();

  final String _baseUrl = ApiConstants.contractorProjectMilestonePayment;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  /// 🔹 Get Milestone Payments (Paginated)
  Future<PaginationResponse<MilestonePaymentItem>> getMilestonePayments({
    int page = 1,
    bool fetchAll = false,
    required String projectId,
    Map<String, String>? filter,
  }) async {
    try {
      final fetchType = fetchAll ? 'limit' : 'page';
      final fetchValue = fetchAll ? 'all' : page.toString();

      final query = <String, String>{
        fetchType: fetchValue,
        'projectId': projectId,
        if (filter != null) ...filter,
      };

      final uri = Uri.parse(_baseUrl).replace(queryParameters: query);
      log('Milestone Payments Url => $uri');

      final response = await http.get(uri, headers: await header());
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<MilestonePaymentItem>.fromJson(
          data,
              (json) =>
              MilestonePaymentItem.fromJson(json),
        );
      } else {
        log("Failed to load milestone payments: ${response.statusCode}");
        log("Response body: ${response.body}");
        throw Exception("Failed to load milestone payments");
      }
    } catch (e) {
      log("Exception in getMilestonePayments: $e");
      rethrow;
    }
  }

  /// 🔹 Create Milestone Payment
  Future<bool> createMilestonePayment(
      Map<String, dynamic> payload) async {
    try {
      log("Create Milestone Payment Payload => $payload");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: await header(),
        body: jsonEncode(payload),
      );

      log("Response body: ${response.body}");
      log("Response status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] ?? true;
      } else {
        log("Failed to create payment");
        return false;
      }
    } catch (e) {
      log("Exception in createMilestonePayment: $e");
      return false;
    }
  }

  /// 🔹 Update Milestone Payment
  Future<bool> updateMilestonePayment({
    required String paymentId,
    required MilestonePaymentItem payload,
  }) async {
    try {
      log("Update Milestone Payment Payload => $payload");

      final uri = Uri.parse('$_baseUrl/$paymentId');
      log("Update Payment URL => $uri");

      final response = await http.put(
        uri,
        headers: await header(),
        body: jsonEncode(payload.toJson()),
      );

      log("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] ?? false;
      } else {
        log("Failed to update milestone payment: ${response.statusCode}");
        throw Exception("Failed to update milestone payment");
      }
    } catch (e) {
      log("Exception in updateMilestonePayment: $e");
      return false;
    }
  }

  /// 🔹 Delete Milestone Payment
  Future<bool> deleteMilestonePayment(String paymentId) async {
    try {
      final uri = Uri.parse('$_baseUrl/$paymentId');
      log("Delete Payment URL => $uri");

      final response = await http.delete(
        uri,
        headers: await header(),
      );

      log("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] ?? false;
      } else {
        log("Failed to delete milestone payment: ${response.statusCode}");
        throw Exception("Failed to delete milestone payment");
      }
    } catch (e) {
      log("Exception in deleteMilestonePayment: $e");
      return false;
    }
  }
}
