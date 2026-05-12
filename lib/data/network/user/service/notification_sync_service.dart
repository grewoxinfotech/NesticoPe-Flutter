import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

import '../../../../app/constants/api_constants.dart';

class NotificationSyncService {
  NotificationSyncService._();
  static final NotificationSyncService instance = NotificationSyncService._();

  final String syncNotificationUrl = ApiConstants.sendNotificationId;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<void> syncToBackend({
    required String deviceToken,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final reqHeaders = await headers();
      final payload = {
        'deviceToken': deviceToken,
        'deviceType': Platform.isAndroid ? 'android' : 'ios',
        // 'metadata': metadata ?? {},
      };

      final response = await http.post(
        Uri.parse(syncNotificationUrl),
        headers: reqHeaders,
        body: jsonEncode(payload),
      );

      debugPrint('📦 Notification sync response: ${syncNotificationUrl}');
      

      final data = jsonDecode(response.body);

      debugPrint('📦 Notification sync payload: $payload');
      debugPrint('📩 Notification sync response: $data');

      if (response.statusCode == 200 && data['success'] == true) {
        debugPrint('✅ Notification sync successful');
      } else {
        debugPrint('❌ Notification sync failed: ${data['message']}');
      }
    } catch (e, stack) {
      debugPrint('❌ Error during notification sync: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> removeNotificationToken(String deviceToken) async {
    try {
      final reqHeaders = await headers();
      final response = await http.delete(
        Uri.parse(ApiConstants.removeNotificationId),
        headers: reqHeaders,
        body: jsonEncode({
          'deviceToken': deviceToken,
        }),
      );

      final data = jsonDecode(response.body);

      debugPrint('📦 Notification sync payload: $data');
      debugPrint('📩 Notification sync response: $data');


      if (response.statusCode == 200 && data['success'] == true) {
        debugPrint('✅ Notification sync successful');
      } else {
        debugPrint('❌ Notification sync failed: ${data['message']}');
      }
    } catch (e, stack) {
      debugPrint('❌ Error during notification sync: $e');
      debugPrintStack(stackTrace: stack);
    }
  }
}
