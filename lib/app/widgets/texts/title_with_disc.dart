import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

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
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorRes.blueColor,
                    ),
                  ),
                ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description!,
              style: const TextStyle(
                fontSize: 12,
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
