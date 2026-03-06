import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
import 'package:housing_flutter_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
import 'package:housing_flutter_app/modules/builder/controller/builder_form_controller.dart';
import 'package:housing_flutter_app/modules/builder/view/all_project_list_screen.dart';
import 'package:housing_flutter_app/modules/home/controllers/top_builder_controller.dart';
import 'package:housing_flutter_app/utils/global.dart';
import '../top_developer_profile_screen.dart';

class BuilderCard extends StatefulWidget {
  final BuilderItem builder;
  const BuilderCard({super.key, required this.builder});

  @override
  State<BuilderCard> createState() => _BuilderCardState();
}

class _BuilderCardState extends State<BuilderCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final totalProjects = widget.builder.projectStats?.total ?? 0;
    final completed = widget.builder.projectStats?.completed ?? 0;
    final ongoing = widget.builder.projectStats?.ongoing ?? 0;
    final upcoming = widget.builder.projectStats?.upcoming ?? 0;
    final experience = widget.builder.totalExperience ?? 0;
    final name = _safeName(widget.builder);
    final cityState = _formatCityState(
      widget.builder.city,
      widget.builder.state,
    );

    return GestureDetector(
      onTap: () async {
        final userId = widget.builder.id ?? '';
        final createdBy = widget.builder.id ?? '';
        log('BuilderCard: ${widget.builder.toMap()},');
        final tag = 'top_dev_profile_$userId';
        final projectController =
            Get.isRegistered<ProjectWizardController>(tag: tag)
                ? Get.find<ProjectWizardController>(tag: tag)
                : Get.put(
                  ProjectWizardController(isBuilderView: false),
                  tag: tag,
                );
        final profileController =
            Get.isRegistered<TopBuilderController>(tag: tag)
                ? Get.find<TopBuilderController>(tag: tag)
                : Get.put(TopBuilderController(), tag: tag);

        projectController.fetchCreatedBy(
          created: createdBy,
          isItem: true,
          withoutCity: true,
        );
        projectController.withoutCityFilter();
        await profileController.loadSellerProfile(userId);
        if (userId.isNotEmpty && createdBy.isNotEmpty) {
          Get.to(
            () =>
                TopDeveloperProfileScreen(userId: userId, createdBy: createdBy),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImage(
                    type:
                        (widget.builder.profilePic?.isNotEmpty ?? false)
                            ? CustomImageType.network
                            : CustomImageType.asset,
                    src:
                        (widget.builder.profilePic?.isNotEmpty ?? false)
                            ? widget.builder.profilePic!
                            : imageOfNotAvailable,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: ColorRes.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              cityState,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.leadGreyColor.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "$totalProjects",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "Total Projects",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorRes.leadGreyColor.shade700,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "$experience",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "Experience",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorRes.leadGreyColor.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const SizedBox(height: 2),
            _BuilderStatusTile(
              label: "Ready to Move",
              count: completed,
              filterlabel: "completed",
              userId: widget.builder.id ?? '',
            ),
            const SizedBox(height: 8),
            _BuilderStatusTile(
              label: "Under Construction",
              count: ongoing,
              filterlabel: "ongoing",
              userId: widget.builder.id ?? '',
            ),
            const SizedBox(height: 8),
            _BuilderStatusTile(
              label: "New Launch",
              count: upcoming,
              filterlabel: "upcoming",
              userId: widget.builder.id ?? '',
            ),
          ],
        ),
      ),
    );
  }

  String _safeName(BuilderItem b) {
    if ((b.firstName?.isNotEmpty ?? false) ||
        (b.lastName?.isNotEmpty ?? false)) {
      return [
        b.firstName,
        b.lastName,
      ].where((e) => (e ?? '').isNotEmpty).join(' ');
    }
    return b.username ?? 'Unknown';
  }

  String _formatCityState(String? city, String? state) {
    final c = (city ?? '').trim();
    final s = (state ?? '').trim();
    if (c.isEmpty && s.isEmpty) return '—';
    if (c.isNotEmpty && s.isNotEmpty) return "$c, $s";
    return c.isNotEmpty ? c : s;
  }
}

class _BuilderStatusTile extends StatefulWidget {
  final String label;
  final int count;
  final String filterlabel;
  final String userId;

  const _BuilderStatusTile({
    required this.label,
    required this.count,
    required this.filterlabel,
    required this.userId,
  });

  @override
  State<_BuilderStatusTile> createState() => _BuilderStatusTileState();
}

class _BuilderStatusTileState extends State<_BuilderStatusTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final tag = 'top_dev_profile_${widget.userId}';
        final projectController =
            Get.isRegistered<ProjectWizardController>(tag: tag)
                ? Get.find<ProjectWizardController>(tag: tag)
                : Get.put(
                  ProjectWizardController(isBuilderView: false),
                  tag: tag,
                );
        final profileController =
            Get.isRegistered<TopBuilderController>(tag: tag)
                ? Get.find<TopBuilderController>(tag: tag)
                : Get.put(TopBuilderController(), tag: tag);

        projectController.fetchCreatedBy(
          created: widget.userId,
          isItem: true,
          withoutCity: true,
        );
        projectController.withoutCityFilter();
        projectController.builderStatus.value = widget.filterlabel;
        profileController.loadSellerProfile(widget.userId);

        log(
          'Check any the filter label ${projectController.builderStatus.value}, ${tag}',
        );
         Get.to(
          () => TopDeveloperProfileScreen(
            userId: widget.userId,
            createdBy: widget.userId,
          ),
        );
        setState(() {
          
        });
        // status apply will be handled after initial list load in profile screen

       
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ColorRes.leadGreyColor.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ColorRes.leadGreyColor.shade800,
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "${widget.count}",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: ColorRes.leadGreyColor.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
