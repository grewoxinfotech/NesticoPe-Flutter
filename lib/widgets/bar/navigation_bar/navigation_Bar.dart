import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/size_manager.dart';

class NesticoPeNavigationBar extends StatelessWidget {
  const NesticoPeNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<NavigationController>(() => NavigationController());
    NavigationController controller = Get.find();
    TextStyle style = TextStyle(
      fontSize: AppFontSizes.small,
      fontWeight: AppFontWeights.extraBold,
      color: Get.theme.colorScheme.primary,
    );
    double iconSize = 18;

    return Obx(
      () => Card(
        elevation: 5,
        shadowColor: Get.theme.colorScheme.surface,
        color: Get.theme.colorScheme.surface,
        margin: const EdgeInsets.only(
          left: AppMargin.small,
          bottom: AppMargin.small,
          right: AppMargin.small,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Container(
          height: kToolbarHeight,
          alignment: Alignment.center,
          child: SalomonBottomBar(
            duration: const Duration(milliseconds: 400),
            unselectedItemColor: Get.theme.colorScheme.onSurface.withOpacity(
              0.7,
            ),
            margin: const EdgeInsets.all(AppPadding.small),
            itemShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            itemPadding: const EdgeInsets.all(AppPadding.small),
            currentIndex: controller.currentIndex.value,
            onTap: (i) => controller.changeIndex(i),
            items: [
              SalomonBottomBarItem(
                icon: Icon(Icons.home_outlined, size: iconSize * 1.2),
                title: Text("Home", style: style),
              ),

              SalomonBottomBarItem(
                icon: Icon(Icons.apartment_outlined, size: iconSize * 1.2),
                title: Text("Property", style: style),
              ),

              SalomonBottomBarItem(
                icon: Icon(Icons.location_city_outlined, size: iconSize * 1.2),
                title: Text("Project", style: style),
              ),

              SalomonBottomBarItem(
                icon: Icon(
                  Icons.workspace_premium_outlined,
                  size: iconSize * 1.2,
                ),
                title: Text("Plans", style: style),
              ),

              SalomonBottomBarItem(
                icon: Icon(Icons.history_outlined, size: iconSize * 1.2),
                title: Text("Activity", style: style),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  RxInt currentIndex = 0.obs;

  int changeIndex(int i) => currentIndex(i);
}
