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

import 'app/theme/themes.dart' as AppTheme;
import 'app/utils/helper_function/user_helper/user_helper.dart';

void main() async {
  debugProfileBuildsEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorRes.primary,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: ColorRes.primary,
      // iOS: dark icons
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize network service
  final networkService = await Get.putAsync(() => NetworkStatusService().init());
  await UserHelper.initUserType();
  Get.put(CompareManager(), permanent: true);
  Get.put(ContractorCompareManager(), permanent: true);
  Get.put(ProjectCompareManager(), permanent: true);
  
  // Check initial internet connection
  final hasInternet = networkService.isConnected;
  
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: CustomBinding(),
      // Show no internet screen if no connection, otherwise splash
      home: const SplashScreen(),
      // Define named routes
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/no-internet', page: () => const NoInternetScreen()),
        GetPage(name: '/dashboard', page: () => DashboardScreen()),
      ],
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: const TextScaler.linear(1.0), // Lock font scaling
          ),
          child: child!,
        );
      },
    ),
  );
}

class CustomBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => AuthController());
  }
}
