

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/contractor/service/contractor_my_service.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';

class ContractorMyServiceController extends PaginatedController<ContractorServiceItem> {
  // ---------------- FORM VARIABLES ----------------

  Rxn<ContractorServiceCategoryResponse> contractorServiceCategory=Rxn<ContractorServiceCategoryResponse>();
  // Text Fields
  final serviceNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController(text: "0");
  final minRangeController = TextEditingController();
  final maxRangeController = TextEditingController();
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
  Future<void> refreshService() async {
    try {
      isRefreshing.value = true;
      refreshList();
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
  Future<String> getTheContractorByID(String id)
   async {
   final data= await ContractorMyService.contractorMyService.getContractorByIDCategory(
      fields: id
    );
   log("data for service category ${data.toMap()}");
   return data.name;

   // print("Category Data ${data}");
   //  final item = contractorServiceCategory.value?.data.items
   //      .firstWhere((e) => e.id == id,);
   //
   //  String name = item?.name ?? "";
   //
   //  return name;


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

          priceModel: selectedPriceModel.value.toLowerCase(),
          minPriceRange: int.tryParse(minRangeController.text.trim())??0,
          maxPriceRange: int.tryParse(maxRangeController.text.trim())??0,
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
  //---------------------------------------Up
  // ---------------- UPDATE SERVICE ----------------
// Add this observable to track which service is being edited
  Rxn<ContractorServiceItem> editingService = Rxn<ContractorServiceItem>();

// Method to populate form with existing service data
  void populateFormForEdit(ContractorServiceItem service) {
    editingService.value = service;

    serviceNameController.text = service.serviceName ?? '';
    descriptionController.text = service.description ?? '';

    minRangeController.text = service.meta?.minPriceRange.toString()??'';
    maxRangeController.text = service.meta?.maxPriceRange.toString()??'';
    brandController.text = service.meta?.brandsUsed ?? '';
    advanceController.text = service.meta?.advanceRequiredPercentage?.toString() ?? '0';

    selectedCategory.value = service.category ?? "Renovation & Remodeling";
    selectedPriceModel.value = _formatPriceModel(service.meta?.priceModel ?? 'fixed');
    selectedAvailability.value = _formatAvailability(service.meta?.workAvailability ?? 'immediate');
    selectedBillingType.value = _formatBillingType(service.meta?.billingType ?? 'gst');

    provideMaterials.value = service.meta?.provideMaterials ?? false;
    equipmentProvided.value = service.meta?.equipmentProvided ?? false;
    insuranceAvailable.value = service.meta?.insuranceAvailable ?? false;

    acceptedPaymentModes.value = service.meta?.acceptedPaymentModes
        ?.map((e) => _formatPaymentMode(e))
        .toList() ?? [];
  }

// Helper methods to format values from API back to UI format
  String _formatPriceModel(String value) {
    switch (value.toLowerCase()) {
      case 'fixed': return 'Fixed';
      case 'hourly': return 'Hourly';
      case 'per_sq_ft': return 'Per Sq Ft';
      case 'custom': return 'Custom';
      default: return 'Fixed';
    }
  }

  String _formatAvailability(String value) {
    switch (value.toLowerCase()) {
      case 'immediate': return 'Immediate';
      case 'in_3_days': return 'In 3 Days';
      case 'in_1_week': return 'In 1 Week';
      case 'custom': return 'Custom';
      default: return 'Immediate';
    }
  }

  String _formatBillingType(String value) {
    switch (value.toLowerCase()) {
      case 'gst': return 'GST';
      case 'non_gst': return 'Non GST';
      default: return 'GST';
    }
  }

  String _formatPaymentMode(String value) {
    switch (value.toLowerCase()) {
      case 'upi': return 'UPI';
      case 'bank_transfer': return 'Bank Transfer';
      case 'cash': return 'Cash';
      case 'cheque': return 'Cheque';
      default: return value;
    }
  }

// Method to clear form
  void clearForm() {
    editingService.value = null;
    serviceNameController.clear();
    descriptionController.clear();
    priceController.text = '0';
    minRangeController.clear();
    maxRangeController.clear();
    brandController.clear();
    advanceController.text = '0';

    selectedCategory.value = "Renovation & Remodeling";
    selectedPriceModel.value = "Fixed";
    selectedAvailability.value = "Immediate";
    selectedBillingType.value = "GST";

    provideMaterials.value = false;
    equipmentProvided.value = false;
    insuranceAvailable.value = false;

    acceptedPaymentModes.clear();
  }

// Update service method
  Future<void> updateService() async {
    try {
      isCreating.value = true;

      if (editingService.value == null) {
        Get.snackbar("Error", "No service selected for update");
        return;
      }

      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      final updatedServiceItem = ContractorServiceItem(
        id: editingService.value!.id, // Keep the existing ID
        category: selectedCategory.value,
        contractorId: userId,
        serviceName: serviceNameController.text.trim(),
        description: descriptionController.text.trim(),
        isActive: editingService.value!.isActive, // Preserve active status
        meta: ContractorMetaData(
          priceModel: selectedPriceModel.value.toLowerCase(),
          minPriceRange: int.tryParse(minRangeController.text.trim())??0,
          maxPriceRange: int.tryParse(maxRangeController.text.trim())??0,
          workAvailability: selectedAvailability.value.toLowerCase().split(" ").join("_"),
          provideMaterials: provideMaterials.value,
          brandsUsed: brandController.text.trim(),
          equipmentProvided: equipmentProvided.value,
          insuranceAvailable: insuranceAvailable.value,
          acceptedPaymentModes: acceptedPaymentModes
              .map((element) => element.toLowerCase().split(" ").join("_"))
              .toList(),
          advanceRequiredPercentage: int.tryParse(advanceController.text.trim()) ?? 0,
          billingType: selectedBillingType.value.toLowerCase().split(" ").join("_"),
        ),
        createdAt: editingService.value!.createdAt, // Preserve creation date
        updatedAt: DateTime.now().toIso8601String(),
      );

      final payload = updatedServiceItem.toMap();

      print("Update service payload: $payload");

      final response = await ContractorMyService.contractorMyService.updateContractorService(

        payload,
        editingService.value!.id ?? '',
      );

      print("Update Service Response: $response");

      if (response) {
        Get.back(); // Close form
        Get.snackbar("Success", "Service updated successfully!");
        clearForm();
        refreshList();
      } else {
        Get.snackbar("Error", "Failed to update service");
      }
    } catch (e) {
      print("Error updating service: $e");
      Get.snackbar("Error", "Failed to update service");
    } finally {
      isCreating.value = false;
    }
  }

  // ---------------- CLEANUP ----------------
  @override
  void onClose() {
    serviceNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    maxRangeController.dispose();
    minRangeController.dispose();
    brandController.dispose();
    advanceController.dispose();
    super.onClose();
  }
}
