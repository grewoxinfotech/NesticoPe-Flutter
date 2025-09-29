import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/data/network/property/services/property_service.dart';

import '../../../app/care/pagination/models/pagination_models.dart';

class PropertyController extends PaginatedController<Items> {
  final PropertyService _service = PropertyService();

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController listingTypeController = TextEditingController();
  final TextEditingController propertyTypeController = TextEditingController();
  final TextEditingController propertyDescriptionController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController builderNameController = TextEditingController();
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController ownerPhoneController = TextEditingController();
  final TextEditingController ownerEmailController = TextEditingController();
  final TextEditingController reraIdController = TextEditingController();
  final TextEditingController propertyFacingController =
      TextEditingController();
  final TextEditingController propertyConditionController =
      TextEditingController();
  final TextEditingController propertyCarpetAreaController =
      TextEditingController();
  final TextEditingController propertyBuiltUpAreaController =
      TextEditingController();

  // Reactive fields
  Rxn<PropertyMedia> propertyMedia = Rxn<PropertyMedia>();
  Rxn<PropertyDetails> propertyDetails = Rxn<PropertyDetails>();
  Rxn<Location> location = Rxn<Location>();
  RxList<NearbyLocations> nearbyLocations = <NearbyLocations>[].obs;
  RxString approvalStatus = "pending".obs;
  RxString assignmentStatus = "available".obs;
  RxBool isVerified = false.obs;
  RxBool isExpanded = false.obs;
  RxBool isDeveloper = false.obs;
  var allowContact = true.obs;
  var interestedInHomeLoan = false.obs;

  // Optional filters
  Map<String, String>? filters;

  @override
  void onInit() {
    super.onInit();
    loadInitial(); // Load first page automatically
  }

  /// --- Required override from PaginatedController ---
  // @override
  // Future<List<Items>> fetchItems(int page) async {
  //   try {
  //     final response = await _service.fetchProperties(
  //       page: page,
  //      // pageSize: 10,
  //      //  filters: filters,
  //     );
  //     print("Fetched items: ${response.length}");
  //     return response; // Returns List<Items>
  //   } catch (e) {
  //     print("Exception in fetchItems: $e");
  //     return [];
  //   }
  // }

  @override
  Future<PaginationResponse<Items>> fetchItems(int page) async {
    try {
      final response = await _service.fetchProperties(page: page);

      print("Fetched items: ${response.items.length}");
      return response; // ✅ full response with items + meta
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  /// --- Reset form ---
  void resetForm() {
    titleController.clear();
    typeController.clear();
    listingTypeController.clear();
    propertyTypeController.clear();
    propertyDescriptionController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    zipCodeController.clear();
    builderNameController.clear();
    projectNameController.clear();
    ownerNameController.clear();
    ownerPhoneController.clear();
    ownerEmailController.clear();
    reraIdController.clear();
    propertyFacingController.clear();
    propertyConditionController.clear();
    propertyCarpetAreaController.clear();
    propertyBuiltUpAreaController.clear();

    propertyMedia.value = null;
    propertyDetails.value = null;
    location.value = null;
    nearbyLocations.clear();
    approvalStatus.value = "pending";
    assignmentStatus.value = "available";
    isVerified.value = false;
  }

  /// Get single property by ID
  // Future<Items?> getPropertyById(String id) async {
  //   try {
  //     final existing = items.firstWhereOrNull((item) => item.id == id);
  //     if (existing != null) return existing;
  //
  //     final property = await _service.getPropertyById(id);
  //     if (property != null) {
  //       items.add(property);
  //       items.refresh();
  //       return property;
  //     }
  //   } catch (e) {
  //     print("Get property error: $e");
  //   }
  //   return null;
  // }

  /// Create a new property
  // Future<bool> createProperty(Items property) async {
  //   try {
  //     final success = await _service.createProperty(property);
  //     if (success) await loadInitial();
  //     return success;
  //   } catch (e) {
  //     print("Create property error: $e");
  //     return false;
  //   }
  // }

  /// Update property
  Future<bool> updateProperty(String id, Items updatedProperty) async {
    try {
      final success = await _service.updateProperty(id, updatedProperty);
      if (success) {
        int index = items.indexWhere((item) => item.id == id);
        if (index != -1) {
          items[index] = updatedProperty;
          items.refresh();
        }
      }
      return success;
    } catch (e) {
      print("Update property error: $e");
      return false;
    }
  }

  /// Delete property
  Future<bool> deleteProperty(String id) async {
    try {
      final success = await _service.deleteProperty(id);
      if (success) items.removeWhere((item) => item.id == id);
      return success;
    } catch (e) {
      print("Delete property error: $e");
      return false;
    }
  }

  /// Apply filters and refresh
  Future<void> applyFilters(Map<String, String> newFilters) async {
    filters = newFilters;
    await refreshList();
  }

  void lessOrReadMore() {
    isExpanded.value = !isExpanded.value;
    update();
  }

  void checkTheSellerType() {
    isDeveloper.value = !isDeveloper.value;
    update();
  }
}
