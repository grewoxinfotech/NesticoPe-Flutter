import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/contractor/model/hire-contractor_service_model.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/contractor/model/contractor_hire_profile_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../data/network/contractor/model/new_hire_contractor.dart';
import '../../../data/network/contractor/service/hire_contractor_service.dart';
import '../../../utils/logger/app_logger.dart';
import '../../../widgets/messages/snack_bar.dart';

class HireContractorFilterProfileController
    extends PaginatedController<OverAllContractorItem> {
  // Observable variables
  var isLoading = false.obs;
  var categories = <ContractorServiceCategory>[].obs;

  Rxn<User> userData = Rxn<User>();

  // final Rx<HireContractorServiceResponse?> filteredData = Rx<HireContractorServiceResponse?>(null);
  final Rxn<HireContractorUserProfile> userProfile =
      Rxn<HireContractorUserProfile>();
  final Rxn<ContractorCityInsightsResponse> contractorCity =
      Rxn<ContractorCityInsightsResponse>();
  RxList<String> selectedServiceNames = <String>[].obs;
  RxString selectedServiceNameDropdown = ''.obs;
  final selectedWorkItems = <String>[].obs;
  final workItemOptions = <String>[].obs;
  void onServiceNameSelected(String val, {String? label}) {
    selectedServiceNameDropdown.value = val;
    final displayName = label ?? val;
    if (!selectedServiceNames.contains(displayName)) {
      selectedServiceNames.add(displayName);
    }
    _refreshWorkItems();
  }

  List<Map<String, dynamic>> getServiceNamesForCategory(String categoryId) {
    log("getServiceNamesForCategory ${categoryId}");
    return kServiceCategoryData[categoryId] ?? [];
  }

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

  void removeServiceName(String label) {
    selectedServiceNames.remove(label);
    if (selectedServiceNameDropdown.value == label) {
      selectedServiceNameDropdown.value = '';
    }
    _refreshWorkItems();
  }

  RxString selectedCategoryId = ''.obs;

  RxString selectedCategoryName = ''.obs;
  RxDouble selectedServiceRating = 0.0.obs;
  RxDouble selectedContractorRating = 0.0.obs;
  final selectedExperience = ''.obs;
  final selectedAccountType = ''.obs;
  RxString selectedCity = ''.obs;

  RxMap<String, String> filters = <String, String>{}.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    filters.value = {};
  }

  Future<void> applyFilters(Map<String, String> filter) async {
    if (filter.containsKey('category_ui')) {
      filter.remove('category_ui');
    }
    filters.assignAll(filter);
    loadInitial();
    log("🎛️ Apply Filter in Hire Contractor Section: $filters");
  }

  Future<Rxn<HireContractorUserProfile>> fetchUserDataById(
    String userId,
  ) async {
    log("Fetch User Data by ID called $userId");
    userProfile.value = await HireContractorService.contractorMyService
        .fetchContractorProfileById(userId);
    log("Fetched User Profile Data: ${userProfile.value?.toMap()}");

    return userProfile;
  }

  Future<Rxn<User>> fetchUserByID(String userId) async {
    log("Fetch User by ID called $userId");
    userData.value = await HireContractorService.contractorMyService
        .fetchUserById(userId);
    log("Fetched User Data: ${userData.value?.toJson()}");
    return userData;
  }

  Future<void> setValue<T>(Rx<T> target, T value) async {
    target.value = value;
    // await HireContractorService.contractorMyService
    //     .fetchHireContractorService(categoryId: target.toString(), filter: filters);
    // fetchHireContractorCategories(target.string,'');
  }

  // 🔹 Reset all filters

  Future<void> fetchHireContractorCategories(String id, String name) async {
    try {
      selectedCategoryId.value = id;
      selectedCategoryName.value = name;
      log('ckjnjvjn ${selectedCategoryName.value}');
      isLoading.value = true;
      fetchCityOfContractor();
      await loadInitial();
      log("Fetched ${items.length} contractor categories");
    } catch (e) {
      log("Error fetching contractor categories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetFilters() {
    selectedExperience.value = '';
    selectedAccountType.value = '';
    // ❌ DON'T reset these - keep the category selected
    // selectedCategoryId.value = '';
    // selectedCategoryName.value = '';
    selectedContractorRating.value = 0.0;
    selectedServiceRating.value = 0.0;
    selectedCity.value = ''; // Add this to reset city
    filters.clear(); // Clear the filters map
    selectedServiceNames.clear();
    selectedServiceNameDropdown.value = '';
    selectedWorkItems.clear();
    workItemOptions.clear();
  }

  /// 🔁 Refresh contractor list manually

  /// 🔁 Refresh with delay (for pull-to-refresh)
  Future<void> refreshService() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      refreshList();
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh services',
        contentType: ContentType.failure,
      );
    } finally {}
  }

  @override
  @override
  Future<PaginationResponse<OverAllContractorItem>> fetchItems(int page) async {
    try {
      isLoading.value = true;

      final filters = {
        if (selectedCity.value.isNotEmpty) 'city': selectedCity.value,

        if (selectedContractorRating.value > 0)
          'contractorMinRating':
              selectedContractorRating.value.toInt().toString(),
        if (selectedServiceRating.value > 0)
          'serviceMinRating': selectedServiceRating.value.toInt().toString(),
        if (selectedExperience.value.isNotEmpty)
          'experience': selectedExperience.value,
        if (selectedAccountType.value.isNotEmpty)
          'premiumAccount': selectedAccountType.value,
        if (selectedServiceNames.isNotEmpty)
          'serviceNames': selectedServiceNames.map((e) => e.trim()).join(', '),
        if (selectedWorkItems.isNotEmpty)
          'works': selectedWorkItems.map((e) => e.trim()).join(', '),
      };

      log(
        "Fetching items for category ID: ${selectedCategoryId.value} with filters: $filters",
      );

      final response = await HireContractorService.contractorMyService
          .fetchHireContractorByCategory(
            id: selectedCategoryId.value,
            filter: filters,
            limit: 24,
          );

      AppLogger.structured(
        'Fetched contractors',
        response.items.map((element) => element.toMap()),
      );

      items.assignAll(response.items); // ✅ use assignAll for RxList
      return response;
    } finally {
      isLoading.value = false; // ✅ stop loader after fetch
    }
  }

  Future<void> fetchCityOfContractor() async {
    try {
      final response =
          await HireContractorService.contractorMyService.fetchContractorCity();
      contractorCity.value = ContractorCityInsightsResponse.fromJson(response);
    } catch (e) {
      log("Error fetching contractor cities: $e");
    }
  }

  /// 🚫 Not used anymore since pagination removed
}

extension on HireContractorFilterProfileController {
  void _refreshWorkItems() {
    final catKey = selectedCategoryName.value
        .trim()
        .toLowerCase()
        .replaceAll('/', ' ')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    ;
    final options = getServiceNamesForCategory(catKey);
    final set = <String>{};
    for (final label in selectedServiceNames) {
      for (final m in options) {
        final lbl = (m['label'] as String?) ?? '';
        if (lbl == label) {
          final items =
              (m['items'] as List?)?.cast<String>() ?? const <String>[];
          set.addAll(items);
          break;
        }
      }
    }
    final list = set.toList()..sort();
    workItemOptions.assignAll(list);
    selectedWorkItems.removeWhere((e) => !workItemOptions.contains(e));
  }
}
