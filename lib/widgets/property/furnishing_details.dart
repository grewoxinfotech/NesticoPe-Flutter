import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import 'package:housing_flutter_app/app/manager/property_highlight_manager.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';

import '../../app/constants/app_font_sizes.dart';

/// Widget to display property furnishing details
class FurnishingDetails extends StatelessWidget {
  final Items property;
  final Color bgColor;
  final Color txtColor;

  const FurnishingDetails({
    super.key,
    required this.property,
    this.bgColor = ColorRes.propertyBg,
    this.txtColor = ColorRes.propertyText,
  });

  @override
  Widget build(BuildContext context) {
    final manager = PropertyHighlightManager(property);
    final furnishingItems = manager.getFurnishingInfo();
    final furnishingType = manager.furnishingType;

    if (furnishingItems.isEmpty && furnishingType == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Furnishing Items
        if (furnishingItems.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: furnishingItems.map((item) {
                return FurnishingCard(
                  label: item.displayText,
                  icon: item.icon ?? Icons.check_circle_outline,
                  bgColor: bgColor,
                  foreColor: txtColor,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  String _formatFurnishingType(String type) {
    // Convert "fully-furnished" to "Fully Furnished"
    return type
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

/// Card widget for individual furnishing items
class FurnishingCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color foreColor;

  const FurnishingCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.foreColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 80,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: ColorRes.primary, width: 1),
        borderRadius: BorderRadius.circular(20),
        color: ColorRes.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: ColorRes.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact horizontal scrollable version for property cards
class FurnishingDetailsCompact extends StatelessWidget {
  final Items property;
  final int maxItems;

  const FurnishingDetailsCompact({
    super.key,
    required this.property,
    this.maxItems = 3,
  });

  @override
  Widget build(BuildContext context) {
    final furnishingItems = PropertyHighlightManager(property).getFurnishingInfo();

    if (furnishingItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayItems = furnishingItems.take(maxItems).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(displayItems.length, (index) {
          final item = displayItems[index];

          return Row(
            children: [
              if (index != 0) ...[
                const Text('  •', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 6),
              ],
              _buildChip(item.displayText, 16, icon: item.icon),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildChip(String text, double size, {IconData? icon}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon ?? Icons.check_circle_outline, size: size, color: ColorRes.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.grey,
          ),
        ),
      ],
    );
  }
}
