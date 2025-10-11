import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/seller/view/widget/seller_property_list.dart';

/// --- DATA MODEL ---
class AgentProfile {
  final String name;
  final bool isOwner;
  final String logoUrl;
  final String badgeText;
  final String buyersServed;
  final String listings;
  final String description;
  final List<InfoTileData> infoTiles;
  final List<String> areas;
  final List<Map<String, dynamic>> categories;
  final List<AgentTagData> tags;

  /// --- Visibility flags ---
  final bool showTags;
  final bool showAreas;
  final bool showActiveProperties;
  final bool showSellerPropertyList;

  AgentProfile({
    required this.name,
    required this.logoUrl,
    required this.badgeText,
    required this.buyersServed,
    required this.isOwner,
    required this.listings,
    required this.description,
    required this.infoTiles,
    required this.areas,
    required this.categories,
    required this.tags,
    this.showTags = true,
    this.showAreas = true,
    this.showActiveProperties = true,
    this.showSellerPropertyList = true,
  });
}

class InfoTileData {
  final String title;
  final String value;
  InfoTileData({required this.title, required this.value});
}

class AgentTagData {
  final IconData icon;
  final String text;
  final Color color;

  AgentTagData({required this.icon, required this.text, required this.color});
}

/// --- PAGE ---
class AgentProfilePage extends StatelessWidget {
  final AgentProfile agent;
  final PropertyController controller = Get.put(PropertyController());

  AgentProfilePage({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.home, color: ColorRes.white, size: 18),
            label:  Text(
              'View Properties',
              style: TextStyle(fontSize: AppFontSizes.medium, color: ColorRes.white),
            ),
            onPressed: () {
              // TODO: Navigate to Agent’s property list
            },
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: ColorRes.blackShade87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            /// Profile Logo
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(agent.logoUrl),
              ),
            ),
            const SizedBox(height: 12),

            /// Agent Name
            Center(
              child: Text(
                agent.name,
                style:  TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.textColor,
                ),
              ),
            ),
            const SizedBox(height: 8),

            /// Tags (controlled by flag)
            if (agent.showTags && agent.tags.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    agent.tags
                        .map(
                          (tag) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: AgentTag(
                              icon: tag.icon,
                              text: tag.text,
                              color: tag.color,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],

            const SizedBox(height: 20),

            /// Agent Card
            AgentCard(
              logoUrl: agent.logoUrl,
              title: agent.name,
              isOwner: agent.isOwner,
              badgeText: agent.badgeText,
              buyersServed: agent.buyersServed,
              listings: agent.listings,
              description: agent.description,
              infoTiles:
                  agent.infoTiles
                      .map((e) => InfoTile(title: e.title, value: e.value))
                      .toList(),
            ),

            /// Areas (controlled by flag)
            if (agent.showAreas && agent.areas.isNotEmpty) ...[
              const SectionTitle("Areas of operation"),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Wrap(
                  spacing: 8,
                  children: agent.areas.map((area) => AreaChip(area)).toList(),
                ),
              ),
            ],

            /// Active Properties (controlled by flag)
            if (agent.showActiveProperties && agent.categories.isNotEmpty) ...[
              (agent.isOwner)
                  ? SectionTitle(
                    "My Properties (${totalPropertyLength(agent.categories)})",
                  )
                  : SectionTitle(
                    "Active Properties (${totalPropertyLength(agent.categories)})",
                  ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      agent.categories.length,
                      (index) => CategoryChip(
                        label: agent.categories[index]['type'],
                        isSelected: index == 0,
                        number: agent.categories[index]['number'],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],

            if (agent.showSellerPropertyList) ...[SellerPropertyList()],
          ],
        ),
      ),
    );
  }
}

class AgentCard extends StatelessWidget {
  final String logoUrl;
  final String title;
  final String badgeText;
  final String buyersServed;
  final String listings;
  final String description;
  final List<InfoTile> infoTiles;
  final bool isOwner;

  const AgentCard({
    super.key,
    required this.logoUrl,
    required this.title,
    required this.badgeText,
    required this.buyersServed,
    required this.listings,
    required this.description,
    required this.infoTiles,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.grey.withOpacity(0.25), width: 0.8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.08),
        //     blurRadius: 10,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row with logo & badge
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(logoUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:  TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.bold,
                        color: ColorRes.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style:  TextStyle(
                          fontSize: AppFontSizes.mini,
                          color: ColorRes.white,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Buyers & Listings row
            if (!isOwner) ...[
              Row(
                children: [
                  const Icon(Icons.groups, color: ColorRes.blueColor, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      buyersServed,
                      style:  TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.verified_user,
                    color: ColorRes.green,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      listings,
                      style:  TextStyle(
                        fontSize:AppFontSizes.extraSmall,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  // const Icon(Icons.groups, color: Colors.blue, size: 18),
                  // const SizedBox(width: 6),
                  // Expanded(
                  //   child: Text(
                  //     buyersServed,
                  //     style: const TextStyle(
                  //       fontSize: 10,
                  //       fontWeight: AppFontWeights.medium,
                  //     ),
                  //   ),
                  // ),
                  const Icon(
                    Icons.verified_user,
                    color: ColorRes.green,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      listings,
                      style:  TextStyle(
                        fontSize:AppFontSizes.extraSmall,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),

            /// Description
            Text(
              description,
              style:  TextStyle(fontSize: AppFontSizes.caption, color: ColorRes.grey),
            ),

            const SizedBox(height: 12),
            Divider(thickness: 0.5, color: ColorRes.grey.withOpacity(0.5)),
            // const SizedBox(height: 12),

            /// Info Tiles with Vertical Dividers
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < infoTiles.length; i++) ...[
                    infoTiles[i],
                    if (i != infoTiles.length - 1)
                      const VerticalDivider(
                        thickness: 0.5,
                        width: 20,
                        color: ColorRes.leadGreyColor,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style:  TextStyle(fontSize: AppFontSizes.caption, color: ColorRes.leadGreyColor)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
      ],
    );
  }
}

class AgentTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const AgentTag({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          text,
          style:  TextStyle(
            fontSize:AppFontSizes.mini,
            color: ColorRes.leadGreyColor,
            fontWeight: AppFontWeights.medium,
          ),
        ),
      ],
    );
  }
}

class AreaChip extends StatelessWidget {
  final String label;
  const AreaChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: ColorRes.leadGreyColor.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: ColorRes.leadGreyColor.shade200, width: 1),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int number;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? ColorRes.primary.withOpacity(0.08) : ColorRes.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? ColorRes.primary : ColorRes.grey.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.regular,
              color: isSelected ? ColorRes.primary : ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "($number)",
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.regular,
              color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        title,
        style:  TextStyle(
          fontSize: AppFontSizes.medium,
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.textColor,
        ),
      ),
    );
  }
}

num totalPropertyLength(List<Map<String, dynamic>> list) {
  return list.fold(0, (sum, item) => sum + item['number']);
}
