import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../constants/app_font_sizes.dart';

class TitleWithDescription extends StatelessWidget {
  final String title;
  final String? description; // optional
  final bool showViewAll;
  final VoidCallback? onViewAll;

  const TitleWithDescription({
    Key? key,
    required this.title,
    this.description,
    this.showViewAll = false,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                        fontSize: AppFontSizes.small
                    ),
                  ),
                ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description!,
              style:  TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: FontWeight.w400,
                color: ColorRes.leadGreyColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
