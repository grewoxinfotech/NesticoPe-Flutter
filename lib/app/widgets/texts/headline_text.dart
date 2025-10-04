import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';


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
            width: 250,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,

                color: ColorRes.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                "See All",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorRes.primary,
                    fontSize: 12
                ),
              ),
            ),
        ],
      ),
    );
  }
}
