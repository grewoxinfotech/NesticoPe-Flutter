// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';
// import 'package:housing_flutter_app/modules/auth/views/splash_screen.dart';
// import 'package:housing_flutter_app/app/services/network_status_service.dart';
// import 'package:housing_flutter_app/modules/dashboard/views/dashboard_screen.dart';
// import 'package:housing_flutter_app/app/manager/compare_manager.dart';
// import 'package:housing_flutter_app/app/manager/project_compare_manager.dart';
// import 'package:housing_flutter_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
// import 'package:housing_flutter_app/modules/no_internet/no_internet_screen.dart';
// import 'package:housing_flutter_app/services/notification_service.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'app/theme/themes.dart' as AppTheme;
// import 'app/utils/helper_function/user_helper/user_helper.dart';
//
// void main() async {
//   debugProfileBuildsEnabled = true;
//   WidgetsFlutterBinding.ensureInitialized();
//   await NotificationService.instance.init();
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: ColorRes.primary,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness: Brightness.light,
//       systemNavigationBarColor: ColorRes.primary,
//       // iOS: dark icons
//     ),
//   );
//
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//
//   // Initialize network service
//   final networkService = await Get.putAsync(
//     () => NetworkStatusService().init(),
//   );
//   await UserHelper.initUserType();
//   Get.put(CompareManager(), permanent: true);
//   Get.put(ContractorCompareManager(), permanent: true);
//   Get.put(ProjectCompareManager(), permanent: true);
//   //=========================
//   // Get.put(ProjectWizardController(isBuilderView:false ), permanent: true);
//
//   runApp(
//     GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       initialBinding: CustomBinding(),
//       // Show no internet screen if no connection, otherwise splash
//       home: const SplashScreen(),
//       // Define named routes
//       getPages: [
//         GetPage(name: '/splash', page: () => const SplashScreen()),
//         GetPage(name: '/no-internet', page: () => const NoInternetScreen()),
//         GetPage(name: '/dashboard', page: () => DashboardScreen()),
//       ],
//       builder: (context, child) {
//         final mediaQuery = MediaQuery.of(context);
//         return MediaQuery(
//           data: mediaQuery.copyWith(
//             textScaler: const TextScaler.linear(1.0), // Lock font scaling
//           ),
//           child: child!,
//         );
//       },
//     ),
//   );
// }
//
// class CustomBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(() => AuthController());
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';
import 'package:housing_flutter_app/modules/auth/views/splash_screen.dart';
import 'package:housing_flutter_app/app/services/network_status_service.dart';
import 'package:housing_flutter_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:housing_flutter_app/app/manager/compare_manager.dart';
import 'package:housing_flutter_app/app/manager/project_compare_manager.dart';
import 'package:housing_flutter_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import 'package:housing_flutter_app/modules/no_internet/no_internet_screen.dart';
import 'package:housing_flutter_app/services/notification_service.dart';
import 'app/theme/themes.dart' as AppTheme;
import 'app/utils/helper_function/user_helper/user_helper.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Enable performance profiling (remove in production)
  debugProfileBuildsEnabled = true;

  try {
    // 1. Initialize NotificationService FIRST
    await NotificationService.instance.init();
    debugPrint('✅ NotificationService initialized');

    // 2. Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: ColorRes.primary,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: ColorRes.primary,
      ),
    );

    // 3. Lock orientation to portrait
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // 4. Initialize network service
    await Get.putAsync(() => NetworkStatusService().init());
    debugPrint('✅ NetworkStatusService initialized');

    // 5. Initialize user type
    await UserHelper.initUserType();
    debugPrint('✅ UserHelper initialized');

    // 6. Initialize permanent controllers
    Get.put(CompareManager(), permanent: true);
    Get.put(ContractorCompareManager(), permanent: true);
    Get.put(ProjectCompareManager(), permanent: true);
    debugPrint('✅ Managers initialized');
  } catch (e) {
    debugPrint('❌ Error during initialization: $e');
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NesticoPe',
      theme: AppTheme.lightTheme,
      initialBinding: CustomBinding(),
      home: const SplashScreen(),

      // Define named routes
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/no-internet', page: () => const NoInternetScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
      ],

      // Lock font scaling and handle text scaling
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: const TextScaler.linear(1.0), // Lock font scaling
          ),
          child: child!,
        );
      },
    );
  }
}

class CustomBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthController
    Get.lazyPut(() => AuthController());
  }
}
