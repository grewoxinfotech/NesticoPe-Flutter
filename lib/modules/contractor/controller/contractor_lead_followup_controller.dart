import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/contractor/service/contractor_lead_follow_up_service..dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/contractor_lead_model/contractor_lead_followup_model.dart';
import '../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../add_property/view/create_property.dart';
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

    loadInitial();
  }
  // Add inside ContractorLeadFollowupController

  final RxString selectedType = ''.obs;
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtTime = TextEditingController();
  final RxBool reminder = false.obs;
  final TextEditingController txtNotes = TextEditingController();

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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Add Follow-up",
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(Icons.close_rounded,
                          color: ColorRes.white, size: 20),
                    ),
                  ],
                ),
              ),

              Flexible(
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                          [  'Call',
                            'Meeting',
                            // 'In Progress',
                            // 'Converted',
                            // 'Rejected',
                            ]
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val){
                           selectedType.value=val;
                          } ,
                          darkText: true,
                        );
                      },),
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
                                  initialDate:  DateTime.now(),
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
                            child: buildTextField('Time', Icons.timelapse_rounded, txtTime, validator: (value) {
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
                          txtTime.text = picked.format(Get.context!);
                          }
                          },
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Reminder
                     Row(
                        children: [

                          const Text(
                            'Reminder',
                            style: TextStyle(
                                color: ColorRes.textSecondary,
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.medium),
                          ),
                          SizedBox(width: 12,),
                          Obx(() => CustomSwitch(
                            onChanged: (val) => reminder.value = val,
                            value: reminder.value,
                          ),),

                        ],
                      ),

                      const SizedBox(height: 16),

                      // Notes
                      const Text('Notes',
                          style: TextStyle(
                              color: ColorRes.textSecondary,
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.medium)),
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
                            onPressed: () => Get.back(),
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
                              // Add follow-up submit logic here
                              Get.back();
                              Get.snackbar('Success',
                                  'Follow-up added successfully!');
                            },
                            child: const Text('Add Follow-up'),
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
    Get.snackbar('Edit', 'Edit follow-up: $id');
  }



  void deleteFollowUp(String id) {
    // Implement delete functionality
    // allFollowUps.removeWhere((item) => item.id == id);

    Get.snackbar('Delete', 'Follow-up deleted successfully');
  }

  void addNewFollowUp() {
    // Implement add new follow-up
    Get.snackbar('Add', 'Add new follow-up');
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
        .fetchContractorLeadFollowUp(id: leadId.value,filters: filters.value);
    return response;
  }
}
