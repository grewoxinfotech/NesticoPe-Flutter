import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

import '../../constants/app_font_sizes.dart';


class TitleWithViewAll extends StatelessWidget {
  final String title;
  final bool showViewAll;
  final VoidCallback? onViewAll;
  final bool isSubTitle;
  final String? subTitle;

  const TitleWithViewAll({
    Key? key,
    required this.title,
    this.showViewAll = false,
    this.onViewAll,
    this.isSubTitle = false,
    this.subTitle='',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
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
          if (isSubTitle)
          Text(
            subTitle!,
            maxLines: 1,
            style: TextStyle(
              fontSize: AppFontSizes.caption,

              fontWeight: AppFontWeights.medium,
          
              color: ColorRes.textColor.withOpacity(0.65),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
