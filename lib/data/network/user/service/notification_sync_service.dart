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
      final packageInfo = await PackageInfo.fromPlatform();
      final user = await SecureStorage.getUserData();
      final payload = {
        'userId': user?.user?.id ?? null,
        'device_token': deviceToken,
        'device_type': Platform.isAndroid ? 'android' : 'ios',
        'device_model': Platform.operatingSystemVersion,
        'os_version': Platform.operatingSystemVersion,
        'app_version': packageInfo.version,
        'metadata': metadata ?? {},
      };

      final response = await http.post(
        Uri.parse(syncNotificationUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

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

  Future<void> removeNotificationToken(String playerId) async {
    try {
      final user = await SecureStorage.getUserData();
      final response = await http.post(
        Uri.parse(ApiConstants.removeNotificationId),
        // headers: await headers(),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'device_token': playerId,
          'userId': user?.user?.id ?? null,
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
