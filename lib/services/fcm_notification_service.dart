import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/user/service/notification_sync_service.dart';

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
    importance: Importance.high,
  );

  bool _initialized = false;
  String? _token;

  String? get token => _token;

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
    const initSettings = InitializationSettings(android: androidInit);
    await _local.initialize(initSettings);

    // 3) Android channel
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // 4) Foreground messages -> show local notification
    FirebaseMessaging.onMessage.listen(_onMessage);

    // 5) Background handler (must be registered once)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    _initialized = true;
    debugPrint('✅ FCMNotificationService initialized');
  }

  Future<void> requestPermissionAndFetchToken() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    _token = await FirebaseMessaging.instance.getToken();
    debugPrint('🪪 [FCM] token: $_token');
    if (_token != null && _token!.isNotEmpty) {
      await SecureStorage.saveFcmToken(_token!);
      await NotificationSyncService.instance.syncToBackend(
        deviceToken: _token!,
      
        // metadata: {'role': 'guest'},

      );
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
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}

