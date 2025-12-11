import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';

class ListScreenAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showAppBar;
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onFilterTap;
  final bool showFilter;
  final bool isFormScreen;

  const ListScreenAppbar({
    super.key,
    this.showAppBar = true,
    required this.title,
    this.onBack,
    this.onFilterTap,
    this.showFilter = true,
    this.isFormScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showAppBar) return const SizedBox.shrink();

    return AppBar(
      elevation: 0,
      backgroundColor: ColorRes.white,
      automaticallyImplyLeading: !isFormScreen, // ✅ don’t reserve space
      leadingWidth: isFormScreen ? 0 : null, // ✅ remove left padding space

      // ✅ Conditionally show back icon
      leading: isFormScreen
          ? null // no space at all
          : GestureDetector(
        onTap: onBack ?? Get.back,
        child: const Icon(Icons.arrow_back, color: ColorRes.textColor),
      ),

     // ✅ center title if no back icon

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.textColor,
        ),
      ),

      // ✅ Filter icon (optional)
      actions: showFilter
          ? [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: onFilterTap,
            child: const Icon(
              Icons.filter_list,
              color: ColorRes.textColor,
            ),
          ),
        ),
      ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
