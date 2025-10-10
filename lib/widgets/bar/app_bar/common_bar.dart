import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

class CommonNesticoPeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackArrow;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final IconData? leadingIcon;

  const CommonNesticoPeAppBar({
    Key? key,
    required this.title,
    this.showBackArrow = false,
    this.actions,
    this.onBack,
    this.leadingIcon,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: ColorRes.white, // Background color of status bar
        statusBarIconBrightness: Brightness.dark, // Android
        statusBarBrightness: Brightness.light, // iOS
      ),
    );

    return SafeArea(
      child: Container(
        height: preferredSize.height,
        color: ColorRes.white, // Themed background color
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back arrow or spacer
            if (showBackArrow)
              IconButton(
                icon: Icon(
                  leadingIcon ?? Icons.arrow_back,
                  color: ColorRes.primary, // Themed icon color
                ),
                onPressed: onBack ?? () => Navigator.of(context).pop(),
                tooltip: 'Back',
              )
            else
              const SizedBox(width: 48),

            const SizedBox(width: 4),

            // Title
            Expanded(
              child: Text(
                title,
                style: theme.appBarTheme.titleTextStyle?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),

                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Right-aligned actions
            if (actions != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < actions!.length; i++) ...[
                    actions![i],
                    if (i != actions!.length - 1) const SizedBox(width: 12),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
