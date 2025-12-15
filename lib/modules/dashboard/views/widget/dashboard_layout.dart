import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/color_res.dart';
import '../dashboard_screen.dart';
import 'dashboard_header.dart';

class DashboardLayout extends StatelessWidget{
  final Widget? floatingButton;
  final Widget child;

  const DashboardLayout({super.key,  this.floatingButton, required this.child});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DashboardHeader(
              title: 'Welcome Back!',
              subtitle: 'Manage your properties efficiently',
              icon: Icons.home_work_rounded,
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
      floatingActionButton: floatingButton,
    );
  }

}