import 'dart:developer';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/lead/lead_service.dart';
import '../../../../../data/network/lead/model/lead_property_inquiry_model.dart';

class LeadPropertyInquiryController extends PaginatedController<PropertyInquireItem> {
  RxInt leadInquiryId = 0.obs;
  RxMap<String, String> filters = <String, String>{}.obs;
  Rxn<PropertyInquireItem> selectedInquiry = Rxn<PropertyInquireItem>();

  final LeadService _leadService = LeadService();

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  @override
  Future<PaginationResponse<PropertyInquireItem>> fetchItems(int page) async {
    log("Fetching inquiries for Lead ID: ${leadInquiryId.value}");
    log("Filters applied: ${filters.toString()}");
    log("Page number: $page");

    final response = await _leadService.fetchInquiry(
      page: page,
      filters: filters,
      userId: leadInquiryId.value,
    );

    log("Response received: ${response.toString()}");
    return response;
  }

  Future<void> fetchInquiryById(int id)  async {
    log("Fetching inquiry by ID: $id");

    try {
      final inquiry = await _leadService.getInquiryById(id.toString());

      if (inquiry != null) {
        selectedInquiry.value = inquiry;
        log("Inquiry fetched successfully: ${inquiry.toMap()}");
      } else {

        log("No inquiry found for ID: $id");
        selectedInquiry.value = null;
      }
    } catch (e) {
      log("Error fetching inquiry by ID: $e");
      selectedInquiry.value = null;
    }
  }


  /// Set the currently active inquiry ID, then refresh the list.
  void setLeadInquiryId(int id) {
    log("Setting Lead Inquiry ID to: $id");
    leadInquiryId.value = id;
    fetchInquiryById(id);
    loadInitial();
  }
  // void selectInquiryFromList() {
  //   log("Lead Inquiry Id ${leadInquiryId.value}");
  //   try {
  //     if (items.isNotEmpty) {
  //       selectedInquiry.value = items.first;
  //       log("Selected inquiry: ${selectedInquiry.value?.toMap()}");
  //     } else {
  //       log("No inquiries available");
  //       selectedInquiry.value = null;
  //     }
  //   } catch (e) {
  //     log("Error selecting first inquiry: $e");
  //     selectedInquiry.value = null;
  //   }
  // }

  /// Select a specific inquiry from the loaded list by ID.
//   void selectInquiryFromList(int id ) {
// log("Lead Inquiry Id ${id}");
// log("Fetch All Items data ${items.map((element) => element.toMap(),)}");
//       selectedInquiry.value =
//           items.firstWhere((element) => element.id == id);
//       log("Selected inquiry: ${selectedInquiry.value?.toMap()}");
//   }
}
