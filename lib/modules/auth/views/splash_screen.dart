import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/user/service/notification_sync_service.dart';
import '../../../services/notification_service.dart';
import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../auth/views/login_screen.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../dashboard/views/seller_dashboard_screen.dart';
import '../../builder/view/builder_main_screen.dart';
import '../../contractor/view/contractor_main.dart';
import '../../reseller/view/property_reseller.dart';
import '../../saved_property/controllers/property_favorite_controller.dart';
import 'onboarding_screen.dart';
import '../../home/views/select_city_screen/select_city_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
    _initialize();
  }

  // Future<void> _initialize() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   await NotificationService.instance.init();
  //   await UserHelper.initUserType();
  //
  //   final isFirstTime = await SecureStorage.isFirstTimeUser();
  //   if (isFirstTime) {
  //     await NotificationService.instance.attachGuestUser();
  //     Get.offAll(() => const OnboardingScreen());
  //     return;
  //   }
  //
  //   final isLogin = await SecureStorage.getLoggedIn();
  //   final token = await SecureStorage.getToken();
  //
  //   if (isLogin && token != null && token.isNotEmpty) {
  //     final user = await SecureStorage.getUserData();
  //     final userId = user?.user?.id?.toString();
  //
  //     if (userId != null) {
  //       await NotificationService.instance.attachLoggedInUser(
  //         userId: userId,
  //         role: UserHelper.userType?.name ?? 'buyer',
  //       );
  //     } else {
  //       await NotificationService.instance.attachGuestUser();
  //     }
  //   } else {
  //     await NotificationService.instance.attachGuestUser();
  //   }
  //
  //   Get.put(PropertyFavoriteController(), permanent: true);
  //   _navigate();
  // }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2));

    await NotificationService.instance.init();
    Future.delayed(const Duration(milliseconds: 500), () {
      OneSignal.Notifications.requestPermission(true);
    });

    await UserHelper.initUserType();

    // Buyer onboarding: user already logged in or skipped, but closed the app
    // on SelectCityScreen before choosing a city — resume city selection.
    final pendingOnboardingCity =
        await SecureStorage.getPendingOnboardingCitySelection();
    final storedCity = await SecureStorage.getSelectedCity();
    final hasStoredCity = storedCity != null && storedCity.trim().isNotEmpty;
    if (pendingOnboardingCity && !hasStoredCity) {
      final cat = await SecureStorage.getHomeCategory();
      final title =
          cat == 'Rent/Lease'
              ? 'Find or Rent Property in Your Location'
              : 'Find or Buy Property in Your Location';

      final isLogin = await SecureStorage.getLoggedIn();
      final token = await SecureStorage.getToken();
      if (isLogin && token != null && token.isNotEmpty) {
        final user = await SecureStorage.getUserData();
        final userId = user?.user?.id?.toString();
        final role = UserHelper.userType?.name ?? 'buyer';
        if (userId != null && userId.isNotEmpty) {
          await NotificationService.instance.attachLoggedInUser(
            userId: userId,
            role: role,
            syncToBackend: (playerId) async {
              await NotificationSyncService.instance.syncToBackend(
                deviceToken: playerId,
                metadata: {'user_id': userId, 'role': role, 'source': 'splash'},
              );
            },
          );
        } else {
          await NotificationService.instance.attachGuestUser();
        }
      } else {
        await NotificationService.instance.attachGuestUser();
      }

      Get.put(PropertyFavoriteController(), permanent: true);
      Get.offAll(
        () => SelectCityScreen(
          isFromLogin: true,
          resumeAfterOnboardingFromSplash: true,
          title: title,
        ),
      );
      return;
    }

    final isFirstTime = await SecureStorage.isFirstTimeUser();
    if (isFirstTime) {
      await NotificationService.instance.attachGuestUser();
      Get.offAll(() => const OnboardingScreen());
      return;
    }

    final isLogin = await SecureStorage.getLoggedIn();
    final token = await SecureStorage.getToken();

    // If not logged in, respect previous "Skip" decision.
    if (!isLogin) {
      final bool loginSkipped = await SecureStorage.getLoginSkipped();
      if (loginSkipped) {
        // User chose to skip login previously — proceed as guest to dashboard
        await NotificationService.instance.attachGuestUser();
        Get.put(PropertyFavoriteController(), permanent: true);
        Get.offAll(() => const DashboardScreen());
        return;
      } else {
        // Not skipped and not logged in — send to onboarding
        await NotificationService.instance.attachGuestUser();
        Get.offAll(() => const OnboardingScreen());
        return;
      }
    }

    if (isLogin && token != null && token.isNotEmpty) {
      print("Step -1 ");
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id?.toString();
      final role = UserHelper.userType?.name ?? 'buyer';

      if (userId != null && userId.isNotEmpty) {
        print("Step -3 ");

        await NotificationService.instance.attachLoggedInUser(
          userId: userId,
          role: role,
          syncToBackend: (playerId) async {
            // 🔁 Re-sync device on app reopen
            await NotificationSyncService.instance.syncToBackend(
              deviceToken: playerId,
              metadata: {'user_id': userId, 'role': role, 'source': 'splash'},
            );
          },
        );
      } else {
        await NotificationService.instance.attachGuestUser();
        print("Step -4 ");
      }
    } else {
      await NotificationService.instance.attachGuestUser();
      print("Step -2 ");
    }

    Get.put(PropertyFavoriteController(), permanent: true);
    _navigate();
  }

  void _navigate() {
    if (UserHelper.isBuyer) {
      Get.offAll(() => const DashboardScreen());
    } else if (UserHelper.isSellerOwner) {
      Get.offAll(() => const SellerDashboardScreen());
    } else if (UserHelper.isSellerBuilder) {
      Get.offAll(() => const BuilderMainScreen());
    } else if (UserHelper.isReseller) {
      Get.offAll(() => MainNavigationScreen());
    } else if (UserHelper.isContractor) {
      Get.offAll(() => const ContractorMainScreen());
    } else if (UserHelper.isGuest) {
      Get.offAll(() => DashboardScreen());
    } else {
      Get.offAll(() => const OtpLoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌈 Base dark gradient
          /*  Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x810E0E0E),
                  Color(0x81262626),
                  Color(0x692C2C2C),
                ],
              ),
            ),
          ),*/

          // 🌫 Full-screen blur overlay (black glassmorphism)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Colors.black.withOpacity(0.45),
                //     Colors.black.withOpacity(0.25),
                //   ],
                // ),
                color: ColorRes.primary,
              ),
            ),
          ),

          // ✨ Subtle radial glow (optional, behind logo)
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: RadialGradient(
          //       center: Alignment.center,
          //       radius: 1.0,
          //       colors: [
          //         Colors.white.withOpacity(0.05),
          //         Colors.transparent,
          //       ],
          //     ),
          //   ),
          // ),

          // 🪄 Animated Logo
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: FadeTransition(
                opacity: _animation,
                child: Container(
                  child: Image.asset(
                    'assets/images/NesticoPe_logo.png',
                    width: 230,
                    height: 230,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
