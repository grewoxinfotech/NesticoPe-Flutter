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

  const ListScreenAppbar({
    super.key,
    this.showAppBar = true,
    required this.title,
    this.onBack,
    this.onFilterTap,
    this.showFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showAppBar) return const SizedBox.shrink();

    return AppBar(
      elevation: 0,
      backgroundColor: ColorRes.white,

      leading: GestureDetector(
        onTap: onBack ?? Get.back,
        child: const Icon(Icons.arrow_back, color: ColorRes.textColor),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.textColor,
        ),
      ),

      actions:
          showFilter
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
