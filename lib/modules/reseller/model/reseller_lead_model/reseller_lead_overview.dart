import 'package:nesticope_app/data/network/property/models/property_model.dart';

class ResellerLeadOverview {
  String id;
  String createdBy;
  String? updatedBy;
  String name;
  String email;
  String phone;
  String propertyId;
  String resellerId;
  String source;
  String status;
  String stage;
  String? notes;
  DateTime? lastContactedAt;
  bool isFake;
  String? fakeReason;
  String? markedFakeBy;
  DateTime? markedFakeAt;
  Items customFields;
  DateTime createdAt;
  DateTime updatedAt;

  ResellerLeadOverview({
    required this.id,
    required this.createdBy,
    this.updatedBy,
    required this.name,
    required this.email,
    required this.phone,
    required this.propertyId,
    required this.resellerId,
    required this.source,
    required this.status,
    required this.stage,
    this.notes,
    this.lastContactedAt,
    required this.isFake,
    this.fakeReason,
    this.markedFakeBy,
    this.markedFakeAt,
    required this.customFields,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResellerLeadOverview.fromJson(Map<String, dynamic> json) {
    return ResellerLeadOverview(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      propertyId: json['property_id'],
      resellerId: json['reseller_id'],
      source: json['source'],
      status: json['status'],
      stage: json['stage'],
      notes: json['notes'],
      lastContactedAt:
          json['lastContactedAt'] != null
              ? DateTime.parse(json['lastContactedAt'])
              : null,
      isFake: json['isFake'],
      fakeReason: json['fakeReason'],
      markedFakeBy: json['markedFakeBy'],
      markedFakeAt:
          json['markedFakeAt'] != null
              ? DateTime.parse(json['markedFakeAt'])
              : null,
      customFields: Items.fromJson(json['customFields']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'name': name,
      'email': email,
      'phone': phone,
      'property_id': propertyId,
      'reseller_id': resellerId,
      'source': source,
      'status': status,
      'stage': stage,
      'notes': notes,
      'lastContactedAt': lastContactedAt?.toIso8601String(),
      'isFake': isFake,
      'fakeReason': fakeReason,
      'markedFakeBy': markedFakeBy,
      'markedFakeAt': markedFakeAt?.toIso8601String(),
      'customFields': customFields.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ResellerLeadCustomFields {
  String city;
  String type;
  String state;
  String title;
  String address;
  String zipCode;
  String builderName;
  String listingType;
  String projectName;
  String propertyType;
  ResellerLeadPropertyDetails propertyDetails;

  ResellerLeadCustomFields({
    required this.city,
    required this.type,
    required this.state,
    required this.title,
    required this.address,
    required this.zipCode,
    required this.builderName,
    required this.listingType,
    required this.projectName,
    required this.propertyType,
    required this.propertyDetails,
  });

  factory ResellerLeadCustomFields.fromJson(Map<String, dynamic> json) {
    return ResellerLeadCustomFields(
      city: json['city'],
      type: json['type'],
      state: json['state'],
      title: json['title'],
      address: json['address'],
      zipCode: json['zipCode'],
      builderName: json['builderName'],
      listingType: json['listingType'],
      projectName: json['projectName'],
      propertyType: json['propertyType'],
      propertyDetails: ResellerLeadPropertyDetails.fromJson(
        json['propertyDetails'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'type': type,
      'state': state,
      'title': title,
      'address': address,
      'zipCode': zipCode,
      'builderName': builderName,
      'listingType': listingType,
      'projectName': projectName,
      'propertyType': propertyType,
      'propertyDetails': propertyDetails.toJson(),
    };
  }
}

class ResellerLeadPropertyDetails {
  int bhk;
  int balcony;
  int bathroom;
  List<String> amenities;
  String zoneType;
  ResellerLeadFloorInfo floorInfo;
  ResellerLeadFurnishInfo furnishInfo;
  ResellerLeadParkingInfo parkingInfo;
  ResellerLeadFinancialInfo financialInfo;
  ResellerLeadPossessionInfo possessionInfo;
  String propertyFacing;
  String propertyCondition;
  double propertyCarpetArea;
  double propertyBuiltUpArea;

  ResellerLeadPropertyDetails({
    required this.bhk,
    required this.balcony,
    required this.bathroom,
    required this.amenities,
    required this.zoneType,
    required this.floorInfo,
    required this.furnishInfo,
    required this.parkingInfo,
    required this.financialInfo,
    required this.possessionInfo,
    required this.propertyFacing,
    required this.propertyCondition,
    required this.propertyCarpetArea,
    required this.propertyBuiltUpArea,
  });

  factory ResellerLeadPropertyDetails.fromJson(Map<String, dynamic> json) {
    return ResellerLeadPropertyDetails(
      bhk: json['bhk'],
      balcony: json['balcony'],
      bathroom: json['bathroom'],
      amenities: List<String>.from(json['amenities']),
      zoneType: json['zone_type'],
      floorInfo: ResellerLeadFloorInfo.fromJson(json['floor_info']),
      furnishInfo: ResellerLeadFurnishInfo.fromJson(json['furnish_info']),
      parkingInfo: ResellerLeadParkingInfo.fromJson(json['parking_info']),
      financialInfo: ResellerLeadFinancialInfo.fromJson(json['financial_info']),
      possessionInfo: ResellerLeadPossessionInfo.fromJson(
        json['possession_info'],
      ),
      propertyFacing: json['property_facing'],
      propertyCondition: json['property_condition'],
      propertyCarpetArea: json['property_carpet_area'].toDouble(),
      propertyBuiltUpArea: json['property_built_up_area'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bhk': bhk,
      'balcony': balcony,
      'bathroom': bathroom,
      'amenities': amenities,
      'zone_type': zoneType,
      'floor_info': floorInfo.toJson(),
      'furnish_info': furnishInfo.toJson(),
      'parking_info': parkingInfo.toJson(),
      'financial_info': financialInfo.toJson(),
      'possession_info': possessionInfo.toJson(),
      'property_facing': propertyFacing,
      'property_condition': propertyCondition,
      'property_carpet_area': propertyCarpetArea,
      'property_built_up_area': propertyBuiltUpArea,
    };
  }
}

// The remaining classes (FloorInfo, FurnishInfo, FurnishDetails, ParkingInfo, FinancialInfo, PossessionInfo) will also follow the same pattern:

class ResellerLeadFloorInfo {
  int floorNumber;
  int totalFloors;

  ResellerLeadFloorInfo({required this.floorNumber, required this.totalFloors});

  factory ResellerLeadFloorInfo.fromJson(Map<String, dynamic> json) {
    return ResellerLeadFloorInfo(
      floorNumber: json['floor_number'],
      totalFloors: json['total_floors'],
    );
  }

  Map<String, dynamic> toJson() => {
    'floor_number': floorNumber,
    'total_floors': totalFloors,
  };
}

class ResellerLeadFurnishInfo {
  String furnishType;
  ResellerLeadFurnishDetails furnishDetails;

  ResellerLeadFurnishInfo({
    required this.furnishType,
    required this.furnishDetails,
  });

  factory ResellerLeadFurnishInfo.fromJson(Map<String, dynamic> json) {
    return ResellerLeadFurnishInfo(
      furnishType: json['furnish_type'],
      furnishDetails: ResellerLeadFurnishDetails.fromJson(
        json['furnish_details'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'furnish_type': furnishType,
    'furnish_details': furnishDetails.toJson(),
  };
}

class ResellerLeadFurnishDetails {
  int bed;
  int fan;
  String other;
  bool balcony;
  bool kitchen;
  bool bathroom;

  ResellerLeadFurnishDetails({
    required this.bed,
    required this.fan,
    required this.other,
    required this.balcony,
    required this.kitchen,
    required this.bathroom,
  });

  factory ResellerLeadFurnishDetails.fromJson(Map<String, dynamic> json) {
    return ResellerLeadFurnishDetails(
      bed: json['bed'],
      fan: json['fan'],
      other: json['other'],
      balcony: json['balcony'],
      kitchen: json['kitchen'],
      bathroom: json['bathroom'],
    );
  }

  Map<String, dynamic> toJson() => {
    'bed': bed,
    'fan': fan,
    'other': other,
    'balcony': balcony,
    'kitchen': kitchen,
    'bathroom': bathroom,
  };
}

class ResellerLeadParkingInfo {
  bool openParking;
  bool coveredParking;

  ResellerLeadParkingInfo({
    required this.openParking,
    required this.coveredParking,
  });

  factory ResellerLeadParkingInfo.fromJson(Map<String, dynamic> json) {
    return ResellerLeadParkingInfo(
      openParking: json['open_parking'],
      coveredParking: json['covered_parking'],
    );
  }

  Map<String, dynamic> toJson() => {
    'open_parking': openParking,
    'covered_parking': coveredParking,
  };
}

class ResellerLeadFinancialInfo {
  bool negotiable;
  double propertyPrice;
  double brokerCommission;

  ResellerLeadFinancialInfo({
    required this.negotiable,
    required this.propertyPrice,
    required this.brokerCommission,
  });

  factory ResellerLeadFinancialInfo.fromJson(Map<String, dynamic> json) {
    return ResellerLeadFinancialInfo(
      negotiable: json['negotiable'],
      propertyPrice: json['property_price'].toDouble(),
      brokerCommission: json['broker_commission'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'negotiable': negotiable,
    'property_price': propertyPrice,
    'broker_commission': brokerCommission,
  };
}

class ResellerLeadPossessionInfo {
  String possessionStatus;
  int propertyAgeInYears;

  ResellerLeadPossessionInfo({
    required this.possessionStatus,
    required this.propertyAgeInYears,
  });

  factory ResellerLeadPossessionInfo.fromJson(Map<String, dynamic> json) {
    return ResellerLeadPossessionInfo(
      possessionStatus: json['possession_status'],
      propertyAgeInYears: json['property_age_in_years'],
    );
  }

  Map<String, dynamic> toJson() => {
    'possession_status': possessionStatus,
    'property_age_in_years': propertyAgeInYears,
  };
}
