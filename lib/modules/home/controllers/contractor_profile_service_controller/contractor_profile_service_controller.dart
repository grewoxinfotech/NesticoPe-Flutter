// import 'dart:developer';
//
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
// import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
//
// import 'package:nesticope_app/data/database/secure_storage_service.dart';
//
// import '../../../../data/network/auth/model/user_model.dart';
// import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
// import '../../../../data/network/contractor/service/contractor_my_service.dart';
// import '../../../../data/network/user/service/user_service.dart';
// import '../../../../widgets/messages/snack_bar.dart';
//
// class ContractorServiceController
//     extends PaginatedController<ContractorServiceItem> {
//   final ContractorMyService _service = ContractorMyService.contractorMyService;
//   final UserService _serviceUser = UserService();
//
//   RxList<ContractorServiceItem> selectedItems = <ContractorServiceItem>[].obs;
//
//   /// create Inquiry Form Fields
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   Rx<String> selectedPropertyType = ''.obs;
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController statController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController bhkController = TextEditingController();
//   final TextEditingController carpetAreaController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//
//   final List<String> propertyTypes = [
//     'Apartment', // BHK
//     'House', //
//     'Villa', //
//     'Plot',
//     'Office',
//     'Shop',
//     'Showroom',
//     'Warehouse',
//     'Other', //
//   ];
//   Rxn<User> userData = Rxn<User>();
//   /// Contractor ID is required to fetch services
//   final String contractorId;
//
//   ContractorServiceController({required this.contractorId});
//
//   /// --- Reactive UI states ---
//   RxBool isExpanded = false.obs;
//   RxString selectedPriceModel = ''.obs;
//   RxString selectedAvailability = ''.obs;
//
//   /// --- Optional filters ---
//   Map<String, String> filters = {};
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadInitial();
//   }
//
//   /// --------------------------------------------------------------------------
//   /// FETCH PAGINATED SERVICES
//   /// --------------------------------------------------------------------------
//   @override
//   Future<PaginationResponse<ContractorServiceItem>> fetchItems(int page) async {
//     try {
//       final response = await _service.fetchContractorService(
//         page: page,
//         filters: filters,
//         id: contractorId,
//       );
//
//       print("Fetched Contractor Services: ${response.items.length}");
//       fetchUserDataFromUrl();
//       return response;
//     } catch (e) {
//       print("Exception in fetchItems: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> fetchUserDataFromUrl()
//   async {
//     userData.value = await _serviceUser.getUserById(contractorId);
//     log("Fetched User Data From Have: ${userData.value?.toJson()}");
//
//   }
//
//   Future<void> createInquiry(
//     String contractorId,
//     List<ContractorServiceItem> services,
//   ) async {
//     try {
//       isLoading.value = true;
//
//       // Validate Form
//       if (!formKey.currentState!.validate()) {
//         print("❌ Form validation failed");
//         return;
//       }
//
//       // Get logged-in user info
//       final user = await SecureStorage.getUserData();
//       final email = user?.user?.email ?? '';
//       final username = user?.user?.username ?? '';
//       final phone = user?.user?.phone ?? '';
//
//       // Extracting state (if user entered "City, State")
//
//       // Prepare request body
//       final data = {
//         'contractorId': contractorId,
//         'email': email,
//         'name': username,
//         'phone': phone,
//
//         'services': services.map((e) => e.id).toList(),
//
//         'meta': {
//           if (bhkController.text.trim().isNotEmpty)
//             'bhk': bhkController.text.trim(),
//
//           'carpetArea': carpetAreaController.text.trim(),
//           'city': cityController.text.trim(),
//           'location': locationController.text.trim(),
//           'propertyType': selectedPropertyType.value,
//           'serviceDescription': descriptionController.text.trim(),
//           'state': statController.text.trim(),
//         },
//       };
//
//       print("Request Body: $data");
//
//       // API Call
//       final response = await _service.createInquiry(data);
//       print('✅ Inquiry created successfully: $response');
//
//       if (response) {
//         Get.back(result: true); // optional redirect
//         NesticoPeSnackBar.showAwesomeSnackbar(
//           title: "Success",
//           message: "Inquiry submitted successfully",
//           contentType: ContentType.success,
//         );
//       }
//     } catch (e) {
//       print('❌ Error creating inquiry: $e');
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// --------------------------------------------------------------------------
//   /// APPLY SINGLE FILTER
//   /// --------------------------------------------------------------------------
//   void applyFilter(String key, String value) {
//     filters.clear();
//     filters[key] = value;
//
//     resetPagination();
//     refreshList();
//   }
//
//   /// --------------------------------------------------------------------------
//   /// APPLY MULTIPLE FILTERS
//   /// --------------------------------------------------------------------------
//   Future<void> applyFilters(Map<String, String> newFilters) async {
//     isLoading.value = true;
//
//     filters = newFilters;
//
//     resetPagination();
//     await refreshList();
//
//     isLoading.value = false;
//   }
//
//   /// Reset pagination states
//   void resetPagination() {
//     currentPage.value = 1;
//     totalPages.value = 1;
//     hasMore.value = true;
//     items.clear();
//   }
//
//   /// --------------------------------------------------------------------------
//   /// GET SINGLE SERVICE BY ID
//   /// --------------------------------------------------------------------------
//   Future<ContractorServiceItem?> getServiceById(String id) async {
//     try {
//       final existing = items.firstWhereOrNull((item) => item.id == id);
//       if (existing != null) return existing;
//
//       // If needed, create a getById endpoint later
//       print("Service not found in list. You may add getById API support.");
//     } catch (e) {
//       print("Error getServiceById: $e");
//     }
//     return null;
//   }
//
//   /// --------------------------------------------------------------------------
//   /// TOGGLE ACTIVE/INACTIVE
//   /// --------------------------------------------------------------------------
//   Future<void> toggleActiveStatus(String id, bool current) async {
//     try {
//       await _service.changeActiveToInActive(id, !current);
//
//       final index = items.indexWhere((e) => e.id == id);
//       if (index != -1) {
//         items[index].isActive = !current;
//         items.refresh();
//       }
//     } catch (e) {
//       print("Error toggling active status: $e");
//     }
//   }
//
//   /// --------------------------------------------------------------------------
//   /// DELETE SERVICE
//   /// --------------------------------------------------------------------------
//   Future<bool> deleteService(String id) async {
//     try {
//       final success = await _service.deletedService(id);
//       if (success) {
//         items.removeWhere((element) => element.id == id);
//         items.refresh();
//       }
//       return success;
//     } catch (e) {
//       print("Error deleting service: $e");
//       return false;
//     }
//   }
//
//   void addSelectedService(ContractorServiceItem service) {
//     selectedItems.add(service);
//   }
//
//   void removeSelectedService(ContractorServiceItem service) {
//     selectedItems.remove(service);
//   }
//
//   void toggleSelectedService(ContractorServiceItem service) {
//     if (selectedItems.contains(service)) {
//       removeSelectedService(service);
//     } else {
//       addSelectedService(service);
//     }
//   }
//
//   void clearSelection() {
//     selectedItems.clear();
//   }
// }

import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';

import 'package:nesticope_app/data/database/secure_storage_service.dart';

import '../../../../data/network/auth/model/user_model.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../../data/network/contractor/service/contractor_my_service.dart';
import '../../../../data/network/user/service/user_service.dart';
import '../../../../widgets/messages/snack_bar.dart';

class ContractorServiceController
    extends PaginatedController<ContractorServiceItem> {
  final ContractorMyService _service = ContractorMyService.contractorMyService;
  final UserService _serviceUser = UserService();

  RxList<ContractorServiceItem> selectedItems = <ContractorServiceItem>[].obs;

  /// create Inquiry Form Fields
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<String> selectedPropertyType = ''.obs;
  final TextEditingController cityController = TextEditingController();
  final TextEditingController statController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController bhkController = TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // ✅ ADD THIS: Reactive string for selected city
  RxString selectedCity = ''.obs;

  final List<String> propertyTypes = [
    'Apartment', // BHK
    'House', //
    'Villa', //
    'Plot',
    'Office',
    'Shop',
    'Showroom',
    'Warehouse',
    'Other', //
  ];
  Rxn<User> userData = Rxn<User>();

  /// Contractor ID is required to fetch services
  final String contractorId;

  ContractorServiceController({required this.contractorId});

  /// --- Reactive UI states ---
  RxBool isExpanded = false.obs;
  RxString selectedPriceModel = ''.obs;
  RxString selectedAvailability = ''.obs;

  /// --- Optional filters ---
  Map<String, String> filters = {};

  @override
  void onInit() {
    print("Initializing ContractorServiceController for ID: $contractorId");
    super.onInit();
    loadInitial();
  }

  /// --------------------------------------------------------------------------
  /// FETCH PAGINATED SERVICES
  /// --------------------------------------------------------------------------
  @override
  Future<PaginationResponse<ContractorServiceItem>> fetchItems(int page) async {
    try {
      print("Fetching items for Contractor ID: $contractorId, page: $page");
      final response = await _service.fetchContractorService(
        page: page,
        filters: filters,
        id: contractorId,
      );

      print("Fetched Contractor Services: ${response.items.length}");
      fetchUserDataFromUrl();
      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  Future<void> fetchUserDataFromUrl() async {
    userData.value = await _serviceUser.getUserById(contractorId);
    log("Fetched User Data From Have: ${userData.value?.toJson()}");
  }

  Future<void> createInquiry(
    String contractorId,
    List<ContractorServiceItem> services,
  ) async {
    try {
      isLoading.value = true;

      // Validate Form
      if (!formKey.currentState!.validate()) {
        print("❌ Form validation failed");
        return;
      }

      // Get logged-in user info
      final user = await SecureStorage.getUserData();
      final email = user?.user?.email ?? '';
      final username = user?.user?.username ?? '';
      final phone = user?.user?.phone ?? '';

      // Extracting state (if user entered "City, State")

      // Prepare request body
      final data = {
        'contractorId': contractorId,
        'email': email,
        'name': username,
        'phone': phone,

        'services': services.map((e) => e.id).toList(),

        'meta': {
          'bhk': '0',
          'carpetArea': '0',
          'city': cityController.text.trim(),
          'location': locationController.text.trim(),
          'propertyType': selectedPropertyType.value,
          'serviceDescription': descriptionController.text.trim(),
          'state': statController.text.trim(),
        },
      };

      print("Request Body: $data");

      // API Call
      final response = await _service.createInquiry(data);
      print('✅ Inquiry created successfully: $response');

      if (response) {
        clearInquiryForm();
        Get.back(result: true); // optional redirect
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Inquiry submitted successfully",
          contentType: ContentType.success,
        );
      }
    } catch (e) {
      print('❌ Error creating inquiry: $e');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString(),
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearInquiryForm() {
    formKey.currentState?.reset();
    selectedPropertyType.value = '';
    selectedCity.value = '';
    cityController.clear();
    statController.clear();
    locationController.clear();
    bhkController.clear();
    carpetAreaController.clear();
    descriptionController.clear();
  }

  /// --------------------------------------------------------------------------
  /// APPLY SINGLE FILTER
  /// --------------------------------------------------------------------------
  void applyFilter(String key, String value) {
    filters.clear();
    filters[key] = value;

    resetPagination();
    refreshList();
  }

  /// --------------------------------------------------------------------------
  /// APPLY MULTIPLE FILTERS
  /// --------------------------------------------------------------------------
  Future<void> applyFilters(Map<String, String> newFilters) async {
    isLoading.value = true;

    filters = newFilters;

    resetPagination();
    await refreshList();

    isLoading.value = false;
  }

  /// Reset pagination states
  void resetPagination() {
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();
  }

  /// --------------------------------------------------------------------------
  /// GET SINGLE SERVICE BY ID
  /// --------------------------------------------------------------------------
  Future<ContractorServiceItem?> getServiceById(String id) async {
    try {
      final existing = items.firstWhereOrNull((item) => item.id == id);
      if (existing != null) return existing;

      // If needed, create a getById endpoint later
      print("Service not found in list. You may add getById API support.");
    } catch (e) {
      print("Error getServiceById: $e");
    }
    return null;
  }

  /// --------------------------------------------------------------------------
  /// TOGGLE ACTIVE/INACTIVE
  /// --------------------------------------------------------------------------
  Future<void> toggleActiveStatus(String id, bool current) async {
    try {
      await _service.changeActiveToInActive(id, !current);

      final index = items.indexWhere((e) => e.id == id);
      if (index != -1) {
        items[index].isActive = !current;
        items.refresh();
      }
    } catch (e) {
      print("Error toggling active status: $e");
    }
  }

  /// --------------------------------------------------------------------------
  /// DELETE SERVICE
  /// --------------------------------------------------------------------------
  Future<bool> deleteService(String id) async {
    try {
      final success = await _service.deletedService(id);
      if (success) {
        items.removeWhere((element) => element.id == id);
        items.refresh();
      }
      return success;
    } catch (e) {
      print("Error deleting service: $e");
      return false;
    }
  }

  void addSelectedService(ContractorServiceItem service) {
    selectedItems.add(service);
  }

  void removeSelectedService(ContractorServiceItem service) {
    selectedItems.remove(service);
  }

  void toggleSelectedService(ContractorServiceItem service) {
    if (selectedItems.contains(service)) {
      removeSelectedService(service);
    } else {
      addSelectedService(service);
    }
  }

  void clearSelection() {
    selectedItems.clear();
  }
}
