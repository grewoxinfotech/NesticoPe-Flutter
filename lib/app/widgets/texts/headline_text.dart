import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

import '../../constants/app_font_sizes.dart';

class TitleWithViewAll extends StatelessWidget {
  final String title;
  final bool showViewAll;
  final VoidCallback? onViewAll;
  final bool isSubTitle;
  final String? subTitle;
  final Color? subTitleColor;
  final Color? titleColor;
  final bool showIcon;
  final IconData? icon;
  final Color? iconBgColor;
  final Color? iconColor;

  const TitleWithViewAll({
    Key? key,
    required this.title,
    this.showViewAll = false,
    this.onViewAll,
    this.isSubTitle = false,
    this.subTitle = '',
    this.subTitleColor,
    this.titleColor,
    this.showIcon = false,
    this.icon,
    this.iconBgColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.,
            children: [
              if (showIcon && icon != null) ...[
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: iconBgColor ?? ColorRes.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 2,

                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: iconColor ?? ColorRes.primary,
                  ),
                ),
                SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                        color: titleColor ?? ColorRes.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isSubTitle)
                      Text(
                        subTitle!,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,
                          color:
                              subTitleColor ??
                              ColorRes.textColor.withOpacity(0.65),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (showViewAll)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    "See All",
                    style: TextStyle(
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.primary,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
