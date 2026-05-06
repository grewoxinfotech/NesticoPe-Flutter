import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
import 'package:nesticope_app/modules/hire_contractor/view/widget/category_service_explorer.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:video_player/video_player.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/user/service/notification_sync_service.dart';
import '../../../services/notification_service.dart';
import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../dashboard/views/seller_dashboard_screen.dart';
import '../../builder/view/builder_main_screen.dart';
import '../../contractor/view/contractor_main.dart';
import '../../reseller/view/property_reseller.dart';
import '../../saved_property/controllers/property_favorite_controller.dart';
import 'onboarding_screen.dart';
import '../../home/views/select_city_screen/select_city_screen.dart';

const _kPrimary = Color(0xFF0D5D4A);
const _kPrimaryLight = Color(0xFF1A8A6A);
const _kAccent = Color(0xFF3ABFA0);
const _kAccentSoft = Color(0xFFA8F0DC);
const _kTextPrimary = Color(0xFFE1F5EE);
const _kTextSecondary = Color(0xFF9FE1CB);
const _kTextMuted = Color(0xFF5DCAA5);
const _kOverlayDark = Color(0xFF0F6E56);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;
  late final VideoPlayerController _logoVideoController;
  bool _isLogoVideoReady = false;

  Future<void> _initLogoVideo() async {
    _logoVideoController = VideoPlayerController.asset('assets/logo/Logo1.mp4');
    try {
      await _logoVideoController.initialize();
      await _logoVideoController.setLooping(false);
      await _logoVideoController.setVolume(0.0);
      await _logoVideoController.play();
      if (!mounted) return;
      setState(() => _isLogoVideoReady = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLogoVideoReady = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _loadingAnimation = CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    );
    _initLogoVideo();
    _initialize();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _logoVideoController.dispose();
    super.dispose();
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
    await Future.delayed(const Duration(seconds: 3));

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
        // print("Step -4 ");
      }
    } else {
      await NotificationService.instance.attachGuestUser();
      // print("Step -2 ");
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
      backgroundColor: Color(0xff284FE3),
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
          Positioned(
            top: 100,
            left: -10,
            right: -20,
            bottom: 100,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: CustomPaint(
                painter: CardPatternPainter(
                  color1: Colors.white.withOpacity(0.05),
                  color2: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          ),
          Positioned(
            top: -20,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1), // adjust opacity
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.asset(
                'assets/images/login_background_removebg_preview.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          // 🌫 Full-screen blur overlay (black glassmorphism)
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [
          //         const Color(0xFF284FE3).withOpacity(0.55),
          //         Color.lerp(
          //           const Color(0xFF284FE3),
          //           const Color(0xFF1B3CC4),
          //           0.55,
          //         )!
          //             .withOpacity(0.85),
          //         const Color(0xFF1B3CC4).withOpacity(0.55),
          //         // cardColors[1].withOpacity(0.9),
          //       ],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //   ),
          // ),

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
          ////=======================OLD CODE =======================
          // 🪄 Animated Logo
          // Center(
          //   child: ScaleTransition(
          //     scale: _animation,
          //     child: FadeTransition(
          //       opacity: _animation,
          //       child: Container(
          //         child: Image.asset(
          //           'assets/gif/Nestico_gif.gif',
          //           width: 230,
          //           height: 230,
          //           fit: BoxFit.contain,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          ////=======================NEW CODE =======================
          Center(
            child:
                (_isLogoVideoReady
                    ? SizedBox(
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: _logoVideoController.value.aspectRatio,

                        child: VideoPlayer(_logoVideoController),
                      ),
                    )
                    : const SizedBox.shrink()),
          ),

          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _AnimatedLoadingBar(animation: _loadingAnimation),
                const SizedBox(height: 16),
                Text(
                  'v2.1.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorRes.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 1300.ms),
        ],
      ),
    );
  }
}

class _AnimatedLoadingBar extends StatelessWidget {
  final Animation<double> animation;
  const _AnimatedLoadingBar({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorRes.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: animation.value,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          ColorRes.white.withOpacity(0.95),
                          ColorRes.white.withOpacity(0.55),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
