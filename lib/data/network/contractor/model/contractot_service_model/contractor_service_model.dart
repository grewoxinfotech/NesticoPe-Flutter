import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/modules/propert_detail/view/property_details.dart';

import '../../../../../modules/propert_detail/view/property_details.dart';
import '../../../../../modules/propert_detail/view/property_details.dart'
    as Formatter;

class ContractorServiceResponse {
  final bool success;
  final String message;
  final ContractorServiceData data;

  ContractorServiceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorServiceResponse.fromJson(Map<String, dynamic> json) {
    return ContractorServiceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ContractorServiceData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  Map<String, dynamic> toMap() => toJson();
}

class ContractorServiceData {
  List<ContractorServiceItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  ContractorServiceData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ContractorServiceData.fromJson(Map<String, dynamic> json) {
    return ContractorServiceData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ContractorServiceItem.fromJson(e))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}

class ContractorServiceItem {
  String? id;
  String? createdBy;
  String? updatedBy;
  String category;
  String contractorId;
  String serviceName;
  String description;
  int? totalReviews;
  String? averageRating;
  int? warningCount;
  bool isActive;
  bool? isBlocked;
  String? blockReason;
  String? blockedAt;
  List<String>? serviceImage;
  ContractorMetaData meta;
  String createdAt;
  String updatedAt;

  ContractorServiceItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    required this.category,
    required this.contractorId,
    required this.serviceName,
    required this.description,
    this.totalReviews,
    this.averageRating,
    this.warningCount,
    required this.isActive,
    this.isBlocked,
    this.blockReason,
    this.blockedAt,
    this.serviceImage,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContractorServiceItem.fromJson(Map<String, dynamic> json) {
    return ContractorServiceItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      category: json['category'] ?? '',
      contractorId: json['contractor_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      description: json['description'] ?? '',
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: json['averageRating']?.toString() ?? '0.0',
      warningCount: json['warningCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      blockReason: json['blockReason'],
      blockedAt: json['blockedAt'],
      serviceImage: (json['serviceImage'] as List?)?.cast<String>(),
      meta: ContractorMetaData.fromJson(json['meta'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'category': category,
      'contractor_id': contractorId,
      'serviceName': serviceName,
      'description': description,
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'warningCount': warningCount,
      'isActive': isActive,
      'isBlocked': isBlocked,
      'blockReason': blockReason,
      'blockedAt': blockedAt,
      'serviceImage': serviceImage,
      'meta': meta.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}

/*class ContractorMetaData {
  String priceModel;
  int minPriceRange;
  int maxPriceRange;
  int visitCharge;
  String workAvailability;
  bool provideMaterials;
  String brandsUsed;
  bool equipmentProvided;
  bool insuranceAvailable;
  List<String> acceptedPaymentModes;
  int advanceRequiredPercentage;
  String billingType;

  ContractorMetaData({
    required this.priceModel,
    required this.minPriceRange,
    required this.maxPriceRange,
    required this.visitCharge,
    required this.workAvailability,
    required this.provideMaterials,
    required this.brandsUsed,
    required this.equipmentProvided,
    required this.insuranceAvailable,
    required this.acceptedPaymentModes,
    required this.advanceRequiredPercentage,
    required this.billingType,
  });

  factory ContractorMetaData.fromJson(Map<String, dynamic> json) {
    return ContractorMetaData(
      priceModel: json['priceModel'] ?? '',
      minPriceRange: json['minPrice'] ?? 0,
      maxPriceRange: json['maxPrice'] ?? 0,
      visitCharge: json['visitCharge'] ?? 0,
      workAvailability: json['workAvailability'] ?? '',
      provideMaterials: json['provideMaterials'] ?? false,
      brandsUsed: json['brandsUsed'] ?? '',
      equipmentProvided: json['equipmentProvided'] ?? false,
      insuranceAvailable: json['insuranceAvailable'] ?? false,
      acceptedPaymentModes: List<String>.from(
        json['acceptedPaymentModes'] ?? [],
      ),
      advanceRequiredPercentage: json['advanceRequiredPercentage'] ?? 0,
      billingType: json['billingType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'priceModel': priceModel,
      'minPrice': minPriceRange,
      'maxPrice': maxPriceRange,
      'visitCharge': visitCharge,
      'workAvailability': workAvailability,
      'provideMaterials': provideMaterials,
      'brandsUsed': brandsUsed,
      'equipmentProvided': equipmentProvided,
      'insuranceAvailable': insuranceAvailable,
      'acceptedPaymentModes': acceptedPaymentModes,
      'advanceRequiredPercentage': advanceRequiredPercentage,
      'billingType': billingType,
    };
  }

  String get priceRange {
    if (minPriceRange == 0 && maxPriceRange == 0) {
      return 'No Price Range';
    } else {
      return Formatter.formatPriceRange(minPriceRange, maxPriceRange);
      ;
    }
  }

  Map<String, dynamic> toMap() => toJson();
}*/

class ContractorMetaData {
  final String? priceModel;
  final int? minPriceRange;
  final int? maxPriceRange;
  final int? visitCharge;
  final String? workAvailability;
  final bool? provideMaterials;
  final String? brandsUsed;
  final bool? equipmentProvided;
  final bool? insuranceAvailable;
  final List<String>? acceptedPaymentModes;
  final List<String>? works;

  // ✅ NEW - Sub category

  final int? advanceRequiredPercentage;
  final String? billingType;

  // Optional lists
  final List<String>? cementBrand;
  final List<String>? steelBrand;
  final List<String>? brickType;
  final List<String>? sandSource;
  final List<String>? solarPanelBrands;
  final List<String>? solarInverterBrands;
  final List<String>? securityBrands;
  final List<String>? smartHomeBrands;
  final List<String>? machineBrands;
  final List<String>? claddingBrands;
  final List<String>? electricalWiresBrand;
  final List<String>? electricalSwitchesBrand;
  final List<String>? plumbingPipesBrand;
  final List<String>? sanitaryFittingsBrand;
  final List<String>? waterTankBrand;
  final List<String>? flooringTilesBrand;
  final List<String>? interiorPaintBrand;
  final List<String>? exteriorPaintBrand;
  final List<String>? doorsType;
  final List<String>? windowsType;
  final List<String>? structure;
  final List<String>? plasterType;
  final List<String>? waterproofing;
  final List<String>? chokhatType;
  final List<String>? railingType;
  final List<String>? falseCeiling;
  final List<String>? fabricationWork;

  // Yes / No values
  final String? threeDDesign;
  final String? modularKitchen;
  final String? boreAndPump;
  final String? securitySystems;
  final String? homeAutomation;
  final String? solarSolutions;

  ContractorMetaData({
    this.priceModel,
    this.minPriceRange,
    this.maxPriceRange,
    this.visitCharge,
    this.workAvailability,
    this.provideMaterials,
    this.brandsUsed,
    this.equipmentProvided,
    this.insuranceAvailable,
    this.acceptedPaymentModes,
    this.advanceRequiredPercentage,
    this.billingType,
    this.cementBrand,
    this.steelBrand,
    this.brickType,
    this.sandSource,
    this.works, // ✅ NEW

    this.electricalWiresBrand,
    this.electricalSwitchesBrand,
    this.plumbingPipesBrand,
    this.sanitaryFittingsBrand,
    // constructor
    this.solarPanelBrands,
    this.solarInverterBrands,
    this.securityBrands,
    this.smartHomeBrands,
    this.machineBrands,
    this.claddingBrands,
    this.waterTankBrand,
    this.flooringTilesBrand,
    this.interiorPaintBrand,
    this.exteriorPaintBrand,
    this.doorsType,
    this.windowsType,
    this.structure,
    this.plasterType,
    this.waterproofing,
    this.chokhatType,
    this.railingType,
    this.falseCeiling,
    this.fabricationWork,
    this.threeDDesign,
    this.modularKitchen,
    this.boreAndPump,
    this.securitySystems,
    this.homeAutomation,
    this.solarSolutions,
  });

  factory ContractorMetaData.fromJson(Map<String, dynamic> json) {
    return ContractorMetaData(
      priceModel: json['priceModel'],
      minPriceRange: json['minPrice'],
      maxPriceRange: json['maxPrice'],
      visitCharge: json['visitCharge'],
      works: (json['works'] as List?)?.cast<String>(),

      // ✅ NEW
      workAvailability: json['workAvailability'],
      provideMaterials: json['provideMaterials'],
      brandsUsed: json['brandsUsed'],
      equipmentProvided: json['equipmentProvided'],
      insuranceAvailable: json['insuranceAvailable'],
      acceptedPaymentModes:
          (json['acceptedPaymentModes'] as List?)?.cast<String>(),
      advanceRequiredPercentage: json['advanceRequiredPercentage'],
      billingType: json['billingType'],
      cementBrand: (json['cementBrand'] as List?)?.cast<String>(),
      steelBrand: (json['steelBrand'] as List?)?.cast<String>(),
      brickType: (json['brickType'] as List?)?.cast<String>(),
      sandSource: (json['sandSource'] as List?)?.cast<String>(),
      electricalWiresBrand:
          (json['electricalWiresBrand'] as List?)?.cast<String>(),
      electricalSwitchesBrand:
          (json['electricalSwitchesBrand'] as List?)?.cast<String>(),
      plumbingPipesBrand: (json['plumbingPipesBrand'] as List?)?.cast<String>(),
      sanitaryFittingsBrand:
          (json['sanitaryFittingsBrand'] as List?)?.cast<String>(),
      waterTankBrand: (json['waterTankBrand'] as List?)?.cast<String>(),
      flooringTilesBrand: (json['flooringTilesBrand'] as List?)?.cast<String>(),
      interiorPaintBrand: (json['interiorPaintBrand'] as List?)?.cast<String>(),
      exteriorPaintBrand: (json['exteriorPaintBrand'] as List?)?.cast<String>(),
      doorsType: (json['doorsType'] as List?)?.cast<String>(),
      windowsType: (json['windowsType'] as List?)?.cast<String>(),
      structure: (json['structure'] as List?)?.cast<String>(),
      plasterType: (json['plasterType'] as List?)?.cast<String>(),
      waterproofing: (json['waterproofing'] as List?)?.cast<String>(),
      chokhatType: (json['chokhatType'] as List?)?.cast<String>(),
      railingType: (json['railingType'] as List?)?.cast<String>(),
      falseCeiling: (json['falseCeiling'] as List?)?.cast<String>(),
      fabricationWork: (json['fabricationWork'] as List?)?.cast<String>(),
      threeDDesign: json['threeDDesign'],
      modularKitchen: json['modularKitchen'],
      boreAndPump: json['boreAndPump'],
      securitySystems: json['securitySystems'],
      solarPanelBrands: (json['solarPanelBrands'] as List?)?.cast<String>(),
      solarInverterBrands: (json['solarInverterBrands'] as List?)?.cast<String>(),
      securityBrands: (json['securityBrands'] as List?)?.cast<String>(),
      smartHomeBrands: (json['smartHomeBrands'] as List?)?.cast<String>(),
      machineBrands: (json['machineBrands'] as List?)?.cast<String>(),
      claddingBrands: (json['claddingBrands'] as List?)?.cast<String>(),
      homeAutomation: json['homeAutomation'],
      solarSolutions: json['solarSolutions'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'priceModel': priceModel,
      'minPrice': minPriceRange,
      'maxPrice': maxPriceRange,
      'visitCharge': visitCharge,
      'workAvailability': workAvailability,
      'provideMaterials': provideMaterials,
      'brandsUsed': brandsUsed,
      'equipmentProvided': equipmentProvided,
      'insuranceAvailable': insuranceAvailable,
      'acceptedPaymentModes': acceptedPaymentModes,
      'advanceRequiredPercentage': advanceRequiredPercentage,
      'billingType': billingType,
      'works': works, // ✅ NEW// ✅ NEW
      'cementBrand': cementBrand,
      'steelBrand': steelBrand,
      'brickType': brickType,
      'solarPanelBrands': solarPanelBrands,
      'solarInverterBrands': solarInverterBrands,
      'securityBrands': securityBrands,
      'smartHomeBrands': smartHomeBrands,
      'machineBrands': machineBrands,
      'claddingBrands': claddingBrands,
      'sandSource': sandSource,
      'electricalWiresBrand': electricalWiresBrand,
      'electricalSwitchesBrand': electricalSwitchesBrand,
      'plumbingPipesBrand': plumbingPipesBrand,
      'sanitaryFittingsBrand': sanitaryFittingsBrand,
      'waterTankBrand': waterTankBrand,
      'flooringTilesBrand': flooringTilesBrand,
      'interiorPaintBrand': interiorPaintBrand,
      'exteriorPaintBrand': exteriorPaintBrand,
      'doorsType': doorsType,
      'windowsType': windowsType,
      'structure': structure,
      'plasterType': plasterType,
      'waterproofing': waterproofing,
      'chokhatType': chokhatType,
      'railingType': railingType,
      'falseCeiling': falseCeiling,
      'fabricationWork': fabricationWork,

      'threeDDesign': threeDDesign,
      'modularKitchen': modularKitchen,
      'boreAndPump': boreAndPump,
      'securitySystems': securitySystems,
      'homeAutomation': homeAutomation,
      'solarSolutions': solarSolutions,
    };

    // 🔥 THIS LINE FIXES YOUR ISSUE
    data.removeWhere((key, value) => value == null);

    return data;
  }

  String get priceRange {
    if (minPriceRange == 0 && maxPriceRange == 0) {
      return 'No Price Range';
    } else {
      return Formatter.formatPriceRange(minPriceRange, maxPriceRange);
      ;
    }
  }
}

var serviceName = {
  "materialSupply": {
    "id": "material_supply",
    "title": "Material Supply",
    "categories": [
      {
        "items": [
          {"label": "Foundation & Structure", "value": "foundation_structure"},
          {
            "label": "Cement (UltraTech / ACC / Ambuja)",
            "value": "cement_ultra_tech_acc_ambuja",
          },
          {
            "label": "TMT Steel Bars (8mm, 10mm, 12mm, 16mm, 20mm)",
            "value": "tmt_steel_bars_8_mm_10_mm_12_mm_16_mm_20_mm",
          },
          {"label": "Binding Wire", "value": "binding_wire"},
          {
            "label": "Sand (River Sand / M-Sand)",
            "value": "sand_river_sand_m_sand",
          },
          {"label": "Crush Sand", "value": "crush_sand"},
          {
            "label": "Aggregates (20mm, 10mm, 40mm)",
            "value": "aggregates_20_mm_10_mm_40_mm",
          },
          {"label": "Bricks (Red / Fly Ash)", "value": "bricks_red_fly_ash"},
          {
            "label": "Concrete Blocks (AAC Block)",
            "value": "concrete_blocks_aac_block",
          },
          {
            "label": "RMC (Ready Mix Concrete)",
            "value": "rmc_ready_mix_concrete",
          },
          {"label": "PCC Material", "value": "pcc_material"},
          {
            "label": "Waterproofing Compound",
            "value": "waterproofing_compound",
          },
          {"label": "Shutterining", "value": "shutterining"},
        ],
        "label": "Civil / Structural Material",
        "value": "civil_structural_material",
      },
      {
        "items": [
          {"label": "Plaster Sand", "value": "plaster_sand"},
          {"label": "Wall Putty", "value": "wall_putty"},
          {"label": "POP (Plaster of Paris)", "value": "pop_plaster_of_paris"},
          {"label": "Gypsum", "value": "gypsum"},
          {"label": "Tile Adhesive", "value": "tile_adhesive"},
          {
            "label":
                "Construction Chemical (Dr. Fixit,ke,rouf, home pried type)",
            "value": "construction_chemical_dr_fixit_ke_rouf_home_pried_type",
          },
          {
            "label": "Expansion Joint Material",
            "value": "expansion_joint_material",
          },
        ],
        "label": "Masonry & Plaster Material",
        "value": "masonry_plaster_material",
      },
      {
        "items": [
          {"label": "Floor Tiles", "value": "floor_tiles"},
          {"label": "Wall Tiles", "value": "wall_tiles"},
          {"label": "Bathroom Tiles", "value": "bathroom_tiles"},
          {"label": "Kitchen Tiles", "value": "kitchen_tiles"},
          {"label": "Marble", "value": "marble"},
          {"label": "Granite", "value": "granite"},
          {"label": "Kota Stone", "value": "kota_stone"},
          {"label": "Skirting Tiles", "value": "skirting_tiles"},
          {"label": "Tile Spacer", "value": "tile_spacer"},
        ],
        "label": "Flooring & Tiles",
        "value": "flooring_tiles",
      },
      {
        "items": [
          {"label": "PVC Pipe", "value": "pvc_pipe"},
          {"label": "CPVC Pipe", "value": "cpvc_pipe"},
          {"label": "UPVC Pipe", "value": "upvc_pipe"},
          {"label": "SWR Pipe", "value": "swr_pipe"},
          {
            "label": "Water Tank (Sintex type)",
            "value": "water_tank_sintex_type",
          },
          {
            "label": "Bathroom Fittings (Tap, Shower, Diverter)",
            "value": "bathroom_fittings_tap_shower_diverter",
          },
          {"label": "Basin", "value": "basin"},
          {
            "label": "Western/Indian Toilet Seat",
            "value": "western_indian_toilet_seat",
          },
          {"label": "Floor Trap", "value": "floor_trap"},
          {"label": "Ball Valve", "value": "ball_valve"},
          {"label": "Angle Valve", "value": "angle_valve"},
          {
            "label": "Pipe Fittings (Elbow, Tee, Socket)",
            "value": "pipe_fittings_elbow_tee_socket",
          },
          {"label": "Septic Tank Material", "value": "septic_tank_material"},
        ],
        "label": "Plumbing Material",
        "value": "plumbing_material",
      },
      {
        "items": [
          {"label": "Electrical Wire", "value": "electrical_wire"},
          {"label": "Switch Board", "value": "switch_board"},
          {"label": "Switch & Socket", "value": "switch_socket"},
          {"label": "MCB", "value": "mcb"},
          {"label": "Distribution Board", "value": "distribution_board"},
          {"label": "Concealed Box", "value": "concealed_box"},
          {"label": "PVC Conduit Pipe", "value": "pvc_conduit_pipe"},
          {"label": "Fan Box", "value": "fan_box"},
          {"label": "LED Lights", "value": "led_lights"},
          {"label": "Ceiling Fan", "value": "ceiling_fan"},
          {"label": "Exhaust Fan", "value": "exhaust_fan"},
          {"label": "Door Bell", "value": "door_bell"},
          {"label": "Earthing Material", "value": "earthing_material"},
          {"label": "AC", "value": "ac"},
          {"label": "Fan", "value": "fan"},
        ],
        "label": "Electrical Material",
        "value": "electrical_material",
      },
      {
        "items": [
          {
            "label": "Main Door (Teak Wood / Flush Door)",
            "value": "main_door_teak_wood_flush_door",
          },
          {"label": "Internal Doors", "value": "internal_doors"},
          {"label": "Door Frames", "value": "door_frames"},
          {
            "label": "Window Frames (Aluminium / UPVC)",
            "value": "window_frames_aluminium_upvc",
          },
          {"label": "Glass", "value": "glass"},
          {"label": "Door Handle", "value": "door_handle"},
          {"label": "Hinges", "value": "hinges"},
          {"label": "Lock Set", "value": "lock_set"},
          {"label": "Door Closer", "value": "door_closer"},
        ],
        "label": "Doors & Windows",
        "value": "doors_windows",
      },
      {
        "items": [
          {
            "label": "Primer (Wall / Metal / Wood)",
            "value": "primer_wall_metal_wood",
          },
          {"label": "Putty", "value": "putty"},
          {"label": "Interior Paint", "value": "interior_paint"},
          {"label": "Exterior Paint", "value": "exterior_paint"},
          {"label": "Waterproof Paint", "value": "waterproof_paint"},
          {"label": "Texture Paint", "value": "texture_paint"},
          {"label": "Enamel Paint", "value": "enamel_paint"},
          {"label": "Thinner", "value": "thinner"},
          {"label": "Roller & Brush", "value": "roller_brush"},
        ],
        "label": "Paint & Finishing",
        "value": "paint_finishing",
      },
      {
        "items": [
          {"label": "Dr Fixit Chemical", "value": "dr_fixit_chemical"},
          {"label": "Membrane Sheet", "value": "membrane_sheet"},
          {"label": "Bitumen", "value": "bitumen"},
          {"label": "Terrace Tile", "value": "terrace_tile"},
          {"label": "Heat Proof Coating", "value": "heat_proof_coating"},
        ],
        "label": "Waterproofing & Terrace",
        "value": "waterproofing_terrace",
      },
      {
        "items": [
          {"label": "Plywood", "value": "plywood"},
          {"label": "Block Board", "value": "block_board"},
          {"label": "Laminate", "value": "laminate"},
          {"label": "Veneer", "value": "veneer"},
          {
            "label": "Modular Kitchen Material",
            "value": "modular_kitchen_material",
          },
          {"label": "Wardrobe Material", "value": "wardrobe_material"},
          {
            "label": "False Ceiling Material",
            "value": "false_ceiling_material",
          },
          {"label": "Aluminium Channel", "value": "aluminium_channel"},
        ],
        "label": "Carpentry & Interior",
        "value": "carpentry_interior",
      },
    ],
  },
  "packersAndMovers": {
    "id": "packers_movers",
    "title": "Packers & Movers",
    "subCategories": [
      {"label": "Within City", "value": "within_city"},
      {"label": "Between city", "value": "between_city"},
      {"label": "Moving Only", "value": "moving_only"},
      {
        "label": "Vehicle Shifting (Bike/Car)",
        "value": "vehicle_shifting_bike_car",
      },
      {"label": "City Tempo Service", "value": "city_tempo_service"},
      {"label": "Rent Vehicle(Truck)", "value": "rent_vehicle_truck"},
    ],
  },
  "homeServices": {
    "id": "home_services",
    "title": "Home Services",
    "categories": [
      {
        "items": [
          {
            "label": "Solar Panel Installation (1kW - 10kW+)",
            "value": "solar_panel_installation_1_k_w_10_k_w",
          },
          {"label": "On-Grid Solar System", "value": "on_grid_solar_system"},
          {"label": "Off-Grid Solar System", "value": "off_grid_solar_system"},
          {"label": "Hybrid Solar System", "value": "hybrid_solar_system"},
          {"label": "Solar Water Heater", "value": "solar_water_heater"},
          {
            "label": "Solar Inverter & Battery",
            "value": "solar_inverter_battery",
          },
          {
            "label": "Solar Panel Cleaning & Maintenance",
            "value": "solar_panel_cleaning_maintenance",
          },
        ],
        "label": "Rooftop Solar Panel Solutions",
        "value": "rooftop_solar_panel_solutions",
      },
      {
        "items": [
          {
            "label": "CCTV Camera Installation",
            "value": "cctv_camera_installation",
          },
          {"label": "Video Door Phone", "value": "video_door_phone"},
          {
            "label": "Biometric & Digital Door Lock",
            "value": "biometric_digital_door_lock",
          },
          {"label": "Intruder Alarm System", "value": "intruder_alarm_system"},
          {
            "label": "Fire & Smoke Alarm System",
            "value": "fire_smoke_alarm_system",
          },
          {"label": "Access Control System", "value": "access_control_system"},
          {"label": "Security Fencing", "value": "security_fencing"},
        ],
        "label": "Home Security Solutions",
        "value": "home_security_solutions",
      },
      {
        "items": [
          {
            "label": "Home Automation System",
            "value": "home_automation_system",
          },
          {
            "label": "Smart Lighting Control",
            "value": "smart_lighting_control",
          },
          {
            "label": "Smart Curtains & Blinds",
            "value": "smart_curtains_blinds",
          },
          {
            "label": "Voice Control (Alexa/Google Home)",
            "value": "voice_control_alexa_google_home",
          },
          {"label": "Smart Switches & Plugs", "value": "smart_switches_plugs"},
          {
            "label": "Smart Sensors (Motion, Door, Gas)",
            "value": "smart_sensors_motion_door_gas",
          },
        ],
        "label": "Smart Home Solutions",
        "value": "smart_home_solutions",
      },
      {
        "items": [
          {
            "label": "Architectural 2D/3D Design",
            "value": "architectural_2_d_3_d_design",
          },
          {
            "label": "Structural Drawing & Engineering",
            "value": "structural_drawing_engineering",
          },
          {"label": "3D Elevation Design", "value": "3_d_elevation_design"},
          {
            "label": "Interior Layout Planning",
            "value": "interior_layout_planning",
          },
          {"label": "Vastu Consultation", "value": "vastu_consultation"},
          {
            "label": "Government Approval Drawings",
            "value": "government_approval_drawings",
          },
          {"label": "Landscaping Design", "value": "landscaping_design"},
        ],
        "label": "Structure Planning and Design",
        "value": "structure_planning_and_design",
      },
      {
        "items": [
          {"label": "Kitchen Renovation", "value": "kitchen_renovation"},
          {"label": "Bathroom Renovation", "value": "bathroom_renovation"},
          {
            "label": "Living Room Renovation",
            "value": "living_room_renovation",
          },
          {"label": "Full House Renovation", "value": "full_house_renovation"},
          {"label": "Tiling Work Fixing", "value": "tiling_work_fixing"},
          {"label": "Build Extra Rooms", "value": "build_extra_rooms"},
          {"label": "Balcony Renovation", "value": "balcony_renovation"},
          {"label": "Fabrication Work", "value": "fabrication_work"},
        ],
        "label": "Renovation and Remodeling",
        "value": "renovation_and_remodeling",
      },
      {
        "items": [
          {"label": "AC Repair", "value": "ac_repair"},
          {"label": "Geyser Repair", "value": "geyser_repair"},
          {
            "label": "Washing Machine Repair",
            "value": "washing_machine_repair",
          },
          {"label": "Water Purifier Repair", "value": "water_purifier_repair"},
          {"label": "Refrigerator Repair", "value": "refrigerator_repair"},
          {"label": "Microwave Repair", "value": "microwave_repair"},
        ],
        "label": "Maintenance & AMC Services",
        "value": "maintenance_amc_services",
      },
      {
        "items": [
          {"label": "Interior Painting", "value": "interior_painting"},
          {"label": "Exterior Painting", "value": "exterior_painting"},
          {"label": "Waterproofing", "value": "waterproofing"},
        ],
        "features": [
          "Genuine Branded Paints",
          "End to End Managed",
          "Wall Health Checkup",
          "Material + Labor Cost Included",
          "Professionally Trained Painters",
          "Furniture and Electrical Outlets Masking",
          "Post Painting Cleanup",
        ],
        "label": "Home Painting",
        "value": "home_painting",
      },
      {
        "items": [
          {"label": "Full House Cleaning", "value": "full_house_cleaning"},
          {"label": "Kitchen Cleaning", "value": "kitchen_cleaning"},
          {"label": "Bathroom Cleaning", "value": "bathroom_cleaning"},
          {
            "label": "Sintex/Water Tank Cleaning",
            "value": "sintex_water_tank_cleaning",
          },
        ],
        "label": "Home Cleaning",
        "value": "home_cleaning",
      },
      {
        "items": [
          {"label": "Fan", "value": "fan"},
          {"label": "Switch & Socket", "value": "switch_socket"},
          {"label": "TV", "value": "tv"},
          {"label": "Light", "value": "light"},
          {"label": "Inverter & Stabilizer", "value": "inverter_stabilizer"},
          {"label": "AC Repair", "value": "ac_repair"},
          {"label": "Geyser Repair", "value": "geyser_repair"},
          {
            "label": "Washing Machine Repair",
            "value": "washing_machine_repair",
          },
          {"label": "Water Purifier Repair", "value": "water_purifier_repair"},
          {"label": "Refrigerator Repair", "value": "refrigerator_repair"},
          {"label": "Microwave Repair", "value": "microwave_repair"},
          {"label": "Wiring", "value": "wiring"},
          {"label": "MCB & Fuse", "value": "mcb_fuse"},
          {"label": "Door Bell", "value": "door_bell"},
        ],
        "label": "Electrician",
        "value": "electrician",
      },
      {
        "items": [
          {"label": "Toilet Repair", "value": "toilet_repair"},
          {"label": "Tap & Mixer Repair", "value": "tap_mixer_repair"},
          {"label": "Basin & Sink Repair", "value": "basin_sink_repair"},
          {"label": "Drainage Pipe", "value": "drainage_pipe"},
          {"label": "Water Pipe Connection", "value": "water_pipe_connection"},
          {"label": "Bathroom & Shower", "value": "bathroom_shower"},
          {"label": "Water Tank", "value": "water_tank"},
          {"label": "Grouting", "value": "grouting"},
        ],
        "label": "Plumber",
        "value": "plumber",
      },
      {
        "items": [
          {"label": "Door", "value": "door"},
          {"label": "Drill & Hang", "value": "drill_hang"},
          {"label": "Cupboard & Drawer", "value": "cupboard_drawer"},
          {"label": "Window & Curtain", "value": "window_curtain"},
          {"label": "Bed", "value": "bed"},
          {"label": "Furniture Repair", "value": "furniture_repair"},
          {"label": "Furniture Assembly", "value": "furniture_assembly"},
          {"label": "TV", "value": "tv"},
          {"label": "Balcony", "value": "balcony"},
        ],
        "label": "Carpenter",
        "value": "carpenter",
      },
      {
        "items": [
          {"label": "Sofa Set", "value": "sofa_set"},
          {"label": "Recliner & Rocker", "value": "recliner_rocker"},
          {"label": "Sofa Bed & Day Bed", "value": "sofa_bed_day_bed"},
          {"label": "Center Table", "value": "center_table"},
          {"label": "TV Unit", "value": "tv_unit"},
          {"label": "Shoe Rack", "value": "shoe_rack"},
          {"label": "Balcony Set", "value": "balcony_set"},
          {"label": "Chairs & Stools", "value": "chairs_stools"},
          {"label": "Office Chair", "value": "office_chair"},
          {
            "label": "Bed (King/Queen/Single)",
            "value": "bed_king_queen_single",
          },
          {"label": "Mattress", "value": "mattress"},
          {"label": "Wardrobe & Almirah", "value": "wardrobe_almirah"},
          {"label": "Bedside Table", "value": "bedside_table"},
          {"label": "Chest of Drawers", "value": "chest_of_drawers"},
          {"label": "Dresser & Mirror", "value": "dresser_mirror"},
          {
            "label": "Bookshelf & Display Unit",
            "value": "bookshelf_display_unit",
          },
          {"label": "Storage Cabinet", "value": "storage_cabinet"},
          {"label": "Dining Table Set", "value": "dining_table_set"},
          {"label": "Coffee Table", "value": "coffee_table"},
          {"label": "Study Table", "value": "study_table"},
          {
            "label": "Study Table with Chair",
            "value": "study_table_with_chair",
          },
          {"label": "Computer Table", "value": "computer_table"},
        ],
        "label": "Buy / Rent Furniture",
        "value": "buy_rent_furniture",
      },
      {
        "items": [
          {"label": "Split / Window AC", "value": "split_window_ac"},
          {"label": "Air Cooler", "value": "air_cooler"},
          {"label": "Ceiling & Table Fan", "value": "ceiling_table_fan"},
          {"label": "Air Purifier", "value": "air_purifier"},
          {
            "label": "Refrigerator (Single/Double Door)",
            "value": "refrigerator_single_double_door",
          },
          {
            "label": "Washing Machine (Front/Top Load)",
            "value": "washing_machine_front_top_load",
          },
          {"label": "Microwave & Oven", "value": "microwave_oven"},
          {"label": "Dishwasher", "value": "dishwasher"},
          {"label": "Water Purifier (RO/UV)", "value": "water_purifier_ro_uv"},
          {"label": "Kitchen Chimney", "value": "kitchen_chimney"},
          {"label": "Mixer & Grinder", "value": "mixer_grinder"},
          {"label": "Smart TV / LED TV", "value": "smart_tv_led_tv"},
          {"label": "Home Theater System", "value": "home_theater_system"},
          {
            "label": "Gaming Console (Playstation/Xbox)",
            "value": "gaming_console_playstation_xbox",
          },
        ],
        "label": "Buy / Rent Appliances",
        "value": "buy_rent_appliances",
      },
    ],
  },
  "interiorDesign": {
    "id": "interior_design",
    "title": "Interior Design",
    "categories": [
      {
        "items": [
          {"label": "Living Room Design", "value": "living_room_design"},
          {"label": "Master Bedroom Design", "value": "master_bedroom_design"},
          {"label": "Kids Room Design", "value": "kids_room_design"},
          {"label": "Dining Room Design", "value": "dining_room_design"},
          {"label": "Bathroom Design", "value": "bathroom_design"},
          {"label": "Balcony Design", "value": "balcony_design"},
          {"label": "Pooja Mandir Design", "value": "pooja_mandir_design"},
          {"label": "Home Office Design", "value": "home_office_design"},
          {"label": "Foyer Design", "value": "foyer_design"},
          {"label": "Room Design", "value": "room_design"},
        ],
        "label": "Residential Room Design",
        "value": "residential_room_design",
      },
      {
        "items": [
          {
            "label": "Modular Kitchen Design",
            "value": "modular_kitchen_design",
          },
          {"label": "Kitchen Design", "value": "kitchen_design"},
          {"label": "Kitchen Tiles Design", "value": "kitchen_tiles_design"},
          {
            "label": "Kitchen False Ceiling Design",
            "value": "kitchen_false_ceiling_design",
          },
          {"label": "Kitchen Wall Design", "value": "kitchen_wall_design"},
          {"label": "Countertops Design", "value": "countertops_design"},
          {"label": "Crockery Unit Design", "value": "crockery_unit_design"},
        ],
        "label": "Kitchen Design",
        "value": "kitchen_design",
      },
      {
        "items": [
          {
            "label": "Office Workspaces Interior",
            "value": "office_workspaces_interior",
          },
          {"label": "Retail Store Interior", "value": "retail_store_interior"},
          {"label": "Restaurant Interior", "value": "restaurant_interior"},
        ],
        "label": "Commercial & Retail",
        "value": "commercial_retail",
      },
      {
        "items": [
          {"label": "Staircase Design", "value": "staircase_design"},
          {"label": "Railing Design", "value": "railing_design"},
          {"label": "Partition Design", "value": "partition_design"},
          {"label": "False Ceiling Design", "value": "false_ceiling_design"},
          {"label": "Flooring Design", "value": "flooring_design"},
          {"label": "Wall Panel Design", "value": "wall_panel_design"},
          {"label": "Wall Designs Ideas", "value": "wall_designs_ideas"},
          {"label": "Wall Paint Design", "value": "wall_paint_design"},
          {
            "label": "Wall Color Combination Design",
            "value": "wall_color_combination_design",
          },
          {"label": "Wallpaper Design", "value": "wallpaper_design"},
          {"label": "Tiles Design", "value": "tiles_design"},
          {"label": "Window Design", "value": "window_design"},
          {"label": "Door Design", "value": "door_design"},
        ],
        "label": "Structural & Elements",
        "value": "structural_elements",
      },
      {
        "items": [
          {"label": "Wardrobe Design", "value": "wardrobe_design"},
          {"label": "TV Unit Design", "value": "tv_unit_design"},
          {"label": "Bed Headboard Design", "value": "bed_headboard_design"},
          {"label": "Shoerack Design", "value": "shoerack_design"},
          {"label": "Table Design", "value": "table_design"},
        ],
        "label": "Furniture Design",
        "value": "furniture_design",
      },
    ],
  },
  "legalServices": {
    "id": "legal_services",
    "title": "Legal Services",
    "categories": [
      {
        "items": [
          {
            "label": "Property Sale Deed Drafting",
            "value": "property_sale_deed_drafting",
          },
          {
            "label": "Sale Agreement Review & Analysis",
            "value": "sale_agreement_review_analysis",
          },
          {
            "label": "Memorandum of Understanding (MOU) Drafting",
            "value": "memorandum_of_understanding_mou_drafting",
          },
          {
            "label": "Power of Attorney (POA) Registration",
            "value": "power_of_attorney_poa_registration",
          },
          {
            "label": "Will Registration & Probate Services",
            "value": "will_registration_probate_services",
          },
          {
            "label": "Gift Deed Drafting & Registration",
            "value": "gift_deed_drafting_registration",
          },
          {
            "label": "Letter of Administration Services",
            "value": "letter_of_administration_services",
          },
          {
            "label": "Legal Affidavits & Declarations",
            "value": "legal_affidavits_declarations",
          },
        ],
        "label": "Property Documentation & Drafting",
        "value": "property_documentation_drafting",
      },
      {
        "items": [
          {
            "label": "Property Registration Assistance",
            "value": "property_registration_assistance",
          },
          {
            "label": "Commercial Lease Agreement Registration",
            "value": "commercial_lease_agreement_registration",
          },
          {
            "label": "Residential Rent Agreement Services",
            "value": "residential_rent_agreement_services",
          },
          {
            "label": "Leave & License Agreement Drafting",
            "value": "leave_license_agreement_drafting",
          },
        ],
        "label": "Registration & Agreements",
        "value": "registration_agreements",
      },
      {
        "items": [
          {
            "label": "Property Title Search & Verification",
            "value": "property_title_search_verification",
          },
          {
            "label": "Property Litigation & Case Search",
            "value": "property_litigation_case_search",
          },
          {
            "label": "Complete Property Due Diligence & Verification",
            "value": "complete_property_due_diligence_verification",
          },
          {
            "label": "Legal Title Opinion Report",
            "value": "legal_title_opinion_report",
          },
          {
            "label": "Public Notice & No-Objection Certificate (NOC)",
            "value": "public_notice_no_objection_certificate_noc",
          },
          {
            "label": "Legal Court Record Verification",
            "value": "legal_court_record_verification",
          },
          {
            "label": "Encumbrance Certificate Assistance",
            "value": "encumbrance_certificate_assistance",
          },
          {
            "label": "Property Valuation Report",
            "value": "property_valuation_report",
          },
        ],
        "label": "Verification & Due Diligence",
        "value": "verification_due_diligence",
      },
      {
        "items": [
          {
            "label": "Property Document Review & Consultation",
            "value": "property_document_review_consultation",
          },
          {
            "label": "Expert Real Estate Legal Consultation (Call)",
            "value": "expert_real_estate_legal_consultation_call",
          },
          {
            "label": "RERA Complaint Filing & Advisory",
            "value": "rera_complaint_filing_advisory",
          },
          {
            "label": "Legal Notice & Dispute Resolution",
            "value": "legal_notice_dispute_resolution",
          },
          {
            "label": "Tenant Verification Services",
            "value": "tenant_verification_services",
          },
          {
            "label": "Home Loan Legal Opinion",
            "value": "home_loan_legal_opinion",
          },
          {
            "label": "Khata Transfer / Property Mutation",
            "value": "khata_transfer_property_mutation",
          },
        ],
        "label": "Legal Consultation & Advisory",
        "value": "legal_consultation_advisory",
      },
    ],
  },
};
