import 'package:flutter/material.dart';

import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:readmore/readmore.dart';

import '../../../../app/constants/app_font_sizes.dart';


class ReadMoreClass extends StatelessWidget {
  const ReadMoreClass({
    super.key,
    required this.description,
    required this.trimLines,
    required this.size,
    required this.colorClickableText,
  });

  final String description;
  final int trimLines;
  final double size;
  final Color colorClickableText;

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      description,
      trimLines: trimLines,
      colorClickableText: colorClickableText,


      style: TextStyle(
        fontSize: size,
        fontWeight: AppFontWeights.regular,
        height: 1.6,
      ),
      trimMode: TrimMode.Line,

      trimCollapsedText: 'Read More',
      trimExpandedText: ' Read Less',
      lessStyle: TextStyle(
        fontSize: size,
        fontWeight: AppFontWeights.semiBold,
        color: colorClickableText,
      ),

      moreStyle: const TextStyle(
        fontSize: AppFontSizes.caption,
        fontWeight: AppFontWeights.semiBold,
        color: ColorRes.primary,
      ),
    );
  }
}

