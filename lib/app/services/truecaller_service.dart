import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/services/notification_service.dart' as app_notif;
import 'package:nesticope_app/data/network/user/service/notification_sync_service.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
import 'package:nesticope_app/data/network/auth/service/auth_service.dart';
import 'package:nesticope_app/confige/helper/api_helper.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

class TruecallerResponse {
  final String? authorizationCode;
  final String? state;
  final String? codeVerifier;
  final String? codeChallenge;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? accessToken;

  TruecallerResponse({
    this.authorizationCode,
    this.state,
    this.codeVerifier,
    this.codeChallenge,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.accessToken,
  });
}

class TruecallerService {
  StreamSubscription? _streamSubscription;
  final currentUser = Rxn<UserModel>();
  final authState = AuthState.initial.obs;
  final RxBool isTruecallerLoading = false.obs;

  /// Initializes the Truecaller SDK
  // Future<void> initialize() async {
  //   try {
  //     await ApiConfig.ensureTruecallerClientId();
  //     if (ApiConfig.truecallerClientId.isNotEmpty) {
  //       print(
  //         "🔑 Truecaller ClientId (from server): ${ApiConfig.truecallerClientId}",
  //       );
  //     } else {
  //       print(
  //         "ℹ️ Truecaller ClientId not found in ThirdPartySettings; using manifest value",
  //       );
  //     }
  //     await TcSdk.initializeSDK(
  //       sdkOption: TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS,
  //     );
  //   } catch (e) {
  //     print("Truecaller SDK Initialization Error: $e");
  //     NesticoPeSnackBar.showAwesomeSnackbar(
  //       title: 'Initialization Error',
  //       message: 'Truecaller SDK failed to initialize',
  //       contentType: ContentType.failure,
  //     );
  //   }
  // }
  Future<void> initialize() async {
    // Truecaller SDK is supported only on Android
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await ApiConfig.ensureTruecallerClientId();

      if (ApiConfig.truecallerClientId.isNotEmpty) {
      } else {}

      await TcSdk.initializeSDK(
        sdkOption: TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS,
      );
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Initialization Error',
        message: 'Truecaller SDK failed to initialize',
        contentType: ContentType.failure,
      );
    }
  }

  /// Checks if Truecaller OAuth flow is usable
  Future<bool> isUsable() async {
    try {
      return await TcSdk.isOAuthFlowUsable;
    } catch (e) {
      return false;
    }
  }

  /// Opens the Truecaller authorization screen and listens for response
  Future<TruecallerResponse?> login() async {
    if (!Platform.isAndroid) {
      return null;
    }
    final usable = await isUsable();
    if (!usable) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Not Available',
        message: 'Truecaller is not available on this device',
        contentType: ContentType.warning,
      );
      return null;
    }

    final Completer<TruecallerResponse?> completer =
        Completer<TruecallerResponse?>();

    String? savedCodeVerifier;
    String? savedCodeChallenge;

    _streamSubscription = TcSdk.streamCallbackData.listen((callback) {
      switch (callback.result) {
        case TcSdkCallbackResult.success:
          final data = callback.tcOAuthData;
          final profile = callback.profile;

          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Truecaller Verified',
            message: 'Authorization received successfully',
            contentType: ContentType.success,
          );
          completer.complete(
            TruecallerResponse(
              authorizationCode: data?.authorizationCode,
              state: data?.state,
              codeVerifier: savedCodeVerifier,
              codeChallenge: savedCodeChallenge,
              firstName: profile?.firstName,
              lastName: profile?.lastName,
              phoneNumber: profile?.phoneNumber,
            ),
          );
          break;
        case TcSdkCallbackResult.failure:
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Login Failed',
            message: callback.error?.message ?? 'Truecaller login failed',
            contentType: ContentType.failure,
          );
          completer.complete(null);
          break;
        case TcSdkCallbackResult.verification:
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Verification Needed',
            message: 'Manual verification/OTP required',
            contentType: ContentType.warning,
          );
          completer.complete(null);
          break;
        default:
          break;
      }
    });

    try {
      TcSdk.setOAuthState("random_state");
      TcSdk.setOAuthScopes(['profile', 'phone', 'openid']);

      final codeVerifier = await TcSdk.generateRandomCodeVerifier;
      final codeChallenge = await TcSdk.generateCodeChallenge(codeVerifier);
      savedCodeVerifier = codeVerifier;
      savedCodeChallenge = codeChallenge;

      if (codeChallenge != null) {
        TcSdk.setCodeChallenge(codeChallenge);

        TcSdk.getAuthorizationCode;
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Preparation Failed',
          message: 'Failed to prepare Truecaller OAuth',
          contentType: ContentType.failure,
        );
        completer.complete(null);
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Exception',
        message: 'Error during Truecaller login',
        contentType: ContentType.failure,
      );
      if (!completer.isCompleted) completer.complete(null);
    }

    final result = await completer.future.timeout(
      const Duration(seconds: 12),
      onTimeout: () {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Request Timeout',
          message:
              'Truecaller app did not respond. Please ensure Truecaller is active or try again.',
          contentType: ContentType.warning,
        );
        return null;
      },
    );
    if (result != null) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Login Ready',
        message: 'Proceeding with backend authentication',
        contentType: ContentType.success,
      );
    }
    dispose();
    return result;
  }

  Future<bool> loginWithTrueCaller() async {
    if (!Platform.isAndroid) {
      return false;
    }
    if (isTruecallerLoading.value) return false;
    try {
      isTruecallerLoading.value = true;
      final result = await login();
      if (result == null) {
        authState.value = AuthState.unauthenticated;
        return false;
      }
      final authorizationCode = result.authorizationCode;
      final codeVerifier = result.codeVerifier;

      if (authorizationCode == null || authorizationCode.isEmpty) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Missing Code',
          message: 'Authorization code not available',
          contentType: ContentType.failure,
        );
        return false;
      }
      if (codeVerifier == null || codeVerifier.isEmpty) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Missing Verifier',
          message: 'Code verifier not available',
          contentType: ContentType.failure,
        );
        return false;
      }
      final payload = {
        'authorizationCode': authorizationCode,
        'codeVerifier': codeVerifier,
      };

      final user = await AuthService().loginWithTrueCaller(payload);
      if (user != null) {
        await SecureStorage.saveToken(user.token ?? '');
        await SecureStorage.saveUserData(user);
        await SecureStorage.saveLoggedIn(true);
        await SecureStorage.saveTermAndConditionValue(false.toString());
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Login Successful',
          message: 'Welcome to NesticoPe',
          contentType: ContentType.success,
        );

        // 3️⃣ Set user role/type
        if (user.user != null) {
          await UserHelper.setUserType(
            user.user?.userType,
            sellerType: user.user?.sellerType,
            isAadharVerified: user.user?.isAadharVerified,
          );
        }

        currentUser.value = user;
        authState.value = AuthState.authenticated;

        // 4️⃣ 🔔 NOTIFICATION SYNC
        final userId = user.user?.id?.toString();
        final role = UserHelper.userType?.name ?? 'buyer';

        if (userId != null && userId.isNotEmpty) {
          await app_notif.NotificationService.instance.attachLoggedInUser(
            userId: userId,
            role: role,
            syncToBackend: (playerId) async {
              // ✅ THIS IS THE SYNC POINT
              await NotificationSyncService.instance.syncToBackend(
                deviceToken: playerId,
                metadata: {'user_id': userId, 'role': role},
              );
            },
          );
        }
        return true;
      }

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Backend Login Failed',
        message: 'Could not complete Truecaller login',
        contentType: ContentType.failure,
      );
      return false;
    } finally {
      isTruecallerLoading.value = false;
    }
  }

  /// Properly disposes StreamSubscription
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
}
