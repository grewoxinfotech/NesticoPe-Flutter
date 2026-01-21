import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/lead/lead_service.dart';
import 'package:housing_flutter_app/data/network/lead/model/lead_visit_model.dart';
import 'package:intl/intl.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/auth/model/user_model.dart';
import '../../../../../data/network/lead/model/lead_property_inquiry_model.dart';
import '../../../../../data/network/property/services/top_seller_profile_service.dart';
import '../../../../../data/network/user/service/user_service.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../add_property/view/create_property.dart';
import '../../../../profile/model/seller_profile.dart';

class LeadVisitController extends PaginatedController<LeadVisitItem> {
  RxString buyer_Id = ''.obs;
  RxString property_Id = ''.obs;
  RxString buyerPayload_Id = ''.obs;
  RxString propertyPayload_Id = ''.obs;
  RxString seller_Id = ''.obs;
  RxString status = ''.obs;
  RxString leadVisitId = ''.obs;

  RxMap<String, String> filters = <String, String>{}.obs;
  UserService userService = UserService();
  Rxn<User> selectedVisit = Rxn<User>();
  var txtReason = TextEditingController();
  var txtDate = TextEditingController();
  var txtTime = TextEditingController();
  RxString leadIdFollowUp = ''.obs;
  Rxn<GlobalKey> formKey = Rxn<GlobalKey>();

  // final payload = {
  //   "property_id": "XBaFK4a5znQSIBw68ZztTRw",
  //   "buyer_id": "QdKzQ3VAeZCgjrD6Rfu73ZT",
  //   "seller_id": "Gz7RdxMnrovMDBTpgwcTOIu",
  //   "status": "rescheduled",
  //   "cancellationReason": "njdvnjdvzkjcndjcnsdjcnsdcn",
  //   "visitDate": "2025-12-26T00:00:00.000Z",
  //   "timeSlot": "20:02",
  // };
  Future<void> refreshLead() async {
    try {
      isRefreshing.value = true;
      refreshList();
      selectedVisit.refresh();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh ',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  void populatePayloadData(LeadVisitItem payload) {
    buyerPayload_Id.value = payload.buyerId ?? '';
    propertyPayload_Id.value = payload.propertyId ?? '';
    leadVisitId.value = payload.id ?? '';
    seller_Id.value = payload.sellerId ?? '';
    status.value = payload.status ?? '';
    txtReason.text = payload.cancellationReason ?? '';
    String visitDate = payload.visitDate ?? '';
    if (visitDate.isNotEmpty) {
      DateTime parsedDate = DateTime.parse(visitDate);
      txtDate.text = DateFormat('yyyy-MM-dd').format(parsedDate);
    } else {
      txtDate.text = '';
    }
    txtTime.text = payload.timeSlot ?? '';
    log("Populated payload data: ${payload.toMap()}");
  }

  void clearPayloadData() {
    buyerPayload_Id.value = '';
    propertyPayload_Id.value = '';
    leadVisitId.value = '';
    seller_Id.value = '';
    status.value = '';
    txtReason.clear();
    txtDate.clear();
    txtTime.clear();

    log("Cleared all payload data");
  }

  final LeadService _leadService = LeadService();

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  @override
  Future<PaginationResponse<LeadVisitItem>> fetchItems(int page) async {
    log("Fetching Visit for Lead ID: ${buyer_Id.value}");
    log("Fetching Visit for Lead ID: ${property_Id.value}");
    log("Filters applied: ${filters.toString()}");
    log("Page number: $page");

    final response = await _leadService.fetchLeadVisitData(
      page: page,
      filters: filters,
      buyerId: buyer_Id.value,
      propertyId: property_Id.value,
    );
    log("Response received: ${response.toString()}");
    return response;
  }

  /// Set the currently active inquiry ID, then refresh the list.
  void setLeadVisitId(String? buyerId, String? propertyId) {
    log("Setting Lead Visit Buyer ID to: $buyerId");
    log("Setting Lead Visit Property ID to: $propertyId");

    buyer_Id.value = buyerId ?? '';
    property_Id.value = propertyId ?? '';
    log("Loading initial data for Lead Visit");
    log("Buyer ID: ${buyer_Id.value}, Property ID: ${property_Id.value}");
    // leadInquiryId.value = id;
    loadInitial();
    refreshLead();
  }

  void getLeadId(String? leadId) {
    log("Setting Lead Visit leadId ID to: $leadId");

    leadIdFollowUp.value = leadId ?? '';

    log("Loading initial data for Lead Visit  ${leadIdFollowUp.value}");

    // leadInquiryId.value = id;
    leadIdFollowUp.refresh();
    // loadInitial();
    // refreshLead();
  }

  // Instead of a single user:
  RxMap<String, User> userProfiles = <String, User>{}.obs;

  Future<void> getTheVisitersProfile(String visiterId) async {
    log("Fetching visiter profile for ID: $visiterId");

    if (userProfiles.containsKey(visiterId)) {
      log("User already cached: $visiterId");
      return; // Avoid duplicate API calls
    }

    try {
      final user = await userService.getUserById(visiterId);
      if (user != null) {
        userProfiles[visiterId] = user;
        log("KDisadji ${userProfiles}");
        userProfiles.refresh();
        log('Profile stored for user $visiterId');
      }
    } catch (e) {
      log("Error fetching visiter profile: $e");
    }
  }

  void deleteLead() {
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
                        "${'Reject Visit'}",
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
                        clearPayloadData();
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
                  child: Form(
                    key: formKey.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type Dropdown
                        NesticoPeTextField(
                          controller: txtReason,
                          title: 'Reason',
                          hintText: 'Enter Reason',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textSecondary,
                          ),
                          prefixIcon: Icons.note_alt_outlined,
                          isRequired: true,
                          maxLines: 3,
                        ),
                        SizedBox(height: 16),
                        // Row(
                        //   children: [
                        //     buildSectionTitle('(Reschedule) Date & Time'),
                        //   ],
                        // ),
                        // SizedBox(height: 8,),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: buildTextField(
                        //         'Start Date',
                        //         Icons.calendar_month_outlined,
                        //         txtDate,
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return 'Please enter valid date';
                        //           }
                        //           return null;
                        //         },
                        //         isEnable: false,
                        //         onTap: () async {
                        //
                        //           DateTime? picked = await showDatePicker(
                        //             context: Get.context!,
                        //             initialDate:  DateTime.now(),
                        //             firstDate: DateTime(2000),
                        //             lastDate: DateTime(2100),
                        //             builder: (context, child) {
                        //               return Theme(
                        //                 data: Theme.of(context).copyWith(
                        //                   colorScheme: ColorScheme.light(
                        //                     primary: ColorRes.primary,
                        //                     onPrimary: ColorRes.white,
                        //                     onSurface: ColorRes.black,
                        //                   ),
                        //                   textButtonTheme: TextButtonThemeData(
                        //                     style: TextButton.styleFrom(
                        //                       foregroundColor: ColorRes.primary,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 child: child!,
                        //               );
                        //             },
                        //           );
                        //           if (picked != null) {
                        //             txtDate.text =picked.toIso8601String();
                        //           }
                        //         },
                        //         isPhoneKey: true,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 12),
                        //     Expanded(
                        //       child: buildTextField(
                        //         'Time',
                        //         Icons.timelapse_rounded,
                        //         txtTime,
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return 'Please enter valid Time';
                        //           }
                        //           return null;
                        //         },
                        //         isEnable: false,
                        //         onTap: () async {
                        //           final picked = await showTimePicker(
                        //             context: Get.context!,
                        //             initialTime: TimeOfDay.now(),
                        //           );
                        //           if (picked != null) {
                        //             // Convert TimeOfDay to 24-hour formatted string (HH:mm)
                        //             final now = DateTime.now();
                        //             final formattedTime = DateFormat('HH:mm').format(
                        //               DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
                        //             );
                        //
                        //             txtTime.text = formattedTime;
                        //             log("Picked time: $formattedTime");
                        //           }
                        //         },
                        //       ),
                        //     )
                        //
                        //   ],
                        // ),
                        // const SizedBox(height: 16),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                clearPayloadData();
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
                                if (formKey.value?.currentState != null &&
                                    !(formKey.value?.currentState as FormState)
                                        .validate()) {
                                  Get.back();
                                  log(
                                    "Form is invalid. Please correct the errors.",
                                  );
                                } else {
                                  updateRejectVisit(leadVisitId.value);
                                  Get.back();
                                  log(
                                    "Form is valid. Proceeding with submission.",
                                  );
                                }
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      ],
                    ),
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

  Map<String, String> buildPayload() {
    return {
      "property_id": propertyPayload_Id.value,
      "buyer_id": buyerPayload_Id.value,
      "seller_id": seller_Id.value,
      "status": 'rescheduled',
      "action": "reject",
      "cancellationReason": txtReason.text,
      "visitDate": txtDate.text.isNotEmpty ? "${txtDate.text}" : "",
      "timeSlot": txtTime.text,
    };
  }

  Map<String, String> buildRejectPayload() {
    return {
      "property_id": propertyPayload_Id.value,
      "buyer_id": buyerPayload_Id.value,
      "seller_id": seller_Id.value,
      "status": 'cancelled',
      "cancellationReason": txtReason.text,
      "action": "reject",
    };
  }

  void updateRejectVisit(String visitId) async {
    log("Reject visit with ID: $visitId");
    Map<String, String> payload = buildRejectPayload();
    log("Payload for Reject: $payload");

    try {
      await _leadService.updateTheVisitedData(payload, visitId);
      log("Visit Reject successfully for ID: $visitId");
      refreshList();
      clearPayloadData();
    } catch (e) {
      log("Error Reject visit for ID $visitId: $e");
    }
  }

  void updateVisit(String visitId) async {
    log("Updating visit with ID: $visitId");
    Map<String, String> payload = buildPayload();
    log("Payload for update: $payload");

    try {
      await _leadService.updateTheVisitedData(payload, visitId);
      log("Visit updated successfully for ID: $visitId");
      // Optionally, refresh the list or perform other actions after update
      refreshList();
      clearPayloadData();
    } catch (e) {
      log("Error updating visit for ID $visitId: $e");
    }
  }

  void approvedVisite(String visitId) async {
    log("Updating visit with ID: $visitId");
    Map<String, String> payload = {'status': "confirmed"};
    log("Payload for update: $payload");

    try {
      await _leadService.updateTheVisitedData(payload, visitId);
      log("Visit updated successfully for ID: $visitId");
      // Optionally, refresh the list or perform other actions after update
      refreshList();
      clearPayloadData();
    } catch (e) {
      log("Error updating visit for ID $visitId: $e");
    }
  }

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
                        "${'Update Visit'}",
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
                        clearPayloadData();
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
                  child: Form(
                    key: formKey.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type Dropdown
                        NesticoPeTextField(
                          controller: txtReason,
                          title: 'Reason',
                          hintText: 'Enter Reason',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textSecondary,
                          ),
                          prefixIcon: Icons.note_alt_outlined,
                          isRequired: true,
                          maxLines: 3,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            buildSectionTitle('(Reschedule) Date & Time'),
                          ],
                        ),
                        SizedBox(height: 8),
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
                                    txtDate.text = picked.toUtc().toString();
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
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                clearPayloadData();
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
                                if (formKey.value?.currentState != null &&
                                    !(formKey.value?.currentState as FormState)
                                        .validate()) {
                                  Get.back();
                                  log(
                                    "Form is invalid. Please correct the errors.",
                                  );
                                } else {
                                  updateVisit(leadVisitId.value);
                                  Get.back();
                                  log(
                                    "Form is valid. Proceeding with submission.",
                                  );
                                }
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
}
