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
  final bool showIconWithText;
  final bool isFormScreen;

  const ListScreenAppbar({
    super.key,
    this.showAppBar = true,
    this.showIconWithText=false,
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


        GestureDetector(
          onTap: onFilterTap,
          child:  Icon(
            Icons.filter_list,
            size: 22,
            color: ColorRes.primary,
          ),
        ),
       if(showIconWithText)...[
         Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(onTap: onFilterTap,child: Text('Filter',style: TextStyle(color: ColorRes.primary,fontSize: 15,fontWeight: FontWeight.w500),)),
        )
       ]else...[
        SizedBox(width: 12,)
       ]

      ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
