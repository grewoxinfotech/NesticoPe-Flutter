import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/lead/lead_service.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/auth/model/user_model.dart';
import '../../../../../data/network/lead/model/lead_property_inquiry_model.dart';
import '../../../../../data/network/lead/model/lead_property_price_negotiable.dart';
import '../../../../../data/network/user/service/user_service.dart';
import '../../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../../widgets/messages/snack_bar.dart';
import '../../../../add_property/view/create_property.dart';

class LeadPropertyNegotiablePriceController
    extends PaginatedController<NegotiableItem> {
  RxString leadInquiryId = ''.obs;
  RxString leadBuyerId = ''.obs;

  RxMap<String, String> filters = <String, String>{}.obs;
  Rxn<PropertyInquireItem> selectedInquiry = Rxn<PropertyInquireItem>();
  var txtReason = TextEditingController();
  var txtPrice = TextEditingController();
  Rxn<GlobalKey> formKey = Rxn<GlobalKey>();
  final propertyId = "".obs;
  final buyerId = "".obs;
  final sellerId = "".obs;
  final action = "rejected".obs;
  final previousAction = "N/A".obs;
  RxString previousNegotiablePrice = ''.obs;
  final newStatus = "rejected".obs;
  final status = "approved".obs;

  final leadId = ''.obs;
  final LeadService _leadService = LeadService();
  Rxn<User> selectedVisit = Rxn<User>();
  UserService userService = UserService();
  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  void populatedContainData(NegotiableItem data) {
    log("Data of Negotiable Item: ${data.toMap()}");

    propertyId.value = data.propertyId ?? '';
    buyerId.value = data.buyerId ?? '';
    leadId.value = data.id ?? '';
    sellerId.value = data.sellerId ?? '';
    action.value = data.newStatus ?? 'rejected';
    previousAction.value = 'N/A';

    // ✅ Fixed conversion
    previousNegotiablePrice.value = data.previousNegotiablePrice ?? '';

    newStatus.value = data.newStatus ?? 'rejected';
    status.value = data.oldStatus ?? 'approved';
    txtPrice.text = (data.negotiablePrice ?? 0).toString();
    txtReason.text = data.rejectionReason ?? '';
  }

  Map<String, dynamic> getPayload() {
    // Clean the price text and parse it
    String priceText = txtPrice.text.trim();
    int? negotiablePrice;

    if (priceText.isNotEmpty) {
      // Try parsing as int first
      negotiablePrice = int.tryParse(priceText);

      // If that fails, try parsing as double and convert to int
      if (negotiablePrice == null) {
        double? doubleValue = double.tryParse(priceText);
        if (doubleValue != null) {
          negotiablePrice = doubleValue.toInt();
        }
      }
    }

    log("Parsed negotiable price: $negotiablePrice from text: '$priceText'");

    return {
      "propertyId": propertyId.value,
      "buyerId": buyerId.value,
      "sellerId": sellerId.value,
      "negotiablePrice": negotiablePrice,
      // "action": action.value,
      // "previousAction": previousAction.value,
      "previousNegotiablePrice": previousNegotiablePrice.value,
      "newStatus": "rejected",
      "rejectionReason": txtReason.text.trim(),
    };
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
                        "${'Reject Negotiable'}",
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
                        clearValues();
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
                        NesticoPeTextField(
                          controller: txtPrice,
                          title: 'Price',
                          hintText: 'Enter negotiable price',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textSecondary,
                          ),
                          prefixIcon:
                              Icons.currency_rupee, // or appropriate icon
                          isRequired: true,
                          keyboardType: TextInputType.number, // Add this

                          validator: (value) {
                            // Add validation
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a price';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                clearValues();
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
                                  rejectUpdateData(leadId.value ?? '');
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

  Future<void> rejectUpdateData(String id) async {
    log("Updating visit with ID: $id");
    Map<String, dynamic> payload = getPayload();
    log("Payload for update: $payload");

    try {
      await _leadService.updateRejectOfNegotiable(payload, id);
      log("Visit updated successfully for ID: $id");
      // Optionally, refresh the list or perform other actions after update
      refreshList();
      clearValues();
    } catch (e) {
      log("Error updating visit for ID $id: $e");
    }
  }

  void clearValues() {
    propertyId.value = '';
    buyerId.value = '';
    sellerId.value = '';
    action.value = 'rejected';
    previousAction.value = 'N/A';
    previousNegotiablePrice.value = '';
    newStatus.value = 'rejected';
    status.value = 'approved';

    txtPrice.clear();
    txtReason.clear();
  }

  final RxMap<String, User> buyerProfiles = <String, User>{}.obs;

  @override
  Future<PaginationResponse<NegotiableItem>> fetchItems(int page) async {
    log(
      "Fetching Negotiable Price for Lead ID: ${leadInquiryId.value}======= and Buyer ID: ${leadBuyerId.value}",
    );

    log("Filters applied: ${filters.toString()}");
    log("Page number: $page");

    final response = await _leadService.fetchLeadPrice(
      page: page,
      filters: filters,
      userId: leadInquiryId.value,
      buyerId: leadBuyerId.value,
    );

    log("Response received: ${response.toString()}");
    return response;
  }

  Future<void> getTheVisitersProfile(String visiterId) async {
    log("Fetching visiter profile for ID: $visiterId");
    final user = await userService.getUserById(visiterId);
    buyerProfiles[visiterId] = user ?? User.fromJson({});
    // Store by ID
    buyerProfiles.refresh(); // Trigger UI update
    log('✅ Loaded profile for ${user?.firstName}');
  }

  /// Set the currently active inquiry ID, then refresh the list.
  void setLeadNegotiablePriceId(String id, {String? buyerID}) {
    log("Setting Lead Negotiable Price ID to: $id");
    leadInquiryId.value = id;
    leadBuyerId.value = buyerID ?? '';

    loadInitial();
  }

  Future<void> updateTheDataApproved(String id) async {
    var data = {"newStatus": "approved"};
    log("Approved payload : $data");
    final response = await _leadService.updateStatusOfNegotiable(data, id);
    if (response) {
      refreshList();
    }
  }

  Future<void> refreshLead() async {
    try {
      isRefreshing.value = true;
      refreshList();
      selectedVisit.refresh();
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
}
