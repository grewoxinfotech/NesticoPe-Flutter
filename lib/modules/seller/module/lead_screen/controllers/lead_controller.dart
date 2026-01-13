// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
//
// class LeadController extends GetxController {
//   final List<String> statusList = [
//     'Interested',
//     'New Lead',
//     'Contacted',
//     'Follow Up',
//     'Site Visit',
//     'Negotiation',
//     'Closed',
//     'Lost',
//   ];
//
//   RxString selectedFilterStatus = ''.obs;
//   RxString selectedStatus = ''.obs;
//
//   final List<String> leadTypeList = ["All Leads", "Residential", "Commercial"];
//
//   RxString selectedLeadType = ''.obs;
//   Rxn<DateTime> selectedDate = Rxn<DateTime>();
//   final TextEditingController dateController = TextEditingController();
//
//   // Add notes functionality
//   RxString notes = ''.obs;
//   final TextEditingController notesController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadVariables();
//   }
//
//   @override
//   void onClose() {
//     dateController.dispose();
//     notesController.dispose();
//     super.onClose();
//   }
//
//   void loadVariables() {
//     selectedFilterStatus.value = 'All Status'; // Changed to show all by default
//     selectedLeadType.value = leadTypeList.first; // This is "All Leads"
//     selectedStatus.value = statusList.first;
//     dateController.text = "";
//     selectedDate.value = null;
//     notes.value = '';
//   }
//
//   // Method to update lead status
//   void updateStatus(String newStatus) {
//     if (statusList.contains(newStatus)) {
//       selectedFilterStatus.value = newStatus;
//     }
//   }
//
//   // Method to update lead type filter
//   void updateLeadType(String newType) {
//     if (leadTypeList.contains(newType)) {
//       selectedLeadType.value = newType;
//     }
//   }
//
//   // Method to set follow-up date and time
//   void setFollowUpDateTime(DateTime dateTime) {
//     selectedDate.value = dateTime;
//     dateController.text = dateTime.toString();
//   }
//
//   // Method to clear follow-up date
//   void clearFollowUpDate() {
//     selectedDate.value = null;
//     dateController.text = "";
//   }
//
//   // Method to update notes
//   void updateNotes(String newNotes) {
//     notes.value = newNotes;
//     notesController.text = newNotes;
//   }
//
//   // Method to clear notes
//   void clearNotes() {
//     notes.value = '';
//     notesController.text = '';
//   }
//
//   // Method to reset all filters and data
//   void resetFilters() {
//     selectedFilterStatus.value = statusList.first;
//     selectedLeadType.value = leadTypeList.first;
//   }
//
//   // Method to check if lead has pending follow-up
//   bool hasUpcomingFollowUp() {
//     if (selectedDate.value == null) return false;
//     return selectedDate.value!.isAfter(DateTime.now());
//   }
//
//   // Method to check if follow-up is overdue
//   bool isFollowUpOverdue() {
//     if (selectedDate.value == null) return false;
//     return selectedDate.value!.isBefore(DateTime.now());
//   }
//
//   // Method to get formatted follow-up date
//   String getFormattedFollowUpDate() {
//     if (selectedDate.value == null) return "No follow-up set";
//     return dateController.text;
//   }
//
//   // Method to validate if all required fields are filled
//   bool isValid() {
//     return selectedFilterStatus.value.isNotEmpty;
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
// import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
//
// import '../../../../../data/network/lead/lead_service.dart';
// import '../model/lead_model.dart';
//
// class LeadController extends PaginatedController<LeadItem> {
//   final LeadService _service = LeadService();
//
//   // --- Form Controllers ---
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//
//   // --- Lead Status & Type Lists ---
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
//   // --- Reactive Fields ---
//   RxString selectedFilterStatus = 'All Status'.obs;
//   RxString selectedStatus = 'New Lead'.obs;
//   RxString selectedLeadType = 'All Leads'.obs;
//   Rxn<DateTime> selectedDate = Rxn<DateTime>();
//   RxString notes = ''.obs;
//
//   // --- Optional filters for API ---
//   Map<String, String>? filters;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadVariables();
//     loadInitial(); // Load first page of leads automatically
//   }
//
//   @override
//   void onClose() {
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     notesController.dispose();
//     dateController.dispose();
//     super.onClose();
//   }
//
//   // --- Pagination Fetch ---
//   @override
//   Future<PaginationResponse<LeadItem>> fetchItems(int page) async {
//     try {
//       final response = await _service.fetchLeads(page: page, filters: filters);
//       print("Fetched leads: ${response.items.length}");
//       return response;
//     } catch (e) {
//       print("Exception in fetchItems: $e");
//       rethrow;
//     }
//   }
//
//   // --- CRUD Methods ---
//   Future<bool> createLead(LeadItem lead) async {
//     try {
//       final success = await _service.createLead(lead);
//       if (success) await loadInitial();
//       return success;
//     } catch (e) {
//       print("Create lead error: $e");
//       return false;
//     }
//   }
//
//   Future<bool> updateLead(String id, LeadItem updatedLead) async {
//     try {
//       final success = await _service.updateLead(id, updatedLead);
//       if (success) {
//         int index = items.indexWhere((item) => item.id == id);
//         if (index != -1) {
//           items[index] = updatedLead;
//           items.refresh();
//         }
//       }
//       return success;
//     } catch (e) {
//       print("Update lead error: $e");
//       return false;
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
//   // --- Filters ---
//   Future<void> applyFilters(Map<String, String> newFilters) async {
//     filters = newFilters;
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
//   // --- Lead Management Helpers ---
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
//     notesController.text = newNotes;
//   }
//
//   void clearNotes() {
//     notes.value = '';
//     notesController.clear();
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
//   // --- Reset Form ---
//   void resetForm() {
//     nameController.clear();
//     phoneController.clear();
//     emailController.clear();
//     notesController.clear();
//     dateController.clear();
//     notes.value = '';
//     selectedDate.value = null;
//     selectedStatus.value = statusList.first;
//     selectedLeadType.value = leadTypeList.first;
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';

import '../../../../../data/database/secure_storage_service.dart';
import '../../../../../data/network/lead/lead_service.dart';
import '../../../../../data/network/property/services/property_service.dart';
import '../../../../property/controllers/property_controller.dart';

import '../model/lead_model.dart';

class LeadController extends PaginatedController<LeadItem> {
  final LeadService _service = LeadService();
  final PropertyService _serviceProperty = PropertyService();


  late final bool fromReseller;
  Items customFields = Items();
  RxList<Items> leadPropertiesList =
      <Items>[].obs; // Store all properties fetched for leads

  final PropertyController propertyController = Get.put(
    PropertyController(),
    tag: "reseller",
  );
  Rxn<NewUpdatedLeadModel> newUpdatedLeadModel = Rxn<NewUpdatedLeadModel>();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  // --- Form Controllers ---
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

  // --- Lead Status & Type Lists ---
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

  // --- Reactive Fields ---
  RxString selectedFilterStatus = 'All Status'.obs;

  // RxString selectedStatus = 'New Lead'.obs;
  RxString selectedLeadType = 'All Leads'.obs;
  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  RxString notes = ''.obs;
  RxList<Items> propertyList = <Items>[].obs;
  Rxn<Items> selectedProperty = Rxn<Items>();

  // --- Optional filters for API ---
  RxMap<String, String> filters = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (UserHelper.isReseller) {
      fromReseller = true;
      // fetchResellerLead();
    }

    if (UserHelper.isSeller) {
      fromReseller = false;
      // fetchResellerLead();
    }
    fetchResellerAssignProperty();
    loadVariables();

    loadInitial();
  }

  Future<void> fetchPropertyById(String propertyId) async {
    try {
      final property = await _serviceProperty.getPropertyById(propertyId);
      if (property != null) {
        customFields = property;
        // Add to list if not already present
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
      propertyList.value = propertyController.items;

      print("Property List for Lead: ${propertyList.length}");
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

  // --- Pagination Fetch ---
  @override
  Future<PaginationResponse<LeadItem>> fetchItems(int page) async {
    try {
      if (fromReseller) {
        final user = await SecureStorage.getUserData();
        final userId = user?.user?.id;
        final response = await _service.fetchLeads(
          page: page,
          userId: userId,
          filters: filters.value,
          fromReseller: fromReseller,
        );
        if (response.items.isNotEmpty) {
          for (var item in response.items) {
            if (item.propertyId != null && item.propertyId!.isNotEmpty) {
              print("Fetching property with ID: ${item.propertyId}");
              await fetchPropertyById(item.propertyId!);
            }
          }
        }

        return response;
      } else {
        final response = await _service.fetchLeads(
          page: page,
          filters: filters.value,
          fromReseller: fromReseller,
        );
        if (response.items.isNotEmpty) {
          for (var item in response.items) {
            if (item.propertyId != null && item.propertyId!.isNotEmpty) {
              print("Fetching Seller property with ID: ${item.propertyId}");
              await fetchPropertyById(item.propertyId!);
            }
          }
        }
        return response;
      }
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  // --- CRUD Methods ---
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
    // log('Lead Details: ${lead.toJson()}');
    newUpdatedLeadModel.value=await _service.getLeadDataByID(id);
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

  // --- Filters ---
  Future<void> applyFilters(
    Map<String, String> newFilters, {
    String? propertyId,
  }) async {
    filters.value = newFilters;
    await refreshList();
    if (propertyId != null) {
      await getLeadsByProperty(propertyId);
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

  // --- Lead Management Helpers ---
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

  // --- Reset Form ---
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
      selectedProperty.value = propertyController.items.first;
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

  // Add these properties to your LeadController class

  // ============ Property-Specific Lead Pagination ============
  RxList<LeadItem> propertyLeads = <LeadItem>[].obs;
  var isLoadingPropertyLeads = false.obs;
  var propertyLeadsCurrentPage = 1.obs;
  var propertyLeadsTotalPages = 1.obs;
  var propertyLeadsHasMore = true.obs;

  /// Get leads by property with pagination and filters
  Future<void> getLeadsByProperty(
    String propertyId, {
    bool loadMore = false,
  }) async {
    await getLeadsByPropertyWithFilters(propertyId, loadMore: loadMore);
  }

  /// Get leads by property with pagination and optional filters
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
        filters: filters ?? {}, // Pass filters to API
      );

      // Fetch property details for each lead if needed
      if (response.items.isNotEmpty) {
        for (var item in response.items) {
          if (item.propertyId != null && item.propertyId!.isNotEmpty) {
            await fetchPropertyById(item.propertyId!);
          }
        }
      }

      if (loadMore) {
        propertyLeads.addAll(response.items);
      } else {
        propertyLeads.assignAll(response.items);
      }

      propertyLeadsTotalPages.value = response.meta.totalPages;
      propertyLeadsHasMore.value = response.meta.hasMore;

      print(
        "Property leads loaded: ${response.items.length}, Page: ${propertyLeadsCurrentPage.value}",
      );
      print("Applied filters: $filters");
    } catch (e) {
      print("Error loading property leads: $e");
    } finally {
      isLoadingPropertyLeads.value = false;
    }
  }

  /// Load more property leads (for scroll pagination)
  Future<void> loadMorePropertyLeads(String propertyId) async {
    if (propertyLeadsHasMore.value && !isLoadingPropertyLeads.value) {
      await getLeadsByProperty(propertyId, loadMore: true);
    }
  }

  /// Refresh property leads (for pull-to-refresh)
  Future<void> refreshPropertyLeads(String propertyId) async {
    await getLeadsByProperty(propertyId, loadMore: false);
  }

  /// Reset property leads state (call when navigating away)
  void resetPropertyLeads() {
    propertyLeads.clear();
    propertyLeadsCurrentPage.value = 1;
    propertyLeadsTotalPages.value = 1;
    propertyLeadsHasMore.value = true;
    isLoadingPropertyLeads.value = false;
  }
}
