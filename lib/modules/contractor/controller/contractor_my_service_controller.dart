import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/contractor/service/contractor_my_service.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
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
  final selectedServiceNameDropdown = ''.obs;

  // ── Works / Items multi-select ──
  final selectedWorkItems = <String>[].obs;
  final workItemOptions = <String>[].obs;

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
  // Solar Panel
  final solarPanelOptions =
      <String>[
        'Tata Power',
        'Adani Solar',
        'Waaree',
        'Vikram Solar',
        'Loom Solar',
      ].obs;
  final selectedSolarPanel = <String>[].obs;

  // Solar Inverter
  final solarInverterOptions =
      <String>['Luminous', 'Microtek', 'Havells', 'V-Guard', 'Growatt'].obs;
  final selectedSolarInverter = <String>[].obs;

  // Security
  final securityOptions =
      <String>['CP Plus', 'Hikvision', 'Godrej', 'Dahua', 'Honeywell'].obs;
  final selectedSecurity = <String>[].obs;

  // Smart Home
  final smartHomeOptions =
      <String>['Philips Hue', 'Wipro', 'Oakter', 'Sonoff', 'Schneider'].obs;
  final selectedSmartHome = <String>[].obs;

  // Machine
  final machineOptions =
      <String>[
        'JCB',
        'CAT',
        'Tata Hitachi',
        'Mahindra',
        'Komatsu',
        'Volvo',
      ].obs;
  final selectedMachine = <String>[].obs;

  // Cladding
  final claddingOptions =
      <String>['Aludecor', 'Eurobond', 'Viva', 'Alstone'].obs;
  final selectedCladding = <String>[].obs;
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

  // Image Picking
  final selectedImagePaths = <String>[].obs;
  final existingImageUrls = <String>[].obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    try {
      final int totalCount =
          selectedImagePaths.length + existingImageUrls.length;
      if (totalCount >= 5) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Limit Exceeded",
          message: "You can only pick up to 5 images",
          contentType: ContentType.warning,
        );
        return;
      }

      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        final int remainingSlots = 5 - totalCount;
        final List<XFile> imagesToAdd =
            images.take(remainingSlots).toList();

        for (var image in imagesToAdd) {
          selectedImagePaths.add(image.path);
        }

        if (images.length > remainingSlots) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Limit Exceeded",
            message: "Only first $remainingSlots images were added",
            contentType: ContentType.warning,
          );
        }
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  void removeSelectedImage(int index) {
    selectedImagePaths.removeAt(index);
  }

  void removeExistingImage(int index) {
    existingImageUrls.removeAt(index);
  }

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

      final workItemsStr = selectedWorkItems
          .join(', ')
          .toLowerCase()
          .replaceAll(" ", "_");

      /*   final contractorServiceItem = ContractorServiceItem(
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
      );*/
      final contractorServiceItem = ContractorServiceItem(
        category: selectedCategory.value,
        contractorId: userId,
        serviceName: serviceNameController.text
            .trim()
            .toLowerCase()
            .replaceAll('/', ' ')
            .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
            .trim()
            .replaceAll(RegExp(r'\s+'), '_'),
        // Description: agar Home Construction nahi hai toh workItems append karo
        description: descriptionController.text.trim(),

        isActive: true,
        meta: ContractorMetaData(
          priceModel: selectedPriceModel.value.toLowerCase().replaceAll(
            " ",
            "_",
          ),
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
          // Material lists (Home Construction ke liye)
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
          solarPanelBrands: _listOrNull(selectedSolarPanel),
          solarInverterBrands: _listOrNull(selectedSolarInverter),
          securityBrands: _listOrNull(selectedSecurity),
          smartHomeBrands: _listOrNull(selectedSmartHome),
          machineBrands: _listOrNull(selectedMachine),
          claddingBrands: _listOrNull(selectedCladding),
          falseCeiling: _listOrNull(selectedCeiling),
          fabricationWork: _listOrNull(selectedFabrication),
          // Yes / No
          threeDDesign: _stringOrNull(selected3D.value),
          modularKitchen: _stringOrNull(selectedModularKitchen.value),
          boreAndPump: _stringOrNull(selectedBoreAndPump.value),
          securitySystems: _stringOrNull(selectedSecuritySystems.value),
          homeAutomation: _stringOrNull(selectedHomeAutomation.value),
          solarSolutions: _stringOrNull(selectedSolarSolutions.value),
          // ── Work Items (non-HomeConstruction) ──
          // works field
          works:
              workItemOptions
                      .isEmpty // ✅ Packers & Movers or any category with no items
                  ? null
                  : _listOrNull(
                    selectedWorkItems
                        .map(
                          (label) => label
                              .toLowerCase()
                              .replaceAll('/', ' ')
                              .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
                              .trim()
                              .replaceAll(RegExp(r'\s+'), '_'),
                        )
                        .toList(),
                  ),
        ),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Convert to payload map for API
      final payload = contractorServiceItem.toMap();

      AppLogger.structured("Create service payload: ", payload);

      final response = await ContractorMyService.contractorMyService
          .createService(payload, imagePaths: selectedImagePaths);
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
    selectedServiceNameDropdown.value = service.serviceName;

    log(
      "Check any ${selectedServiceNameDropdown.value}===== ${service.serviceName}",
    );
    // Basic fields
    descriptionController.text = service.description ?? '';
    minRangeController.text = service.meta?.minPriceRange?.toString() ?? '';
    maxRangeController.text = service.meta?.maxPriceRange?.toString() ?? '';
    visitChargeController.text = service.meta?.visitCharge?.toString() ?? '';
    brandController.text = service.meta?.brandsUsed ?? '';
    advanceController.text =
        service.meta?.advanceRequiredPercentage?.toString() ?? '0';

    // Category
    selectedCategory.value = service.category ?? '';
    final category = contractorServiceCategory.value?.data.items.firstWhere(
      (e) => e.id == service.category,
    );
    selectedCategoryName.value = category?.name ?? '';

    // Dropdowns
    selectedPriceModel.value = _formatPriceModel(
      service.meta?.priceModel ?? 'fixed',
    );
    selectedAvailability.value = _formatAvailability(
      service.meta?.workAvailability ?? 'immediate',
    );
    selectedBillingType.value = _formatBillingType(
      service.meta?.billingType ?? 'gst',
    );

    // Booleans
    provideMaterials.value = service.meta?.provideMaterials ?? false;
    equipmentProvided.value = service.meta?.equipmentProvided ?? false;
    insuranceAvailable.value = service.meta?.insuranceAvailable ?? false;

    // Payment modes
    acceptedPaymentModes.value =
        service.meta?.acceptedPaymentModes?.map(_formatPaymentMode).toList() ??
        [];

    // ── Home Construction check ──────────────────────────────
    // ── Home Construction check ──────────────────────────────

    /* serviceNameController.text = service.serviceName ?? '';

      // ✅ FIX: Find the value key from label stored in API
      final catId = selectedCategoryName.value.replaceAll(" ", "_").toLowerCase() ?? '';
      final services = getServiceNamesForCategory(catId);
      final match = services.firstWhere(
            (s) => s['label'] == service.serviceName,
        orElse: () => {'label': service.serviceName ?? '', 'value': service.serviceName ?? ''},
      );
      selectedServiceNameDropdown.value = match['value'] as String;

      // Work items restore
      workItemOptions.assignAll(
        getWorkItemsForServiceName(catId, match['value'] as String),
      );

      // In populateFormForEdit — restore works by matching labels
      final savedItems = service.meta?.works;
      if (savedItems != null && savedItems.isNotEmpty) {
        // ✅ works from API are stored as labels (since onServiceNameSelected
        // stores labels in selectedWorkItems)
        selectedWorkItems.assignAll(
          savedItems.where((item) => workItemOptions.contains(item)).toList(),
        );
      } else {
        selectedWorkItems.clear();
      }*/
    serviceNameController.text = service.serviceName ?? '';

    // ✅ Use selectedCategory.value (already set above) as category key
    final catId = selectedCategoryName.value
        .trim()
        .toLowerCase()
        .replaceAll('/', ' ')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    final services = getServiceNamesForCategory(catId);

    final match = services.firstWhere(
      (s) => s['value'] == service.serviceName,
      orElse:
          () => {
            'label': service.serviceName ?? '',
            'value': service.serviceName ?? '',
          },
    );

    log(
      "Check service name section ${service.serviceName}   ${selectedServiceNameDropdown.value}",
    );

    selectedServiceNameDropdown.value = match['value'] as String;

    // Image handling
    existingImageUrls.assignAll(service.serviceImage ?? []);
    selectedImagePaths.clear();

    // Load workItemOptions using category ID + service value
    workItemOptions.assignAll(
      getWorkItemsForServiceName(catId, match['value'] as String),
    );
    log(
      "Check service name section dsfdsf ${workItemOptions}   ${selectedServiceNameDropdown.value}",
    );

    // ✅ FIX: API saves work VALUES, but workItemOptions contains LABELS
    // We need to find the label for each saved value
    // In populateFormForEdit, after workItemOptions is populated:
    final savedItems =
        service.meta?.works; // these are snake_case values from API
    if (savedItems != null && savedItems.isNotEmpty) {
      selectedWorkItems.assignAll(
        savedItems
            .map((apiValue) {
              // Convert snake_case value back to label by finding matching workItemOption
              return workItemOptions.firstWhere(
                (label) =>
                    label
                        .toLowerCase()
                        .replaceAll('/', ' ') // treat / as word separator
                        .replaceAll(
                          RegExp(r'[^a-z0-9\s]'),
                          '',
                        ) // strip remaining special chars
                        .trim()
                        .replaceAll(RegExp(r'\s+'), '_') ==
                    apiValue,
                orElse: () => apiValue,
              );
            })
            .where((item) => workItemOptions.contains(item))
            .toList(),
      );
    } else {
      selectedWorkItems.clear();
    }

    // Material Multi-selects (Home Construction)
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
      selectedList: selectedSolarPanel,
      options: solarPanelOptions,
      apiValues: service.meta?.solarPanelBrands,
    );
    _populateMultiSelect(
      selectedList: selectedSolarInverter,
      options: solarInverterOptions,
      apiValues: service.meta?.solarInverterBrands,
    );
    _populateMultiSelect(
      selectedList: selectedSecurity,
      options: securityOptions,
      apiValues: service.meta?.securityBrands,
    );
    _populateMultiSelect(
      selectedList: selectedSmartHome,
      options: smartHomeOptions,
      apiValues: service.meta?.smartHomeBrands,
    );
    _populateMultiSelect(
      selectedList: selectedMachine,
      options: machineOptions,
      apiValues: service.meta?.machineBrands,
    );
    _populateMultiSelect(
      selectedList: selectedCladding,
      options: claddingOptions,
      apiValues: service.meta?.claddingBrands,
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

    // Yes / No fields
    selected3D.value = service.meta?.threeDDesign?.capitalize ?? '';
    showAllMaterials.value =
        (service.meta?.threeDDesign?.isEmpty ?? true) ? false : true;
    selectedModularKitchen.value =
        service.meta?.modularKitchen?.capitalize ?? '';
    selectedBoreAndPump.value = service.meta?.boreAndPump?.capitalize ?? '';
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

  void _clearMultiSelect(RxList<String> list) => list.clear();

  /// Description aur workItems ko merge karna (agar API mein alag field na ho)
  String _mergeDescriptionAndItems(String desc, String items) {
    if (items.isEmpty) return desc;
    if (desc.isEmpty) return items;
    return '$desc';
  }

  bool isHomeConstruction(String categoryId) =>
      categoryId.toLowerCase().replaceAll(" ", "_") ==
      kHomeConstructionCategoryId.toLowerCase();
  /*  Map<String, List<Map<String, dynamic>>> kServiceCategoryData = {
    // ── Home Services ──────────────────────────────────────────
    'home_services': [
      {
        'label': 'Rooftop Solar Panel Solutions',
        'value': 'rooftop_solar_panel_solutions',
        'items': [
          'Solar Panel Installation (1kW - 10kW+)',
          'On-Grid Solar System',
          'Off-Grid Solar System',
          'Hybrid Solar System',
          'Solar Water Heater',
          'Solar Inverter & Battery',
          'Solar Panel Cleaning & Maintenance',
        ],
      },
      {
        'label': 'Home Security Solutions',
        'value': 'home_security_solutions',
        'items': [
          'CCTV Camera Installation',
          'Video Door Phone',
          'Biometric & Digital Door Lock',
          'Intruder Alarm System',
          'Fire & Smoke Alarm System',
          'Access Control System',
          'Security Fencing',
        ],
      },
      {
        'label': 'Smart Home Solutions',
        'value': 'smart_home_solutions',
        'items': [
          'Home Automation System',
          'Smart Lighting Control',
          'Smart Curtains & Blinds',
          'Voice Control (Alexa/Google Home)',
          'Smart Switches & Plugs',
          'Smart Sensors (Motion, Door, Gas)',
        ],
      },
      {
        'label': 'Structure Planning and Design',
        'value': 'structure_planning_and_design',
        'items': [
          'Architectural 2D/3D Design',
          'Structural Drawing & Engineering',
          '3D Elevation Design',
          'Interior Layout Planning',
          'Vastu Consultation',
          'Government Approval Drawings',
          'Landscaping Design',
        ],
      },
      {
        'label': 'Renovation and Remodeling',
        'value': 'renovation_and_remodeling',
        'items': [
          'Kitchen Renovation',
          'Bathroom Renovation',
          'Living Room Renovation',
          'Full House Renovation',
          'Tiling Work Fixing',
          'Build Extra Rooms',
          'Balcony Renovation',
          'Fabrication Work',
        ],
      },
      {
        'label': 'Maintenance & AMC Services',
        'value': 'maintenance_amc_services',
        'items': [
          'AC Repair',
          'Geyser Repair',
          'Washing Machine Repair',
          'Water Purifier Repair',
          'Refrigerator Repair',
          'Microwave Repair',
        ],
      },
      {
        'label': 'Home Painting',
        'value': 'home_painting',
        'items': ['Interior Painting', 'Exterior Painting', 'Waterproofing'],
      },
      {
        'label': 'Home Cleaning',
        'value': 'home_cleaning',
        'items': [
          'Full House Cleaning',
          'Kitchen Cleaning',
          'Bathroom Cleaning',
          'Sintex/Water Tank Cleaning',
        ],
      },
      {
        'label': 'Electrician',
        'value': 'electrician',
        'items': [
          'Fan',
          'Switch & Socket',
          'TV',
          'Light',
          'Inverter & Stabilizer',
          'AC Repair',
          'Geyser Repair',
          'Washing Machine Repair',
          'Water Purifier Repair',
          'Refrigerator Repair',
          'Microwave Repair',
          'Wiring',
          'MCB & Fuse',
          'Door Bell',
        ],
      },
      {
        'label': 'Plumber',
        'value': 'plumber',
        'items': [
          'Toilet Repair',
          'Tap & Mixer Repair',
          'Basin & Sink Repair',
          'Drainage Pipe',
          'Water Pipe Connection',
          'Bathroom & Shower',
          'Water Tank',
          'Grouting',
        ],
      },
      {
        'label': 'Carpenter',
        "value": "carpenter",

        'items': [
          'Door',
          'Drill & Hang',
          'Cupboard & Drawer',
          'Window & Curtain',
          'Bed',
          'Furniture Repair',
          'Furniture Assembly',
          'TV',
          'Balcony',
        ],
      },
      {
        'label': 'Buy / Rent Furniture',
        "value": "buy_rent_furniture",
        'items': [
          'Sofa Set',
          'Recliner & Rocker',
          'Sofa Bed & Day Bed',
          'Center Table',
          'TV Unit',
          'Shoe Rack',
          'Balcony Set',
          'Chairs & Stools',
          'Office Chair',
          'Bed (King/Queen/Single)',
          'Mattress',
          'Wardrobe & Almirah',
          'Bedside Table',
          'Chest of Drawers',
          'Dresser & Mirror',
          'Bookshelf & Display Unit',
          'Storage Cabinet',
          'Dining Table Set',
          'Coffee Table',
          'Study Table',
          'Study Table with Chair',
          'Computer Table',
        ],
      },
      {
        'label': 'Buy / Rent Appliances',
        "value": "buy_rent_appliances",
        'items': [
          'Split / Window AC',
          'Air Cooler',
          'Ceiling & Table Fan',
          'Air Purifier',
          'Refrigerator (Single/Double Door)',
          'Washing Machine (Front/Top Load)',
          'Microwave & Oven',
          'Dishwasher',
          'Water Purifier (RO/UV)',
          'Kitchen Chimney',
          'Mixer & Grinder',
          'Smart TV / LED TV',
          'Home Theater System',
          'Gaming Console (Playstation/Xbox)',
        ],
      },
    ],

    // ── Interior Design ────────────────────────────────────────
    'interior_design': [
      {
        'label': 'Residential Room Design',
        "value": "residential_room_design",
        'items': [
          'Living Room Design',
          'Master Bedroom Design',
          'Kids Room Design',
          'Dining Room Design',
          'Bathroom Design',
          'Balcony Design',
          'Pooja Mandir Design',
          'Home Office Design',
          'Foyer Design',
          'Room Design',
        ],
      },
      {
        'label': 'Kitchen Design',
        "value": "kitchen_design",
        'items': [
          'Modular Kitchen Design',
          'Kitchen Design',
          'Kitchen Tiles Design',
          'Kitchen False Ceiling Design',
          'Kitchen Wall Design',
          'Countertops Design',
          'Crockery Unit Design',
        ],
      },
      {
        'label': 'Commercial & Retail',
        'value': 'commercial_retail',
        'items': [
          'Office Workspaces Interior',
          'Retail Store Interior',
          'Restaurant Interior',
        ],
      },
      {
        'label': 'Structural & Elements',
        "value": "structural_elements",
        'items': [
          'Staircase Design',
          'Railing Design',
          'Partition Design',
          'False Ceiling Design',
          'Flooring Design',
          'Wall Panel Design',
          'Wall Designs Ideas',
          'Wall Paint Design',
          'Wall Color Combination Design',
          'Wallpaper Design',
          'Tiles Design',
          'Window Design',
          'Door Design',
        ],
      },
      {
        'label': 'Furniture Design',
        "value": "furniture_design",
        'items': [
          'Wardrobe Design',
          'TV Unit Design',
          'Bed Headboard Design',
          'Shoerack Design',
          'Table Design',
        ],
      },
    ],

    // ── Legal Services ─────────────────────────────────────────
    'legal_services': [
      {
        'label': 'Property Documentation & Drafting',
        "value": "property_documentation_drafting",
        'items': [
          'Property Sale Deed Drafting',
          'Sale Agreement Review & Analysis',
          'Memorandum of Understanding (MOU) Drafting',
          'Power of Attorney (POA) Registration',
          'Will Registration & Probate Services',
          'Gift Deed Drafting & Registration',
          'Letter of Administration Services',
          'Legal Affidavits & Declarations',
        ],
      },
      {
        'label': 'Registration & Agreements',
        "value": "registration_agreements",
        'items': [
          'Property Registration Assistance',
          'Commercial Lease Agreement Registration',
          'Residential Rent Agreement Services',
          'Leave & License Agreement Drafting',
        ],
      },
      {
        'label': 'Verification & Due Diligence',
        "value": "verification_due_diligence",
        'items': [
          'Property Title Search & Verification',
          'Property Litigation & Case Search',
          'Complete Property Due Diligence & Verification',
          'Legal Title Opinion Report',
          'Public Notice & No-Objection Certificate (NOC)',
          'Legal Court Record Verification',
          'Encumbrance Certificate Assistance',
          'Property Valuation Report',
        ],
      },
      {
        'label': 'Legal Consultation & Advisory',
        "value": "legal_consultation_advisory",
        'items': [
          'Property Document Review & Consultation',
          'Expert Real Estate Legal Consultation (Call)',
          'RERA Complaint Filing & Advisory',
          'Legal Notice & Dispute Resolution',
          'Tenant Verification Services',
          'Home Loan Legal Opinion',
          'Khata Transfer / Property Mutation',
        ],
      },
    ],

    // ── Material Supply ────────────────────────────────────────
    'material_supply': [
      {
        'label': 'Civil / Structural Material',
        "value": "civil_structural_material",
        'items': [
          'Cement (UltraTech / ACC / Ambuja)',
          'TMT Steel Bars (8mm, 10mm, 12mm, 16mm, 20mm)',
          'Binding Wire',
          'Sand (River Sand / M-Sand)',
          'Crush Sand',
          'Aggregates (20mm, 10mm, 40mm)',
          'Bricks (Red / Fly Ash)',
          'Concrete Blocks (AAC Block)',
          'RMC (Ready Mix Concrete)',
          'PCC Material',
          'Waterproofing Compound',
          'Shutterining',
        ],
      },
      {
        'label': 'Masonry & Plaster Material',
        "value": "masonry_plaster_material",
        'items': [
          'Plaster Sand',
          'Wall Putty',
          'POP (Plaster of Paris)',
          'Gypsum',
          'Tile Adhesive',
          'Construction Chemical',
          'Expansion Joint Material',
        ],
      },
      {
        'label': 'Flooring & Tiles',
        "value": "flooring_tiles",
        'items': [
          'Floor Tiles',
          'Wall Tiles',
          'Bathroom Tiles',
          'Kitchen Tiles',
          'Marble',
          'Granite',
          'Kota Stone',
          'Skirting Tiles',
          'Tile Spacer',
        ],
      },
      {
        'label': 'Plumbing Material',
        "value": "plumbing_material",
        'items': [
          'PVC Pipe',
          'CPVC Pipe',
          'UPVC Pipe',
          'SWR Pipe',
          'Water Tank (Sintex type)',
          'Bathroom Fittings (Tap, Shower, Diverter)',
          'Basin',
          'Western/Indian Toilet Seat',
          'Floor Trap',
          'Ball Valve',
          'Angle Valve',
          'Pipe Fittings (Elbow, Tee, Socket)',
          'Septic Tank Material',
        ],
      },
      {
        'label': 'Electrical Material',
        "value": "electrical_material",
        'items': [
          'Electrical Wire',
          'Switch Board',
          'Switch & Socket',
          'MCB',
          'Distribution Board',
          'Concealed Box',
          'PVC Conduit Pipe',
          'Fan Box',
          'LED Lights',
          'Ceiling Fan',
          'Exhaust Fan',
          'Door Bell',
          'Earthing Material',
          'AC',
          'Fan',
        ],
      },
      {
        'label': 'Doors & Windows',
        "value": "doors_windows",
        'items': [
          'Main Door (Teak Wood / Flush Door)',
          'Internal Doors',
          'Door Frames',
          'Window Frames (Aluminium / UPVC)',
          'Glass',
          'Door Handle',
          'Hinges',
          'Lock Set',
          'Door Closer',
        ],
      },
      {
        'label': 'Paint & Finishing',
        "value": "paint_finishing",
        'items': [
          'Primer (Wall / Metal / Wood)',
          'Putty',
          'Interior Paint',
          'Exterior Paint',
          'Waterproof Paint',
          'Texture Paint',
          'Enamel Paint',
          'Thinner',
          'Roller & Brush',
        ],
      },
      {
        'label': 'Waterproofing & Terrace',
        "value": "waterproofing_terrace",
        'items': [
          'Dr Fixit Chemical',
          'Membrane Sheet',
          'Bitumen',
          'Terrace Tile',
          'Heat Proof Coating',
        ],
      },
      {
        'label': 'Carpentry & Interior',
        "value": "carpentry_interior",
        'items': [
          'Plywood',
          'Block Board',
          'Laminate',
          'Veneer',
          'Modular Kitchen Material',
          'Wardrobe Material',
          'False Ceiling Material',
          'Aluminium Channel',
        ],
      },
    ],

    // ── Packers & Movers ───────────────────────────────────────
    'packers_movers': [
      {
        'label': 'Packers & Movers Services',
        'value': 'packers_&_movers_services',
        'items': [
          'Within City',
          'Between city',
          'Moving Only',
          'Vehicle Shifting (Bike/Car)',
          'City Tempo Service',
          'Rent Vehicle (Truck)',
        ],
      },
    ],
  };*/
  Map<String, List<Map<String, dynamic>>> kServiceCategoryData = {
    // ── Home Services ──────────────────────────────────────────
    'home_services': [
      {
        'label': 'Maintenance & AMC Services',
        'value': 'maintenance_amc_services',
        'bestSelling': false,
        "trending": true,
        'items': [
          'AC Repair',
          'Geyser Repair',
          'Washing Machine Repair',
          'Water Purifier Repair',
          'Refrigerator Repair',
          'Microwave Repair',
        ],
      },
      {
        'label': 'Home Painting',
        'value': 'home_painting',
        'bestSelling': true,
        "trending": false,
        'items': ['Interior Painting', 'Exterior Painting', 'Waterproofing'],
      },
      {
        'label': 'Home Cleaning',
        'value': 'home_cleaning',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Full House Cleaning',
          'Kitchen Cleaning',
          'Bathroom Cleaning',
          'Sintex/Water Tank Cleaning',
        ],
      },
      {
        'label': 'Electrician',
        'value': 'electrician',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Fan',
          'Switch & Socket',
          'TV',
          'Light',
          'Inverter & Stabilizer',
          'AC Repair',
          'Geyser Repair',
          'Washing Machine Repair',
          'Water Purifier Repair',
          'Refrigerator Repair',
          'Microwave Repair',
          'Wiring',
          'MCB & Fuse',
          'Door Bell',
        ],
      },
      {
        'label': 'Plumber',
        'value': 'plumber',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Toilet Repair',
          'Tap & Mixer Repair',
          'Basin & Sink Repair',
          'Drainage Pipe',
          'Water Pipe Connection',
          'Bathroom & Shower',
          'Water Tank',
          'Grouting',
        ],
      },
      {
        "label": "Pest Control",
        'bestSelling': false,
        "trending": false,
        "value": "pest_control",
        'items': [
          'Home Pest Control',
          'Sanitization & Disinfection (Anti-Viral)',
          'Garden Pest Control',
          'Anti Termite Treatment (For Pre & Post Construction)',
          'Commercial & Industrial Pest Control (Hotels & Restaurants, Hospitals, Warehouses, Factories)',
        ],
      },
      {
        'label': 'Carpenter',
        'value': 'carpenter',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Door',
          'Drill & Hang',
          'Cupboard & Drawer',
          'Window & Curtain',
          'Bed',
          'Furniture Repair',
          'Furniture Assembly',
          'TV',
          'Balcony',
        ],
      },
      {
        'label': 'Buy / Rent Furniture',
        'value': 'buy_rent_furniture',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Sofa Set',
          'Recliner & Rocker',
          'Sofa Bed & Day Bed',
          'Center Table',
          'TV Unit',
          'Shoe Rack',
          'Balcony Set',
          'Chairs & Stools',
          'Office Chair',
          'Bed (King/Queen/Single)',
          'Mattress',
          'Wardrobe & Almirah',
          'Bedside Table',
          'Chest of Drawers',
          'Dresser & Mirror',
          'Bookshelf & Display Unit',
          'Storage Cabinet',
          'Dining Table Set',
          'Coffee Table',
          'Study Table',
          'Study Table with Chair',
          'Computer Table',
        ],
      },
      {
        'label': 'Buy / Rent Appliances',
        'value': 'buy_rent_appliances',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Split / Window AC',
          'Air Cooler',
          'Ceiling & Table Fan',
          'Air Purifier',
          'Refrigerator (Single/Double Door)',
          'Washing Machine (Front/Top Load)',
          'Microwave & Oven',
          'Dishwasher',
          'Water Purifier (RO/UV)',
          'Kitchen Chimney',
          'Mixer & Grinder',
          'Smart TV / LED TV',
          'Home Theater System',
          'Gaming Console (Playstation/Xbox)',
        ],
      },
    ],

    // ── Home Construction ──────────────────────────────────────
    'home_construction': [
      {
        'label': 'Rooftop Solar Panel Solutions',
        'value': 'rooftop_solar_panel_solutions',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Solar Panel Installation (1kW - 10kW+)',
          'On-Grid Solar System',
          'Off-Grid Solar System',
          'Hybrid Solar System',
          'Solar Water Heater',
          'Solar Inverter & Battery',
          'Solar Panel Cleaning & Maintenance',
        ],
      },
      {
        'label': 'Home Security Solutions',
        'bestSelling': false,
        "trending": false,
        'value': 'home_security_solutions',
        'items': [
          'CCTV Camera Installation',
          'Video Door Phone',
          'Biometric & Digital Door Lock',
          'Intruder Alarm System',
          'Fire & Smoke Alarm System',
          'Access Control System',
          'Security Fencing',
        ],
      },
      {
        'label': 'Smart Home Solutions',
        'bestSelling': false,
        "trending": false,
        'value': 'smart_home_solutions',
        'items': [
          'Home Automation System',
          'Smart Lighting Control',
          'Smart Curtains & Blinds',
          'Voice Control (Alexa/Google Home)',
          'Smart Switches & Plugs',
          'Smart Sensors (Motion, Door, Gas)',
        ],
      },
      {
        'label': 'Structure Planning and Design',
        'value': 'structure_planning_and_design',
        'bestSelling': false,
        "trending": true,
        'items': [
          '2D & 3D Floor Plan, Section, Elevation Architectural Drawing',
          'Structural Engineering Drawing',
          'Vastu Consultation',
          'Government Approval Drawings',
          'Landscaping Design',
        ],
      },
      {
        'label': 'Renovation and Remodeling',
        'value': 'renovation_and_remodeling',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Kitchen Renovation',
          'Bathroom Renovation',
          'Living Room Renovation',
          'Full House Renovation',
          'Tiling Work Fixing',
          'Build Extra Rooms',
          'Balcony Renovation',
          'Fabrication Work',
        ],
      },
      {
        'label':
            'End to End New Home Construction Contractors (Turnkey Home Construction)',
        'value': 'end_to_end_new_home_construction_contractors',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Budget Home Construction',
          'Luxury / Premium Home Construction',
          'Villa Construction',
          'Duplex/Triplex Construction',
          'Farmhouse Construction',
          'Green Home Construction (Eco-friendly Homes)',
          'Basement Home Construction',
        ],
      },
      {
        'label': 'Commercial Construction Contractors',
        'value': 'commercial_construction_contractors',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Office Construction',
          'Shop Construction',
          'Warehouse Construction',
          'Apartment Building Construction',
          'Commercial Complex Construction',
        ],
      },
      {
        'label': 'Exterior Cladding & Facade Contractors',
        'value': 'exterior_cladding_facade_contractors',
        'bestSelling': false,
        "trending": false,
        'items': [
          'ACP Cladding Installation Contractors',
          'Glass Facade Contractors',
          'Industrial PUF Panel Installation Contractors',
          'Industrial Shed Cladding Contractors',
          'Premium Exterior Panel (WPC/HPL) Installation Contractors',
          'Stone & Cement board Cladding Contractors',
        ],
      },
      {
        'label': 'Specialized Service',
        'bestSelling': false,
        "trending": false,
        'value': 'specialized_service',
        'items': [
          'Waterproofing Solution',
          'Roofing (RCC Roof, Metal Roof) and Slab Casting',
          'Bore and Pump Solution',
          'Rain Water Harvesting Setup',
          'Soil Testing, Structural Audits and Surveying',
          'Flooring & Tiling',
          'Glass & Aluminium Work',
          'Boundary Wall & Compound Wall',
          'Fabrication Work',
        ],
      },
      {
        'label': 'Construction Site Machine Rent (YantraRent)',
        'value': 'construction_site_machine_rent_yantrarent',
        'bestSelling': false,
        "trending": false,
        'items': [
          'JCB',
          'Poclain',
          'Dumper/Tipper',
          'AJAX',
          'Bobcat',
          'Roller/Baby roller',
          'Breaker Machine',
          'TM (Transit Mixer)',
          'Tractor Trolley',
        ],
      },
    ],

    // ── Interior Design ────────────────────────────────────────
    'interior_design': [
      {
        'label': 'Residential Room Design',
        'value': 'residential_room_design',
        'bestSelling': true,
        "trending": false,
        'items': [
          'Living Room Design',
          'Master Bedroom Design',
          'Kids Room Design',
          'Dining Room Design',
          'Bathroom Design',
          'Balcony Design',
          'Pooja Mandir Design',
          'Home Office Design',
          'Foyer Design',
          'Room Design',
        ],
      },
      {
        'label': 'Kitchen Design',
        'value': 'kitchen_design',
        'bestSelling': false,
        "trending": true,
        'items': [
          'Modular Kitchen Design',
          'Kitchen Design',
          'Kitchen Tiles Design',
          'Kitchen False Ceiling Design',
          'Kitchen Wall Design',
          'Countertops Design',
          'Crockery Unit Design',
        ],
      },
      {
        'label': 'Commercial & Retail',
        'bestSelling': false,
        "trending": false,
        'value': 'commercial_retail',
        'items': [
          'Office Workspaces Interior',
          'Retail Store Interior',
          'Restaurant Interior',
        ],
      },
      {
        'label': 'Structural & Elements',
        'value': 'structural_elements',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Staircase Design',
          'Railing Design',
          'Partition Design',
          'False Ceiling Design',
          'Flooring Design',
          'Wall Panel Design',
          'Wall Designs Ideas',
          'Wall Paint Design',
          'Wall Color Combination Design',
          'Wallpaper Design',
          'Tiles Design',
          'Window Design',
          'Door Design',
        ],
      },
      {
        'label': 'Furniture Design',
        'value': 'furniture_design',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Wardrobe Design',
          'TV Unit Design',
          'Bed Headboard Design',
          'Shoerack Design',
          'Table Design',
        ],
      },
    ],

    // ── Legal Services ─────────────────────────────────────────
    'legal_services': [
      {
        'label': 'Property Documentation & Drafting',
        'value': 'property_documentation_drafting',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Property Sale Deed Drafting',
          'Sale Agreement Review & Analysis',
          'Memorandum of Understanding (MOU) Drafting',
          'Power of Attorney (POA) Registration',
          'Will Registration & Probate Services',
          'Gift Deed Drafting & Registration',
          'Letter of Administration Services',
          'Legal Affidavits & Declarations',
        ],
      },
      {
        'label': 'Registration & Agreements',
        'value': 'registration_agreements',
        'bestSelling': true,
        "trending": false,
        'items': [
          'Property Registration Assistance',
          'Commercial Lease Agreement Registration',
          'Residential Rent Agreement Services',
          'Leave & License Agreement Drafting',
        ],
      },
      {
        'label': 'Verification & Due Diligence',
        'value': 'verification_due_diligence',
        'bestSelling': false,
        "trending": true,
        'items': [
          'Property Title Search & Verification',
          'Property Litigation & Case Search',
          'Complete Property Due Diligence & Verification',
          'Legal Title Opinion Report',
          'Public Notice & No-Objection Certificate (NOC)',
          'Legal Court Record Verification',
          'Encumbrance Certificate Assistance',
          'Property Valuation Report',
        ],
      },
      {
        'label': 'Legal Consultation & Advisory',
        'value': 'legal_consultation_advisory',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Property Document Review & Consultation',
          'Expert Real Estate Legal Consultation (Call)',
          'RERA Complaint Filing & Advisory',
          'Legal Notice & Dispute Resolution',
          'Tenant Verification Services',
          'Home Loan Legal Opinion',
          'Khata Transfer / Property Mutation',
        ],
      },
    ],

    // ── Material Supply ────────────────────────────────────────
    'building_material_supply': [
      {
        'label': 'Civil / Structural Material',
        'value': 'civil_structural_material',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Cement (UltraTech / ACC / Ambuja)',
          'TMT Steel Bars (8mm, 10mm, 12mm, 16mm, 20mm)',
          'Binding Wire',
          'Sand (River Sand / M-Sand)',
          'Crush Sand',
          'Aggregates (20mm, 10mm, 40mm)',
          'Bricks (Red / Fly Ash)',
          'Concrete Blocks (AAC Block)',
          'RMC (Ready Mix Concrete)',
          'PCC Material',
          'Waterproofing Compound',
          'Shutterining',
        ],
      },
      {
        'label': 'Masonry & Plaster Material',
        'bestSelling': false,
        "trending": false,
        'value': 'masonry_plaster_material',
        'items': [
          'Plaster Sand',
          'Wall Putty',
          'POP (Plaster of Paris)',
          'Gypsum',
          'Tile Adhesive',
          'Construction Chemical',
          'Expansion Joint Material',
        ],
      },
      {
        'label': 'Flooring & Tiles',
        'value': 'flooring_tiles',
        'bestSelling': true,
        "trending": false,
        'items': [
          'Floor Tiles',
          'Wall Tiles',
          'Bathroom Tiles',
          'Kitchen Tiles',
          'Marble',
          'Granite',
          'Kota Stone',
          'Skirting Tiles',
          'Tile Spacer',
        ],
      },
      {
        'label': 'Plumbing Material',
        'value': 'plumbing_material',
        'bestSelling': false,
        "trending": false,
        'items': [
          'PVC Pipe',
          'CPVC Pipe',
          'UPVC Pipe',
          'SWR Pipe',
          'Water Tank (Sintex type)',
          'Bathroom Fittings (Tap, Shower, Diverter)',
          'Basin',
          'Western/Indian Toilet Seat',
          'Floor Trap',
          'Ball Valve',
          'Angle Valve',
          'Pipe Fittings (Elbow, Tee, Socket)',
          'Septic Tank Material',
        ],
      },
      {
        'label': 'Electrical Material',
        'bestSelling': false,
        "trending": true,
        'value': 'electrical_material',
        'items': [
          'Electrical Wire',
          'Switch Board',
          'Switch & Socket',
          'MCB',
          'Distribution Board',
          'Concealed Box',
          'PVC Conduit Pipe',
          'Fan Box',
          'LED Lights',
          'Ceiling Fan',
          'Exhaust Fan',
          'Door Bell',
          'Earthing Material',
          'AC',
          'Fan',
        ],
      },
      {
        'label': 'Doors & Windows',
        'bestSelling': false,
        "trending": false,
        'value': 'doors_windows',
        'items': [
          'Main Door (Teak Wood / Flush Door)',
          'Internal Doors',
          'Door Frames',
          'Window Frames (Aluminium / UPVC)',
          'Glass',
          'Door Handle',
          'Hinges',
          'Lock Set',
          'Door Closer',
        ],
      },
      {
        'label': 'Paint & Finishing',
        'value': 'paint_finishing',
        'bestSelling': false,
        "trending": false,
        'items': [
          'Primer (Wall / Metal / Wood)',
          'Putty',
          'Interior Paint',
          'Exterior Paint',
          'Waterproof Paint',
          'Texture Paint',
          'Enamel Paint',
          'Thinner',
          'Roller & Brush',
        ],
      },
      {
        'label': 'Waterproofing & Terrace',
        'bestSelling': false,
        "trending": false,
        'value': 'waterproofing_terrace',
        'items': [
          'Dr Fixit Chemical',
          'Membrane Sheet',
          'Bitumen',
          'Terrace Tile',
          'Heat Proof Coating',
        ],
      },
      {
        'label': 'Carpentry & Interior',
        'bestSelling': false,
        "trending": false,
        'value': 'carpentry_interior',
        'items': [
          'Plywood',
          'Block Board',
          'Laminate',
          'Veneer',
          'Modular Kitchen Material',
          'Wardrobe Material',
          'False Ceiling Material',
          'Aluminium Channel',
        ],
      },
    ],

    // ── Packers & Movers ───────────────────────────────────────
    'packers_movers': [
      {
        "label": "Within City",
        "value": "within_city",
        'bestSelling': true,
        "trending": false,
        "items": [],
      },
      {
        "label": "Between city",
        "value": "between_city",
        'bestSelling': false,
        "trending": true,
        "items": [],
      },
      {
        "label": "Moving Only",
        "value": "moving_only",
        'bestSelling': false,
        "trending": false,
        "items": [],
      },
      {
        "label": "Vehicle Shifting (Bike/Car)",
        "value": "vehicle_shifting_bike_car",
        'bestSelling': false,
        "trending": false,
        "items": [],
      },
      {
        "label": "City Tempo Service",
        "value": "city_tempo_service",
        'bestSelling': false,
        "trending": false,
        "items": [],
      },
      {
        "label": "Rent Vehicle(Truck)",
        "value": "rent_vehicle_truck",
        'bestSelling': false,
        "trending": false,
        "items": [],
      },
    ],
  };

  List<Map<String, dynamic>> getServiceNamesForCategory(String categoryId) {
    log("getServiceNamesForCategory ${categoryId}");
    return kServiceCategoryData[categoryId] ?? [];
  }

  /*  List<String> getWorkItemsForServiceName(
      String categoryId,
      String serviceLabel,
      ) {
    final services = kServiceCategoryData[categoryId.toLowerCase()] ?? [];
    for (final s in services) {
      if (s['label'] == serviceLabel) {
        return List<String>.from(s['items'] as List);
      }
    }
    return [];
  }*/
  List<String> getWorkItemsForServiceName(
    String categoryId,
    String serviceValue,
  ) {
    log("🔍 Called getWorkItemsForServiceName");
    log("➡ categoryId: $categoryId");
    log("➡ serviceValue: $serviceValue");

    final normalizedCategory = categoryId.toLowerCase().replaceAll(" ", "_");
    log("➡ normalizedCategory: $normalizedCategory");

    final services = kServiceCategoryData[normalizedCategory] ?? [];
    log("➡ services found: ${services.length}");

    if (services.isEmpty) {
      log("⚠ No services found for category: $normalizedCategory");
    }

    for (final s in services) {
      log("---- Checking service: ${s['value']}");

      if (s['value'] == serviceValue) {
        log("✅ Match found for serviceValue: $serviceValue");

        final items = s['items'] as List? ?? [];
        log("➡ Raw items: $items");
        log("➡ Items count: ${items.length}");

        final result = items.cast<String>().toList();
        log("✅ Returning items: $result");

        return result;
      }
    }

    log("❌ No matching service found for serviceValue: $serviceValue");
    return [];
  }

  void onCategoryChanged(String categoryId, String categoryName) {
    selectedCategory.value = categoryId;
    selectedCategoryName.value = categoryName;
    selectedServiceNameDropdown.value = '';
    selectedWorkItems.clear();
    workItemOptions.clear();
    serviceNameController.clear();
  }

  /// Service Name dropdown se select hone par work items load karo
  /*  void onServiceNameSelected(String label) {
    selectedServiceNameDropdown.value = label;
    serviceNameController.text = label; // API payload ke liye
    selectedWorkItems.clear();
    workItemOptions.assignAll(
      getWorkItemsForServiceName(selectedCategory.value, label),
    );
  }*/
  void onServiceNameSelected(String value) {
    selectedServiceNameDropdown.value = value;

    // Find label to store as serviceName for API
    final services = getServiceNamesForCategory(
      selectedCategoryName
          .trim()
          .toLowerCase()
          .replaceAll('/', ' ')
          .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
          .trim()
          .replaceAll(RegExp(r'\s+'), '_'),
    );
    final match = services.firstWhere(
      (s) => s['value'] == value,
      orElse: () => {'label': value, 'value': value},
    );
    serviceNameController.text = match['label'] as String;

    selectedWorkItems.clear();
    workItemOptions.assignAll(
      getWorkItemsForServiceName(
        selectedCategoryName.value.toLowerCase().replaceAll(" ", "_"),
        value,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HOME CONSTRUCTION category ID – apni actual API category ID se replace karo
  // ─────────────────────────────────────────────────────────────
  String kHomeConstructionCategoryId = 'home_construction';

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
    editingService.value = null;

    // Text fields
    serviceNameController.clear();
    descriptionController.clear();
    priceController.text = '0';
    minRangeController.clear();
    maxRangeController.clear();
    visitChargeController.clear();
    brandController.clear();
    advanceController.text = '0';

    // Image fields
    selectedImagePaths.clear();
    existingImageUrls.clear();

    // Single dropdowns
    selectedCategory.value = '';
    selectedCategoryName.value = '';
    selectedPriceModel.value = "Fixed";
    selectedAvailability.value = "Immediate";
    selectedBillingType.value = "GST";

    // Service name dropdown + work items
    selectedServiceNameDropdown.value = '';
    selectedWorkItems.clear();
    workItemOptions.clear();

    // Toggles
    provideMaterials.value = false;
    equipmentProvided.value = false;
    insuranceAvailable.value = false;

    // Payment modes
    acceptedPaymentModes.clear();

    // Material multi-selects
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
    _clearMultiSelect(selectedSolarPanel);
    _clearMultiSelect(selectedSolarInverter);
    _clearMultiSelect(selectedSecurity);
    _clearMultiSelect(selectedSmartHome);
    _clearMultiSelect(selectedMachine);
    _clearMultiSelect(selectedCladding);
    _clearMultiSelect(selectedFabrication);

    // Yes / No fields
    selected3D.value = '';
    selectedModularKitchen.value = '';
    selectedBoreAndPump.value = '';
    selectedSecuritySystems.value = '';
    selectedHomeAutomation.value = '';
    selectedSolarSolutions.value = '';

    showAllMaterials.value = false;
  }

  // Update service method
  /*  Future<void> updateService() async {
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
  }*/

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

      final workItemsStr = selectedWorkItems.join(', ');

      final updatedServiceItem = ContractorServiceItem(
        id: editingService.value!.id,
        category: selectedCategory.value,
        contractorId: userId,
        serviceName: serviceNameController.text
            .trim()
            .toLowerCase()
            .replaceAll('/', ' ')
            .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
            .trim()
            .replaceAll(RegExp(r'\s+'), '_'),
        description: descriptionController.text.trim(),

        isActive: editingService.value!.isActive,
        meta: ContractorMetaData(
          priceModel: selectedPriceModel.value.toLowerCase().replaceAll(
            " ",
            "_",
          ),
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
          // Material lists
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
          solarPanelBrands: _listOrNull(selectedSolarPanel),
          solarInverterBrands: _listOrNull(selectedSolarInverter),
          securityBrands: _listOrNull(selectedSecurity),
          smartHomeBrands: _listOrNull(selectedSmartHome),
          machineBrands: _listOrNull(selectedMachine),
          claddingBrands: _listOrNull(selectedCladding),
          fabricationWork: _listOrNull(selectedFabrication),
          // Yes / No
          threeDDesign: _stringOrNull(selected3D.value),
          modularKitchen: _stringOrNull(selectedModularKitchen.value),
          boreAndPump: _stringOrNull(selectedBoreAndPump.value),
          securitySystems: _stringOrNull(selectedSecuritySystems.value),
          homeAutomation: _stringOrNull(selectedHomeAutomation.value),
          solarSolutions: _stringOrNull(selectedSolarSolutions.value),
          // Work Items
          // works field
          works:
              workItemOptions
                      .isEmpty // ✅ Packers & Movers or any category with no items
                  ? null
                  : _listOrNull(
                    selectedWorkItems
                        .map(
                          (label) => label
                              .toLowerCase()
                              .replaceAll('/', ' ')
                              .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
                              .trim()
                              .replaceAll(RegExp(r'\s+'), '_'),
                        )
                        .toList(),
                  ),
        ),

        createdAt: editingService.value!.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        serviceImage: existingImageUrls,
      );

      final payload = updatedServiceItem.toMap();
      AppLogger.structured("Update service payload: ", payload);

      final response = await ContractorMyService.contractorMyService
          .updateContractorService(
        payload,
        editingService.value!.id ?? '',
        imagePaths: selectedImagePaths,
      );

      if (response) {
        Get.back();
        clearForm();
        refreshList();
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

  // Format helper

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

  // ---------------- CLEANUP ----------------
}
