import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/user/service/notification_sync_service.dart';
import 'package:nesticope_app/modules/property/views/property_detail_screen.dart';
import 'package:nesticope_app/modules/builder/view/project_detail/project_detail.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Keep this function top-level; avoid touching UI here.
  debugPrint('🔔 [FCM bg] ${message.messageId}');
}

class FCMNotificationService {
  FCMNotificationService._();
  static final FCMNotificationService instance = FCMNotificationService._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications.',
    importance: Importance.max,
    playSound: true,
    showBadge: true,
    enableLights: true,
    enableVibration: true,
  );

  bool _initialized = false;
  String? _token;

  String? get token => _token;

  bool isAppFullyInitialized = false;
  Map<String, dynamic>? pendingNotificationData;

  Future<void> init({bool requestPermission = false}) async {
    if (_initialized) return;

    if (requestPermission) {
      await requestPermissionAndFetchToken();
    } else {
      // Still keep token refresh for later (it will fire after a token exists).
      FirebaseMessaging.instance.onTokenRefresh.listen((t) {
        _token = t;
        debugPrint('🔁 [FCM] token refreshed: $t');
        if (t.isNotEmpty) {
          unawaited(SecureStorage.saveFcmToken(t));
        }
      });
    }

    // 2) Local notifications init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            final Map<String, dynamic> data = jsonDecode(payload);
            _handleNotificationTap(data);
          } catch (e) {
            debugPrint('❌ Error parsing local notification tap payload: $e');
          }
        }
      },
    );

    // 3) Android channel
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // 4) Foreground messages -> show local notification
    FirebaseMessaging.onMessage.listen(_onMessage);

    // 5) Background handler (must be registered once)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 6) App in background and opened via notification click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔔 [FCM onMessageOpenedApp] ${message.messageId}');
      _handleNotificationTap(message.data);
    });

    // 7) App terminated/closed and opened via notification click
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('🔔 [FCM getInitialMessage] ${message.messageId}');
        _handleNotificationTap(message.data);
      }
    });

    _initialized = true;
    debugPrint('✅ FCMNotificationService initialized');
  }

  Future<void> requestPermissionAndFetchToken() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      String? apnsToken;

      for (int i = 0; i < 10; i++) {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();

        if (apnsToken != null) {
          break;
        }

        await Future.delayed(const Duration(seconds: 1));
      }

      debugPrint('🍎 APNS Token: $apnsToken');

      if (apnsToken == null) {
        debugPrint('❌ APNS token not available yet');
        return;
      }
    }

    _token = await FirebaseMessaging.instance.getToken();
    debugPrint('🪪 [FCM] token: $_token');
    if (_token != null && _token!.isNotEmpty) {
      await SecureStorage.saveFcmToken(_token!);
      try {
        await NotificationSyncService.instance.syncToBackend(
          deviceToken: _token!,
        );
      } catch (e) {
        debugPrint('❌ [FCM] sync token failed: $e');
      }
    }
  }

  Future<void> _onMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _local.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
          showProgress: true,
          showWhen: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void checkAndHandlePendingNotification() {
    isAppFullyInitialized = true;
    if (pendingNotificationData != null) {
      debugPrint('🔔 [FCM] Processing pending notification tap: $pendingNotificationData');
      final data = pendingNotificationData!;
      pendingNotificationData = null;
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleNotificationTap(data);
      });
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    if (!isAppFullyInitialized) {
      debugPrint('🔔 [FCM Tap] App not fully initialized yet. Saving payload as pending: $data');
      pendingNotificationData = data;
      return;
    }

    debugPrint('🔔 [FCM Tap] Deep link triggered with payload data: $data');
    
    String? type = data['type']?.toString() ?? data['related_type']?.toString();
    String? propertyId = data['propertyId']?.toString() ?? data['property_id']?.toString();
    String? projectId = data['projectId']?.toString() ?? data['project_id']?.toString();
    final String? relatedId = data['related_id']?.toString();

    if (type != null) {
      final normalizedType = type.trim().toLowerCase();
      if (normalizedType == 'project' && relatedId != null && relatedId.isNotEmpty) {
        projectId = relatedId;
      } else if (normalizedType == 'property' && relatedId != null && relatedId.isNotEmpty) {
        propertyId = relatedId;
      }
    }

    // Fallback: parse action_url if type/ids are still null
    if (type == null || (projectId == null && propertyId == null)) {
      final String? actionUrl = data['action_url']?.toString();
      if (actionUrl != null && actionUrl.isNotEmpty) {
        try {
          final uri = Uri.tryParse(actionUrl);
          if (uri != null) {
            final pathSegments = uri.pathSegments;
            if (pathSegments.length >= 2) {
              final segment0 = pathSegments[0].toLowerCase();
              final segment1 = pathSegments[1];
              if (segment0 == 'project') {
                type ??= 'PROJECT';
                projectId ??= segment1;
              } else if (segment0 == 'property') {
                type ??= 'PROPERTY';
                propertyId ??= segment1;
              }
            }
          }
        } catch (e) {
          debugPrint('❌ Error parsing action_url: $e');
        }
      }
    }

    if (type == null) return;

    switch (type.toUpperCase()) {
      case 'PROJECT':
      case 'PROJECT_LISTED':
      case 'PROJECT_APPROVED':
      case 'PROJECT_REJECTED':
      case 'PROJECT_ASSIGNED':
        if (projectId != null && projectId.isNotEmpty) {
          Get.to(() => ProjectDetailsScreen(projectId: projectId));
        }
        break;

      case 'PROPERTY':
      case 'PROPERTY_LISTED':
      case 'PROPERTY_APPROVED':
      case 'PROPERTY_REJECTED':
      case 'INQUIRY_RECEIVED':
      case 'PRICE_UPDATED':
      case 'PRICE_DROPPED':
      case 'PROPERTY_ASSIGNED':
        if (propertyId != null && propertyId.isNotEmpty) {
          Get.to(() => PropertyDetailScreen(propertyId: propertyId));
        }
        break;
    }
  }
}
