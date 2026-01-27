import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';

import '../../../../app/constants/color_res.dart';
import '../dashboard_screen.dart';
import 'dashboard_header.dart';

class DashboardLayout extends StatelessWidget {
  final Widget? floatingButton;
  final Widget child;
  final RefreshCallback onRefresh;

  DashboardLayout({super.key, this.floatingButton, required this.child,required this.onRefresh,});
  RxString name = ''.obs;
  RxString image="".obs;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await SecureStorage.getUserData();
      if (user != null) {
        if(user.user?.profilePic!=null && (user.user?.profilePic?.isNotEmpty??false))
          {
            image.value=user.user?.profilePic??'';
          }
        if (user.user?.firstName != null && user.user?.lastName != null) {
          name.value = '${user.user!.firstName} ${user.user!.lastName}';
        } else {
          if (user.user?.username != null) {
            name.value = user.user!.username!;
          }
        }
      }
    });
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: ColorRes.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Get.offAll(() => DashboardScreen()),
            child: const Text('Switch To Buyer'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Obx(
                () => DashboardHeader(
                  title: 'Welcome, ${name.value}',
                  subtitle: 'Manage your properties efficiently',
                  image: image.value,
                  // icon: Icons.home_work_rounded,
                ),
              ),
              const SizedBox(height: 20),
              child,
              // MetricGrid(metrics: metrics),
              // const SizedBox(height: 20),
              // Obx(() => buildSellerLeadGraph(overviewController)),
              // const SizedBox(height: 20),
              // Obx(() => buildSellerCommissionGraph(overviewController)),
            ],
          ),
        ),
      ),
      floatingActionButton: floatingButton,
    );
  }
}
