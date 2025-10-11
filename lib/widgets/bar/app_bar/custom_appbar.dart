import 'package:flutter/material.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> leftActions;
  final List<Widget> rightActions;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leftActions = const [],
    this.rightActions = const [],
    this.backgroundColor = ColorRes.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: ColorRes.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              // 🔹 Left Icons
              Row(children: leftActions),

              // 🔹 Title in Center
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.large,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.black,
                    ),
                  ),
                ),
              ),

              // 🔹 Right Icons
              Row(children: rightActions),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}