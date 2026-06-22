import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:nesticope_app/modules/auth/views/splash_screen.dart';
import 'package:nesticope_app/app/services/network_status_service.dart';
import 'package:provider/provider.dart';
import 'package:nesticope_app/modules/home/widgets/scroll_listiner_provider.dart';
import 'package:nesticope_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:nesticope_app/app/manager/compare_manager.dart';
import 'package:nesticope_app/app/manager/project_compare_manager.dart';
import 'package:nesticope_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import 'package:nesticope_app/modules/no_internet/no_internet_screen.dart';
import 'package:nesticope_app/services/fcm_notification_service.dart';
import 'app/theme/themes.dart' as AppTheme;
import 'app/utils/helper_function/user_helper/user_helper.dart';
import 'confige/helper/api_helper.dart';
// import 'firebase_options.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Enable performance profiling (remove in production)
  debugProfileBuildsEnabled = true;

  try {
    await Firebase.initializeApp();
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    debugPrint('✅ Firebase initialized');
    // 3. Catch all Flutter-level crashes
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Initialize FCM (foreground display via local notifications).
    // If you only use OneSignal, this is safe but optional.
    // Do not request permission here; onboarding will ask at the right time.
    await FCMNotificationService.instance.init(requestPermission: false);

    // 1. Initialize NotificationService FIRST
    // await NotificationService.instance.init();
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

    // 6. Load third-party settings (Google Maps API key, etc.)
    await ApiConfig.fetchThirdPartySettings();
    debugPrint('✅ Third-party settings loaded');

    // 7. Initialize permanent controllers
    Get.put(CompareManager(), permanent: true);
    Get.put(ContractorCompareManager(), permanent: true);
    Get.put(ProjectCompareManager(), permanent: true);
    debugPrint('✅ Managers initialized');
  } catch (e) {
    debugPrint('❌ Error during initialization: $e');
  }
  // Run the app
  runApp(
    // DevicePreview(
    // enabled: true,
    // builder: (context) =>
    MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PinnedSearchNotifier(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NesticoPe',
        theme: AppTheme.lightTheme,
        initialBinding: CustomBinding(),
        home: const SplashScreen(),
        getPages: [
          GetPage(name: '/splash', page: () => const SplashScreen()),
          GetPage(name: '/no-internet', page: () => const NoInternetScreen()),
          GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        ],
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
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
