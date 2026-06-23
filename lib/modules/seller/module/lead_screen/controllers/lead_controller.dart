// import 'dart:developer';
// import 'dart:math' hide log;
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
// import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
// import 'package:nesticope_app/app/manager/property/property_name_manager.dart';
// import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
// import 'package:nesticope_app/data/network/property/models/property_model.dart';
//
// import '../../../../../app/constants/color_res.dart';
// import '../../../../../data/database/secure_storage_service.dart';
// import '../../../../../data/network/lead/lead_service.dart';
// import '../../../../../data/network/property/services/property_service.dart';
// import '../../../../../utils/logger/app_logger.dart';
// import '../../../../../widgets/messages/snack_bar.dart';
// import '../../../../builder/controller/all_project_controller.dart';
// import '../../../../builder/controller/project_controller.dart';
// import '../../../../property/controllers/property_controller.dart';
//
// import '../model/lead_model.dart';
//
// class LeadController extends PaginatedController<LeadItem> {
//   final LeadService _service = LeadService();
//   final PropertyService _serviceProperty = PropertyService();
//
//   late final bool fromReseller;
//   Items customFields = Items();
//   RxList<Items> leadPropertiesList = <Items>[].obs;
//
//   // ADDED: Track specific property ID for filtering
//   RxnString currentPropertyFilterId = RxnString();
//
//   final PropertyController propertyController = Get.put(
//     PropertyController(),
//     tag: "reseller",
//   );
//   final AllProjectController projectController = Get.put(
//     AllProjectController(),
//     tag: "reseller",
//   );
//   Rxn<NewUpdatedLeadModel> newUpdatedLeadModel = Rxn<NewUpdatedLeadModel>();
//
//   DateTime startDate = DateTime.now();
//   DateTime endDate = DateTime.now();
//
//   // Form Controllers and Status Lists
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController noteController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController txtStartDate = TextEditingController();
//   final TextEditingController txtEndDate = TextEditingController();
//
//   RxString selectedSource = ''.obs;
//   RxString selectedStatus = 'New Lead'.obs;
//   RxString selectedStage = ''.obs;
//
//   final List<String> statusList = [
//     'new',
//     'contacted',
//     'qualified',
//     'negotiation',
//     'lost',
//     'converted',
//   ];
//   final List<String> leadTypeList = ["All Leads", "Residential", "Commercial"];
//
//   final List<String> filterType = ["source", "status", "stage"];
//   final List<String> sourceList = [
//     'app',
//     'website',
//     'referral',
//     'social_media',
//     'direct',
//     'other',
//   ];
//   final List<String> stageList = [
//     'new_lead',
//     'contacted',
//     'interested',
//     'site_visit',
//     'sell',
//   ];
//   final RxString selectedFilterType = RxString("status");
//
//   var selectedFilterValue = "".obs;
//
//   RxString selectedFilterStatus = 'All Status'.obs;
//   RxString selectedLeadType = 'All Leads'.obs;
//   Rxn<DateTime> selectedDate = Rxn<DateTime>();
//   RxString notes = ''.obs;
//   RxList<DisplayEntityModel> propertyList = <DisplayEntityModel>[].obs;
//   Rxn<DisplayEntityModel> selectedProperty = Rxn<DisplayEntityModel>();
//
//   RxMap<String, String> filters = <String, String>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     if (UserHelper.isReseller) {
//       fromReseller = true;
//     }
//
//     if (UserHelper.isSeller) {
//       fromReseller = false;
//     }
//     fetchResellerAssignProperty();
//     fetchResellerAssignProject();
//     loadVariables();
//   }
//
//   /// Fetch property by ID without affecting loading state
//   Future<void> fetchPropertyById(String propertyId) async {
//     try {
//       final property = await _serviceProperty.getPropertyById(propertyId);
//       if (property != null) {
//         customFields = property;
//         if (!leadPropertiesList.any((p) => p.id == property.id)) {
//           leadPropertiesList.add(property);
//         }
//         log("Property fetched: ${property.toJson()}");
//       }
//     } catch (e) {
//       log("Error fetching property: $e");
//     }
//   }
//
//   Future<void> fetchResellerAssignProperty() async {
//     final user = await SecureStorage.getUserData();
//     final userId = user?.user?.id ?? '';
//     if (user != null) {
//       final filter = {"assignedTo": userId};
//       await propertyController.applyFilters(filter);
//       propertyList.addAll(
//         propertyController.items
//             .map(
//               (element) => DisplayEntityModel(
//                 id: element.id,
//                 title: PropertyNameManager(element).displayName,
//                 image: element.propertyMedia?.images?.firstOrNull,
//               ),
//             )
//             .toList(),
//       );
//     }
//   }
//
//   Future<void> fetchResellerAssignProject() async {
//     final user = await SecureStorage.getUserData();
//     final userId = user?.user?.id ?? '';
//     if (user != null) {
//       final filter = {"assignedTo": userId};
//       await projectController.applyFilters(filter);
//       propertyList.addAll(
//         projectController.items
//             .map(
//               (element) => DisplayEntityModel(
//                 id: element.id,
//                 title: element.projectName,
//                 image: element.mediaGallery?.images.firstOrNull,
//               ),
//             )
//             .toList(),
//       );
//     }
//   }
//
//   @override
//   void onClose() {
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     noteController.dispose();
//     dateController.dispose();
//     super.onClose();
//   }
//
//   /// FIXED: Proper pagination fetch with loading state management
//   @override
//   Future<PaginationResponse<LeadItem>> fetchItems(int page) async {
//     try {
//       PaginationResponse<LeadItem> response;
//
//       // 1. Check if we have a specific Property ID set
//       if (currentPropertyFilterId.value != null &&
//           currentPropertyFilterId.value!.isNotEmpty) {
//         print(
//           "Fetching leads for Property ID: ${currentPropertyFilterId.value} with filters: ${filters.value}",
//         );
//
//         // Fetch using the specific property service method
//         response = await _service.getLeadsByProperty(
//           page: page,
//           propertyId: currentPropertyFilterId.value!,
//           filters: filters.value,
//         );
//       }
//       // 2. Fallback to Original Logic (Global Leads)
//       else if (fromReseller) {
//         final user = await SecureStorage.getUserData();
//         final userId = user?.user?.id;
//         response = await _service.fetchLeads(
//           page: page,
//           userId: userId,
//           filters: filters.value,
//           fromReseller: fromReseller,
//         );
//       } else {
//         response = await _service.fetchLeads(
//           page: page,
//           filters: filters.value,
//           fromReseller: fromReseller,
//         );
//       }
//
//       AppLogger.structured(
//         "Data fetched from API:",
//         response.items.map((e) => e.toJson()),
//       );
//
//       // ✅ CRITICAL FIX: Fetch properties AFTER getting response
//       // but BEFORE returning, so loading states stay consistent
//       if (response.items.isNotEmpty) {
//         // Use Future.wait to fetch all properties in parallel
//         // This is faster and won't interfere with loading state
//         await Future.wait(
//           response.items
//               .where(
//                 (item) =>
//                     item.propertyId != null && item.propertyId!.isNotEmpty,
//               )
//               .map((item) => fetchPropertyById(item.propertyId!))
//               .toList(),
//         );
//       }
//
//       return response;
//     } catch (e) {
//       print("Exception in fetchItems: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> refreshLead() async {
//     try {
//       isRefreshing.value = true;
//       await refreshList();
//       await Future.delayed(const Duration(milliseconds: 500));
//     } catch (e) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Error',
//         message: 'Failed to refresh',
//         contentType: ContentType.failure,
//       );
//     } finally {
//       isRefreshing.value = false;
//     }
//   }
//
//   // CRUD Methods
//   Future<bool> createLead(LeadItem lead) async {
//     try {
//       isLoading.value = true;
//       final success = await _service.createLead(lead);
//       if (success) {
//         await loadInitial();
//       }
//       return success;
//     } catch (e) {
//       print("Create lead error: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> getLeadDetailByID(String id) async {
//     newUpdatedLeadModel.value = await _service.getLeadDataByID(id);
//     newUpdatedLeadModel.refresh();
//     log('Lead Details From data : ${newUpdatedLeadModel.value?.toJson()}');
//   }
//
//   Future<bool> updateLead(String id, LeadItem updatedLead) async {
//     try {
//       isLoading.value = true;
//       final success = await _service.updateLead(id, updatedLead);
//       if (success) {
//         int index = items.indexWhere((item) => item.id == id);
//         if (index != -1) {
//           items[index] = items[index].copyWith(
//             name: updatedLead.name,
//             email: updatedLead.email,
//             phone: updatedLead.phone,
//             propertyId: updatedLead.propertyId,
//             source: updatedLead.source,
//             status: updatedLead.status,
//             stage: updatedLead.stage,
//             notes: updatedLead.notes,
//           );
//
//           items.refresh();
//         }
//       }
//       return success;
//     } catch (e) {
//       print("Update lead error: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> deleteLead(String id) async {
//     try {
//       final success = await _service.deleteLead(id);
//       if (success) items.removeWhere((item) => item.id == id);
//       return success;
//     } catch (e) {
//       print("Delete lead error: $e");
//       return false;
//     }
//   }
//
//   /// Apply filters and refresh the list
//   Future<void> applyFilters(
//     Map<String, String> newFilters, {
//     String? propertyId,
//   }) async {
//     filters.value = newFilters;
//     await refreshList();
//   }
//
//   void loadVariables() {
//     selectedFilterStatus.value = 'All Status';
//     selectedLeadType.value = leadTypeList.first;
//     selectedStatus.value = statusList.first;
//     dateController.text = "";
//     selectedDate.value = null;
//     notes.value = '';
//   }
//
//   void updateStatus(String newStatus) {
//     if (statusList.contains(newStatus)) {
//       selectedStatus.value = newStatus;
//     }
//   }
//
//   void updateLeadType(String newType) {
//     if (leadTypeList.contains(newType)) {
//       selectedLeadType.value = newType;
//     }
//   }
//
//   void setFollowUpDateTime(DateTime dateTime) {
//     selectedDate.value = dateTime;
//     dateController.text = dateTime.toString();
//   }
//
//   void clearFollowUpDate() {
//     selectedDate.value = null;
//     dateController.text = "";
//   }
//
//   void updateNotes(String newNotes) {
//     notes.value = newNotes;
//     noteController.text = newNotes;
//   }
//
//   void clearNotes() {
//     notes.value = '';
//     noteController.clear();
//   }
//
//   void resetFilters() {
//     selectedFilterStatus.value = statusList.first;
//     selectedLeadType.value = leadTypeList.first;
//   }
//
//   bool hasUpcomingFollowUp() {
//     if (selectedDate.value == null) return false;
//     return selectedDate.value!.isAfter(DateTime.now());
//   }
//
//   bool isFollowUpOverdue() {
//     if (selectedDate.value == null) return false;
//     return selectedDate.value!.isBefore(DateTime.now());
//   }
//
//   String getFormattedFollowUpDate() {
//     if (selectedDate.value == null) return "No follow-up set";
//     return dateController.text;
//   }
//
//   bool isValid() {
//     return selectedStatus.value.isNotEmpty && nameController.text.isNotEmpty;
//   }
//
//   void resetForm() {
//     nameController.clear();
//     phoneController.clear();
//     emailController.clear();
//     noteController.clear();
//     dateController.clear();
//     notes.value = '';
//     selectedDate.value = null;
//     selectedStatus.value = statusList.first;
//     selectedStage.value = stageList.first;
//     selectedSource.value = sourceList.first;
//     if (propertyController.items.isNotEmpty) {
//       selectedProperty.value = propertyList.first;
//     }
//     selectedLeadType.value = leadTypeList.first;
//   }
//
//   void populateLeadData(LeadItem lead) {
//     nameController.text = lead.name ?? '';
//     phoneController.text = lead.phone ?? '';
//     emailController.text = lead.email ?? '';
//     noteController.text = lead.notes ?? '';
//     notes.value = lead.notes ?? '';
//     selectedStatus.value = lead.status ?? statusList.first;
//     selectedStage.value = lead.stage ?? stageList.first;
//     selectedSource.value = lead.source ?? sourceList.first;
//
//     if (lead.propertyId != null && propertyList.isNotEmpty) {
//       selectedProperty.value = propertyList.firstWhere(
//         (prop) => prop.id == lead.propertyId,
//         orElse: () => propertyList.first,
//       );
//     } else {
//       selectedProperty.value = null;
//     }
//   }
//
//   // Property-Specific Lead Pagination (Legacy support)
//   RxList<LeadItem> propertyLeads = <LeadItem>[].obs;
//   var isLoadingPropertyLeads = false.obs;
//   var propertyLeadsCurrentPage = 1.obs;
//   var propertyLeadsTotalPages = 1.obs;
//   var propertyLeadsHasMore = true.obs;
//
//   Future<void> getLeadsByProperty(
//     String propertyId, {
//     bool loadMore = false,
//   }) async {
//     await getLeadsByPropertyWithFilters(propertyId, loadMore: loadMore);
//   }
//
//   Future<void> getLeadsByPropertyWithFilters(
//     String propertyId, {
//     bool loadMore = false,
//   }) async {
//     try {
//       if (loadMore) {
//         propertyLeadsCurrentPage.value += 1;
//       } else {
//         propertyLeadsCurrentPage.value = 1;
//         propertyLeads.clear();
//       }
//
//       isLoadingPropertyLeads.value = true;
//
//       final response = await _service.getLeadsByProperty(
//         page: propertyLeadsCurrentPage.value,
//         propertyId: propertyId,
//         filters: filters,
//       );
//
//       // Fetch properties in parallel
//       if (response.items.isNotEmpty) {
//         await Future.wait(
//           response.items
//               .where(
//                 (item) =>
//                     item.propertyId != null && item.propertyId!.isNotEmpty,
//               )
//               .map((item) => fetchPropertyById(item.propertyId!))
//               .toList(),
//         );
//       }
//
//       if (loadMore) {
//         propertyLeads.addAll(response.items);
//       } else {
//         propertyLeads.assignAll(response.items);
//       }
//
//       propertyLeadsTotalPages.value = response.meta.totalPages;
//       propertyLeadsHasMore.value = response.meta.hasMore;
//     } catch (e) {
//       print("Error loading property leads: $e");
//     } finally {
//       isLoadingPropertyLeads.value = false;
//     }
//   }
//
//   Future<void> loadMorePropertyLeads(String propertyId) async {
//     if (propertyLeadsHasMore.value && !isLoadingPropertyLeads.value) {
//       await getLeadsByProperty(propertyId, loadMore: true);
//     }
//   }
//
//   Future<void> refreshPropertyLeads(String propertyId) async {
//     await getLeadsByProperty(propertyId, loadMore: false);
//   }
// }
//
// class DisplayEntityModel {
//   final String? id;
//   final String? title;
//   final String? image;
//
//   DisplayEntityModel({this.id, this.title, this.image});
// }

import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/app/manager/property/property_name_manager.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';

import '../../../../../app/constants/color_res.dart';
import '../../../../../data/database/secure_storage_service.dart';
import '../../../../../data/network/lead/lead_service.dart';
import '../../../../../data/network/property/services/property_service.dart';
import '../../../../../utils/excel/generate_excel.dart';
import '../../../../../utils/logger/app_logger.dart';
import '../../../../../widgets/messages/snack_bar.dart';
import '../../../../builder/controller/all_project_controller.dart';
import '../../../../builder/controller/project_controller.dart';
import '../../../../property/controllers/property_controller.dart';

import '../model/lead_model.dart';

class LeadController extends PaginatedController<LeadItem> {
  final LeadService _service = LeadService();
  final PropertyService _serviceProperty = PropertyService();

  late final bool fromReseller;
  Items customFields = Items();
  RxList<Items> leadPropertiesList = <Items>[].obs;
  final RxBool isFilterLoading = false.obs;

  // ADDED: Track specific property ID for filtering
  RxnString currentPropertyFilterId = RxnString();
  RxnString currentModule = RxnString();

  final PropertyController propertyController = Get.put(
    PropertyController(),
    tag: "reseller",
  );
  final AllProjectController projectController = Get.put(
    AllProjectController(),
    tag: "reseller",
  );
  Rxn<NewUpdatedLeadModel> newUpdatedLeadModel = Rxn<NewUpdatedLeadModel>();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  // Form Controllers and Status Lists
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController txtStartDate = TextEditingController();
  final TextEditingController txtEndDate = TextEditingController();

  RxString selectedSource = ''.obs;
  RxString selectedStatus = 'New Lead'.obs;
  RxString selectedStage = ''.obs;

  final List<String> statusList = [
    'new',
    'contacted',
    'qualified',
    'negotiation',
    'lost',
    'converted',
  ];
  final List<String> leadTypeList = ["All Leads", "Residential", "Commercial"];

  final List<String> filterType = ["source", "status", "stage"];
  final List<String> sourceList = [
    'app',
    'website',
    'referral',
    'social_media',
    'direct',
    'other',
  ];
  final List<String> stageList = [
    'new_lead',
    'contacted',
    'interested',
    'site_visit',
    'sell',
  ];
  final RxString selectedFilterType = RxString("status");

  var selectedFilterValue = "".obs;

  RxString selectedFilterStatus = 'All Status'.obs;
  RxString selectedLeadType = 'All Leads'.obs;
  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  RxString notes = ''.obs;
  RxList<DisplayEntityModel> propertyList = <DisplayEntityModel>[].obs;
  RxList<DisplayEntityModel> projectList = <DisplayEntityModel>[].obs;
  Rxn<DisplayEntityModel> selectedProperty = Rxn<DisplayEntityModel>();

  RxMap<String, String> filters = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (UserHelper.isReseller) {
      fromReseller = true;
    }

    if (UserHelper.isSeller) {
      fromReseller = false;
    }
    fetchResellerAssignProperty();
    fetchResellerAssignProject();
    loadVariables();
  }

  /// Fetch property by ID without affecting loading state
  Future<void> fetchPropertyById(String propertyId) async {
    try {
      final property = await _serviceProperty.getPropertyById(propertyId);
      if (property != null) {
        customFields = property;
        if (!leadPropertiesList.any((p) => p.id == property.id)) {
          leadPropertiesList.add(property);
        }
        log("Property fetched: ${property.toJson()}");
      }
    } catch (e) {
      log("Error fetching property: $e");
    }
  }

  Future<void> fetchResellerAssignProperty() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';
    if (user != null) {
      final filter = {"assignedTo": userId};
      await propertyController.applyFilters(filter);
      propertyList.addAll(
        propertyController.items
            .map(
              (element) => DisplayEntityModel(
                id: element.id,
                title: PropertyNameManager(element).displayName,
                image: element.propertyMedia?.images?.firstOrNull,
              ),
            )
            .toList(),
      );
    }
  }

  Future<void> exportToPdf(List<LeadItem> item) async {
    AppLogger.structured(
      "Lead Data Export in excel form : ",
      item.map((e) => e.toJson()),
    );
    await exportLeadsToExcel(items);
  }

  Future<void> exportProjectToPdf(List<LeadItem> item) async {
    AppLogger.structured(
      "Lead Data Export in excel form : ",
      item.map((e) => e.toJson()),
    );
    await exportProjectLeadsToExcel(items);
  }

  Future<void> importFromPdf() async {
    await pickAndImportCsv();
  }

  Future<void> pickAndImportCsv() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'], // ✅ Only CSV
      withData: true,
    );

    if (result == null) {
      print("❌ No file selected");
      return;
    }

    final pickedFile = result.files.single;

    print("📄 File name: ${pickedFile.name}");
    print("📦 Bytes length: ${pickedFile.bytes?.length}");

    // Extra safety check
    if (!pickedFile.name.toLowerCase().endsWith('.csv')) {
      print("❌ Invalid file type. Only CSV allowed.");
      return;
    }

    if (pickedFile.bytes == null || pickedFile.bytes!.isEmpty) {
      print("❌ CSV file is empty");
      return;
    }

    final response = await _service.importLeadDataExcelFile(
      pickedFile.bytes!,
      pickedFile.name,
    );

    if (response == true) {
      Get.back();
      await refreshList();
    }
  }

  Future<void> fetchResellerAssignProject() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';
    if (user != null) {
      final filter = {"assignedTo": userId};
      await projectController.applyFilters(filter);
      projectList.addAll(
        projectController.items
            .map(
              (element) => DisplayEntityModel(
                id: element.id,
                title: element.projectName,
                image: element.mediaGallery?.images.firstOrNull,
              ),
            )
            .toList(),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    noteController.dispose();
    dateController.dispose();
    super.onClose();
  }

  /// FIXED: Proper pagination fetch with loading state management
  @override
  Future<PaginationResponse<LeadItem>> fetchItems(int page) async {
    try {
      PaginationResponse<LeadItem> response;

      // 1. Check if we have a specific Property ID set
      if (currentPropertyFilterId.value != null &&
          currentPropertyFilterId.value!.isNotEmpty) {
        print(
          "Fetching leads for Property ID: ${currentPropertyFilterId.value} with filters: ${filters.value}",
        );

        // Fetch using the specific property service method

        response = await _service.getLeadsByProperty(
          page: page,
          propertyId: currentPropertyFilterId.value!,
          filters: filters.value,
        );
      
      }
      // 2. Fallback to Original Logic (Global Leads)
      else if (fromReseller) {
        final user = await SecureStorage.getUserData();
        final userId = user?.user?.id;
        log("Check it all ok or not ${currentModule.value}");
        response = await _service.fetchLeads(
          page: page,
          userId: userId,
          filters: filters.value,
          fromReseller: fromReseller,
          module: currentModule.value,
        );
      } else {
        response = await _service.fetchLeads(
          page: page,
          filters: filters.value,
          fromReseller: fromReseller,
        );
      }

      AppLogger.structured(
        "Data fetched from API:",
        response.items.map((e) => e.toJson()),
      );

      // ✅ CRITICAL FIX: Fetch properties AFTER getting response
      // but BEFORE returning, so loading states stay consistent
      if (response.items.isNotEmpty) {
        // Use Future.wait to fetch all properties in parallel
        // This is faster and won't interfere with loading state
        await Future.wait(
          response.items
              .where(
                (item) =>
                    item.propertyId != null && item.propertyId!.isNotEmpty,
              )
              .map((item) => fetchPropertyById(item.propertyId!))
              .toList(),
        );
      }

      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  Future<void> refreshLead() async {
    try {
      isRefreshing.value = true;
      await refreshList();
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  // CRUD Methods
  Future<bool> createLead(LeadItem lead) async {
    try {
      isLoading.value = true;
      final success = await _service.createLead(lead);
      if (success) {
        await loadInitial();
      }
      return success;
    } catch (e) {
      print("Create lead error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getLeadDetailByID(String id) async {
    newUpdatedLeadModel.value = await _service.getLeadDataByID(id);
    newUpdatedLeadModel.refresh();
    log('Lead Details From data : ${newUpdatedLeadModel.value?.toJson()}');
  }

  Future<bool> updateLead(String id, LeadItem updatedLead) async {
    try {
      isLoading.value = true;
      final success = await _service.updateLead(id, updatedLead);
      if (success) {
        int index = items.indexWhere((item) => item.id == id);
        if (index != -1) {
          items[index] = items[index].copyWith(
            name: updatedLead.name,
            email: updatedLead.email,
            phone: updatedLead.phone,
            propertyId: updatedLead.propertyId,
            source: updatedLead.source,
            status: updatedLead.status,
            stage: updatedLead.stage,
            notes: updatedLead.notes,
          );

          items.refresh();
        }
      }
      return success;
    } catch (e) {
      print("Update lead error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteLead(String id) async {
    try {
      final success = await _service.deleteLead(id);
      if (success) items.removeWhere((item) => item.id == id);
      return success;
    } catch (e) {
      print("Delete lead error: $e");
      return false;
    }
  }

  // /// Apply filters and refresh the list
  // Future<void> applyFilters(
  //     Map<String, String> newFilters, {
  //       String? propertyId,
  //     }) async {
  //   filters.value = newFilters;
  //   await refreshList();
  // }

  Future<void> applyFilters(
    Map<String, String> newFilters, {
    String? propertyId,
  }) async {
    try {
      isFilterLoading.value = true;

      filters.value = newFilters;

      // Reset pagination properly
      items.clear();
      hasMore.value = true;
      currentPage.value = 1;

      // Property-based filtering
      if (propertyId != null && propertyId.isNotEmpty) {
        currentPropertyFilterId.value = propertyId;
      } else {
        currentPropertyFilterId.value = null;
      }

      await loadInitial(); // 👈 important (not refreshList)
    } finally {
      isFilterLoading.value = false;
    }
  }

  void loadVariables() {
    selectedFilterStatus.value = 'All Status';
    selectedLeadType.value = leadTypeList.first;
    selectedStatus.value = statusList.first;
    dateController.text = "";
    selectedDate.value = null;
    notes.value = '';
  }

  void updateStatus(String newStatus) {
    if (statusList.contains(newStatus)) {
      selectedStatus.value = newStatus;
    }
  }

  void updateLeadType(String newType) {
    if (leadTypeList.contains(newType)) {
      selectedLeadType.value = newType;
    }
  }

  void setFollowUpDateTime(DateTime dateTime) {
    selectedDate.value = dateTime;
    dateController.text = dateTime.toString();
  }

  void clearFollowUpDate() {
    selectedDate.value = null;
    dateController.text = "";
  }

  void updateNotes(String newNotes) {
    notes.value = newNotes;
    noteController.text = newNotes;
  }

  void clearNotes() {
    notes.value = '';
    noteController.clear();
  }

  void resetFilters() {
    selectedFilterStatus.value = statusList.first;
    selectedLeadType.value = leadTypeList.first;
  }

  bool hasUpcomingFollowUp() {
    if (selectedDate.value == null) return false;
    return selectedDate.value!.isAfter(DateTime.now());
  }

  bool isFollowUpOverdue() {
    if (selectedDate.value == null) return false;
    return selectedDate.value!.isBefore(DateTime.now());
  }

  String getFormattedFollowUpDate() {
    if (selectedDate.value == null) return "No follow-up set";
    return dateController.text;
  }

  bool isValid() {
    return selectedStatus.value.isNotEmpty && nameController.text.isNotEmpty;
  }

  void resetForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    noteController.clear();
    dateController.clear();
    notes.value = '';
    selectedDate.value = null;
    selectedStatus.value = statusList.first;
    selectedStage.value = stageList.first;
    selectedSource.value = sourceList.first;
    if (propertyController.items.isNotEmpty) {
      selectedProperty.value = propertyList.first;
    }
    selectedLeadType.value = leadTypeList.first;
  }

  void populateLeadData(LeadItem lead) {
    nameController.text = lead.name ?? '';
    phoneController.text = lead.phone ?? '';
    emailController.text = lead.email ?? '';
    noteController.text = lead.notes ?? '';
    notes.value = lead.notes ?? '';
    selectedStatus.value = lead.status ?? statusList.first;
    selectedStage.value = lead.stage ?? stageList.first;
    selectedSource.value = lead.source ?? sourceList.first;

    if (lead.propertyId != null && propertyList.isNotEmpty) {
      selectedProperty.value = propertyList.firstWhere(
        (prop) => prop.id == lead.propertyId,
        orElse: () => propertyList.first,
      );
    } else {
      selectedProperty.value = null;
    }
  }

  // Property-Specific Lead Pagination (Legacy support)
  RxList<LeadItem> propertyLeads = <LeadItem>[].obs;
  var isLoadingPropertyLeads = false.obs;
  var propertyLeadsCurrentPage = 1.obs;
  var propertyLeadsTotalPages = 1.obs;
  var propertyLeadsHasMore = true.obs;

  Future<void> getLeadsByProperty(
    String propertyId, {
    bool loadMore = false,
  }) async {
    await getLeadsByPropertyWithFilters(propertyId, loadMore: loadMore);
  }

  Future<void> getLeadsByPropertyWithFilters(
    String propertyId, {
    bool loadMore = false,
  }) async {
    try {
      if (loadMore) {
        propertyLeadsCurrentPage.value += 1;
      } else {
        propertyLeadsCurrentPage.value = 1;
        propertyLeads.clear();
      }

      isLoadingPropertyLeads.value = true;

      final response = await _service.getLeadsByProperty(
        page: propertyLeadsCurrentPage.value,
        propertyId: propertyId,
        filters: filters,
      );

      // Fetch properties in parallel
      if (response.items.isNotEmpty) {
        await Future.wait(
          response.items
              .where(
                (item) =>
                    item.propertyId != null && item.propertyId!.isNotEmpty,
              )
              .map((item) => fetchPropertyById(item.propertyId!))
              .toList(),
        );
      }

      if (loadMore) {
        propertyLeads.addAll(response.items);
      } else {
        propertyLeads.assignAll(response.items);
      }

      propertyLeadsTotalPages.value = response.meta.totalPages;
      propertyLeadsHasMore.value = response.meta.hasMore;
    } catch (e) {
      print("Error loading property leads: $e");
    } finally {
      isLoadingPropertyLeads.value = false;
    }
  }

  Future<void> loadMorePropertyLeads(String propertyId) async {
    if (propertyLeadsHasMore.value && !isLoadingPropertyLeads.value) {
      await getLeadsByProperty(propertyId, loadMore: true);
    }
  }

  Future<void> refreshPropertyLeads(String propertyId) async {
    await getLeadsByProperty(propertyId, loadMore: false);
  }

  Future<void> clearFiltersAndReload() async {
    try {
      isFilterLoading.value = true;

      filters.clear();
      currentPropertyFilterId.value = null;

      items.clear();
      hasMore.value = true;
      currentPage.value = 1;

      await loadInitial();
    } finally {
      isFilterLoading.value = false;
    }
  }
}

class DisplayEntityModel {
  final String? id;
  final String? title;
  final String? image;

  DisplayEntityModel({this.id, this.title, this.image});
}
