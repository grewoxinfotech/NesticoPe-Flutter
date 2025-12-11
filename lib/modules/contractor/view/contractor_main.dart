import 'package:flutter/material.dart';
import 'package:housing_flutter_app/modules/contractor/view/lead/contractor_lead_screen.dart';

import 'package:housing_flutter_app/modules/contractor/view/profile/contractot_profile.dart';
import 'package:housing_flutter_app/modules/contractor/view/project/contractor_project.dart';
import 'package:housing_flutter_app/modules/contractor/view/project/contractor_service.dart';
import 'package:housing_flutter_app/modules/contractor/view/widget/contractor_inquiry_screen.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';


import 'package:get/get.dart';

import '../controller/contractor_navigate_controller.dart';
import 'contractor_plan/contractor_plan_screen.dart';
import 'dashboard/contractor_dashboard.dart';
import 'lead/contractor_lead.dart';


class ContractorMainScreen extends StatelessWidget {
  const ContractorMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(ContractorNavigationController());
    // Get.put(ProjectWizardController(isBuilderView: true), tag: "builder");

    final screens = [
      ContractorDashboard(),
      ContractorProjectScreen(),
      // ContractorService(),
      ContractorLeadScreen(),
      ContractorInquiryScreen(),
      ContractorProfileScreen()
      // BuilderSubscriptionPlanScreen(),
      // SellerProfileScreen(),
    ];

    return Scaffold(
      body: Obx(
            () => IndexedStack(
          index: navigationController.currentIndex.value,
          children: screens,
        ),
      ),


      bottomNavigationBar: Obx(
            () => SafeArea(
          child: BottomNavigationBar(
            currentIndex: navigationController.currentIndex.value,
            onTap: navigationController.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.semiBold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
            ),
            backgroundColor: ColorRes.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.dashboard, size: 22),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.inventory, size: 22),
                ),
                label: 'Project',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.people, size: 22),
                ),
                label: 'Leads',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.disc_full_rounded, size: 22),
                ),
                label: 'Inquiry',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person, size: 22),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}