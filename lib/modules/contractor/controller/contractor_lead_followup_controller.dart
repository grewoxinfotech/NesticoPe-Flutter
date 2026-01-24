import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';
import 'package:housing_flutter_app/data/network/contractor/service/contractor_lead_follow_up_service..dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:intl/intl.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/contractor_lead_model/contractor_lead_followup_model.dart';
import '../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../add_property/view/create_property.dart';
import '../../reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import '../view/widget/cotractor_active_switch.dart';

class ContractorLeadFollowupController
    extends PaginatedController<ContractorLeadFollowUpItem> {
  final RxString selectedFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  RxMap<String, String> filters = <String, String>{}.obs;
  final RxMap<String, bool> expandedItems = <String, bool>{}.obs;
  RxString leadId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ever(filters, (_) => refreshList());

    /* loadInitial();*/
  }

  // Add inside ContractorLeadFollowupController
  //---------------------------------------Add followUp variable ------------------------------------------------//
  final RxString selectedType = ''.obs;
  final RxString followUpId = ''.obs;
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtLocation = TextEditingController();
  final TextEditingController txtTime = TextEditingController();
  final RxBool reminder = false.obs;
  final TextEditingController txtNotes = TextEditingController();
  final RxString statusFollow = ''.obs;
  final RxList<String> statusFollowList =
      <String>['Pending', 'Completed', 'Cancelled'].obs;
  RxBool isEditModel = false.obs;
  //---------------------------------------Add followUp variable ------------------------------------------------//
  // Sample follow-up types
  final List<String> followUpTypes = ['Call', 'Meeting', 'Email', 'Visit'];

  // Method to reset fields
  void resetFollowUpForm() {
    selectedType.value = '';
    txtDate.clear();
    txtTime.clear();
    reminder.value = false;
    txtNotes.clear();
  }

  void changeTheStatus(bool value) {
    isEditModel.value = value;
    log(" is EditModel ${isEditModel.value}");
  }

  void populatedFollowUpData(ContractorLeadFollowUpItem item) {
    if (isEditModel.value) {
      followUpId.value = item.id;
      selectedType.value = capitalizeEachWord(item.type);
      txtTime.text = item.time ?? '';

      txtDate.text = item.date ?? '';
      reminder.value = item.reminder;
      statusFollow.value = capitalizeEachWord(item.status);
      txtLocation.text = item.location ?? '';
      txtNotes.text = item.notes ?? '';
    }
  }

  Future<void> payloadMethod() async {
    Map<String, dynamic> payload = {
      "isEditMode": isEditModel.value,
      "related_id": leadId.value, // from your model or controller
      "section": "lead",
      "type": selectedType.value.toLowerCase(),
      "date": txtDate.text.trim(), // e.g., 2025-12-16
      "time": txtTime.text.trim(), // e.g., 05:06
      "reminder": reminder.value,
      "notes": txtNotes.text.trim(),
      if (selectedType.value.toLowerCase() == 'meeting')
        "location": txtLocation.text.trim(),
    };
    print("Follow Up Data ${payload}");

    final response = await ContractorLeadFollowUpService
        .contractorInquiryService
        .createFollowUp(payload);
    if (response) {
      refreshList();

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: 'Follow-up added successfully!',
        contentType: ContentType.success,
      );
    }
  }

  Future<void> payloadEditMethod() async {
    try {
      final String type = selectedType.value.toLowerCase();

      final Map<String, dynamic> payload = {
        "isEditMode": isEditModel.value,
        "related_id": leadId.value,
        "section": "lead",
        "type": type,
        "date": txtDate.text.trim(),
        "time": txtTime.text.trim(),
        "reminder": reminder.value,
        "status": statusFollow.value.toLowerCase(),
        "notes": txtNotes.text.trim(),
      };

      // Add location only for meetings
      if (type == 'meeting') {
        payload["location"] = txtLocation.text.trim();
      } else {
        // payload["location"] = null;
      }

      print("Follow Up Data Edit: $payload");

      final response = await ContractorLeadFollowUpService
          .contractorInquiryService
          .updateFollowUp(payload, followUpId.value);

      if (response) {
        refreshList();
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: 'Follow-up updated successfully!',
          contentType: ContentType.success,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: 'Failed to update follow-up. Please try again.',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      print("Error in payloadEditMethod: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Something went wrong. Please try again.',
        contentType: ContentType.failure,
      );
    }
  }

  Future<void> deleteFollowUpByID(String id) async {
    final response = await ContractorLeadFollowUpService
        .contractorInquiryService
        .deleteFollowUp(id);
    if (response) {
      refreshList();
    }
  }

  void deleteLead(String id, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        title: const Text(
          'Delete Follow Up',
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        content: Text('Are you sure you want to delete Follow for $name?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ColorRes.error),
            onPressed: () {
              Get.back();
              deleteFollowUpByID(id);

              NesticoPeSnackBar.showAwesomeSnackbar(
                title: 'Deleted',
                message: 'Follow Up deleted successfully',
                contentType: ContentType.success,
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> refreshFollowUp() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh ',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  // Open dialog
  void openAddFollowUpDialog() {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${isEditModel.value ? 'Edit Follow-up' : 'Add Follow-up'}",
                        style: const TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        resetFollowUpForm();
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(
                        Icons.close_rounded,
                        color: ColorRes.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type Dropdown
                      buildSectionTitle('Type'),
                      const SizedBox(height: 8),
                      // Obx(() => DropdownButtonFormField<String>(
                      //   value: selectedType.value.isEmpty
                      //       ? null
                      //       : selectedType.value,
                      //   items: followUpTypes
                      //       .map((type) => DropdownMenuItem(
                      //       value: type, child: Text(type)))
                      //       .toList(),
                      //   onChanged: (val) => selectedType.value = val ?? '',
                      //   decoration: InputDecoration(
                      //     contentPadding: const EdgeInsets.symmetric(
                      //         horizontal: 12, vertical: 10),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      // )),
                      Obx(() {
                        return NesticoPeDropdownField<String>(
                          isRequired: true,
                          value: selectedType.value,
                          hintText: "Select availability",
                          prefixIcon: Icons.schedule,
                          items:
                              [
                                    'Call',
                                    'Meeting',
                                    // 'In Progress',
                                    // 'Converted',
                                    // 'Rejected',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            selectedType.value = val;
                            log("Message ${selectedType.value}");
                          },
                          darkText: true,
                        );
                      }),
                      const SizedBox(height: 16),

                      // Date & Time
                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              'Start Date',
                              Icons.calendar_month_outlined,
                              txtDate,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter valid date';
                                }
                                return null;
                              },
                              isEnable: false,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: Get.context!,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: ColorRes.primary,
                                          onPrimary: ColorRes.white,
                                          onSurface: ColorRes.black,
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: ColorRes.primary,
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  txtDate.text =
                                      '${picked.year}-${picked.month}-${picked.day}';
                                }
                              },
                              isPhoneKey: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildTextField(
                              'Time',
                              Icons.timelapse_rounded,
                              txtTime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter valid Time';
                                }
                                return null;
                              },
                              isEnable: false,
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: Get.context!,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  // Convert TimeOfDay to 24-hour formatted string (HH:mm)
                                  final now = DateTime.now();
                                  final formattedTime = DateFormat(
                                    'HH:mm',
                                  ).format(
                                    DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      picked.hour,
                                      picked.minute,
                                    ),
                                  );

                                  txtTime.text = formattedTime;
                                  log("Picked time: $formattedTime");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Obx(() {
                        if (isEditModel.value) {
                          return Column(
                            children: [
                              Obx(() {
                                return NesticoPeDropdownField<String>(
                                  isRequired: true,
                                  value: statusFollow.value,
                                  prefixIcon:
                                      Icons.settings_input_composite_outlined,
                                  items:
                                      statusFollowList.value
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (val) {
                                    statusFollow.value = val;
                                    log("Message Status ${statusFollow.value}");
                                  },
                                  darkText: true,
                                );
                              }),
                              const SizedBox(height: 16),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      }),
                      // Reminder
                      Row(
                        children: [
                          const Text(
                            'Reminder',
                            style: TextStyle(
                              color: ColorRes.textSecondary,
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                          SizedBox(width: 12),
                          Obx(
                            () => CustomSwitch(
                              onChanged: (val) => reminder.value = val,
                              value: reminder.value,
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        if (selectedType.value.toLowerCase() == 'meeting') {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'Location',
                                style: TextStyle(
                                  color: ColorRes.textSecondary,
                                  fontSize: AppFontSizes.small,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                              const SizedBox(height: 6),
                              buildTextField(
                                'Location',
                                Icons.location_on_outlined,
                                txtLocation,
                                maxLines: 3,
                                minLines: 1,
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink(); // return empty widget if condition false
                        }
                      }),
                      const SizedBox(height: 16),

                      // Notes
                      Text(
                        'Notes',
                        style: TextStyle(
                          color: ColorRes.textSecondary,
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      const SizedBox(height: 6),
                      buildTextField(
                        'Notes',
                        Icons.picture_as_pdf,
                        txtNotes,
                        maxLines: 4,
                        minLines: 2,
                      ),
                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                              resetFollowUpForm();
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorRes.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (isEditModel.value) {
                                payloadEditMethod();
                              } else {
                                payloadMethod();
                              }
                              resetFollowUpForm();
                              Get.back();
                            },
                            child:
                                (isEditModel.value)
                                    ? Text('Update Follow-up')
                                    : Text('Add Follow-up'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void initFollowups(String id) {
    leadId.value = id;
    log("Initialise for leader ${leadId.value}==============${id}");

    loadInitial(); // this will call fetchItems internally
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleExpanded(String id) {
    expandedItems[id] = !(expandedItems[id] ?? false);
  }

  bool isExpanded(String id) {
    return expandedItems[id] ?? false;
  }

  void editFollowUp(String id) {
    // Implement edit functionality
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Edit',
      message: 'Edit follow-up: $id',
      contentType: ContentType.success,
    );
  }

  void addNewFollowUp() {
    // Implement add new follow-up
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Add',
      message: 'Add new follow-up',
      contentType: ContentType.success,
    );
  }

  String formatDateTime(String date, String time) {
    try {
      final dateTime = DateTime.parse(date);
      final timeComponents = time.split(':');
      final hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);

      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '${days[dateTime.weekday - 1]}, ${months[dateTime.month - 1]} ${dateTime.day} at $displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return '$date at $time';
    }
  }

  @override
  Future<PaginationResponse<ContractorLeadFollowUpItem>> fetchItems(
    int page,
  ) async {
    // TODO: implement fetchItems
    final response = await ContractorLeadFollowUpService
        .contractorInquiryService
        .fetchContractorLeadFollowUp(id: leadId.value, filters: filters.value);
    log(
      "Follow up section response from api ${response.items.map((e) => e.toMap())}",
    );
    return response;
  }
}
