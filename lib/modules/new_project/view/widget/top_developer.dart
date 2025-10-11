import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';

class DeveloperSection extends StatelessWidget {
  final String developerName;
  final String developerEmail;
  final String developerImage;
  final Map<String, String>
  stats; // e.g. {"Year estd": "1980", "Live Projects": "32"}
  final String projectsTitle;
  final VoidCallback onSeeAll;
  final bool isLoading;
  final List<Items> projects; // Pass your controller.items or any list

  const DeveloperSection({
    super.key,

    required this.developerName,
    required this.developerEmail,
    required this.developerImage,
    required this.stats,
    required this.projectsTitle,
    required this.onSeeAll,
    required this.isLoading,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          /// Developer Info Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorRes.grey.withOpacity(0.3),
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row with Avatar + Name
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorRes.primary, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.yellow.shade100,
                        backgroundImage: NetworkImage(developerImage),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          developerName,
                          style: const TextStyle(
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textPrimary,
                            fontSize: AppFontSizes.large,
                          ),
                        ),
                        Text(
                          developerEmail,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: ColorRes.grey,
                            fontSize: AppFontSizes.caption,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
                const SizedBox(height: 8),

                /// Info Row (Dynamic)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(stats.length * 2 - 1, (index) {
                    if (index.isOdd) return _customDivider();
                    final entry = stats.entries.elementAt(index ~/ 2);
                    return Expanded(
                      child: _buildInfoTile(entry.key, entry.value),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Projects Heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                projectsTitle,
                style: const TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  "See all",
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

          /// Projects List
          SizedBox(
            height: 222,
            child: Obx(() {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (projects.isEmpty) {
                return const Center(child: Text("No Property found."));
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: projects.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final data = projects[index];
                  return _buildProjectCard(data);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Reusable Info Tile
  Widget _buildInfoTile(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppFontSizes.extraSmall,
            color: ColorRes.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Custom Divider
  Widget _customDivider() => Container(
    height: 28,
    width: 1,
    color: ColorRes.leadGreyColor.shade300,
    margin: const EdgeInsets.symmetric(horizontal: 12),
  );

  /// Project Card
  Widget _buildProjectCard(Items data) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 0.8),
      ),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  data.propertyMedia?.images?.isNotEmpty == true
                      ? data.propertyMedia!.images![0]
                      : 'https://images.unsplash.com/photo-1605146769289-440113cc3d00?fm=jpg&q=60&w=3000',
                ),
                fit: BoxFit.cover,
              ),
              color: ColorRes.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    data.title ?? 'Unknown Property',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
                if (data.propertyDetails != null) ...[
                  Text(
                    [
                      if (data.propertyDetails?.bhk != null)
                        "${data.propertyDetails!.bhk} BHK",
                      if (data.propertyDetails?.furnishInfo?.furnishType !=
                          null)
                        data.propertyDetails!.furnishInfo!.furnishType,
                      if (data.propertyDetails?.propertyFacing != null)
                        data.propertyDetails!.propertyFacing!,
                    ].join(" · "),
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.leadGreyColor.shade800,
                      fontWeight: AppFontWeights.medium,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                SizedBox(
                  width: 150,
                  child: Text(
                    data.address ?? 'Unknown Location',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.blackShade54,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.propertyDetails?.financialInfo?.price != null
                      ? Formatter.formatPrice(
                        data.propertyDetails!.financialInfo!.price!.toDouble(),
                      )
                      : 'Price not available',
                  style: const TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
