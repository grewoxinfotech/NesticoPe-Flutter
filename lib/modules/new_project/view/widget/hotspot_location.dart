import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/modules/property/views/widgets/recommended_card.dart';

/// Hotspot Model
class Hotspot {
  final String name;
  final String description;
  final String projectsCount;
  final String appreciationText;
  final double appreciationValue;
  final bool isPositive;
  final List<Items> items; // your property list

  Hotspot({
    required this.name,
    required this.description,
    required this.projectsCount,
    required this.appreciationText,
    required this.appreciationValue,
    required this.isPositive,
    required this.items,
  });
}

/// Hotspot Section
class HotspotSection extends StatefulWidget {
  final String title;
  final VoidCallback onMapView;
  final List<Hotspot> hotspots;

  const HotspotSection({
    super.key,
    required this.title,
    required this.onMapView,
    required this.hotspots,
  });

  @override
  State<HotspotSection> createState() => _HotspotSectionState();
}

class _HotspotSectionState extends State<HotspotSection> {
  Hotspot? selectedHotspot;

  @override
  void initState() {
    super.initState();
    if (widget.hotspots.isNotEmpty) {
      selectedHotspot = widget.hotspots.first; // default selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: AppFontSizes.medium,
                    color: ColorRes.textPrimary,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onMapView,
                  child: const Text(
                    "Map View",
                    style: TextStyle(
                      color: ColorRes.primary,
                      fontWeight: AppFontWeights.semiBold,
                      fontSize: AppFontSizes.caption,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Hotspot List
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.hotspots.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final hotspot = widget.hotspots[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedHotspot = hotspot);
                    },
                    child: _hotspotCard(
                      hotspot,
                      isSelected: selectedHotspot == hotspot,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            /// Related Properties List
            if (selectedHotspot != null)
              HotspotsProperty(properties: selectedHotspot!.items),
          ],
        ),
      ),
    );
  }

  /// Hotspot Card
  Widget _hotspotCard(Hotspot hotspot, {bool isSelected = false}) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? ColorRes.primary.withOpacity(0.08) : ColorRes.white,
        border: Border.all(
          color: isSelected ? ColorRes.primary : ColorRes.grey.withOpacity(0.3),
          width: isSelected ? 1.5 : 0.8,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hotspot.name,
            style: const TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hotspot.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.grey,
            ),
          ),
          const Spacer(),
          Text(
            hotspot.projectsCount,
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                "${hotspot.appreciationValue.toStringAsFixed(2)}%",
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.semiBold,
                  color: hotspot.isPositive ? ColorRes.green : ColorRes.error,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  hotspot.appreciationText,
                  style: const TextStyle(
                    fontSize: AppFontSizes.extraSmall,
                    color: ColorRes.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Example Property List Widget
class HotspotsProperty extends StatelessWidget {
  final List<Items> properties;

  const HotspotsProperty({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const Text("No properties found for this hotspot.");
    }
    return SizedBox(
      height: 335,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: properties.length, // ✅ Always up-to-date
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index >= properties.length) {
            return const SizedBox(); // ✅ Prevents RangeError
          }
          final data = properties[index];
          return RecommendedCard(property: data);
        },
      ),
    );
  }
}
