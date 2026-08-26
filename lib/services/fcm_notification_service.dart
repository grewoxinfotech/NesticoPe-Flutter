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
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/modules/reseller/view/lead_overview/lead_detail.dart';
import 'package:nesticope_app/modules/seller/view/widget/property_overview_seller.dart';
import 'package:nesticope_app/modules/subscription/views/my_subscription_screen.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Keep this function top-level; avoid touching UI here.
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
          } catch (e) {}
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
      _handleNotificationTap(message.data);
    });

    // 7) App terminated/closed and opened via notification click
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        _handleNotificationTap(message.data);
      } else {}
    });

    _initialized = true;
  }

  Future<void> requestPermissionAndFetchToken() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      String? apnsToken;

      for (int i = 0; i < 10; i++) {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();

        if (apnsToken != null) {
          break;
        }

        await Future.delayed(const Duration(seconds: 1));
      }

      if (apnsToken == null) {
        return;
      }
    }

    _token = await FirebaseMessaging.instance.getToken();

    if (_token != null && _token!.isNotEmpty) {
      await SecureStorage.saveFcmToken(_token!);
      try {
        await NotificationSyncService.instance.syncToBackend(
          deviceToken: _token!,
        );
      } catch (e) {}
    }
  }

  Future<void> _onMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) {
      return;
    }

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
      final data = pendingNotificationData!;
      pendingNotificationData = null;
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleNotificationTap(data);
      });
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    if (!isAppFullyInitialized) {
      pendingNotificationData = data;
      return;
    }

    final String? typeVal = data['type']?.toString();
    final String? relatedTypeVal = data['related_type']?.toString();
    final String? templateKeyVal = data['templateKey']?.toString();
    final String? relatedId = data['related_id']?.toString();
    final String? actionUrl = data['action_url']?.toString();

    bool isProject = false;
    bool isProperty = false;
    bool isSubscription = false;

    // 1) Classify based on related_type
    if (relatedTypeVal != null) {
      final normRelated = relatedTypeVal.trim().toLowerCase();

      if (normRelated == 'project') {
        isProject = true;
      } else if (normRelated == 'property') {
        isProperty = true;
      }
    }

    // 2) Classify based on type or templateKey
    final String? checkType = typeVal ?? templateKeyVal;
    if (checkType != null) {
      final normType = checkType.trim().toLowerCase();

      if (normType.contains('project')) {
        isProject = true;
      } else if (normType.contains('property') ||
          normType.contains('inquiry') ||
          normType.contains('price')) {
        isProperty = true;
      } else if (normType.contains('subscription') ||
          normType.contains('plan')) {
        isSubscription = true;
      }
    }

    // 3) Classify and extract IDs using action_url path segments
    String? urlProjectId;
    String? urlPropertyId;
    if (actionUrl != null && actionUrl.isNotEmpty) {
      try {
        final uri = Uri.tryParse(actionUrl);

        if (uri != null) {
          final pathSegments = uri.pathSegments;

          if (pathSegments.length >= 2) {
            final segment0 = pathSegments[0].toLowerCase();
            final segment1 = pathSegments[1];

            if (segment0 == 'project') {
              isProject = true;
              urlProjectId = segment1;
            } else if (segment0 == 'property') {
              isProperty = true;
              urlPropertyId = segment1;
            }
          }
        }
      } catch (e) {}
    }

    // 4) Resolve IDs
    String? propertyId =
        data['propertyId']?.toString() ??
        data['property_id']?.toString() ??
        urlPropertyId;

    String? projectId =
        data['projectId']?.toString() ??
        data['project_id']?.toString() ??
        urlProjectId;

    if (isProject && (projectId == null || projectId.isEmpty)) {
      projectId = relatedId;
    }
    if (isProperty && (propertyId == null || propertyId.isEmpty)) {
      propertyId = relatedId;
    }

    // 5) Perform role-based routing

    if (isProject && projectId != null && projectId.isNotEmpty) {
      if (UserHelper.isReseller) {
        Get.to(
          () => ProjectDetailsScreen(projectId: projectId, isBuilder: true),
        );
      } else if (UserHelper.isSellerBuilder) {
        Get.to(
          () => ProjectDetailsScreen(projectId: projectId, isBuilder: true),
        );
      } else {
        Get.to(
          () => ProjectDetailsScreen(projectId: projectId, isBuilder: false),
        );
      }
    } else if (isProperty && propertyId != null && propertyId.isNotEmpty) {
      if (UserHelper.isReseller) {
        Get.to(
          () => LeadDetailScreen(
            property: Items(id: propertyId),
            isReseller: true,
          ),
        );
      } else if (UserHelper.isSeller) {
        Get.to(
          () => PropertyOverviewSellerScreen(
            propertyId: propertyId!,
            onDelete: () {},
          ),
        );
      } else {
        Get.to(() => PropertyDetailScreen(propertyId: propertyId));
      }
    } else if (isSubscription) {
      Get.to(() => const MySubscriptionScreen());
    } else {}
  }
}
