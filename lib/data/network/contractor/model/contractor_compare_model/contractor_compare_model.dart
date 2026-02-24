// Main Response Model
import '../../../../../app/utils/formater/formater.dart';

class ContractorDataResponse {
  final bool success;
  final String message;
  final ContractorData data;

  ContractorDataResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorDataResponse.fromJson(Map<String, dynamic> json) {
    return ContractorDataResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ContractorData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data.toMap(),
    };
  }
}

// Contractor Data Model
class ContractorData {
  final ContractorItem contractor;
  final Profile profile;
  final List<ServiceCategory> servicesByCategory;
  final int totalCategories;
  final int totalServices;
  final int totalActiveServices;

  ContractorData({
    required this.contractor,
    required this.profile,
    required this.servicesByCategory,
    required this.totalCategories,
    required this.totalServices,
    required this.totalActiveServices,
  });

  factory ContractorData.fromJson(Map<String, dynamic> json) {
    return ContractorData(
      contractor: ContractorItem.fromJson(json['contractor'] ?? {}),
      profile: Profile.fromJson(json['profile'] ?? {}),
      servicesByCategory: (json['servicesByCategory'] as List<dynamic>?)
          ?.map((e) => ServiceCategory.fromJson(e))
          .toList() ??
          [],
      totalCategories: json['totalCategories'] ?? 0,
      totalServices: json['totalServices'] ?? 0,
      totalActiveServices: json['totalActiveServices'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contractor': contractor.toMap(),
      'profile': profile.toMap(),
      'servicesByCategory': servicesByCategory.map((e) => e.toMap()).toList(),
      'totalCategories': totalCategories,
      'totalServices': totalServices,
      'totalActiveServices': totalActiveServices,
    };
  }
}

// Contractor Model
class ContractorItem {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String? city;
  final String? state;
  final String userType;
  final DateTime memberSince;

  ContractorItem({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.city,
    this.state,
    required this.userType,
    required this.memberSince,
  });

  factory ContractorItem.fromJson(Map<String, dynamic> json) {
    return ContractorItem(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'],
      state: json['state'],
      userType: json['userType'] ?? 'contractor',
      memberSince: json['memberSince'] != null
          ? DateTime.parse(json['memberSince'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'city': city,
      'state': state,
      'userType': userType,
      'memberSince': memberSince.toIso8601String(),
    };
  }
}

// Profile Model
class Profile {
  final int totalServices;
  final int activeServices;
  final double overallRating;
  final int totalReviews;
  final bool isBlocked;
  final int warningCount;
  final String contractorType;

  Profile( {
    required this.contractorType,
    required this.totalServices,
    required this.activeServices,
    required this.overallRating,
    required this.totalReviews,
    required this.isBlocked,
    required this.warningCount,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      contractorType:( json['contractorType']==null)? 'Not Provided': json['contractorType'],
      totalServices: json['totalServices'] ?? 0,
      activeServices: json['activeServices'] ?? 0,
      overallRating: (json['overallRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      isBlocked: json['isBlocked'] ?? false,
      warningCount: json['warningCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalServices': totalServices,
      'activeServices': activeServices,
      'overallRating': overallRating,
      'totalReviews': totalReviews,
      'isBlocked': isBlocked,
      'warningCount': warningCount,
    };
  }
}

// Service Category Model
class ServiceCategory {
  final String categoryId;
  final String categoryName;
  final String categoryDescription;
  final List<Service> services;
  final int totalServices;
  final int activeServices;
  final double avgRating;
  final int totalReviews;

  ServiceCategory({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
    required this.services,
    required this.totalServices,
    required this.activeServices,
    required this.avgRating,
    required this.totalReviews,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      categoryDescription: json['categoryDescription'] ?? '',
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => Service.fromJson(e))
          .toList() ??
          [],
      totalServices: json['totalServices'] ?? 0,
      activeServices: json['activeServices'] ?? 0,
      avgRating: (json['avgRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
      'services': services.map((e) => e.toMap()).toList(),
      'totalServices': totalServices,
      'activeServices': activeServices,
      'avgRating': avgRating,
      'totalReviews': totalReviews,
    };
  }
}

// Service Model
class Service {
  final String id;
  final String serviceName;
  final String description;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final ServiceMeta meta;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.rating,
    required this.totalReviews,
    required this.isActive,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      isActive: json['isActive'] ?? true,
      meta: ServiceMeta.fromJson(json['meta'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'description': description,
      'rating': rating,
      'totalReviews': totalReviews,
      'isActive': isActive,
      'meta': meta.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// Service Meta Model
/*class ServiceMeta {
  final double price;
  final String priceModel;
  final String startingPriceRange;
  final String workAvailability;
  final bool provideMaterials;
  final String? brandsUsed;
  final bool equipmentProvided;
  final bool insuranceAvailable;
  final List<String> acceptedPaymentModes;
  final int advanceRequiredPercentage;
  final String billingType;
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

  ServiceMeta({
    required this.price,
    required this.priceModel,
    required this.startingPriceRange,
    required this.workAvailability,
    required this.provideMaterials,
    this.brandsUsed,
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
    required this.equipmentProvided,
    required this.insuranceAvailable,
    required this.acceptedPaymentModes,
    required this.advanceRequiredPercentage,
    required this.billingType,
  });

  factory ServiceMeta.fromJson(Map<String, dynamic> json) {
    return ServiceMeta(
      price: (json['price'] ?? 0).toDouble(),
      priceModel: json['priceModel'] ?? 'fixed',
      startingPriceRange: json['startingPriceRange'] ?? '0',
      workAvailability: json['workAvailability'] ?? 'immediate',
      provideMaterials: json['provideMaterials'] ?? false,
      brandsUsed: json['brandsUsed'],
      equipmentProvided: json['equipmentProvided'] ?? false,
      insuranceAvailable: json['insuranceAvailable'] ?? false,
      acceptedPaymentModes: (json['acceptedPaymentModes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          ['cash'],
      advanceRequiredPercentage: json['advanceRequiredPercentage'] ?? 0,
      billingType: json['billingType'] ?? 'non_gst',
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

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'priceModel': priceModel,
      'startingPriceRange': startingPriceRange,
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
  }
}*/
class ServiceMeta {
  final String priceModel;
  final int minPrice;
  final int maxPrice;
  final int visitCharge;
  final String workAvailability;
  final bool provideMaterials;
  final String? brandsUsed;
  final bool equipmentProvided;
  final bool insuranceAvailable;
  final List<String>? acceptedPaymentModes;
  final int advanceRequiredPercentage;
  final String billingType;
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

  ServiceMeta({
    required this.priceModel,
    required this.minPrice,
    required this.maxPrice,
    required this.visitCharge,
    required this.workAvailability,
    required this.provideMaterials,
    this.brandsUsed,
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
    required this.equipmentProvided,
    required this.insuranceAvailable,
    required this.acceptedPaymentModes,
    required this.advanceRequiredPercentage,
    required this.billingType,
  });

  factory ServiceMeta.fromJson(Map<String, dynamic> json) {
    return ServiceMeta(
      priceModel: json['priceModel'],
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      visitCharge: json['visitCharge'],
      workAvailability: json['workAvailability'] ,
      provideMaterials: json['provideMaterials'] ,
      brandsUsed: json['brandsUsed'],
      equipmentProvided: json['equipmentProvided'],
      insuranceAvailable: json['insuranceAvailable'],
      acceptedPaymentModes:
      (json['acceptedPaymentModes'] as List?)?.cast<String>(),
      advanceRequiredPercentage: json['advanceRequiredPercentage'],
      billingType: json['billingType'] ?? 'non_gst',
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
      fabricationWork: (json['fabricationWork'] as List?)?.cast<String>(),
      threeDDesign: json['threeDDesign'],
      modularKitchen: json['modularKitchen'],
      boreAndPump: json['boreAndPump'],
      securitySystems: json['securitySystems'],
      homeAutomation: json['homeAutomation'],
      solarSolutions: json['solarSolutions'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'priceModel': priceModel,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
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

    data.removeWhere((key, value) => value == null);

    return data;
  }

  /// Helper getter matching ContractorMetaData pattern
  String get priceRange {
    if (minPrice == 0 && maxPrice == 0) {
      return 'No Price Range';
    } else {
      return Formatter.formatPriceRange(minPrice, maxPrice);
    }
  }
}

