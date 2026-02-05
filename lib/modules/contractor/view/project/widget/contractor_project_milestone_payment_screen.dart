import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/contractor/model/contractor_project_model/contractor_project_payment_model.dart';
import '../../../../../utils/shimmer/contractor/payment/contractor_payment_list_screen_shimmer.dart';
import '../../../controller/contractor_project_payment_controller.dart';
import 'add_milestone_payment_screen.dart';

class ContractorProjectMileStonePaymentScreen extends StatefulWidget {
  final String projectId;

  const ContractorProjectMileStonePaymentScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<ContractorProjectMileStonePaymentScreen> createState() =>
      _ContractorProjectMileStonePaymentScreenState();
}

class _ContractorProjectMileStonePaymentScreenState
    extends State<ContractorProjectMileStonePaymentScreen> {
  late final ContractorProjectMilestonePaymentController controller;
  late final String tag;

  @override
  void initState() {
    super.initState();
    tag = 'milestone_payment_${widget.projectId}';
    controller = Get.put(
      ContractorProjectMilestonePaymentController(projectId: widget.projectId),
      tag: tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        title: Text(
          'Payments',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () async {
                final success = await Get.to(
                  () => AddMilestonePaymentScreen(tag: tag),
                );

                if (success == true) {
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
        backgroundColor: ColorRes.surface,
        elevation: 0.5,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return ContractorPaymentListScreenShimmer();
        }

        if (!controller.isLoading.value && controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.payment_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No payments found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add your first milestone payment',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshList,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.items.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= controller.items.length) {
                controller.loadMore();
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return _PaymentCard(
                payment: controller.items[index],
                onEdit: () async {
                  final success = await Get.to(
                    () => AddMilestonePaymentScreen(
                      tag: tag,
                      payment: controller.items[index],
                    ),
                  );

                  if (success == true) {
                    controller.loadInitial();
                  }
                },
                onDelete: () {
                  controller.deletePayment(controller.items[index].id ?? '');
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment, this.onEdit, this.onDelete});

  final MilestonePaymentItem payment;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  bool get _canModify => payment.paymentStatus?.toLowerCase() != 'success';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedAmount = Formatter.formatPrice(
      num.tryParse(payment.amount ?? '') ?? 0,
    );
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColorRes.leadGreyColor.shade300),
      ),

      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Status + Actions
            Row(
              children: [
                Expanded(
                  child: Text(
                    payment.milestone.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
                _StatusChip(
                  label: payment.paymentStatus ?? '',
                  color: _paymentStatusColor(payment.paymentStatus ?? ''),
                ),
                if (_canModify) ...[
                  const SizedBox(width: 4),
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
              ],
            ),

            const SizedBox(height: 8),

            /// Amount
            Text(
              '${Formatter.formatPrice(num.tryParse(payment.amount.toString()) ?? 0)}',

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorRes.primary,
              ),
            ),

            /// Payment Mode & Reference
            /*  Row(
              children: [
                _InfoTile(
                  label: 'Mode',
                  value: _capitalizeFirst(payment.paymentMode??''),
                ),
                if (payment.referenceNote != null &&
                    payment.referenceNote!.isNotEmpty)
                  _InfoTile(
                    label: 'Reference',
                    value: payment.referenceNote!,
                  ),
              ],
            ),

            const SizedBox(height: 10),

            /// Paid On
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Paid on: ${_formatDate(payment.paidOn??DateTime.now())}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),*/
            const SizedBox(height: 5),
            Divider(color: ColorRes.leadGreyColor.shade300),
            const SizedBox(height: 5),
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFFE7F2FF),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 16,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PAYMENT MODE",
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorRes.leadGreyColor.shade600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _capitalizeFirst(payment.paymentMode ?? ''),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFFE7F2FF),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PAID ON",
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorRes.leadGreyColor.shade600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      Formatter.formatDate(payment.paidOn?.toIso8601String()),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorRes.textPrimary,
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

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

Color _paymentStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'success':
    case 'paid':
      return Colors.green;
    case 'failed':
      return Colors.red;
    case 'pending':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
