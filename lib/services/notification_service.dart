// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:flutter/foundation.dart';
//
// class NotificationService {
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();
//
//   bool _isInitialized = false;
//
//   /// INIT – Called on app launch
//   Future<void> init() async {
//     if (_isInitialized) {
//       debugPrint('⚠️ NotificationService already initialized');
//       return;
//     }
//
//     try {
//       // Set log level
//       OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//
//       // Initialize OneSignal with your App ID
//       OneSignal.initialize("21e16d75-ba82-4d03-9672-b66d2c59dea3");
//
//       // Request permission
//       await OneSignal.Notifications.requestPermission(true);
//
//       // Setup notification click handler
//       _setupNotificationClickHandler();
//
//       // Setup foreground notification handler
//       _setupForegroundNotificationHandler();
//
//       _isInitialized = true;
//       debugPrint('✅ NotificationService initialized successfully');
//     } catch (e) {
//       debugPrint('❌ Error initializing NotificationService: $e');
//     }
//   }
//
//   /// ---------------- GUEST USER ----------------
//   Future<void> setGuestUser() async {
//     try {
//       await OneSignal.User.addTags({"is_guest": "true", "user_type": "guest"});
//       debugPrint('✅ User marked as guest');
//     } catch (e) {
//       debugPrint('❌ Error setting guest user: $e');
//     }
//   }
//
//   /// ---------------- LOGIN ----------------
//   Future<void> onLogin({
//     required String userId,
//     required String role,
//     required Function(String playerId) syncToBackend,
//   }) async {
//     try {
//       // Set user tags
//       await OneSignal.User.addTags({
//         "user_id": userId,
//         "role": role.toLowerCase(),
//         "is_guest": "false",
//       });
//
//       debugPrint('✅ User tags set: userId=$userId, role=$role');
//
//       // Get current player ID if available
//       final currentPlayerId = OneSignal.User.pushSubscription.id;
//       if (currentPlayerId != null && currentPlayerId.isNotEmpty) {
//         debugPrint('✅ Player ID available immediately: $currentPlayerId');
//         syncToBackend(currentPlayerId);
//       }
//
//       // Also listen for future changes (in case it's not immediately available)
//       OneSignal.User.pushSubscription.addObserver((state) {
//         final playerId = state.current.id;
//
//         if (playerId != null && playerId.isNotEmpty) {
//           debugPrint('✅ Player ID from observer: $playerId');
//           syncToBackend(playerId);
//         }
//       });
//     } catch (e) {
//       debugPrint('❌ Error during onLogin: $e');
//     }
//   }
//
//   /// ---------------- LOGOUT ----------------
//   Future<void> onLogout() async {
//     try {
//       // Remove user-specific tags
//       await OneSignal.User.removeTags(["user_id", "role"]);
//
//       // Mark as guest
//       await setGuestUser();
//
//       // Logout from OneSignal (clears subscription)
//       OneSignal.logout();
//
//       debugPrint('✅ User logged out from notifications');
//     } catch (e) {
//       debugPrint('❌ Error during logout: $e');
//     }
//   }
//
//   /// ---------------- NOTIFICATION CLICK HANDLER ----------------
//   void _setupNotificationClickHandler() {
//     OneSignal.Notifications.addClickListener((event) {
//       final data = event.notification.additionalData;
//       debugPrint('🔔 Notification clicked: $data');
//
//       if (data == null) return;
//
//       // Handle deep links based on notification data
//       _handleDeepLink(data);
//     });
//   }
//
//   /// ---------------- FOREGROUND NOTIFICATION HANDLER ----------------
//   void _setupForegroundNotificationHandler() {
//     OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//       debugPrint('🔔 Foreground notification: ${event.notification.title}');
//
//       // You can modify the notification or prevent it from showing
//       // event.preventDefault(); // Prevents notification from showing
//
//       // Or display it
//       event.notification.display();
//     });
//   }
//
//   /// ---------------- DEEP LINK HANDLER ----------------
//   void _handleDeepLink(Map<String, dynamic> data) {
//     try {
//       final screen = data['screen'] as String?;
//       final propertyId = data['property_id'] as String?;
//       final userId = data['user_id'] as String?;
//
//       debugPrint(
//         '🔗 Deep link data: screen=$screen, propertyId=$propertyId, userId=$userId',
//       );
//
//       // TODO: Implement navigation based on your app's routing
//       // Example:
//       // switch (screen) {
//       //   case 'home':
//       //     Get.toNamed(Routes.HOME);
//       //     break;
//       //   case 'property_detail':
//       //     if (propertyId != null) {
//       //       Get.toNamed(Routes.PROPERTY_DETAIL, arguments: propertyId);
//       //     }
//       //     break;
//       //   case 'profile':
//       //     Get.toNamed(Routes.PROFILE);
//       //     break;
//       //   case 'chat':
//       //     if (userId != null) {
//       //       Get.toNamed(Routes.CHAT, arguments: userId);
//       //     }
//       //     break;
//       // }
//     } catch (e) {
//       debugPrint('❌ Error handling deep link: $e');
//     }
//   }
//
//   /// ---------------- GETTERS ----------------
//
//   /// Get current player ID
//   String? get playerId => OneSignal.User.pushSubscription.id;
//
//   /// Check if notifications are enabled
//   bool? get areNotificationsEnabled => OneSignal.User.pushSubscription.optedIn;
//
//   /// ---------------- ADDITIONAL METHODS ----------------
//
//   /// Set custom tags for segmentation
//   Future<void> setUserTags(Map<String, String> tags) async {
//     try {
//       await OneSignal.User.addTags(tags);
//       debugPrint('✅ Custom tags set: $tags');
//     } catch (e) {
//       debugPrint('❌ Error setting tags: $e');
//     }
//   }
//
//   /// Remove specific tags
//   Future<void> removeUserTags(List<String> keys) async {
//     try {
//       await OneSignal.User.removeTags(keys);
//       debugPrint('✅ Tags removed: $keys');
//     } catch (e) {
//       debugPrint('❌ Error removing tags: $e');
//     }
//   }
//
//   /// Opt in/out of notifications
//   Future<void> setNotificationOptIn(bool optIn) async {
//     try {
//       if (optIn) {
//         await OneSignal.User.pushSubscription.optIn();
//       } else {
//         await OneSignal.User.pushSubscription.optOut();
//       }
//       debugPrint('✅ Notification opt-in set to: $optIn');
//     } catch (e) {
//       debugPrint('❌ Error setting notification opt-in: $e');
//     }
//   }
// }

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/services/fcm_notification_service.dart';

import '../data/network/user/service/notification_sync_service.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool _isInitialized = false;
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _openedAppSub;

  /// INIT – call ONCE from main.dart
  Future<void> init() async {
    if (_isInitialized) return;
    // OneSignal disabled: use Firebase Messaging only.
    await FCMNotificationService.instance.init(requestPermission: false);
    _wireFirebaseMessageHandlers();

    _isInitialized = true;
    debugPrint('✅ Firebase notification service wired');
  }

  void _wireFirebaseMessageHandlers() {
    _tokenRefreshSub ??= FirebaseMessaging.instance.onTokenRefresh.listen((t) {
      if (t.isNotEmpty) {
        unawaited(_syncFcmTokenToBackend(role: 'guest'));
      }
    });

    _openedAppSub ??= FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationClick(message);
    });
  }

  void _handleNotificationClick(RemoteMessage message) {
    final actionUrl = message.data['action_url']?.toString();
    final propertyId = message.data['propertyId']?.toString();
    final templateKey = message.data['templateKey']?.toString();

    debugPrint(
      '🔗 [FCM] click action_url=$actionUrl propertyId=$propertyId templateKey=$templateKey',
    );

    // Route mapping can be implemented here as backend action_url paths stabilize.
  }

  /// ---------------- GUEST ----------------
  // Future<void> attachGuestUser() async {
  //   final existingId = OneSignal.User.pushSubscription.id;
  //
  //   if (existingId != null) {
  //     debugPrint('ℹ️ Guest already attached: $existingId');
  //     return;
  //   }
  //
  //   await OneSignal.login("guest_${DateTime.now().millisecondsSinceEpoch}");
  //
  //   await OneSignal.User.addTags({"is_guest": "true", "role": "guest"});
  //
  //   debugPrint('✅ Guest user attached');
  // }

  Future<void> attachGuestUser() async {
    debugPrint('🔔 [FCM] Attaching GUEST user');
    if (!_isInitialized) {
      debugPrint('⚠️ NotificationService not initialized yet');
      return;
    }

    await _syncFcmTokenToBackend(role: 'guest');
    debugPrint('🎉 [FCM] Guest token synced');
  }

  /// ---------------- LOGIN ----------------
  // Future<void> attachLoggedInUser({
  //   required String userId,
  //   required String role,
  //   Function(String playerId)? syncToBackend,
  // }) async {
  //   await OneSignal.login(userId);
  //
  //   await OneSignal.User.addTags({
  //     "is_guest": "false",
  //     "role": role.toLowerCase(),
  //   });
  //
  //   final playerId = OneSignal.User.pushSubscription.id;
  //   if (playerId != null && syncToBackend != null) {
  //     syncToBackend(playerId);
  //   }
  //
  //   OneSignal.User.pushSubscription.addObserver((state) {
  //     final id = state.current.id;
  //     if (id != null && syncToBackend != null) {
  //       syncToBackend(id);
  //     }
  //   });
  //
  //   debugPrint('✅ Logged-in user attached: $userId');
  // }

  Future<void> attachLoggedInUser({
    required String userId,
    required String role,
    Function(String playerId)? syncToBackend,
  }) async {
    debugPrint('🔔 [FCM] Attaching LOGGED-IN user');
    debugPrint('👤 User ID : $userId');
    debugPrint('🎭 Role    : $role');
    final token = await _syncFcmTokenToBackend(role: role, userId: userId);
    if (token != null && token.isNotEmpty && syncToBackend != null) {
      await syncToBackend(token);
      await SecureStorage.saveNotificationToken(token);
    }
    debugPrint('🎉 [FCM] Logged-in user token synced');
  }

  Future<String?> _syncFcmTokenToBackend({
    required String role,
    String? userId,
  }) async {
    try {
      // Do NOT request permission here; onboarding controls the prompt.
      final token =
          FCMNotificationService.instance.token ??
          await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return null;
      final resolvedUserId = userId;
      final resolvedRole = role.toLowerCase();
      if (resolvedUserId != null && resolvedUserId.isNotEmpty) {
        await NotificationSyncService.instance.syncToBackend(
          deviceToken: token,
          metadata: {
            'user_id': resolvedUserId,
            'role': resolvedRole,
            'source': 'splash',
          },
        );
      } else {
        await NotificationSyncService.instance.syncToBackend(
          deviceToken: token,
          metadata: {'role': resolvedRole},
        );
      }
      await SecureStorage.saveFcmToken(token);
      return token;
    } catch (e) {
      debugPrint('❌ [FCM] sync token failed: $e');
      return null;
    }
  }

  /// ---------------- LOGOUT ----------------
  Future<void> resetToGuest() async {
    await attachGuestUser();
    debugPrint('🔄 Guest token synced after logout');
  }

  /// ---------------- GETTERS ----------------
  String? get playerId => FCMNotificationService.instance.token;
}
