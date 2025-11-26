import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../constants/app_font_sizes.dart';


class TitleWithViewAll extends StatelessWidget {
  final String title;
  final bool showViewAll;
  final VoidCallback? onViewAll;

  const TitleWithViewAll({
    Key? key,
    required this.title,
    this.showViewAll = false,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 230,
            child: Text(
              title,
              maxLines: 1,
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
              child:  Text(
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
    );
  }
}
