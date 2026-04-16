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
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';

import '../data/network/user/service/notification_sync_service.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool _isInitialized = false;

  /// INIT – call ONCE from main.dart
  Future<void> init() async {
    if (_isInitialized) return;

    OneSignal.Debug.setLogLevel(OSLogLevel.none);
    final appId = await _fetchOneSignalAppId();
    OneSignal.initialize(appId ?? "70d48857-661a-4b36-b757-f221c97a1103");

    // await OneSignal.Notifications.requestPermission(true);

    _setupNotificationClickHandler();
    _setupForegroundNotificationHandler();

    _isInitialized = true;
    debugPrint('✅ OneSignal initialized');
  }

  Future<String?> _fetchOneSignalAppId() async {
    try {
      final uri = Uri.parse(
        ApiConstants.thirdPartySettings,
      ).replace(queryParameters: {'page': '1', 'limit': '10'});
      final res = await http.get(uri, headers: await ApiConstants.getHeaders());
      if (res.statusCode != 200) return null;
      final body = json.decode(res.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>? ?? {};
      final items = data['items'] as List<dynamic>? ?? [];
      for (final item in items) {
        final m = item as Map<String, dynamic>;
        final type = (m['type'] ?? '').toString().toLowerCase();
        final name = (m['name'] ?? '').toString().toLowerCase();
        if (type == 'push notification' || name.contains('onesignal')) {
          final key = m['apiKey']?.toString();
          if (key != null && key.isNotEmpty) return key;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
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
    debugPrint('🔔 [OneSignal] Attaching GUEST user');
    if (!_isInitialized) {
      debugPrint('⚠️ OneSignal not initialized yet');
      return;
    }
    // 1️⃣ Check existing player
    final existingId = OneSignal.User.pushSubscription.id;
    debugPrint('🆔 [OneSignal] Existing playerId: $existingId');

    if (existingId != null) {
      await NotificationSyncService.instance.syncToBackend(
        deviceToken: existingId,
      );
      debugPrint('ℹ️ [OneSignal] Guest already attached → $existingId');
      return;
    }

    // 2️⃣ Generate guest external id
    final guestId = "guest_${DateTime.now().millisecondsSinceEpoch}";
    debugPrint('👻 Generated guest externalId: $guestId');

    // 3️⃣ Login guest
    await OneSignal.login(guestId);
    debugPrint('✅ [OneSignal] login() called for guest');

    // 4️⃣ Add guest tags
    await OneSignal.User.addTags({"is_guest": "true", "role": "guest"});
    debugPrint('🏷️ [Oignal] Tags set → is_gueneSst=true, role=guest');

    // 5️⃣ Confirm playerId
    final playerId = OneSignal.User.pushSubscription.id;
    if (playerId != null) {
      await NotificationSyncService.instance.syncToBackend(
        deviceToken: playerId,
      );
    }
    debugPrint('🆔 [OneSignal] Guest playerId: $playerId');

    debugPrint('🎉 [OneSignal] Guest user attached successfully');
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
    debugPrint('🔔 [OneSignal] Attaching LOGGED-IN user');
    debugPrint('👤 User ID : $userId');
    debugPrint('🎭 Role    : $role');

    // 1️⃣ Login user in OneSignal
    await OneSignal.login(userId);
    debugPrint('✅ [OneSignal] login() called');

    // 2️⃣ Add tags
    await OneSignal.User.addTags({
      "is_guest": "false",
      "role": role.toLowerCase(),
    });
    debugPrint(
      '🏷️ [OneSignal] Tags set → is_guest=false, role=${role.toLowerCase()}',
    );

    // 3️⃣ Get current playerId
    final playerId = OneSignal.User.pushSubscription.id;
    debugPrint('🆔 [OneSignal] Current playerId: $playerId');

    if (playerId != null && syncToBackend != null) {
      debugPrint('📡 [SYNC] Sending playerId to backend (initial)');
      await syncToBackend(playerId);
      await SecureStorage.saveNotificationToken(playerId);
    }

    // 4️⃣ Observe playerId changes (rare but important)
    OneSignal.User.pushSubscription.addObserver((state) {
      final id = state.current.id;
      debugPrint('🔄 [OneSignal] pushSubscription changed → $id');

      if (id != null && syncToBackend != null) {
        debugPrint('📡 [SYNC] Sending updated playerId to backend');
        syncToBackend(id);
      }
    });

    debugPrint('🎉 [OneSignal] Logged-in user attached successfully');
  }

  /// ---------------- LOGOUT ----------------
  Future<void> resetToGuest() async {
    // Some Android builds/devices can hang/crash inside the native SDK during logout.
    // Never block app navigation on this.
    try {
      await OneSignal.logout().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('⏱️ [OneSignal] logout() timed out (continuing)');
        },
      );
    } catch (e) {
      debugPrint('❌ [OneSignal] logout() failed: $e');
    }

    try {
      await attachGuestUser().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('⏱️ [OneSignal] attachGuestUser() timed out (continuing)');
        },
      );
    } catch (e) {
      debugPrint('❌ [OneSignal] attachGuestUser() failed: $e');
    }

    debugPrint('🔄 Player ID reset after logout (best-effort)');
  }

  /// ---------------- HANDLERS ----------------
  void _setupNotificationClickHandler() {
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      debugPrint('🔔 Notification clicked: $data');
    });
  }

  void _setupForegroundNotificationHandler() {
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.notification.display();
    });
  }

  /// ---------------- GETTERS ----------------
  String? get playerId => OneSignal.User.pushSubscription.id;
}
