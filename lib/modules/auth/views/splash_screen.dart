// // /*
// // import 'dart:async';
// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// // import 'package:nesticope_app/modules/auth/views/login_screen.dart';
// // import 'package:nesticope_app/modules/dashboard/views/seller_dashboard_screen.dart';
// // import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';
// // import 'package:nesticope_app/modules/saved_property/controllers/property_favorite_controller.dart';
// // import '../../../app/constants/color_res.dart';
// // import '../../../app/utils/helper_function/user_helper/user_helper.dart';
// // import '../../../data/database/secure_storage_service.dart';
// // import '../../builder/view/builder_main_screen.dart';
// // import '../../contractor/view/contractor_main.dart';
// // import '../../dashboard/views/dashboard_screen.dart';
// // import '../../home/views/select_city_screen/select_city_screen.dart';
// // import 'onboarding_screen.dart';
// //
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   _SplashScreenState createState() => _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animationController;
// //   late Animation<double> _animation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 3),
// //     );
// //
// //     _animation = CurvedAnimation(
// //       parent: _animationController,
// //       curve: Curves.easeOut,
// //     );
// //
// //     _animationController.forward();
// //
// //     splash();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   // Future<void> splash() async {
// //   //   await Future.delayed(const Duration(seconds: 1));
// //   //
// //   //   try {
// //   //     // Initialize user type (can be guest if not logged in)
// //   //     await UserHelper.initUserType();
// //   //
// //   //     final isFirstTime = await SecureStorage.getFirstTime();
// //   //
// //   //     if (isFirstTime)
// //   //       // Fetch login info from secure storage
// //   //       final bool isLogin = await SecureStorage.getLoggedIn();
// //   //     final String? token = await SecureStorage.getToken();
// //   //     final String? selectedCity =
// //   //         await SecureStorage.getSelectedCity(); // 🆕 store selected city locally
// //   //     if (!isLogin) {
// //   //       final data = await SecureStorage.getTermAndConditionValue();
// //   //       log("Sjhdshuh $data");
// //   //       bool isAcceptable = data == "true";
// //   //       if (!isAcceptable) {
// //   //         await SecureStorage.saveTermAndConditionValue(false.toString());
// //   //       }
// //   //     }
// //   //
// //   //     print(
// //   //       "DEBUG >> isLogin=$isLogin, token=$token, role=${UserHelper.userType}, city=$selectedCity",
// //   //     );
// //   //
// //   //     // 🔹 Handle invalid login state (logged in but token missing)
// //   //     if (isLogin && (token == null || token.isEmpty)) {
// //   //       await SecureStorage.clearAll();
// //   //       UserHelper.clearUserType();
// //   //     }
// //   //
// //   //     // 🔹 City selection logic
// //   //     if (selectedCity == null || selectedCity.isEmpty) {
// //   //       // Ask user to select city before going to dashboard
// //   //       // final selected = "Surat";
// //   //       final selected = await Get.to(() => SelectCityScreen());
// //   //       print("Selected city: ${selected}");
// //   //
// //   //       if (selected != null) {
// //   //         await SecureStorage.saveSelectedCity(selected ?? "");
// //   //       }
// //   //     }
// //   //
// //   //     // ✅ Continue to dashboard (guest or logged in)
// //   //     Get.put(PropertyFavoriteController(), permanent: true);
// //   //
// //   //     if (UserHelper.isBuyer) {
// //   //       Get.offAll(() => const DashboardScreen());
// //   //       return;
// //   //     }
// //   //     if (UserHelper.isSellerOwner) {
// //   //       Get.offAll(() => const SellerDashboardScreen());
// //   //       return;
// //   //     }
// //   //     if (UserHelper.isSellerBuilder) {
// //   //       Get.offAll(() => const BuilderMainScreen());
// //   //       return;
// //   //     }
// //   //     if (UserHelper.isContractor) {
// //   //       Get.offAll(() => const ContractorMainScreen());
// //   //       return;
// //   //     }
// //   //     Get.offAll(() => const DashboardScreen());
// //   //   } catch (e) {
// //   //     print("❌ Error during splash init: $e");
// //   //     Get.offAll(() => const LoginScreen());
// //   //   }
// //   // }
// //
// //   // Future<void> splash() async {
// //   //   await Future.delayed(const Duration(seconds: 1));
// //   //
// //   //   try {
// //   //     // Initialize user type (guest / buyer / seller etc.)
// //   //     await UserHelper.initUserType();
// //   //
// //   //     // 🔹 FIRST TIME USER CHECK
// //   //     final bool isFirstTimeUser = await SecureStorage.isFirstTimeUser();
// //   //
// //   //     if (isFirstTimeUser) {
// //   //       await Get.offAll(() => const OnboardingScreen());
// //   //       await SecureStorage.setAppLaunched();
// //   //       return;
// //   //     }
// //   //
// //   //     // 🔹 LOGIN STATE
// //   //     final bool isLogin = await SecureStorage.getLoggedIn();
// //   //     final String? token = await SecureStorage.getToken();
// //   //     // final String? selectedCity = await SecureStorage.getSelectedCity();
// //   //
// //   //     // 🔹 Terms & Conditions (only for non-logged users)
// //   //     if (!isLogin) {
// //   //       final data = await SecureStorage.getTermAndConditionValue();
// //   //       bool isAcceptable = data == "true";
// //   //
// //   //       if (!isAcceptable) {
// //   //         await SecureStorage.saveTermAndConditionValue(false.toString());
// //   //       }
// //   //     }
// //   //
// //   //     // debugPrint(
// //   //     //   "DEBUG >> isLogin=$isLogin, token=$token, role=${UserHelper.userType}, city=$selectedCity",
// //   //     // );
// //   //
// //   //     // 🔹 Invalid login state fix
// //   //     if (isLogin && (token == null || token.isEmpty)) {
// //   //       await SecureStorage.clearAll();
// //   //       UserHelper.clearUserType();
// //   //     }
// //   //
// //   //     // 🔹 City selection logic
// //   //     // if (selectedCity == null || selectedCity.isEmpty) {
// //   //     //   final selected = await Get.to(() => SelectCityScreen());
// //   //     //
// //   //     //   if (selected != null) {
// //   //     //     await SecureStorage.saveSelectedCity(selected);
// //   //     //   }
// //   //     // }
// //   //
// //   //     // 🔹 Controllers
// //   //     Get.put(PropertyFavoriteController(), permanent: true);
// //   //
// //   //     // 🔹 Role-based navigation
// //   //     if (UserHelper.isBuyer) {
// //   //       Get.offAll(() => const DashboardScreen());
// //   //       return;
// //   //     }
// //   //     if (UserHelper.isSellerOwner) {
// //   //       Get.offAll(() => const SellerDashboardScreen());
// //   //       return;
// //   //     }
// //   //     if (UserHelper.isSellerBuilder) {
// //   //       Get.offAll(() => const BuilderMainScreen());
// //   //       return;
// //   //     }
// //   //     if (UserHelper.isContractor) {
// //   //       Get.offAll(() => const ContractorMainScreen());
// //   //       return;
// //   //     }
// //   //
// //   //     // Default fallback
// //   //     Get.offAll(() => const DashboardScreen());
// //   //   } catch (e) {
// //   //     debugPrint("❌ Error during splash init: $e");
// //   //     Get.offAll(() => const LoginScreen());
// //   //   }
// //   // }
// //
// //   Future<void> splash() async {
// //     await Future.delayed(const Duration(seconds: 1));
// //
// //     try {
// //       // Initialize user type (guest / buyer / seller etc.)
// //       await UserHelper.initUserType();
// //
// //       // 🔹 FIRST TIME USER CHECK
// //       final bool isFirstTimeUser = await SecureStorage.isFirstTimeUser();
// //
// //       if (isFirstTimeUser) {
// //         // Just go to onboarding - let it handle the rest
// //         await Get.offAll(() => const OnboardingScreen());
// //         return; // ✅ Stop here - onboarding will handle city selection
// //       }
// //
// //       // 🔹 LOGIN STATE
// //       final bool isLogin = await SecureStorage.getLoggedIn();
// //       final String? token = await SecureStorage.getToken();
// //
// //       // 🔹 Invalid login state fix
// //       if (isLogin && (token == null || token.isEmpty)) {
// //         await SecureStorage.clearAll();
// //         UserHelper.clearUserType();
// //         await Get.offAll(() => const LoginScreen());
// //         return;
// //       }
// //
// //       // 🔹 Terms & Conditions (only for non-logged users)
// //       if (!isLogin) {
// //         final data = await SecureStorage.getTermAndConditionValue();
// //         bool isAcceptable = data == "true";
// //
// //         if (!isAcceptable) {
// //           await SecureStorage.saveTermAndConditionValue(false.toString());
// //           // TODO: Show terms & conditions dialog/screen if needed
// //         }
// //       }
// //
// //       // 🔹 Controllers
// //       Get.put(PropertyFavoriteController(), permanent: true);
// //
// //       // 🔹 Role-based navigation
// //       if (UserHelper.isBuyer) {
// //         await Get.offAll(() => const DashboardScreen());
// //         return;
// //       }
// //       if (UserHelper.isSellerOwner) {
// //         await Get.offAll(() => const SellerDashboardScreen());
// //         return;
// //       }
// //       if (UserHelper.isSellerBuilder) {
// //         await Get.offAll(() => const BuilderMainScreen());
// //         return;
// //       }
// //       if (UserHelper.isReseller) {
// //         await Get.offAll(() => MainNavigationScreen());
// //         return;
// //       }
// //       if (UserHelper.isContractor) {
// //         await Get.offAll(() => const ContractorMainScreen());
// //         return;
// //       }
// //
// //       // Default fallback
// //       await Get.offAll(() => const DashboardScreen());
// //     } catch (e) {
// //       debugPrint("❌ Error during splash init: $e");
// //       await Get.offAll(() => const LoginScreen());
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);
// //
// //     */
// // /*return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         height: double.infinity,
// //         color: ColorRes.white,
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             // Logo Animation
// //             ScaleTransition(
// //               scale: _animation,
// //               child: FadeTransition(
// //                 opacity: _animation,
// //                 child: Column(
// //                   children: [
// //                     Container(
// //                       width: 120,
// //                       height: 120,
// //                       decoration: BoxDecoration(
// //                         color: theme.colorScheme.primary,
// //                         borderRadius: BorderRadius.circular(20),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: theme.colorScheme.primary.withOpacity(0.3),
// //                             blurRadius: 15,
// //                             offset: const Offset(0, 5),
// //                           ),
// //                         ],
// //                       ),
// //                       child: const Center(
// //                         child: Icon(
// //                           Icons.home_work,
// //                           size: 60,
// //                           color: ColorRes.white,
// //                         ),
// //                       ),
// //                     ),
// //                     // const SizedBox(height: 24),
// //                     // Text(
// //                     //   'NesticoPe',
// //                     //   style: TextStyle(
// //                     //     color: theme.colorScheme.primary,
// //                     //     fontSize: AppFontSizes.displaySmall,
// //                     //     fontWeight: FontWeight.bold,
// //                     //     letterSpacing: 2,
// //                     //   ),
// //                     // ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //
// //             // Tagline with fade animation
// //             FadeTransition(
// //               opacity: _animation,
// //               child: Text(
// //                 'NesticoPe',
// //                 style: TextStyle(
// //                   color: ColorRes.leadGreyColor.shade700,
// //                   fontSize: AppFontSizes.body,
// //                   letterSpacing: 0.5,
// //                 ),
// //               ),
// //             ),
// //
// //             // Loading indicator
// //             const SizedBox(height: 60),
// //             CircularProgressIndicator(
// //               valueColor: AlwaysStoppedAnimation<Color>(
// //                 theme.colorScheme.secondary,
// //               ),
// //               strokeWidth: 3,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );*/ /*
// //
// //     return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         height: double.infinity,
// //         color: ColorRes.white,
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             // Logo Animation
// //             ScaleTransition(
// //               scale: _animation,
// //               child: FadeTransition(
// //                 opacity: _animation,
// //                 child: Column(
// //                   children: [
// //                     Container(
// //                       width: 120,
// //                       height: 120,
// //                       decoration: BoxDecoration(
// //                         color: theme.colorScheme.primary,
// //                         borderRadius: BorderRadius.circular(20),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: theme.colorScheme.primary.withOpacity(0.3),
// //                             blurRadius: 15,
// //                             offset: const Offset(0, 5),
// //                           ),
// //                         ],
// //                       ),
// //                       child: Center(
// //                         child: Image.asset(
// //                           'assets/images/NesticoPe_logo.png', // 👈 your logo path
// //                           width: 70,
// //                           height: 70,
// //                           fit: BoxFit.contain,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //
// //             // Tagline with fade animation
// //             FadeTransition(
// //               opacity: _animation,
// //               child: Text(
// //                 'NesticoPe',
// //                 style: TextStyle(
// //                   color: ColorRes.leadGreyColor.shade700,
// //                   fontSize: AppFontSizes.body,
// //                   letterSpacing: 0.5,
// //                 ),
// //               ),
// //             ),
// //
// //             // Loading indicator
// //             const SizedBox(height: 60),
// //             CircularProgressIndicator(
// //               valueColor: AlwaysStoppedAnimation<Color>(
// //                 theme.colorScheme.secondary,
// //               ),
// //               strokeWidth: 3,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //
// //   }
// // }
// // */
// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:nesticope_app/app/constants/color_res.dart';
// // import 'package:nesticope_app/modules/auth/views/login_screen.dart';
// // import 'package:nesticope_app/modules/dashboard/views/seller_dashboard_screen.dart';
// // import 'package:nesticope_app/modules/saved_property/controllers/property_favorite_controller.dart';
// // import '../../../app/utils/helper_function/user_helper/user_helper.dart';
// // import '../../../data/database/secure_storage_service.dart';
// // import '../../../services/notification_service.dart';
// // import '../../builder/view/builder_main_screen.dart';
// // import '../../contractor/view/contractor_main.dart';
// // import '../../dashboard/views/dashboard_screen.dart';
// // import 'onboarding_screen.dart';
// //
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   _SplashScreenState createState() => _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animationController;
// //   late Animation<double> _animation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1800),
// //     );
// //
// //     _animation = CurvedAnimation(
// //       parent: _animationController,
// //       curve: Curves.easeOutBack,
// //     );
// //
// //     _animationController.forward();
// //     splash();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   // Future<void> splash() async {
// //   //   await Future.delayed(const Duration(seconds: 2));
// //   //
// //   //   try {
// //   //     await UserHelper.initUserType();
// //   //
// //   //     final bool isFirstTimeUser = await SecureStorage.isFirstTimeUser();
// //   //     if (isFirstTimeUser) {
// //   //       await Get.offAll(() => const OnboardingScreen());
// //   //       return;
// //   //     }
// //   //
// //   //     final bool isLogin = await SecureStorage.getLoggedIn();
// //   //     final String? token = await SecureStorage.getToken();
// //   //
// //   //     if (isLogin && (token == null || token.isEmpty)) {
// //   //       await SecureStorage.clearAll();
// //   //       UserHelper.clearUserType();
// //   //       await Get.offAll(() => const LoginScreen());
// //   //       return;
// //   //     }
// //   //
// //   //     Get.put(PropertyFavoriteController(), permanent: true);
// //   //
// //   //     if (UserHelper.isBuyer) {
// //   //       await Get.offAll(() => const DashboardScreen());
// //   //       return;
// //   //     }
// //   //     if (UserHelper.isSellerOwner) {
// //   //       await Get.offAll(() => const SellerDashboardScreen());
// //   //       return;
// //   //     }
// //   //     if (UserHelper.isSellerBuilder) {
// //   //       await Get.offAll(() => const BuilderMainScreen());
// //   //       return;
// //   //     }
// //   //     if (UserHelper.isContractor) {
// //   //       await Get.offAll(() => const ContractorMainScreen());
// //   //       return;
// //   //     }
// //   //
// //   //     await Get.offAll(() => const DashboardScreen());
// //   //   } catch (e) {
// //   //     debugPrint("❌ Error during splash init: $e");
// //   //     await Get.offAll(() => const LoginScreen());
// //   //   }
// //   // }
// //
// //   Future<void> splash() async {
// //     await Future.delayed(const Duration(seconds: 2));
// //
// //     try {
// //       await UserHelper.initUserType();
// //
// //       final bool isFirstTimeUser = await SecureStorage.isFirstTimeUser();
// //       if (isFirstTimeUser) {
// //         // Guest only
// //         await NotificationService.instance.setGuestUser();
// //         await Get.offAll(() => const OnboardingScreen());
// //         return;
// //       }
// //
// //       final bool isLogin = await SecureStorage.getLoggedIn();
// //       final String? token = await SecureStorage.getToken();
// //
// //       /// ❌ Logged flag true but token invalid
// //       if (isLogin && (token == null || token.isEmpty)) {
// //         await SecureStorage.clearAll();
// //         UserHelper.clearUserType();
// //
// //         // Reset notification to guest
// //         await NotificationService.instance.onLogout();
// //
// //         await Get.offAll(() => const LoginScreen());
// //         return;
// //       }
// //
// //       /// ✅ Logged in user
// //       if (isLogin && token != null && token.isNotEmpty) {
// //         final user = await SecureStorage.getUserData(); // adapt if needed
// //         final userId = user?.user?.id ?? '';
// //         final role = UserHelper.userType; // buyer / seller / contractor
// //
// //         await NotificationService.instance.onLogin(
// //           userId: userId,
// //           role: role?.name ?? '',
// //           syncToBackend: (playerId) {
// //             print('Player ID synced to backend: $playerId');
// //             // 🔥 API call here
// //             // AuthService.syncPlayerId(playerId);
// //           },
// //         );
// //       } else {
// //         /// 👤 Guest user
// //         await NotificationService.instance.setGuestUser();
// //       }
// //
// //       Get.put(PropertyFavoriteController(), permanent: true);
// //
// //       /// Navigation (unchanged)
// //       if (UserHelper.isBuyer) {
// //         await Get.offAll(() => const DashboardScreen());
// //         return;
// //       }
// //       if (UserHelper.isSellerOwner) {
// //         await Get.offAll(() => const SellerDashboardScreen());
// //         return;
// //       }
// //       if (UserHelper.isSellerBuilder) {
// //         await Get.offAll(() => const BuilderMainScreen());
// //         return;
// //       }
// //       if (UserHelper.isContractor) {
// //         await Get.offAll(() => const ContractorMainScreen());
// //         return;
// //       }
// //
// //       await Get.offAll(() => const DashboardScreen());
// //     } catch (e) {
// //       debugPrint("❌ Error during splash init: $e");
// //
// //       await NotificationService.instance.setGuestUser();
// //       await Get.offAll(() => const LoginScreen());
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Stack(
// //         fit: StackFit.expand,
// //         children: [
// //           // 🌈 Base dark gradient
// //           /*  Container(
// //             decoration: const BoxDecoration(
// //               gradient: LinearGradient(
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //                 colors: [
// //                   Color(0x810E0E0E),
// //                   Color(0x81262626),
// //                   Color(0x692C2C2C),
// //                 ],
// //               ),
// //             ),
// //           ),*/
// //
// //           // 🌫 Full-screen blur overlay (black glassmorphism)
// //           BackdropFilter(
// //             filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomRight,
// //                   colors: [
// //                     Colors.black.withOpacity(0.45),
// //                     Colors.black.withOpacity(0.25),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //
// //           // ✨ Subtle radial glow (optional, behind logo)
// //           // Container(
// //           //   decoration: BoxDecoration(
// //           //     gradient: RadialGradient(
// //           //       center: Alignment.center,
// //           //       radius: 1.0,
// //           //       colors: [
// //           //         Colors.white.withOpacity(0.05),
// //           //         Colors.transparent,
// //           //       ],
// //           //     ),
// //           //   ),
// //           // ),
// //
// //           // 🪄 Animated Logo
// //           Center(
// //             child: ScaleTransition(
// //               scale: _animation,
// //               child: FadeTransition(
// //                 opacity: _animation,
// //                 child: Container(
// //                   child: Image.asset(
// //                     'assets/images/NesticoPe_logo.png',
// //                     width: 160,
// //                     height: 160,
// //                     fit: BoxFit.contain,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/modules/auth/views/login_screen.dart';
// import 'package:nesticope_app/modules/dashboard/views/seller_dashboard_screen.dart';
// import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';
// import 'package:nesticope_app/modules/saved_property/controllers/property_favorite_controller.dart';
// import '../../../app/utils/helper_function/user_helper/user_helper.dart';
// import '../../../data/database/secure_storage_service.dart';
// import '../../../services/notification_service.dart';
// import '../../builder/view/builder_main_screen.dart';
// import '../../contractor/view/contractor_main.dart';
// import '../../dashboard/views/dashboard_screen.dart';
// import 'onboarding_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );
//
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     );
//
//     _animationController.forward();
//     _initializeApp();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initializeApp() async {
//     // Wait for animation
//     await Future.delayed(const Duration(seconds: 2));
//
//     try {
//       // Initialize user type
//       await UserHelper.initUserType();
//
//       // Check if first time user
//       final bool isFirstTimeUser = await SecureStorage.isFirstTimeUser();
//
//       if (isFirstTimeUser) {
//         // First time user - set as guest
//         await NotificationService.instance.setGuestUser();
//         await Get.offAll(() => const OnboardingScreen());
//         return;
//       }
//
//       // Check login status
//       final bool isLogin = await SecureStorage.getLoggedIn();
//       final String? token = await SecureStorage.getToken();
//
//       // Handle invalid login state
//       if (isLogin && (token == null || token.isEmpty)) {
//         debugPrint('⚠️ Invalid login state detected - clearing storage');
//         await SecureStorage.clearAll();
//         UserHelper.clearUserType();
//         await NotificationService.instance.setGuestUser();
//         await Get.offAll(() => const LoginScreen());
//         return;
//       }
//
//       // Setup notifications based on login status
//       if (isLogin && token != null && token.isNotEmpty) {
//         print('Logged in User Notification');
//         await _setupLoggedInUserNotifications();
//       } else {
//         print('Guest Logged in User Notification');
//         await _setupGuestUserNotifications();
//       }
//
//       // Initialize favorite controller
//       Get.put(PropertyFavoriteController(), permanent: true);
//
//       // Navigate based on user role
//       await _navigateToAppropriateScreen();
//     } catch (e) {
//       debugPrint("❌ Error during splash initialization: $e");
//       await NotificationService.instance.setGuestUser();
//       await Get.offAll(() => const LoginScreen());
//     }
//   }
//
//   Future<void> _setupLoggedInUserNotifications() async {
//     try {
//       // Get user data from secure storage
//       final userData = await SecureStorage.getUserData();
//
//       if (userData?.user?.id == null) {
//         debugPrint('⚠️ User data not found in storage');
//         await _setupGuestUserNotifications();
//         return;
//       }
//
//       final userId = userData!.user!.id.toString();
//       final role = UserHelper.userType?.name ?? 'buyer';
//
//       debugPrint('🔔 Setting up notifications for user: $userId, role: $role');
//
//       await NotificationService.instance.onLogin(
//         userId: userId,
//         role: role,
//         syncToBackend: (playerId) async {
//           debugPrint('✅ Player ID received: $playerId');
//
//           // TODO: Sync player ID to your backend
//           // Example API call:
//           // try {
//           //   await AuthService.syncPlayerId(playerId);
//           //   debugPrint('✅ Player ID synced to backend');
//           // } catch (e) {
//           //   debugPrint('❌ Failed to sync player ID: $e');
//           // }
//         },
//       );
//     } catch (e) {
//       debugPrint('❌ Error setting up logged-in user notifications: $e');
//       await _setupGuestUserNotifications();
//     }
//   }
//
//   Future<void> _setupGuestUserNotifications() async {
//     try {
//       await NotificationService.instance.setGuestUser();
//       debugPrint('✅ Guest user notifications configured');
//     } catch (e) {
//       debugPrint('❌ Error setting up guest notifications: $e');
//     }
//   }
//
//   Future<void> _navigateToAppropriateScreen() async {
//     // Navigate based on user role
//     if (UserHelper.isBuyer) {
//       await Get.offAll(() => const DashboardScreen());
//     } else if (UserHelper.isSellerOwner) {
//       await Get.offAll(() => const SellerDashboardScreen());
//     } else if (UserHelper.isSellerBuilder) {
//       await Get.offAll(() => const BuilderMainScreen());
//     } else if (UserHelper.isReseller) {
//       await Get.offAll(() => MainNavigationScreen());
//     } else if (UserHelper.isContractor) {
//       await Get.offAll(() => const ContractorMainScreen());
//     } else {
//       // Default fallback
//       await Get.offAll(() => const DashboardScreen());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Blur overlay with gradient
//           BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Colors.black.withOpacity(0.45),
//                     Colors.black.withOpacity(0.25),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Animated Logo
//           Center(
//             child: ScaleTransition(
//               scale: _animation,
//               child: FadeTransition(
//                 opacity: _animation,
//                 child: Image.asset(
//                   'assets/images/NesticoPe_logo.png',
//                   width: 160,
//                   height: 160,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
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
    await UserHelper.initUserType();

    final isFirstTime = await SecureStorage.isFirstTimeUser();
    if (isFirstTime) {
      await NotificationService.instance.attachGuestUser();
      Get.offAll(() => const OnboardingScreen());
      return;
    }

    final isLogin = await SecureStorage.getLoggedIn();
    final token = await SecureStorage.getToken();

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
      Get.offAll(() => const DashboardScreen());
    } else {
      Get.offAll(() => const LoginScreen());
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
                color:ColorRes.primary,
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
