import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:nesticope_app/modules/dashboard/views/dashboard_screen.dart';

import '../../../../app/constants/color_res.dart';
import 'dashboard_header.dart';

class DashboardLayout extends StatefulWidget {
  final Widget? floatingButton;
  final Widget child;
  final RefreshCallback onRefresh;

  DashboardLayout({
    super.key,
    this.floatingButton,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  RxString name = ''.obs;

  RxString image = "".obs;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await SecureStorage.getUserData();
    if (user != null) {
      if (user.user?.profilePic != null &&
          (user.user?.profilePic?.isNotEmpty ?? false)) {
        image.value = user.user?.profilePic ?? '';
      }
      if (user.user?.firstName != null && user.user?.lastName != null) {
        name.value = '${user.user!.firstName} ${user.user!.lastName}';
      } else {
        if (user.user?.username != null) {
          name.value = user.user!.username!;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  //  
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        backgroundColor: ColorRes.white,

        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              // Seller dashboard may open without CustomBinding having run `find`
              // on AuthController yet (lazyPut). Resolve controller then logout.
              final auth =
                  Get.isRegistered<AuthController>()
                      ? Get.find<AuthController>()
                      : Get.put(AuthController(), permanent: true);
              auth.logout();
              // Get.offAll(()=>DashboardScreen());
              
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: ColorRes.primary.withOpacity(0.3),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Switch to Buyer',
                    style: TextStyle(
                      color: ColorRes.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: ColorRes.primary),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: widget.onRefresh,
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
              widget.child,
              // MetricGrid(metrics: metrics),
              // const SizedBox(height: 20),
              // Obx(() => buildSellerLeadGraph(overviewController)),
              // const SizedBox(height: 20),
              // Obx(() => buildSellerCommissionGraph(overviewController)),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.floatingButton,
    );
  }
}
