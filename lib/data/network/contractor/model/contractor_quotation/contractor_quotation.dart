//
// class ContractorQuotation {
//   final String id;
//   final String createdBy;
//   final String? updatedBy;
//   final String relatedId;
//   final QuotationUser user;
//   final String price;
//   final String status;
//   final QuotationMeta meta;
//   final bool isConverted;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   ContractorQuotation({
//     required this.id,
//     required this.createdBy,
//     this.updatedBy,
//     required this.relatedId,
//     required this.user,
//     required this.price,
//     required this.status,
//     required this.meta,
//     required this.isConverted,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory ContractorQuotation.fromMap(Map<String, dynamic> map) {
//     return ContractorQuotation(
//       id: map['id'] ?? '',
//       createdBy: map['created_by'] ?? '',
//       updatedBy: map['updated_by'],
//       relatedId: map['related_id'] ?? '',
//       user: map['user'] != null
//           ? QuotationUser.fromMap(map['user'])
//           : throw Exception('User is missing in quotation ${map['id']}'),
//       price: map['price'] ?? '0',
//       status: map['status'] ?? '',
//       meta: map['meta'] != null
//           ? QuotationMeta.fromMap(map['meta'])
//           : QuotationMeta.empty(),
//       isConverted: map['is_converted'] ?? false,
//       createdAt: DateTime.parse(map['created_at']),
//       updatedAt: DateTime.parse(map['updated_at']),
//     );
//   }
//
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'created_by': createdBy,
//       'updated_by': updatedBy,
//       'related_id': relatedId,
//       'user': user.toMap(),
//       'price': price,
//       'status': status,
//       'meta': meta.toMap(),
//       'is_converted': isConverted,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }
class QuotationUser {
  final String id;
  final String name;
  final String email;
  final String phone;

  QuotationUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory QuotationUser.fromMap(Map<String, dynamic> map) {
    return QuotationUser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
// class QuotationMeta {
//   final String notes;
//   final PropertyDetails? propertyDetails;
//   final String serviceNames;
//
//   QuotationMeta({
//     required this.notes,
//     required this.propertyDetails,
//     required this.serviceNames,
//   });
//
//   factory QuotationMeta.fromMap(Map<String, dynamic> map) {
//     return QuotationMeta(
//       notes: map['notes'] ?? '',
//       propertyDetails: map['propertyDetails'] != null
//           ? PropertyDetails.fromMap(
//         map['propertyDetails'] as Map<String, dynamic>,
//       )
//           : null,
//       serviceNames: map['serviceNames'] ?? '',
//     );
//   }
//
//   factory QuotationMeta.empty() {
//     return QuotationMeta(
//       notes: '',
//       propertyDetails: null,
//       serviceNames: '',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'notes': notes,
//       'propertyDetails': propertyDetails?.toMap(),
//       'serviceNames': serviceNames,
//     };
//   }
// }
//
// class PropertyDetails {
//   final String propertyType;
//   final String city;
//   final String location;
//   final String state;
//   final int carpetArea;
//   final int? bhk;
//   final String serviceDescription;
//
//   PropertyDetails({
//     required this.propertyType,
//     required this.city,
//     required this.location,
//     required this.state,
//     required this.carpetArea,
//     this.bhk,
//     required this.serviceDescription,
//   });
//   factory PropertyDetails.fromMap(Map<String, dynamic> map) {
//     return PropertyDetails(
//       propertyType: map['propertyType'] ?? '',
//       city: map['city'] ?? '',
//       location: map['location'] ?? '',
//       state: map['state'] ?? '',
//       carpetArea: map['carpetArea'] ?? 0,
//       bhk: map['bhk'],
//       serviceDescription: map['serviceDescription'] ?? '',
//     );
//   }
//
//
//   Map<String, dynamic> toMap() {
//     return {
//       'propertyType': propertyType,
//       'city': city,
//       'location': location,
//       'state': state,
//       'carpetArea': carpetArea,
//       'bhk': bhk,
//       'serviceDescription': serviceDescription,
//     };
//   }
// }

class ContractorQuotation {
  final String id;
  final String createdBy;
  final String? updatedBy;
  final String relatedId;
  final QuotationUser user;
  final String price;
  final String status;
  final String quotationNumber;
  final QuotationMeta meta;
  final bool isConverted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContractorQuotation({
    required this.id,
    required this.createdBy,
    this.updatedBy,
    required this.quotationNumber,
    required this.relatedId,
    required this.user,
    required this.price,
    required this.status,
    required this.meta,

    required this.isConverted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContractorQuotation.fromMap(Map<String, dynamic> map) {
    return ContractorQuotation(
      id: map['id'] ?? '',
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'],
      relatedId: map['related_id'] ?? '',
      quotationNumber: map['quotation_number'] ?? '',
      user: QuotationUser.fromMap(
        map['user'] as Map<String, dynamic>,
      ),
      price: map['price']?.toString() ?? '0',
      status: map['status'] ?? '',
      meta: map['meta'] != null
          ? QuotationMeta.fromMap(
        map['meta'] as Map<String, dynamic>,
      )
          : QuotationMeta.empty(),
      isConverted: map['is_converted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'related_id': relatedId,
      'user': user.toMap(),
      'price': price,
      'status': status,
      'quotation_number':quotationNumber,
      'meta': meta.toMap(),
      'is_converted': isConverted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
/*class QuotationMeta {
  final String notes;
  final PropertyDetails? propertyDetails;
  final List<InquiryService>? inquiryServices;
  final String? serviceNames;

  QuotationMeta({
    required this.notes,
    this.propertyDetails,
    this.inquiryServices,
    this.serviceNames,
  });

  factory QuotationMeta.fromMap(Map<String, dynamic> map) {
    return QuotationMeta(
      notes: map['notes'] ?? '',
      propertyDetails: map['propertyDetails'] != null
          ? PropertyDetails.fromMap(
        map['propertyDetails'] as Map<String, dynamic>,
      )
          : null,
      inquiryServices: map['inquiryServices'] != null
          ? (map['inquiryServices'] as List)
          .map(
            (e) => InquiryService.fromMap(
          e as Map<String, dynamic>,
        ),
      )
          .toList()
          : null,
      serviceNames: map['serviceNames'],
    );
  }

  factory QuotationMeta.empty() {
    return QuotationMeta(
      notes: '',
      propertyDetails: null,
      inquiryServices: null,
      serviceNames: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
      'propertyDetails': propertyDetails?.toMap(),
      'inquiryServices':
      inquiryServices?.map((e) => e.toMap()).toList(),
      'serviceNames': serviceNames,
    };
  }
}*/
class QuotationMeta {
  final String notes;
  final double? originalPrice;
  final String inquiryCustomerId;
  final DateTime expectedStartDate;
  final PropertyDetails? propertyDetails;
  final List<InquiryService> inquiryServices;
  final String serviceNames;
  final int advanceRequiredPercentage;
  final ReferralInfo? referralInfo;

  // New fields for brands and types
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
  final List<String>? fabricationWork;
  final List<String>? structure;
  final List<String>? plasterType;
  final List<String>? waterproofing;
  final List<String>? chokhatType;
  final List<String>? railingType;
  final List<String>? falseCeiling;
  final String? modularKitchen;
  final String? boreAndPump;
  final String? securitySystems;
  final String? homeAutomation;
  final String? solarSolutions;
  final String? design3D;

  QuotationMeta({
    required this.notes,
    this.originalPrice,
    required this.inquiryCustomerId,
    required this.expectedStartDate,
    required this.propertyDetails,
    required this.inquiryServices,
    required this.serviceNames,
    required this.advanceRequiredPercentage,
    required this.referralInfo,
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
    this.design3D,
    this.fabricationWork,
    this.structure,
    this.plasterType,
    this.waterproofing,
    this.chokhatType,
    this.railingType,
    this.falseCeiling,
    this.modularKitchen,
    this.boreAndPump,
    this.securitySystems,
    this.homeAutomation,
    this.solarSolutions,
  });

  factory QuotationMeta.fromMap(Map<String, dynamic> map) {
    return QuotationMeta(
     /* notes: map['notes'],
      originalPrice: map['originalPrice']?.toDouble(),
      inquiryCustomerId: map['inquiryCustomerId'],
      expectedStartDate: DateTime.parse(map['expectedStartDate']),
      propertyDetails: PropertyDetails.fromMap(map['propertyDetails']),
      inquiryServices: List<InquiryService>.from(
          map['inquiryServices']?.map((x) => InquiryService.fromMap(x)) ?? []),
      serviceNames: map['serviceNames'],
      advanceRequiredPercentage: map['advanceRequiredPercentage']??0,
      referralInfo: ReferralInfo.fromMap(map['referralInfo']),

      // Map all brand/type lists
      cementBrand: List<String>.from(map['cementBrand'] ?? []),
      steelBrand: List<String>.from(map['steelBrand'] ?? []),
      brickType: List<String>.from(map['brickType'] ?? []),
      sandSource: List<String>.from(map['sandSource'] ?? []),
      electricalWiresBrand: List<String>.from(map['electricalWiresBrand'] ?? []),
      electricalSwitchesBrand: List<String>.from(map['electricalSwitchesBrand'] ?? []),
      plumbingPipesBrand: List<String>.from(map['plumbingPipesBrand'] ?? []),
      sanitaryFittingsBrand: List<String>.from(map['sanitaryFittingsBrand'] ?? []),
      waterTankBrand: List<String>.from(map['waterTankBrand'] ?? []),
      flooringTilesBrand: List<String>.from(map['flooringTilesBrand'] ?? []),
      interiorPaintBrand: List<String>.from(map['interiorPaintBrand'] ?? []),
      exteriorPaintBrand: List<String>.from(map['exteriorPaintBrand'] ?? []),
      doorsType: List<String>.from(map['doorsType'] ?? []),
      windowsType: List<String>.from(map['windowsType'] ?? []),
      fabricationWork: List<String>.from(map['fabricationWork'] ?? []),
      structure: List<String>.from(map['structure'] ?? []),
      plasterType: List<String>.from(map['plasterType'] ?? []),
      waterproofing: List<String>.from(map['waterproofing'] ?? []),
      chokhatType: List<String>.from(map['chokhatType'] ?? []),
      railingType: List<String>.from(map['railingType'] ?? []),
      falseCeiling: List<String>.from(map['falseCeiling'] ?? []),*/
      notes: map['notes'] ?? '',
      originalPrice: map['originalPrice']?.toDouble(),
      inquiryCustomerId: map['inquiryCustomerId'] ?? '',
      expectedStartDate: map['expectedStartDate'] != null
          ? DateTime.parse(map['expectedStartDate'])
          : DateTime.now(),
      propertyDetails: map['propertyDetails'] != null
          ? PropertyDetails.fromMap(map['propertyDetails'])
          : null,
      inquiryServices: map['inquiryServices'] != null
          ? List<InquiryService>.from(
          map['inquiryServices']?.map((x) => InquiryService.fromMap(x)) ?? [])
          : [],
      serviceNames: map['serviceNames'] ?? '',
      advanceRequiredPercentage: map['advanceRequiredPercentage'] ?? 0,
      referralInfo: map['referralInfo'] != null
          ? ReferralInfo.fromMap(map['referralInfo'])
          : null,

      // Map all brand/type lists
      cementBrand: map['cementBrand'] != null ? List<String>.from(map['cementBrand']) : [],
      steelBrand: map['steelBrand'] != null ? List<String>.from(map['steelBrand']) : [],
      brickType: map['brickType'] != null ? List<String>.from(map['brickType']) : [],
      sandSource: map['sandSource'] != null ? List<String>.from(map['sandSource']) : [],
      electricalWiresBrand: map['electricalWiresBrand'] != null ? List<String>.from(map['electricalWiresBrand']) : [],
      electricalSwitchesBrand: map['electricalSwitchesBrand'] != null ? List<String>.from(map['electricalSwitchesBrand']) : [],
      plumbingPipesBrand: map['plumbingPipesBrand'] != null ? List<String>.from(map['plumbingPipesBrand']) : [],
      sanitaryFittingsBrand: map['sanitaryFittingsBrand'] != null ? List<String>.from(map['sanitaryFittingsBrand']) : [],
      waterTankBrand: map['waterTankBrand'] != null ? List<String>.from(map['waterTankBrand']) : [],
      flooringTilesBrand: map['flooringTilesBrand'] != null ? List<String>.from(map['flooringTilesBrand']) : [],
      interiorPaintBrand: map['interiorPaintBrand'] != null ? List<String>.from(map['interiorPaintBrand']) : [],
      exteriorPaintBrand: map['exteriorPaintBrand'] != null ? List<String>.from(map['exteriorPaintBrand']) : [],
      doorsType: map['doorsType'] != null ? List<String>.from(map['doorsType']) : [],
      windowsType: map['windowsType'] != null ? List<String>.from(map['windowsType']) : [],
      fabricationWork: map['fabricationWork'] != null ? List<String>.from(map['fabricationWork']) : [],
      structure: map['structure'] != null ? List<String>.from(map['structure']) : [],
      plasterType: map['plasterType'] != null ? List<String>.from(map['plasterType']) : [],
      waterproofing: map['waterproofing'] != null ? List<String>.from(map['waterproofing']) : [],
      chokhatType: map['chokhatType'] != null ? List<String>.from(map['chokhatType']) : [],
      railingType: map['railingType'] != null ? List<String>.from(map['railingType']) : [],
      falseCeiling: map['falseCeiling'] != null ? List<String>.from(map['falseCeiling']) : [],
      modularKitchen: map['modularKitchen'],
      boreAndPump: map['boreAndPump'],
      securitySystems: map['securitySystems'],
      homeAutomation: map['homeAutomation'],
      solarSolutions: map['solarSolutions'],
      design3D: map['threeDDesign'],
    );
  }
  factory QuotationMeta.empty() {
    return QuotationMeta(
      notes: '',
      originalPrice: null,
      inquiryCustomerId: '',
      expectedStartDate: DateTime.now(),
      propertyDetails: null,
      inquiryServices: [],
      serviceNames: '',
      advanceRequiredPercentage: 0,
      referralInfo: null,
      cementBrand: [],
      steelBrand: [],
      brickType: [],
      sandSource: [],
      electricalWiresBrand: [],
      electricalSwitchesBrand: [],
      plumbingPipesBrand: [],
      sanitaryFittingsBrand: [],
      waterTankBrand: [],
      flooringTilesBrand: [],
      interiorPaintBrand: [],
      exteriorPaintBrand: [],
      doorsType: [],
      windowsType: [],
      fabricationWork: [],
      structure: [],
      plasterType: [],
      waterproofing: [],
      chokhatType: [],
      railingType: [],
      falseCeiling: [],
      modularKitchen: '',
      boreAndPump: '',
      securitySystems: '',
      homeAutomation: '',
      solarSolutions: '',
      design3D: ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
      'originalPrice': originalPrice,
      'inquiryCustomerId': inquiryCustomerId,
      'expectedStartDate': expectedStartDate.toIso8601String(),
      'propertyDetails': propertyDetails?.toMap(),
      'inquiryServices': inquiryServices.map((x) => x.toMap()).toList(),
      'serviceNames': serviceNames,
      'advanceRequiredPercentage': advanceRequiredPercentage,
      'referralInfo': referralInfo?.toMap(),
      'cementBrand': cementBrand,
      'steelBrand': steelBrand,
      'brickType': brickType,
      'sandSource': sandSource,
      'electricalWiresBrand': electricalWiresBrand,
      'electricalSwitchesBrand': electricalSwitchesBrand,
      'plumbingPipesBrand': plumbingPipesBrand,
      'sanitaryFittingsBrand': sanitaryFittingsBrand,
      'threeDDesign':design3D,
      'waterTankBrand': waterTankBrand,
      'flooringTilesBrand': flooringTilesBrand,
      'interiorPaintBrand': interiorPaintBrand,
      'exteriorPaintBrand': exteriorPaintBrand,
      'doorsType': doorsType,
      'windowsType': windowsType,
      'fabricationWork': fabricationWork,
      'structure': structure,
      'plasterType': plasterType,
      'waterproofing': waterproofing,
      'chokhatType': chokhatType,
      'railingType': railingType,
      'falseCeiling': falseCeiling,
      'modularKitchen': modularKitchen,
      'boreAndPump': boreAndPump,
      'securitySystems': securitySystems,
      'homeAutomation': homeAutomation,
      'solarSolutions': solarSolutions,
    };
  }
}

class InquiryService {
  final String serviceId;
  final String serviceName;

  InquiryService({
    required this.serviceId,
    required this.serviceName,
  });

  factory InquiryService.fromMap(Map<String, dynamic> map) {
    return InquiryService(
      serviceId: map['serviceId'] ?? '',
      serviceName: map['serviceName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
    };
  }
}
class PropertyDetails {
  final String propertyType;
  final String city;
  final String location;
  final String state;
  final int carpetArea;
  final int? bhk;
  final String serviceDescription;

  PropertyDetails({
    required this.propertyType,
    required this.city,
    required this.location,
    required this.state,
    required this.carpetArea,
    this.bhk,
    required this.serviceDescription,
  });

  factory PropertyDetails.fromMap(Map<String, dynamic> map) {
    return PropertyDetails(
      propertyType: map['propertyType'] ?? '',
      city: map['city'] ?? '',
      location: map['location'] ?? '',
      state: map['state'] ?? '',
      carpetArea: map['carpetArea'] ?? 0,
      bhk: map['bhk'],
      serviceDescription: map['serviceDescription'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propertyType': propertyType,
      'city': city,
      'location': location,
      'state': state,
      'carpetArea': carpetArea,
      'bhk': bhk,
      'serviceDescription': serviceDescription,
    };
  }
}
class ReferralInfo {
  final String userId;
  final String userType;
  final int totalReferralPoints;
  final int pointsUsed;
  final double discountApplied;
  final double discountedPrice;

  ReferralInfo({
    required this.userId,
    required this.userType,
    required this.totalReferralPoints,
    required this.pointsUsed,
    required this.discountApplied,
    required this.discountedPrice,
  });

  factory ReferralInfo.fromMap(Map<String, dynamic> map) {
    return ReferralInfo(
      userId: map['userId'] ?? '',
      // default empty string
      userType: map['userType'] ?? '',
      totalReferralPoints: map['totalReferralPoints'] ?? 0,
      // default 0
      pointsUsed: map['pointsUsed'] ?? 0,
      // default 0
      discountApplied: (map['discountApplied'] ?? 0).toDouble(),
      discountedPrice: (map['discountedPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userType': userType,
      'totalReferralPoints': totalReferralPoints,
      'pointsUsed': pointsUsed,
      'discountApplied': discountApplied,
      'discountedPrice': discountedPrice,
    };
  }
}