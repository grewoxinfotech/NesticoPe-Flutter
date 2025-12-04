//
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
// import 'package:housing_flutter_app/data/network/contractor/service/contractor_my_service.dart';
// import 'package:housing_flutter_app/data/network/news/news_model.dart';
//
// import '../../../app/care/pagination/controller/pagination_controller.dart';
// import '../../../data/database/secure_storage_service.dart';
// import '../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
//
// class ContractorMyServiceController extends PaginatedController<ContractorServiceItem>{
//
//
//
//   RxMap<String, String> filters = <String, String>{}.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     ever(filters, (_) {
//       refreshList();
//     });
//     loadInitial(); // Load first page automatically
//
//   }
//   @override
//   Future<PaginationResponse<ContractorServiceItem>> fetchItems(int page) async {
//
//     try {
//       final user = await SecureStorage.getUserData();
//       final userId = user?.user?.id;
//       final response = await ContractorMyService.contractorMyService.fetchContractorService(
//         page: page,
//         filters: filters, id: userId??'',
//       );
//
//       print("Fetched items: ${response.items.length}");
//       return response; // contains items + meta (page/total)
//     } catch (e) {
//       print("Exception in fetchItems: $e");
//       rethrow;
//     }
//   }
//
//   void toggle(ContractorServiceItem item, bool value) async {
//     try {
//       // Update UI immediately
//       final index = items.indexWhere((e) => e.id == item.id);
//       if (index != -1) {
//         items[index].isActive = value;
//         items.refresh(); // update observable list
//       }
//
//       // Call API
//       await ContractorMyService.contractorMyService
//           .changeActiveToInActive(item.id, value);
//
//       print("Service ${item.serviceName} status changed to: $value");
//     } catch (e) {
//       print("Error toggling service: $e");
//
//       // Revert state if failed
//       final index = items.indexWhere((e) => e.id == item.id);
//       if (index != -1) {
//         items[index].isActive = !value;
//         items.refresh();
//       }
//     }
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/contractor/service/contractor_my_service.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';

class ContractorMyServiceController extends PaginatedController<ContractorServiceItem> {
  // ---------------- FORM VARIABLES ----------------

  Rxn<ContractorServiceCategoryResponse> contractorServiceCategory=Rxn<ContractorServiceCategoryResponse>();
  // Text Fields
  final serviceNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController(text: "0");
  final startingRangeController = TextEditingController();
  final brandController = TextEditingController();
  final advanceController = TextEditingController(text: "0");

  // Dropdowns
  final selectedCategory = "Renovation & Remodeling".obs;
  final selectedPriceModel = "Fixed".obs;
  final selectedAvailability = "Immediate".obs;
  final selectedBillingType = "GST".obs;

  // Toggles
  final provideMaterials = false.obs;
  final equipmentProvided = false.obs;
  final insuranceAvailable = false.obs;

  // Chips (multi-select)
  final acceptedPaymentModes = <String>[].obs;
  final allPaymentModes = ["UPI", "Bank Transfer", "Cash", "Cheque",];

  // Filters for pagination (optional)
  RxMap<String, String> filters = <String, String>{}.obs;

  // Loading & form state
  final isCreating = false.obs;

  // ---------------- INIT ----------------
  @override
  void onInit() {
    super.onInit();
    getCategoryService();
    ever(filters, (_) => refreshList());
    loadInitial();
  }

  // ---------------- PAGINATION FETCH ----------------
  @override
  Future<PaginationResponse<ContractorServiceItem>> fetchItems(int page) async {
    try {
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      final response = await ContractorMyService.contractorMyService.fetchContractorService(
        page: page,
        filters: filters,
        id: userId,
      );

      print("Fetched items: ${response.items.length}");
      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  // ---------------- TOGGLE ACTIVE STATUS ----------------
  void toggle(ContractorServiceItem item, bool value) async {
    try {
      final index = items.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        items[index].isActive = value;
        items.refresh();
      }

      await ContractorMyService.contractorMyService.changeActiveToInActive(item.id??'', value);
      print("Service ${item.serviceName} status changed to: $value");
    } catch (e) {
      print("Error toggling service: $e");
      final index = items.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        items[index].isActive = !value;
        items.refresh();
      }
    }
  }
  Future<void> deleteService(String id) async {
    try {
      final success = await ContractorMyService.contractorMyService.deletedService(id);
      if (success) {
        items.removeWhere((r) => r.id == id);
        items.refresh();
      }

    } catch (e) {
      print("❌ Error deleting review: $e");

    }
  }
  //--------------------------SERVICE CATEGORY-------------

  Future<void> getCategoryService()
  async {
    final data= await ContractorMyService.contractorMyService.getContractorCategory();
    contractorServiceCategory.value=ContractorServiceCategoryResponse.fromMap(data);
  }

  // ---------------- CREATE SERVICE ----------------
  Future<void> createService() async {
    try {
      isCreating.value = true;

      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      final contractorServiceItem = ContractorServiceItem(
        category: selectedCategory.value, // just the name
        contractorId: userId,
        serviceName: serviceNameController.text.trim(),
        description: descriptionController.text.trim(),

        isActive: true,

        meta: ContractorMetaData(
          price: double.tryParse(priceController.text.trim()) ?? 0.0,
          priceModel: selectedPriceModel.value.toLowerCase(),
          startingPriceRange: startingRangeController.text.trim(),
          workAvailability: selectedAvailability.value.toLowerCase().split(" ").join("_"),
          provideMaterials: provideMaterials.value,
          brandsUsed: brandController.text.trim(),

          equipmentProvided: equipmentProvided.value,
          insuranceAvailable: insuranceAvailable.value,
          acceptedPaymentModes: acceptedPaymentModes.map((element) => element.toLowerCase().split(" ").join("_"),).toList(), // List<String>
          advanceRequiredPercentage: int.tryParse(advanceController.text.trim()) ?? 0,
          billingType: selectedBillingType.value.toLowerCase().split(" ").join("_"),
        ),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

// Convert to payload map for API
      final payload = contractorServiceItem.toMap();


      print("Create service payload: $payload");

      final response=await ContractorMyService.contractorMyService.createService(payload);
      print("Create Service Response: $response");

     if(response)
       {
         Get.back(); // Close form
         Get.snackbar("Success", "Service created successfully!");
         refreshList();
       }
     else{
       Get.snackbar("Error", "Failed to create service");
     }
    } catch (e) {
      print("Error creating service: $e");
      Get.snackbar("Error", "Failed to create service");
    } finally {
      isCreating.value = false;
    }
  }

  // ---------------- FORM VALIDATION ----------------
  bool validateForm() {
    if (serviceNameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return false;
    }
    return true;
  }

  // ---------------- CLEANUP ----------------
  @override
  void onClose() {
    serviceNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    startingRangeController.dispose();
    brandController.dispose();
    advanceController.dispose();
    super.onClose();
  }
}
