import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
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

    return Obx(() {
      final index = controller.currentIndex.value;
      final isServicesSelected = index == 4;
      final primary = Get.theme.colorScheme.primary;
      final baseSize = iconSize * 1.2;
      final circleSize = isServicesSelected ? baseSize * 1.35 + 12 : baseSize + 10;
      final servicesIcon = Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // gradient: LinearGradient(
              //   colors: [
              //     primary,
              //     primary.withOpacity(isServicesSelected ? 0.85 : 0.25),
              //   ],
              // ),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(isServicesSelected ? 0.35 : 0.15),
                  blurRadius: isServicesSelected ? 14 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.engineering_outlined,
                size: isServicesSelected ? baseSize * 1.05 : baseSize,
                color:  primary,
              ),
            ),
          ),
          Positioned(
            right: isServicesSelected ? -2 : -12,
            top: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.shade600,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.shade700.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'NEW',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: AppFontSizes.mini,
                  fontWeight: AppFontWeights.bold,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      );
      return Card(
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
            duration: const Duration(milliseconds: 150),
            unselectedItemColor: Get.theme.colorScheme.onSurface.withOpacity(
              0.7,
            ),
            margin: const EdgeInsets.all(AppPadding.small),
            itemShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            itemPadding: const EdgeInsets.all(AppPadding.small),
            currentIndex: index,
            onTap: (i) => controller.changeIndex(i),
            items: [
              SalomonBottomBarItem(
                icon: Icon(Icons.home_outlined, size: iconSize * 1.2),
                title: Text("Home", style: style),
              ),
              SalomonBottomBarItem(
                icon: Icon(Icons.search_outlined, size: iconSize * 1.2),
                title: Text("Explore", style: style),
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  Icons.favorite_border_outlined,
                  size: iconSize * 1.2,
                ),
                title: Text("Saved", style: style),
              ),
              SalomonBottomBarItem(
                icon: Icon(
                  Icons.credit_card,
                  size: iconSize * 1.2,
                ),
                title: Text("Plans", style: style),
              ),
              SalomonBottomBarItem(
                icon: servicesIcon,
                title: Text(
                  "Services",
                  style: style.copyWith(
                    fontWeight: isServicesSelected
                        ? AppFontWeights.extraBold
                        : AppFontWeights.bold,
                    color: isServicesSelected ? primary : style.color,
                  ),
                ),
                selectedColor: primary,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class NavigationController extends GetxController {
  RxInt currentIndex = 0.obs;

  int changeIndex(int i) => currentIndex(i);
}
