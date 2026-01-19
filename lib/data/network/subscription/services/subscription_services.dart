import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:http/http.dart' as http;

import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';

import '../model/subscription_model.dart';
import '../model/user_subscription_model.dart';

class SubscriptionPlanService {
  final String baseUrl = ApiConstants.subscriptionPlan; // <-- Your endpoint
  final String subscription = ApiConstants.subscription; // <-- Your endpoint
  final String subscriptionInquiry =
      ApiConstants.subscriptionPlanInquiry; // <-- Your endpoint

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  ///==================== Fetch Subscription Plans (Paginated) ====================
  Future<PaginationResponse<SubscriptionPlan>> fetchPlans({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': "all",
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      debugPrint("Fetching Plans from: $uri");

      final response = await http.get(uri, headers: await headers());

      debugPrint("Plans API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<SubscriptionPlan>.fromJson(
          data,
          (json) => SubscriptionPlan.fromJson(json),
        );
      } else {
        debugPrint("Failed to fetch plans: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to load subscription plans",
          type: SnackBarType.error,
        );

        throw Exception("Failed to load subscription plans");
      }
    } catch (e) {
      debugPrint("Exception in fetchPlans: $e");
      rethrow;
    }
  }

  ///==================== Get Single Subscription Plan by ID ====================
  Future<SubscriptionPlan?> getPlanById(String id) async {
    try {
      final url = "$baseUrl/$id";
      debugPrint("Get plan by ID: $url");

      final response = await http.get(Uri.parse(url), headers: await headers());

      debugPrint("Get plan by ID response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final model = SubscriptionPlansResponse.fromJson(jsonBody);

        return model.data.items.isNotEmpty ? model.data.items.first : null;
      } else {
        debugPrint("Failed to get plan by ID: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Get plan by ID exception: $e");
    }
    return null;
  }

  Future<bool> buySubscriptionPlan(String planId) async {
    try {
      final uri = subscription;
      final payload = {'planId': planId.toString(), "autoRenew": false};
      print("Buy plan payload: $payload");

      print("Buy plan url: $uri");
      final response = await http.post(
        Uri.parse(uri),
        headers: await headers(),
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      debugPrint("Buy plan response: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: data['message'],
          contentType: ContentType.failure,
        );
        return false;
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString(),
        contentType: ContentType.failure,
      );
      print("Exception in BuyPlan: $e");
      return false;
    }
  }

  Future<bool> subscriptionInquiryPlan(Map<String, dynamic> payload) async {
    try {
      final uri = subscriptionInquiry;
      print("Buy plan payload: $payload");

      print("Buy plan url: $uri");
      final response = await http.post(
        Uri.parse(uri),
        headers: await headers(),
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      debugPrint("Buy plan response: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: data['message'],
          contentType: ContentType.failure,
        );
        return false;
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString(),
        contentType: ContentType.failure,
      );
      print("Exception in BuyPlan: $e");
      return false;
    }
  }

  Future<PaginationResponse<CurrentUserSubscriptionItem>>
  fetchUserSubscriptionData({
    int page = 1,
    Map<String, String>? filters,
    required String userId,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': "all",
        if (filters != null) ...filters,
        'userId': userId,
      };

      final uri = Uri.parse(
        subscription,
      ).replace(queryParameters: queryParameters);
      debugPrint("Fetching Plans from: $uri");

      final response = await http.get(uri, headers: await headers());

      debugPrint("Plans API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<CurrentUserSubscriptionItem>.fromJson(
          data,
          (json) => CurrentUserSubscriptionItem.fromJson(json),
        );
      } else {
        debugPrint("Failed to fetch plans: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to load subscription plans",
          type: SnackBarType.error,
        );

        throw Exception("Failed to load subscription plans");
      }
    } catch (e) {
      debugPrint("Exception in fetchPlans: $e");
      rethrow;
    }
  }
}
