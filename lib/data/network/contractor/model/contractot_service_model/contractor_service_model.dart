import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/propert_detail/view/property_details.dart';

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
  final int? advanceRequiredPercentage;
  final String? billingType;

  // Optional lists
  final List<String>? cementBrand;
  final List<String>? steelBrand;
  final List<String>? brickType;
  final List<String>? sandSource;
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
    this.electricalWiresBrand,
    this.electricalSwitchesBrand,
    this.plumbingPipesBrand,
    this.sanitaryFittingsBrand,
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
      plumbingPipesBrand:
      (json['plumbingPipesBrand'] as List?)?.cast<String>(),
      sanitaryFittingsBrand:
      (json['sanitaryFittingsBrand'] as List?)?.cast<String>(),
      waterTankBrand: (json['waterTankBrand'] as List?)?.cast<String>(),
      flooringTilesBrand:
      (json['flooringTilesBrand'] as List?)?.cast<String>(),
      interiorPaintBrand:
      (json['interiorPaintBrand'] as List?)?.cast<String>(),
      exteriorPaintBrand:
      (json['exteriorPaintBrand'] as List?)?.cast<String>(),
      doorsType: (json['doorsType'] as List?)?.cast<String>(),
      windowsType: (json['windowsType'] as List?)?.cast<String>(),
      structure: (json['structure'] as List?)?.cast<String>(),
      plasterType: (json['plasterType'] as List?)?.cast<String>(),
      waterproofing: (json['waterproofing'] as List?)?.cast<String>(),
      chokhatType: (json['chokhatType'] as List?)?.cast<String>(),
      railingType: (json['railingType'] as List?)?.cast<String>(),
      falseCeiling: (json['falseCeiling'] as List?)?.cast<String>(),
      fabricationWork:
      (json['fabricationWork'] as List?)?.cast<String>(),
      threeDDesign: json['threeDDesign'],
      modularKitchen: json['modularKitchen'],
      boreAndPump: json['boreAndPump'],
      securitySystems: json['securitySystems'],
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

      'cementBrand': cementBrand,
      'steelBrand': steelBrand,
      'brickType': brickType,
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

