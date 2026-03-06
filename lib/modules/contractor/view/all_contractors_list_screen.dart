import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/home/controllers/contractor_profile_controller/contractor_profile_controller.dart';
import 'package:housing_flutter_app/modules/home/widgets/contractor_profile_card.dart';
import 'package:housing_flutter_app/utils/shimmer/buyer/hire_contractor/buyer_hire_contractor_list_screen_shimmer.dart';
import '../../home/widgets/unified_comparison_floating_button.dart';

class AllContractorsListScreen extends StatelessWidget {
  const AllContractorsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TopContractorsController(withoutCity: true),
      tag: 'contractors_all',
    );

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: const Text(
          'All Contractors',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const BuyerHireContractorListScreenShimmer();
              }
              if (!controller.isLoading.value && controller.items.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.refreshList,
                  child: ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('No contractors found')),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshList,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, __) => SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final data = controller.items[index];
                    return ContractorCard(contractor: data);
                  },
                ),
              );
            }),
            const UnifiedComparisonFloatingButton(bottom: 16),
          ],
        ),
      ),
    );
  }
}
