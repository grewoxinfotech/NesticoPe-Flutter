import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/contractor/service/contractor_my_service.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../widgets/messages/snack_bar.dart';
import 'contractor_dashboard_controller.dart';

class ContractorMyServiceController
    extends PaginatedController<ContractorServiceItem> {
  // ---------------- FORM VARIABLES ----------------

  Rxn<ContractorServiceCategoryResponse> contractorServiceCategory =
      Rxn<ContractorServiceCategoryResponse>();
  ContractorDashboardController contractorDashboardController =
      ContractorDashboardController();

  // Text Fields
  final serviceNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController(text: "0");
  final minRangeController = TextEditingController();
  final maxRangeController = TextEditingController();
  final visitChargeController = TextEditingController();
  final brandController = TextEditingController();
  final advanceController = TextEditingController(text: "0");

  // Dropdowns
  final selectedCategory = "Renovation & Remodeling".obs;
  final selectedCategoryName = "Renovation & Remodeling".obs;
  final selectedPriceModel = "Fixed".obs;
  final selectedAvailability = "Immediate".obs;
  final selectedBillingType = "GST".obs;

  ///Home Construction field
  // Cement
  final cementOptions =
      <String>['UltraTech', 'Ambuja', 'ACC', 'Birla', 'Shree', 'JSW'].obs;
  final selectedCement = <String>[].obs;

  // Steel
  final steelOptions =
      <String>['TATA Tiscon', 'JSW', 'SAIL', 'Vizag', 'Jindal Panther'].obs;
  final selectedSteel = <String>[].obs;

  // Bricks
  final brickOptions =
      <String>['Red Bricks', 'Fly Ash Bricks', 'AAC Blocks', 'CLC Blocks'].obs;
  final selectedBrick = <String>[].obs;

  // Sand
  final sandOptions = <String>['River Sand', 'M-Sand', 'P-Sand'].obs;
  final selectedSand = <String>[].obs;

  // Water Tank
  final tankOptions = <String>['Plasto', 'Sintex', 'Vectus', 'Supreme'].obs;
  final selectedTank = <String>[].obs;

  // Wires
  final wireOptions =
      <String>['Havells', 'Polycab', 'Finolex', 'KEI', 'RR Kabel'].obs;
  final selectedWire = <String>[].obs;

  // Switches
  final switchOptions =
      <String>['Legrand', 'Schneider', 'Anchor', 'Havells', 'Crabtree'].obs;
  final selectedSwitch = <String>[].obs;

  // Pipes
  final pipeOptions =
      <String>['Astral', 'Supreme', 'Ashirvad', 'Prince', 'Finolex'].obs;
  final selectedPipe = <String>[].obs;

  // Sanitary
  final sanitaryOptions =
      <String>['Jaquar', 'Cera', 'Hindware', 'Parryware', 'Kohler', 'Toto'].obs;
  final selectedSanitary = <String>[].obs;

  // Tiles
  final tileOptions =
      <String>[
        'Kajaria',
        'Simpolo',
        'Nitco',
        'Somany',
        'Orientbell',
        'Johnson',
      ].obs;
  final selectedTile = <String>[].obs;

  // Interior Paint
  final interiorPaintOptions =
      <String>[
        'Asian Royale',
        'Dulux Velvet',
        'Berger Silk',
        'Nerolac Impressions',
      ].obs;
  final selectedInteriorPaint = <String>[].obs;

  // Exterior Paint
  final exteriorPaintOptions =
      <String>[
        'Asian Apex Ultima',
        'Dulux Weathershield',
        'Berger Weathercoat',
      ].obs;
  final selectedExteriorPaint = <String>[].obs;

  // Ceiling
  final ceilingOptions = <String>['POP', 'Gypsum', 'PVC', 'Wooden'].obs;
  final selectedCeiling = <String>[].obs;

  // Fabrication
  final fabricationOptions =
      <String>[
        'MS Safety Grills',
        'Gates',
        'Main Door Grill',
        'Window Grills',
        'Fencing',
      ].obs;
  final selectedFabrication = <String>[].obs;

  // Doors
  final doorOptions =
      <String>[
        'Teak Wood',
        'Flush Door',
        'Plywood',
        'PVC',
        'WPC',
        'Aluminium',
      ].obs;
  final selectedDoor = <String>[].obs;

  // Windows
  final windowOptions =
      <String>['Aluminium Sliding', 'UPVC', 'Wooden', 'Steel'].obs;
  final selectedWindow = <String>[].obs;

  // Structure
  final structureOptions =
      <String>['RCC Frame', 'Load Bearing', 'Steel Frame', 'Prefabricated'].obs;
  final selectedStructure = <String>[].obs;

  // Plaster
  final plasterOptions =
      <String>[
        'Internal Plaster',
        'External Plaster',
        'Gypsum Plaster',
        'Lime Plaster',
      ].obs;
  final selectedPlaster = <String>[].obs;

  // Waterproofing
  final waterproofingOptions =
      <String>['Terrace', 'Toilet/Bathroom', 'Basement', 'External Walls'].obs;
  final selectedWaterproofing = <String>[].obs;

  // Chokhat
  final chokhatOptions = <String>['Wooden', 'Granite', 'Cement', 'Steel'].obs;
  final selectedChokhat = <String>[].obs;

  // Railing
  final railingOptions =
      <String>[
        'SS Railing',
        'MS Railing',
        'Glass Railing',
        'Wooden Railing',
      ].obs;
  final selectedRailing = <String>[].obs;
  final RxBool showAllMaterials = false.obs;

  final selected3D = ''.obs;
  final selectedModularKitchen = ''.obs;
  final selectedBoreAndPump = ''.obs;
  final selectedSecuritySystems = ''.obs;
  final selectedHomeAutomation = ''.obs;
  final selectedSolarSolutions = ''.obs;

  //================================================================================
  // Toggles
  final provideMaterials = false.obs;
  final equipmentProvided = false.obs;
  final insuranceAvailable = false.obs;
  final categoryNames = <String, String>{}.obs;

  // Chips (multi-select)
  final acceptedPaymentModes = <String>[].obs;
  final allPaymentModes = ["UPI", "Bank Transfer", "Cash", "Cheque"];

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

      final response = await ContractorMyService.contractorMyService
          .fetchContractorService(page: page, filters: filters, id: userId);
      for (final item in response.items) {
        final id = item.category ?? "";
        if (id.isNotEmpty && !categoryNames.containsKey(id)) {
          getTheContractorByID(id); // async call (no await needed)
        }
      }
      print("Fetched items: ${response.items.length}");
      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  List<String>? _listOrNull(List<String> list) {
    return list.isEmpty ? null : list;
  }

  String? _stringOrNull(String value) {
    return value.trim().isEmpty ? null : value.toUpperCase();
  }

  Future<void> refreshService() async {
    try {
      isRefreshing.value = true;
      refreshList();
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

  Future<String> getTheContractorByID(String id) async {
    if (categoryNames.containsKey(id)) return categoryNames[id]!;
    final data = await ContractorMyService.contractorMyService
        .getContractorByIDCategory(fields: id);
    categoryNames[id] = data.name;
    return data.name;
  }

  // ---------------- TOGGLE ACTIVE STATUS ----------------
  void toggle(ContractorServiceItem item, bool value) async {
    try {
      final index = items.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        items[index].isActive = value;
        items.refresh();
      }

      await ContractorMyService.contractorMyService.changeActiveToInActive(
        item.id ?? '',
        value,
      );
      await contractorDashboardController.getContractorDashboard(
        leadsYear: contractorDashboardController.selectedGraphYear.value,
      );

      print(
        "Service sdkfjfijdifjdifoj${item.serviceName} status changed to: $value",
      );
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
      final success = await ContractorMyService.contractorMyService
          .deletedService(id);
      if (success) {
        items.removeWhere((r) => r.id == id);
        items.refresh();
      }
    } catch (e) {
      print("❌ Error deleting review: $e");
    }
  }

  //--------------------------SERVICE CATEGORY-------------

  Future<void> getCategoryService() async {
    final data =
        await ContractorMyService.contractorMyService.getContractorCategory();
    contractorServiceCategory.value = ContractorServiceCategoryResponse.fromMap(
      data,
    );
  }

  // ---------------- CREATE SERVICE ----------------
  Future<void> createService() async {
    try {
      isCreating.value = true;

      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      /*  final contractorServiceItem = ContractorServiceItem(
        category: selectedCategory.value,
        // just the name
        contractorId: userId,
        serviceName: serviceNameController.text.trim(),
        description: descriptionController.text.trim(),

        isActive: true,

        meta: ContractorMetaData(
          priceModel: selectedPriceModel.value.toLowerCase(),
          minPriceRange: int.tryParse(minRangeController.text.trim()) ?? 0,
          maxPriceRange: int.tryParse(maxRangeController.text.trim()) ?? 0,
          visitCharge: int.tryParse(visitChargeController.text.trim()) ?? 0,
          workAvailability: selectedAvailability.value
              .toLowerCase()
              .split(" ")
              .join("_"),
          provideMaterials: provideMaterials.value,
          brandsUsed: brandController.text.trim(),

          equipmentProvided: equipmentProvided.value,
          insuranceAvailable: insuranceAvailable.value,
          acceptedPaymentModes:
              acceptedPaymentModes
                  .map((element) => element.toLowerCase().split(" ").join("_"))
                  .toList(),
          // List<String>
          advanceRequiredPercentage:
              int.tryParse(advanceController.text.trim()) ?? 0,
          billingType: selectedBillingType.value
              .toLowerCase()
              .split(" ")
              .join("_"),
        ),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );*/
      final contractorServiceItem = ContractorServiceItem(
        category: selectedCategory.value,
        contractorId: userId,
        serviceName: serviceNameController.text.trim(),
        description: descriptionController.text.trim(),
        isActive: true,

        meta: ContractorMetaData(
          priceModel: selectedPriceModel.value.toLowerCase().replaceAll(" ", "_"),
          minPriceRange: int.tryParse(minRangeController.text.trim()) ?? 0,
          maxPriceRange: int.tryParse(maxRangeController.text.trim()) ?? 0,
          visitCharge: int.tryParse(visitChargeController.text.trim()) ?? 0,
          workAvailability: selectedAvailability.value
              .toLowerCase()
              .split(" ")
              .join("_"),
          provideMaterials: provideMaterials.value,
          brandsUsed: brandController.text.trim(),
          equipmentProvided: equipmentProvided.value,
          insuranceAvailable: insuranceAvailable.value,
          acceptedPaymentModes:
              acceptedPaymentModes
                  .map((e) => e.toLowerCase().split(" ").join("_"))
                  .toList(),
          advanceRequiredPercentage:
              int.tryParse(advanceController.text.trim()) ?? 0,
          billingType: selectedBillingType.value
              .toLowerCase()
              .split(" ")
              .join("_"),

          // 🔹 MATERIAL LISTS
          cementBrand: _listOrNull(selectedCement),
          steelBrand: _listOrNull(selectedSteel),
          brickType: _listOrNull(selectedBrick),
          sandSource: _listOrNull(selectedSand),
          electricalWiresBrand: _listOrNull(selectedWire),
          electricalSwitchesBrand: _listOrNull(selectedSwitch),
          plumbingPipesBrand: _listOrNull(selectedPipe),
          sanitaryFittingsBrand: _listOrNull(selectedSanitary),
          waterTankBrand: _listOrNull(selectedTank),
          flooringTilesBrand: _listOrNull(selectedTile),
          interiorPaintBrand: _listOrNull(selectedInteriorPaint),
          exteriorPaintBrand: _listOrNull(selectedExteriorPaint),
          doorsType: _listOrNull(selectedDoor),
          windowsType: _listOrNull(selectedWindow),
          structure: _listOrNull(selectedStructure),
          plasterType: _listOrNull(selectedPlaster),
          waterproofing: _listOrNull(selectedWaterproofing),
          chokhatType: _listOrNull(selectedChokhat),
          railingType: _listOrNull(selectedRailing),
          falseCeiling: _listOrNull(selectedCeiling),
          fabricationWork: _listOrNull(selectedFabrication),

          // 🔹 YES / NO SERVICES
          threeDDesign: _stringOrNull(selected3D.value),
          modularKitchen: _stringOrNull(selectedModularKitchen.value),
          boreAndPump: _stringOrNull(selectedBoreAndPump.value),
          securitySystems: _stringOrNull(selectedSecuritySystems.value),
          homeAutomation: _stringOrNull(selectedHomeAutomation.value),
          solarSolutions: _stringOrNull(selectedSolarSolutions.value),
        ),

        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Convert to payload map for API
      final payload = contractorServiceItem.toMap();

      AppLogger.structured("Create service payload: ", payload);

      final response = await ContractorMyService.contractorMyService
          .createService(payload);
      print("Create Service Response: $response");

      if (response) {
        Get.back(); // Close form
        // NesticoPeSnackBar.showAwesomeSnackbar(
        //   title: 'Success',
        //   message: 'Service created successfully!',
        //   contentType: ContentType.success,
        // );
        refreshList();
      } else {
        // NesticoPeSnackBar.showAwesomeSnackbar(
        //   title: 'Error',
        //   message: 'Failed to create service',
        //   contentType: ContentType.failure,
        // );
      }
    } catch (e) {
      print("Error creating service: $e");

      // NesticoPeSnackBar.showAwesomeSnackbar(
      //   title: 'Error',
      //   message: 'Failed to create service',
      //   contentType: ContentType.failure,
      // );
    } finally {
      isCreating.value = false;
    }
  }

  // ---------------- FORM VALIDATION ----------------
  bool validateForm() {
    if (serviceNameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Please fill all required fields",
        contentType: ContentType.failure,
      );
      return false;
    }
    return true;
  }

  //---------------------------------------Up
  // ---------------- UPDATE SERVICE ----------------
  // Add this observable to track which service is being edited
  Rxn<ContractorServiceItem> editingService = Rxn<ContractorServiceItem>();

  // Method to populate form with existing service data
/*  void populateFormForEdit(ContractorServiceItem service) {
    editingService.value = service;

    serviceNameController.text = service.serviceName ?? '';
    descriptionController.text = service.description ?? '';

    minRangeController.text = service.meta?.minPriceRange.toString() ?? '';
    maxRangeController.text = service.meta?.maxPriceRange.toString() ?? '';
    visitChargeController.text = service.meta?.visitCharge.toString() ?? '';
    brandController.text = service.meta?.brandsUsed ?? '';
    advanceController.text =
        service.meta?.advanceRequiredPercentage?.toString() ?? '0';

    selectedCategory.value = service.category ?? "Renovation & Remodeling";
    selectedPriceModel.value = _formatPriceModel(
      service.meta?.priceModel ?? 'fixed',
    );
    selectedAvailability.value = _formatAvailability(
      service.meta?.workAvailability ?? 'immediate',
    );
    selectedBillingType.value = _formatBillingType(
      service.meta?.billingType ?? 'gst',
    );

    provideMaterials.value = service.meta?.provideMaterials ?? false;
    equipmentProvided.value = service.meta?.equipmentProvided ?? false;
    insuranceAvailable.value = service.meta?.insuranceAvailable ?? false;

    acceptedPaymentModes.value =
        service.meta?.acceptedPaymentModes
            ?.map((e) => _formatPaymentMode(e))
            .toList() ??
        [];
  }*/
  void populateFormForEdit(ContractorServiceItem service) {



    AppLogger.structured("PopulatedForm ", service.toMap());

    editingService.value = service;

    // 🔹 Basic fields
    serviceNameController.text = service.serviceName ?? '';
    descriptionController.text = service.description ?? '';

    minRangeController.text =
        service.meta?.minPriceRange?.toString() ?? '';
    maxRangeController.text =
        service.meta?.maxPriceRange?.toString() ?? '';
    visitChargeController.text =
        service.meta?.visitCharge?.toString() ?? '';
    brandController.text = service.meta?.brandsUsed ?? '';
    advanceController.text =
        service.meta?.advanceRequiredPercentage?.toString() ?? '0';

    // 🔹 Dropdowns
    selectedCategory.value =
        service.category ?? "Renovation & Remodeling";

    final category =
    contractorServiceCategory.value?.data.items
        .firstWhere(
          (e) => e.id == service.category,
    );

    selectedCategoryName.value = category?.name ?? '';

    selectedPriceModel.value =
        _formatPriceModel(service.meta?.priceModel ?? 'fixed');

    selectedAvailability.value =
        _formatAvailability(service.meta?.workAvailability ?? 'immediate');

    selectedBillingType.value =
        _formatBillingType(service.meta?.billingType ?? 'gst');

    // 🔹 Booleans
    provideMaterials.value =
        service.meta?.provideMaterials ?? false;

    equipmentProvided.value =
        service.meta?.equipmentProvided ?? false;

    insuranceAvailable.value =
        service.meta?.insuranceAvailable ?? false;

    // 🔹 Payment modes
    acceptedPaymentModes.value =
        service.meta?.acceptedPaymentModes
            ?.map(_formatPaymentMode)
            .toList() ??
            [];

    // ============================
    // 🔥 MATERIAL MULTI-SELECTS
    // ============================

    _populateMultiSelect(
      selectedList: selectedCement,
      options: cementOptions,
      apiValues: service.meta?.cementBrand,
    );

    _populateMultiSelect(
      selectedList: selectedSteel,
      options: steelOptions,
      apiValues: service.meta?.steelBrand,
    );

    _populateMultiSelect(
      selectedList: selectedBrick,
      options: brickOptions,
      apiValues: service.meta?.brickType,
    );

    _populateMultiSelect(
      selectedList: selectedSand,
      options: sandOptions,
      apiValues: service.meta?.sandSource,
    );

    _populateMultiSelect(
      selectedList: selectedTank,
      options: tankOptions,
      apiValues: service.meta?.waterTankBrand,
    );

    _populateMultiSelect(
      selectedList: selectedWire,
      options: wireOptions,
      apiValues: service.meta?.electricalWiresBrand,
    );

    _populateMultiSelect(
      selectedList: selectedSwitch,
      options: switchOptions,
      apiValues: service.meta?.electricalSwitchesBrand,
    );

    _populateMultiSelect(
      selectedList: selectedPipe,
      options: pipeOptions,
      apiValues: service.meta?.plumbingPipesBrand,
    );

    _populateMultiSelect(
      selectedList: selectedSanitary,
      options: sanitaryOptions,
      apiValues: service.meta?.sanitaryFittingsBrand,
    );

    _populateMultiSelect(
      selectedList: selectedTile,
      options: tileOptions,
      apiValues: service.meta?.flooringTilesBrand,
    );

    _populateMultiSelect(
      selectedList: selectedInteriorPaint,
      options: interiorPaintOptions,
      apiValues: service.meta?.interiorPaintBrand,
    );

    _populateMultiSelect(
      selectedList: selectedExteriorPaint,
      options: exteriorPaintOptions,
      apiValues: service.meta?.exteriorPaintBrand,
    );

    _populateMultiSelect(
      selectedList: selectedDoor,
      options: doorOptions,
      apiValues: service.meta?.doorsType,
    );

    _populateMultiSelect(
      selectedList: selectedWindow,
      options: windowOptions,
      apiValues: service.meta?.windowsType,
    );

    _populateMultiSelect(
      selectedList: selectedStructure,
      options: structureOptions,
      apiValues: service.meta?.structure,
    );

    _populateMultiSelect(
      selectedList: selectedPlaster,
      options: plasterOptions,
      apiValues: service.meta?.plasterType,
    );

    _populateMultiSelect(
      selectedList: selectedWaterproofing,
      options: waterproofingOptions,
      apiValues: service.meta?.waterproofing,
    );

    _populateMultiSelect(
      selectedList: selectedChokhat,
      options: chokhatOptions,
      apiValues: service.meta?.chokhatType,
    );

    _populateMultiSelect(
      selectedList: selectedRailing,
      options: railingOptions,
      apiValues: service.meta?.railingType,
    );

    _populateMultiSelect(
      selectedList: selectedCeiling,
      options: ceilingOptions,
      apiValues: service.meta?.falseCeiling,
    );

    _populateMultiSelect(
      selectedList: selectedFabrication,
      options: fabricationOptions,
      apiValues: service.meta?.fabricationWork,
    );

    // 🔹 Yes / No fields
    selected3D.value = service.meta?.threeDDesign?.capitalize ?? '';
    showAllMaterials.value=(service.meta.threeDDesign?.isEmpty??false)?false:true;
    selectedModularKitchen.value =
        service.meta?.modularKitchen?.capitalize ?? '';
    selectedBoreAndPump.value =
        service.meta?.boreAndPump?.capitalize ?? '';
    selectedSecuritySystems.value =
        service.meta?.securitySystems?.capitalize ?? '';
    selectedHomeAutomation.value =
        service.meta?.homeAutomation?.capitalize ?? '';
    selectedSolarSolutions.value =
        service.meta?.solarSolutions?.capitalize ?? '';
  }

  void _populateMultiSelect({
    required RxList<String> selectedList,
    required RxList<String> options,
    required List<String>? apiValues,
  }) {
    selectedList.clear();

    if (apiValues == null || apiValues.isEmpty) return;

    for (final value in apiValues) {
      // Add to options if it was custom
      if (!options.contains(value)) {
        options.add(value);
      }
      selectedList.add(value);
    }
  }

  // Helper methods to format values from API back to UI format
  String _formatPriceModel(String value) {
    switch (value.toLowerCase()) {
      case 'fixed':
        return 'Fixed';
      case 'hourly':
        return 'Hourly';
      case 'per_sq_ft':
        return 'Per Sq Ft';
      case 'custom':
        return 'Custom';
      default:
        return 'Fixed';
    }
  }

  String _formatAvailability(String value) {
    switch (value.toLowerCase()) {
      case 'immediate':
        return 'Immediate';
      case 'in_3_days':
        return 'In 3 Days';
      case 'in_1_week':
        return 'In 1 Week';
      case 'custom':
        return 'Custom';
      default:
        return 'Immediate';
    }
  }

  String _formatBillingType(String value) {
    switch (value.toLowerCase()) {
      case 'gst':
        return 'GST';
      case 'non_gst':
        return 'Non GST';
      default:
        return 'GST';
    }
  }

  String _formatPaymentMode(String value) {
    switch (value.toLowerCase()) {
      case 'upi':
        return 'UPI';
      case 'bank_transfer':
        return 'Bank Transfer';
      case 'cash':
        return 'Cash';
      case 'cheque':
        return 'Cheque';
      default:
        return value;
    }
  }
  void _clearMultiSelect(RxList<String> list) {
    list.clear();
  }

  // Method to clear form
/*  void clearForm() {
    editingService.value = null;
    serviceNameController.clear();
    descriptionController.clear();
    priceController.text = '0';
    minRangeController.clear();
    maxRangeController.clear();
    visitChargeController.clear();
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
  }*/
  void clearForm() {
    // 🔹 Edit state
    editingService.value = null;

    // 🔹 Text fields
    serviceNameController.clear();
    descriptionController.clear();
    priceController.text = '0';
    minRangeController.clear();
    maxRangeController.clear();
    visitChargeController.clear();
    brandController.clear();
    advanceController.text = '0';

    // 🔹 Single dropdowns
    selectedCategory.value = "Renovation & Remodeling";
    selectedPriceModel.value = "Fixed";
    selectedAvailability.value = "Immediate";
    selectedBillingType.value = "GST";

    // 🔹 Toggles
    provideMaterials.value = false;
    equipmentProvided.value = false;
    insuranceAvailable.value = false;

    // 🔹 Payment modes
    acceptedPaymentModes.clear();

    // ============================
    // 🔥 CLEAR MATERIAL MULTI-SELECTS
    // ============================

    _clearMultiSelect(selectedCement);
    _clearMultiSelect(selectedSteel);
    _clearMultiSelect(selectedBrick);
    _clearMultiSelect(selectedSand);
    _clearMultiSelect(selectedTank);
    _clearMultiSelect(selectedWire);
    _clearMultiSelect(selectedSwitch);
    _clearMultiSelect(selectedPipe);
    _clearMultiSelect(selectedSanitary);
    _clearMultiSelect(selectedTile);
    _clearMultiSelect(selectedInteriorPaint);
    _clearMultiSelect(selectedExteriorPaint);
    _clearMultiSelect(selectedDoor);
    _clearMultiSelect(selectedWindow);
    _clearMultiSelect(selectedStructure);
    _clearMultiSelect(selectedPlaster);
    _clearMultiSelect(selectedWaterproofing);
    _clearMultiSelect(selectedChokhat);
    _clearMultiSelect(selectedRailing);
    _clearMultiSelect(selectedCeiling);
    _clearMultiSelect(selectedFabrication);

    // ============================
    // 🔹 YES / NO FIELDS
    // ============================

    selected3D.value = '';
    selectedModularKitchen.value = '';
    selectedBoreAndPump.value = '';
    selectedSecuritySystems.value = '';
    selectedHomeAutomation.value = '';
    selectedSolarSolutions.value = '';

    // 🔹 UI helpers
    showAllMaterials.value = false;
  }


  // Update service method
  Future<void> updateService() async {
    try {
      isCreating.value = true;

      if (editingService.value == null) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: "No service selected for update",
          contentType: ContentType.failure,
        );
        return;
      }

      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      final updatedServiceItem = ContractorServiceItem(
        id: editingService.value!.id,
        // Keep the existing ID
        category: selectedCategory.value,
        contractorId: userId,
        serviceName: serviceNameController.text.trim(),
        description: descriptionController.text.trim(),
        isActive: editingService.value!.isActive,
        // Preserve active status
        meta: ContractorMetaData(
          priceModel: selectedPriceModel.value.toLowerCase().replaceAll(" ", "_"),
          minPriceRange: int.tryParse(minRangeController.text.trim()) ?? 0,
          maxPriceRange: int.tryParse(maxRangeController.text.trim()) ?? 0,
          visitCharge: int.tryParse(visitChargeController.text.trim()) ?? 0,
          workAvailability: selectedAvailability.value
              .toLowerCase()
              .split(" ")
              .join("_"),
          provideMaterials: provideMaterials.value,
          brandsUsed: brandController.text.trim(),
          equipmentProvided: equipmentProvided.value,
          insuranceAvailable: insuranceAvailable.value,
          acceptedPaymentModes:
              acceptedPaymentModes
                  .map((element) => element.toLowerCase().split(" ").join("_"))
                  .toList(),
          advanceRequiredPercentage:
              int.tryParse(advanceController.text.trim()) ?? 0,
          billingType: selectedBillingType.value
              .toLowerCase()
              .split(" ")
              .join("_"),
          // 🔹 MATERIAL LISTS
          cementBrand: _listOrNull(selectedCement),
          steelBrand: _listOrNull(selectedSteel),
          brickType: _listOrNull(selectedBrick),
          sandSource: _listOrNull(selectedSand),
          electricalWiresBrand: _listOrNull(selectedWire),
          electricalSwitchesBrand: _listOrNull(selectedSwitch),
          plumbingPipesBrand: _listOrNull(selectedPipe),
          sanitaryFittingsBrand: _listOrNull(selectedSanitary),
          waterTankBrand: _listOrNull(selectedTank),
          flooringTilesBrand: _listOrNull(selectedTile),
          interiorPaintBrand: _listOrNull(selectedInteriorPaint),
          exteriorPaintBrand: _listOrNull(selectedExteriorPaint),
          doorsType: _listOrNull(selectedDoor),
          windowsType: _listOrNull(selectedWindow),
          structure: _listOrNull(selectedStructure),
          plasterType: _listOrNull(selectedPlaster),
          waterproofing: _listOrNull(selectedWaterproofing),
          chokhatType: _listOrNull(selectedChokhat),
          railingType: _listOrNull(selectedRailing),
          falseCeiling: _listOrNull(selectedCeiling),
          fabricationWork: _listOrNull(selectedFabrication),

          // 🔹 YES / NO SERVICES
          threeDDesign: _stringOrNull(selected3D.value),
          modularKitchen: _stringOrNull(selectedModularKitchen.value),
          boreAndPump: _stringOrNull(selectedBoreAndPump.value),
          securitySystems: _stringOrNull(selectedSecuritySystems.value),
          homeAutomation: _stringOrNull(selectedHomeAutomation.value),
          solarSolutions: _stringOrNull(selectedSolarSolutions.value),
        ),
        createdAt: editingService.value!.createdAt,
        // Preserve creation date
        updatedAt: DateTime.now().toIso8601String(),
      );

      final payload = updatedServiceItem.toMap();

      AppLogger.structured("Update service payload: ", payload);


      final response = await ContractorMyService.contractorMyService
          .updateContractorService(payload, editingService.value!.id ?? '');

      print("Update Service Response: $response");

      if (response) {
        Get.back(); // Close form
        // NesticoPeSnackBar.showAwesomeSnackbar(
        //   title: "Success",
        //   message: "Service updated successfully!",
        //   contentType: ContentType.success,
        // );
        clearForm();
        refreshList();
      } else {
        // NesticoPeSnackBar.showAwesomeSnackbar(
        //   title: "Error",
        //   message: "Failed to update service",
        //   contentType: ContentType.failure,
        // );
      }
    } catch (e) {
      print("Error updating service: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Failed to update service",
        contentType: ContentType.failure,
      );
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
    visitChargeController.dispose();
    brandController.dispose();
    advanceController.dispose();
    super.onClose();
  }
}
