import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/contractor/view/project/widget/add_milestone_screen.dart';
import 'package:housing_flutter_app/modules/property_rating/view/widget/read_more_or_less.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/contractor/model/contractor_project_model/contractor_project_milestone_model.dart';
import '../../../../../utils/shimmer/contractor/milestone/contractor_milestone_list_screen_shimmer.dart';
import '../../../controller/contractor_project_milestone_controller.dart';

class ContactorProjectMileStoneScreen extends StatefulWidget {
  final String projectId;
  final double projectPrice;

  const ContactorProjectMileStoneScreen({
    super.key,
    required this.projectId,
    required this.projectPrice,
  });

  @override
  State<ContactorProjectMileStoneScreen> createState() =>
      _ContactorProjectMileStoneScreenState();
}

class _ContactorProjectMileStoneScreenState
    extends State<ContactorProjectMileStoneScreen> {
  late final ContractorProjectMilestoneController controller;
  late final String tag;

  @override
  void initState() {
    super.initState();
    tag = 'milestone_${widget.projectId}';
    controller = Get.put(
      ContractorProjectMilestoneController(projectId: widget.projectId),
      tag: 'milestone_${widget.projectId}',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        title: Text(
          'Milestone',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),

        backgroundColor: ColorRes.surface,
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () async {
                final success = await Get.to(
                  () => AddMilestoneScreen(
                    tag: tag, // Controller tag
                    milestone: null, // null = Add mode
                    projectPrice: widget.projectPrice,
                  ),
                );

                if (success) {
                  controller.loadInitial();
                }
              },
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: ColorRes.primary,
                size: 25,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return ContractorMilestoneListScreenShimmer();
        }

        if (!controller.isLoading.value && controller.items.isEmpty) {
          return const Center(
            child: Text('No milestones found', style: TextStyle(fontSize: 14)),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshList(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.items.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              return _MilestoneCard(
                milestone: controller.items[index],
                onDelete: () {
                  controller.deleteMilestone(controller.items[index].id!);
                },
                onEdit: () async {
                  final success = await Get.to(
                    () => AddMilestoneScreen(
                      tag: tag,
                      milestone: controller.items[index],
                      projectPrice: widget.projectPrice,
                    ),
                  );

                  if (success) {
                    controller.loadInitial();
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({required this.milestone, this.onEdit, this.onDelete});

  final ProjectMilestone milestone;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  bool get _canModify => milestone.paymentStatus == 'pending';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Status + Actions
            /*  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.title ?? '',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                            color: ColorRes.textPrimary
                        ),
                      ),
                      const SizedBox(width: 4),
                      _StatusChip(
                        label: milestone.workStatus ?? '',
                        color: _workStatusColor(milestone.workStatus!),
                      ),
                    ],
                  ),
                ),

                /// Edit / Delete (Only if payment pending)
                if (_canModify)
                  Row(
                    children: [
                      _IconAction(
                        icon: Icons.edit,
                        color: Colors.blue,
                        onTap: onEdit,
                      ),
                      _IconAction(
                        icon: Icons.delete_outline,
                        color: Colors.red,
                        onTap: onDelete,
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 8),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "MILESTONE",
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        _StatusChip(
                          label: milestone.paymentStatus ?? '',
                          color: _paymentStatusColor(milestone.paymentStatus!),
                        ),
                        SizedBox(width: 8),
                        _StatusChip(
                          label: (milestone.workStatus ?? '').toUpperCase(),
                          color: _paymentStatusColor(
                            milestone.paymentStatus ?? '',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      milestone.title ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                // --- Circular progress indicator
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        value: (milestone.percentage ?? 0) / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ),
                    ),
                    Text(
                      "${milestone.percentage ?? 0}%",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            ReadMoreClass(
              description: milestone.description ?? '',
              trimLines: 3,
              size: 13,
              colorClickableText: ColorRes.primary,
            ),

            // Text(milestone.description ?? '', style: theme.textTheme.bodySmall),
            const SizedBox(height: 6),
            Divider(color: ColorRes.leadGreyColor.shade300),
            const SizedBox(height: 6),

            /// Amounts
            Row(
              children: [
                Expanded(
                  child: _AmountTile(
                    label: 'Total',
                    value: Formatter.formatPrice(
                      num.tryParse(milestone.milestoneAmount ?? '') ?? 0,
                    ),
                  ),
                ),

                Container(
                  width: 1,
                  height: 32,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),

                Expanded(
                  child: _AmountTile(
                    label: 'Paid',
                    value: Formatter.formatPrice(
                      num.tryParse(milestone.paidAmount ?? '') ?? 0,
                    ),
                    // value: milestone.paidAmount!,
                  ),
                ),

                Container(
                  width: 1,
                  height: 32,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),

                Expanded(
                  child: _AmountTile(
                    label: 'Remaining',
                    // value: milestone.remainingAmount!,
                    value: Formatter.formatPrice(
                      num.tryParse(milestone.remainingAmount ?? '') ?? 0,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Type + Payment Status
            /*  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  milestone.milestoneType == 'percentage'
                      ? 'Percentage: ${milestone.percentage ?? 0}%'
                      : 'Fixed Amount',
                  style: theme.textTheme.bodySmall,
                ),
                _StatusChip(
                  label: milestone.paymentStatus ?? '',
                  color: _paymentStatusColor(milestone.paymentStatus!),
                ),
              ],
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      Formatter.formatDate(
                        milestone.startDate?.toIso8601String(),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      Formatter.formatDate(
                        milestone.endDate?.toIso8601String(),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  const _AmountTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            '$value',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

Color _workStatusColor(String status) {
  switch (status) {
    case 'completed':
      return Colors.green;
    case 'in_progress':
      return Colors.orange;
    case 'not_started':
    default:
      return Colors.grey;
  }
}

Color _paymentStatusColor(String status) {
  switch (status) {
    case 'paid':
      return Colors.green;
    case 'pending':
    default:
      return Colors.red;
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.color, this.onTap});

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
