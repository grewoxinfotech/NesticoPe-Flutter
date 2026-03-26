import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/reseller/controller/meeting/reseller_meeting_controller.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';

class ResellerMeetingScreen extends StatelessWidget {
  const ResellerMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ResellerMeetingController>()
        ? Get.find<ResellerMeetingController>()
        : Get.put(ResellerMeetingController(), permanent: true);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Meetings',
          style: TextStyle(
            color: ColorRes.black,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        backgroundColor: ColorRes.white,
      ),
      body: Obx(() {
        final items = controller.items;
        if (controller.isLoading.value && items.isEmpty) {
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, __) => const MeetingShimmerCard(),
          );
        }
        if (items.isEmpty) {
          return const Center(child: Text('No meetings yet'));
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!controller.isPaging.value &&
                controller.hasMore.value &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200) {
              controller.loadMore();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () => controller.refreshMeetings(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length + (controller.isPaging.value ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                if (i >= items.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final m = items[i];

                // Format date & time (null-safe)
                String formattedDate;
                try {
                  formattedDate = m.date.isNotEmpty
                      ? DateFormat('dd MMM yyyy').format(DateTime.parse(m.date))
                      : '-';
                } catch (_) {
                  formattedDate = '-';
                }
                String formattedTime;
                try {
                  formattedTime = m.time.isNotEmpty
                      ? DateFormat('hh:mm a')
                          .format(DateFormat('HH:mm').parse(m.time))
                      : '-';
                } catch (_) {
                  formattedTime = '-';
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Top Row (Title + Status)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              m.meetingTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorRes.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          _buildStatusBadge(m.status),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// 🔹 Date & Time Row
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: ColorRes.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: ColorRes.leadGreyColor.shade700,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),

                          const SizedBox(width: 16),

                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: ColorRes.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 11,
                              color: ColorRes.leadGreyColor.shade700,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ],
                      ),

                      /// 🔹 Note
                      if ((m.note ?? '').isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          m.note!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ],

                      Divider(
                        height: 20,
                        color: ColorRes.leadGreyColor.shade200,
                      ),

                      /// 🔹 Bottom Row (Approval + Created Date)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildApprovalBadge(m.approvalStatus),
                          Builder(builder: (context) {
                            String createdText;
                            try {
                              createdText = m.createdAt.isNotEmpty
                                  ? DateFormat('MMM dd, yyyy')
                                      .format(DateTime.parse(m.createdAt))
                                  : '-';
                            } catch (_) {
                              createdText = '-';
                            }
                            return Text(
                              "Created on $createdText",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black45,
                                fontWeight: AppFontWeights.medium,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateDialog(context),
        label: const Text(
          'Request Meeting',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: ColorRes.primary,
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'scheduled':
        bgColor = ColorRes.primary.withOpacity(0.1);
        textColor = ColorRes.primary;
        break;
      case 'completed':
        bgColor = ColorRes.success.withOpacity(0.1);
        textColor = ColorRes.success;
        break;
      case 'cancelled':
        bgColor = ColorRes.error.withOpacity(0.1);
        textColor = ColorRes.error;
        break;
      case 'postponed':
        bgColor = ColorRes.deepPurpleColor.withOpacity(0.1);
        textColor = ColorRes.deepPurpleColor;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildApprovalBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'pending':
        bgColor = ColorRes.warning.withOpacity(0.1);
        textColor = ColorRes.warning;
        break;
      case 'approved':
        bgColor = ColorRes.success.withOpacity(0.1);
        textColor = ColorRes.success;
        break;
      case 'rejected':
        bgColor = ColorRes.error.withOpacity(0.1);
        textColor = ColorRes.error;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.black;
    }

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _openCreateDialog(BuildContext context) {
    final controller = Get.find<ResellerMeetingController>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    Get.dialog(
      Dialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Request Meeting',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w600,
                            color: ColorRes.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NesticoPeTextField(
                          controller: titleCtrl,
                          title: 'Meeting Title',
                          hintText: 'Enter meeting title',
                          prefixIcon: Icons.title,
                          isRequired: true,
                          validator:
                              (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Title is required'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: NesticoPeTextField(
                                controller: dateCtrl,
                                title: 'Date',
                                hintText: 'Select date',
                                prefixIcon: Icons.calendar_today,
                                readOnly: true,
                                isRequired: true,
                                onTap: () async {
                                  final now = DateTime.now();
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: now,
                                    firstDate: now,
                                    lastDate: DateTime(now.year + 2),
                                  );
                                  if (picked != null) {
                                    selectedDate = picked;
                                    dateCtrl.text = DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(picked);
                                  }
                                },
                                validator:
                                    (v) =>
                                        v == null || v.trim().isEmpty
                                            ? 'Date is required'
                                            : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: NesticoPeTextField(
                                controller: timeCtrl,
                                title: 'Time',
                                hintText: 'Select time',
                                prefixIcon: Icons.schedule,
                                readOnly: true,
                                isRequired: true,
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (picked != null) {
                                    selectedTime = picked;
                                    timeCtrl.text = picked.format(context);
                                  }
                                },
                                validator:
                                    (v) =>
                                        v == null || v.trim().isEmpty
                                            ? 'Time is required'
                                            : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        NesticoPeTextField(
                          controller: noteCtrl,
                          title: 'Note',
                          hintText: 'Enter any notes',
                          prefixIcon: Icons.notes,
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: (){
                            noteCtrl.clear();
                            dateCtrl.clear();
                            timeCtrl.clear();
                            selectedDate = null;
                            selectedTime = null;
                            
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: ColorRes.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: FontWeight.w600,
                              color: ColorRes.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;
                            if (selectedDate == null || selectedTime == null)
                              return;

                            final dateStr = DateFormat(
                              'yyyy-MM-dd',
                            ).format(selectedDate!);
                            final timeStr = DateFormat('HH:mm').format(
                              DateTime(
                                0,
                                1,
                                1,
                                selectedTime!.hour,
                                selectedTime!.minute,
                              ),
                            );

                            await controller.createMeeting(
                              title: titleCtrl.text.trim(),
                              date: dateStr,
                              time: timeStr,
                              note: noteCtrl.text.trim(),
                            );
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Request Meeting',
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}

class MeetingShimmerCard extends StatelessWidget {
  const MeetingShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 140, height: 14),
                _box(width: 80, height: 24, radius: 20),
              ],
            ),

            const SizedBox(height: 12),

            /// Date & Time
            Row(
              children: [
                _box(width: 100, height: 12),
                const SizedBox(width: 16),
                _box(width: 80, height: 12),
              ],
            ),

            const SizedBox(height: 12),

            /// Note
            _box(width: double.infinity, height: 12),
            const SizedBox(height: 6),
            _box(width: 200, height: 12),

            const SizedBox(height: 16),

            /// Bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 90, height: 20, radius: 12),
                _box(width: 120, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({double? width, double? height, double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
