import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../app/constants/app_font_sizes.dart';

class CommonNesticoPeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
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
    final canPop = Navigator.of(context).canPop();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: ColorRes.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Back arrow ONLY if allowed
            if (showBackArrow && canPop)
              IconButton(
                icon: Icon(
                  leadingIcon ?? Icons.arrow_back,
                  color: ColorRes.primary,
                ),
                onPressed:
                    onBack ??
                    () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                tooltip: 'Back',
              )
            else
              const SizedBox(width: 48), // keep title centered

            const SizedBox(width: 4),

            // Title
            Expanded(
              child: Text(
                title,
                style: theme.appBarTheme.titleTextStyle?.copyWith(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.semiBold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Actions
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
