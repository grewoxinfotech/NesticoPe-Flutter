import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import 'package:http/http.dart' as http;

import '../model/in_app_messaging_model.dart';

class NotificationService {
  final String baseUrl = ApiConstants.notifications;
  final String baseUrlMarkAsRead = ApiConstants.notificationsMarkAsRead;

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Fetch Notifications (Paginated) ====================
  Future<PaginationResponse<NotificationItem>> fetchNotifications({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

      debugPrint("Fetching Notifications from: $uri");

      final response = await http.get(uri, headers: await headers());

      debugPrint("Notifications API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<NotificationItem>.fromJson(
          data,
          (json) => NotificationItem.fromJson(json),
        );
      } else {
        debugPrint("Failed to fetch notifications: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        // NesticoPeSnackBar.showAwesomeSnackbar(
        //   title: 'Error',
        //   message: 'Failed to load notifications',
        //   contentType: ContentType.failure,
        // );

        throw Exception("Failed to load notifications");
      }
    } catch (e) {
      debugPrint("Exception in fetchNotifications: $e");
      rethrow;
    }
  }

  ///==================== Get Single Notification by ID ====================
  Future<NotificationItem?> getNotificationById(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );

      debugPrint("Get notification by ID response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        return NotificationModel.fromJson(jsonData).data?.notifications?.first;
      } else {
        debugPrint("Failed to get notification by ID: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Get notification by ID exception: $e");
    }

    return null;
  }

  Future<bool> markReadNotificationById(String id) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/$id/read"),
        headers: await headers(),
      );

      debugPrint(
        "Get notification by ID Url : ${Uri.parse("$baseUrl/$id/read")}",
      );
      debugPrint("Get notification by ID response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        log("When the user are from ${jsonData}");

        return jsonData['success'];
      } else {
        debugPrint("Failed to get notification by ID: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Get notification by ID exception: $e");
    }

    return false;
  }

  Future<bool> updateNotificationMarkAsRead() async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrlMarkAsRead"),
        headers: await headers(),
      );

      debugPrint("Get notification by ID response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        AppLogger.structured("All Notification Clear ", jsonData);

        return jsonData['success'];
      } else {
        debugPrint("Failed to get notification by ID: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Get notification by ID exception: $e");
    }

    return false;
  }

  Future<int> fetchCountOfUnReadNotification() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/unread-count"),

        headers: await headers(),
      );

      debugPrint("Get notification by ID response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        AppLogger.structured("All Notification Clear ", jsonData);
        /*bdgdh uiuhjdb androd*/

        return jsonData['data']['unreadCount'];
      } else {
        debugPrint("Failed to get notification by ID: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Get notification by ID exception: $e");
    }

    return 0;
  }
}
