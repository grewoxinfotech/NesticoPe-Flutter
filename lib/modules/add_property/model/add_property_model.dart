class AddPropertyModel {
  PropertyMedia? propertyMedia;
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? title;
  final String? type;
  final String? listingType;
  final String? propertyType;
  final String? propertyDescription;
  final PropertyDetails? propertyDetails;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? location;
  final String? reraId;
  final String? propertyStatus;
  final String? builderName;
  final String? projectName;
  final String? ownerPhone;
  final String? ownerName;
  final String? ownerEmail;

  AddPropertyModel({
    this.propertyMedia,
    this.id,
    this.createdBy,
    this.updatedBy,
    this.title,
    this.type,
    this.listingType,
    this.propertyType,
    this.propertyDescription,
    this.propertyDetails,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.location,
    this.reraId,
    this.propertyStatus,
    this.builderName,
    this.projectName,
    this.ownerPhone,
    this.ownerName,
    this.ownerEmail,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (propertyMedia != null) data['propertyMedia'] = propertyMedia!.toJson();
    if (id != null) data['id'] = id;
    if (createdBy != null) data['created_by'] = createdBy;
    if (updatedBy != null) data['updated_by'] = updatedBy;
    if (title != null) data['title'] = title;
    if (type != null) data['type'] = type;
    if (listingType != null) data['listingType'] = listingType;
    if (propertyType != null) data['propertyType'] = propertyType;
    if (propertyDescription != null)
      data['propertyDescription'] = propertyDescription;
    if (propertyDetails != null)
      data['propertyDetails'] = propertyDetails!.toJson();
    if (address != null) data['address'] = address;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (zipCode != null) data['zipCode'] = zipCode;
    if (location != null) data['location'] = location;
    if (reraId != null) data['reraId'] = reraId;
    if (propertyStatus != null) data['property_status'] = propertyStatus;
    if (builderName != null) data['builderName'] = builderName;
    if (projectName != null) data['projectName'] = projectName;
    if (ownerPhone != null) data['ownerPhone'] = ownerPhone;
    if (ownerName != null) data['ownerName'] = ownerName;
    if (ownerEmail != null) data['ownerEmail'] = ownerEmail;

    return data;
  }
}

class PropertyDetails {
  final PgInfo? pgInfo;
  final int? bhk;
  final int? balcony;
  final int? bathroom;
  final String? zoneType;
  final List<String>? amenities;
  final FloorInfo? floorInfo;
  final PropertyFurnishInfo? furnishInfo;
  final ParkingInfo? parkingInfo;
  final FinancialInfo? financialInfo;
  final PossessionInfo? possessionInfo;
  final String? propertyFacing;
  final double? propertyCarpetArea;
  final double? propertyBuiltUpArea;
  final String? propertyCondition;
  final String? propertyCarpetAreaUnit;
  final String? propertyBuiltUpAreaUnit;
  final PlotInfo? plotInfo;
  final bool? petFriendly;
  final FacilitiesInfo? facilitiesInfo;
  final LiftInfo? lifInfo;
  final bool? serventRoom;
  final String? transactionType;

  PropertyDetails({
    this.pgInfo,
    this.bhk,
    this.balcony,
    this.bathroom,
    this.amenities,
    this.floorInfo,
    this.furnishInfo,
    this.parkingInfo,
    this.financialInfo,
    this.possessionInfo,
    this.propertyFacing,
    this.propertyCarpetArea,
    this.propertyBuiltUpArea,
    this.propertyCarpetAreaUnit,
    this.propertyBuiltUpAreaUnit,
    this.plotInfo,
    this.zoneType,
    this.facilitiesInfo,
    this.propertyCondition,
    this.petFriendly,
    this.lifInfo,
    this.serventRoom,
    this.transactionType,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (pgInfo != null) data['pg_info'] = pgInfo!.toJson();
    if (bhk != null) data['bhk'] = bhk;
    if (balcony != null) data['balcony'] = balcony;
    if (bathroom != null) data['bathroom'] = bathroom;
    if (amenities != null) data['amenities'] = amenities;
    if (floorInfo != null) data['floor_info'] = floorInfo!.toJson();
    if (furnishInfo != null)
      data['property_furnish_info'] = furnishInfo!.toJson();
    if (parkingInfo != null) data['parking_info'] = parkingInfo!.toJson();
    if (financialInfo != null) data['financial_info'] = financialInfo!.toJson();
    if (possessionInfo != null)
      data['possession_info'] = possessionInfo!.toJson(); // ← new
    if (propertyFacing != null) data['property_facing'] = propertyFacing;
    if (propertyCarpetArea != null)
      data['property_carpet_area'] = propertyCarpetArea;
    if (propertyBuiltUpArea != null)
      data['property_built_up_area'] = propertyBuiltUpArea;
    if (propertyCarpetAreaUnit != null)
      data['property_carpet_area_unit'] = removeDots(propertyCarpetAreaUnit!);
    if (propertyBuiltUpAreaUnit != null)
      data['property_built_up_area_unit'] = removeDots(
        propertyBuiltUpAreaUnit!,
      );
    if (plotInfo != null) data['plot_info'] = plotInfo;
    if (zoneType != null) data['zone_type'] = zoneType!.toLowerCase();
    if (facilitiesInfo != null) data['facilities_info'] = facilitiesInfo;
    if (propertyCondition != null)
      data['property_condition'] = propertyCondition;
    if (petFriendly != null) data['"pet_friendly"'] = petFriendly;
    if (lifInfo != null) data['lift_info'] = lifInfo;
    if (serventRoom != null) data['servant_room'] = serventRoom;
    if (transactionType != null) data['transaction_type'] = transactionType;

    return data;
  }
}

class LiftInfo {
  final bool? serviceLift;

  LiftInfo({this.serviceLift});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (serviceLift != null) data['service_lift'] = serviceLift;

    return data;
  }
}

class FloorInfo {
  final int? floorNumber;
  final int? totalFloors;

  FloorInfo({this.floorNumber, this.totalFloors});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (floorNumber != null) data['floor_number'] = floorNumber;
    if (totalFloors != null) data['total_floors'] = totalFloors;
    return data;
  }
}

class PossessionInfo {
  String? possessionStatus;
  String? propertyAgeInYear;
  String? possessionDate;

  PossessionInfo({
    this.possessionStatus,
    this.propertyAgeInYear,
    this.possessionDate,
  });

  PossessionInfo.fromJson(Map<String, dynamic> json) {
    possessionStatus = json['possession_status'] as String?;

    propertyAgeInYear = json['property_age_in_years']?.toString();

    possessionDate = json['possession_date']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (possessionStatus != null)
      data['possession_status'] = possessionStatus!.toLowerCase().replaceAll(
        " ",
        "_",
      );
    if (propertyAgeInYear != null)
      data['property_age_in_years'] = propertyAgeInYear;
    if (possessionDate != null) data['possession_date'] = possessionDate;
    return data;
  }
}

class PropertyFurnishInfo {
  final String? furnishType;
  final FurnishDetails? furnishDetails;

  PropertyFurnishInfo({this.furnishType, this.furnishDetails});

  factory PropertyFurnishInfo.fromJson(Map<String, dynamic> json) {
    return PropertyFurnishInfo(
      furnishType: json['furnish_type'],
      furnishDetails:
          json['furnish_details'] != null
              ? FurnishDetails.fromJson(json['furnish_details'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (furnishType != null && furnishType!.isNotEmpty) {
      data['furnish_type'] = furnishType!.toLowerCase().replaceAll(" ", "-");
    }

    if (furnishDetails != null) {
      final detailsJson = furnishDetails!.toJson();
      if (detailsJson.isNotEmpty) {
        data['furnish_details'] = detailsJson;
      }
    }

    return data;
  }
}

class PropertyMedia {
  List<String>? images;
  List<String>? videos;
  List<String>? documents; // <-- add this

  PropertyMedia({this.images, this.videos, this.documents});

  PropertyMedia.fromJson(Map<String, dynamic> json) {
    images = (json['images'] as List?)?.map((e) => e as String).toList();
    videos = (json['videos'] as List?)?.map((e) => e as String).toList();
    documents = (json['documents'] as List?)?.map((e) => e as String).toList();
  }

  Map<String, dynamic> toJson() => {
    'images': images,
    'videos': videos,
    'documents': documents, // <-- include here
  };
}

class FurnishDetails {
  final bool? washingMachine;
  final bool? cupboard;
  final bool? stove;
  final bool? fridge;
  final bool? waterPurifier;
  final bool? modularKitchen;
  final int? ac;
  final int? bed;
  final int? geyser;

  FurnishDetails({
    this.washingMachine,
    this.cupboard,
    this.stove,
    this.fridge,
    this.waterPurifier,
    this.modularKitchen,
    this.ac,
    this.bed,
    this.geyser,
  });

  factory FurnishDetails.fromJson(Map<String, dynamic> json) {
    return FurnishDetails(
      washingMachine: json['washing_machine'],
      cupboard: json['cupboard'],
      stove: json['stove'],
      fridge: json['fridge'],
      waterPurifier: json['water_purifier'],
      modularKitchen: json['modular_kitchen'],
      ac: json['ac'],
      bed: json['bed'],
      geyser: json['geyser'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (washingMachine != null) data['washing_machine'] = washingMachine;
    if (cupboard != null) data['cupboard'] = cupboard;
    if (stove != null) data['stove'] = stove;
    if (fridge != null) data['fridge'] = fridge;
    if (waterPurifier != null) data['water_purifier'] = waterPurifier;
    if (modularKitchen != null) data['modular_kitchen'] = modularKitchen;
    if (ac != null) data['ac'] = ac;
    if (bed != null) data['bed'] = bed;
    if (geyser != null) data['geyser'] = geyser;

    return data;
  }
}

class ParkingInfo {
  final bool? coveredParking;
  final bool? openParking;

  ParkingInfo({this.coveredParking, this.openParking});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coveredParking != null) data['covered_parking'] = coveredParking;
    if (openParking != null) data['open_parking'] = openParking;
    return data;
  }
}

class FinancialInfo {
  final double? propertyPrice;
  final double? propertyRentPerMonth;
  final double? monthlyRent;
  final double? pricePerSqft;
  final double? brokerCommission;
  final bool? brokerNegotiable;
  final double? propertySecurityDeposit;
  final int? lockInPeriod;
  final int? noticePeriod;
  final bool? negotiable;
  final double? maintenanceCharges;
  final dynamic parkingCharges; // can be string or number

  FinancialInfo({
    this.propertyPrice,
    this.propertyRentPerMonth,
    this.monthlyRent,
    this.pricePerSqft,
    this.brokerCommission,
    this.brokerNegotiable,
    this.propertySecurityDeposit,
    this.lockInPeriod,
    this.noticePeriod,
    this.negotiable,
    this.maintenanceCharges,
    this.parkingCharges,
  });

  factory FinancialInfo.fromJson(Map<String, dynamic> json) {
    return FinancialInfo(
      propertyPrice: (json['property_price'] as num?)?.toDouble(),
      propertyRentPerMonth:
          (json['property_rent_per_month'] as num?)?.toDouble(),
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble(),
      pricePerSqft: (json['price_per_sqft'] as num?)?.toDouble(),
      brokerCommission: (json['broker_commission'] as num?)?.toDouble(),
      brokerNegotiable:
          json['broker_negotiable'] is bool
              ? json['broker_negotiable']
              : (json['broker_negotiable']?.toString().toLowerCase() == 'true'),
      propertySecurityDeposit:
          (json['property_security_deposit'] as num?)?.toDouble(),
      lockInPeriod:
          json['lock_in_period'] is int
              ? json['lock_in_period']
              : int.tryParse(json['lock_in_period']?.toString() ?? ''),
      noticePeriod:
          json['notice_period'] is int
              ? json['notice_period']
              : int.tryParse(json['notice_period']?.toString() ?? ''),
      negotiable:
          json['negotiable'] is bool
              ? json['negotiable']
              : (json['negotiable']?.toString().toLowerCase() == 'true'),
      maintenanceCharges: (json['maintenance_charges'] as num?)?.toDouble(),
      parkingCharges: json['parking_charges'], // string or number
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (propertyPrice != null) data['property_price'] = propertyPrice;
    if (propertyRentPerMonth != null)
      data['property_rent_per_month'] = propertyRentPerMonth;
    if (monthlyRent != null) data['monthlyRent'] = monthlyRent;
    if (pricePerSqft != null) data['price_per_sqft'] = pricePerSqft;
    if (brokerCommission != null) data['broker_commission'] = brokerCommission;
    if (brokerNegotiable != null) data['broker_negotiable'] = brokerNegotiable;
    if (propertySecurityDeposit != null)
      data['property_security_deposit'] = propertySecurityDeposit;
    if (lockInPeriod != null) data['lock_in_period'] = lockInPeriod;
    if (noticePeriod != null) data['notice_period'] = noticePeriod;
    if (negotiable != null) data['negotiable'] = negotiable;
    if (maintenanceCharges != null)
      data['maintenance_charges'] = maintenanceCharges;
    if (parkingCharges != null) data['parking_charges'] = parkingCharges;
    return data;
  }
}

class PgInfo {
  final String? pgName;
  final String? pgFor;
  final int? totalBed;
  final String? pgSuitedFor;
  final String? pgMealOffered;
  final String? pgCommonArea;
  final String? pgManageBy;
  final bool? pgOwnerStaysAtPg;
  final int? mealChargesPerMonth;
  final int? electricityChargesPerMonth;
  final PgRules? pgRules;
  final List<PgRoomInfo>? pgRoomInfo;

  PgInfo({
    this.pgName,
    this.pgFor,
    this.totalBed,
    this.pgSuitedFor,
    this.pgMealOffered,
    this.pgCommonArea,
    this.pgManageBy,
    this.pgOwnerStaysAtPg,
    this.mealChargesPerMonth,
    this.electricityChargesPerMonth,
    this.pgRules,
    this.pgRoomInfo,
  });

  factory PgInfo.fromJson(Map<String, dynamic> json) {
    return PgInfo(
      pgName: json['pg_name'],
      pgFor: json['pg_for'],
      totalBed: json['total_beds'],
      pgSuitedFor: json['pg_suited_for'],
      pgMealOffered: json['pg_meal_offered'],
      pgCommonArea: json['pg_common_area'],
      pgManageBy: json['pg_manage_by'],
      pgOwnerStaysAtPg: json['pg_owner_stays_at_pg'],
      mealChargesPerMonth: json['meal_charges_per_month'],
      electricityChargesPerMonth: json['electricity_charges_per_month'],
      pgRules:
          json['pg_rules'] != null ? PgRules.fromJson(json['pg_rules']) : null,
      pgRoomInfo:
          json['pg_room_info'] != null
              ? List<PgRoomInfo>.from(
                json['pg_room_info'].map((x) => PgRoomInfo.fromJson(x)),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (pgName != null) 'pg_name': pgName,
      if (pgFor != null) 'pg_for': pgFor,
      if (pgSuitedFor != null) 'pg_suited_for': pgSuitedFor,
      if (pgMealOffered != null) 'pg_meal_offered': pgMealOffered,
      if (totalBed != null) 'total_beds': totalBed,
      if (pgCommonArea != null) 'pg_common_area': pgCommonArea,
      if (pgManageBy != null) 'pg_manage_by': pgManageBy,
      if (pgOwnerStaysAtPg != null) 'pg_owner_stays_at_pg': pgOwnerStaysAtPg,
      if (mealChargesPerMonth != null)
        'meal_charges_per_month': mealChargesPerMonth,
      if (electricityChargesPerMonth != null)
        'electricity_charges_per_month': electricityChargesPerMonth,
      if (pgRules != null) 'pg_rules': pgRules!.toJson(),
      if (pgRoomInfo != null)
        'pg_room_info': pgRoomInfo!.map((x) => x.toJson()).toList(),
    };
  }
}

class PgRules {
  final bool? nonVegAllowed;
  final bool? petsAllowed;
  final bool? lateEntryAllowed;
  final bool? smokingAllowed;
  final bool? drinkingAllowed;
  final bool? visitorAllowed;

  PgRules({
    this.nonVegAllowed,
    this.petsAllowed,
    this.lateEntryAllowed,
    this.smokingAllowed,
    this.drinkingAllowed,
    this.visitorAllowed,
  });

  factory PgRules.fromJson(Map<String, dynamic> json) {
    return PgRules(
      nonVegAllowed: json['non_veg_allowed'],
      petsAllowed: json['pets_allowed'],
      lateEntryAllowed: json['late_entry_allowed'],
      smokingAllowed: json['smoking_allowed'],
      drinkingAllowed: json['drinking_allowed'],
      visitorAllowed: json['visitor_allowed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (nonVegAllowed != null) 'non_veg_allowed': nonVegAllowed,
      if (petsAllowed != null) 'pets_allowed': petsAllowed,
      if (lateEntryAllowed != null) 'late_entry_allowed': lateEntryAllowed,
      if (smokingAllowed != null) 'smoking_allowed': smokingAllowed,
      if (drinkingAllowed != null) 'drinking_allowed': drinkingAllowed,
      if (visitorAllowed != null) 'visitor_allowed': visitorAllowed,
    };
  }
}

class PgRoomInfo {
  final String? roomType;
  final int? rent;
  final int? securityDeposit;
  final RoomFacilityInfo? roomFacilityInfo;

  PgRoomInfo({
    this.roomType,
    this.rent,
    this.securityDeposit,
    this.roomFacilityInfo,
  });

  factory PgRoomInfo.fromJson(Map<String, dynamic> json) {
    return PgRoomInfo(
      roomType: json['room_type'],
      rent: json['rent'],
      securityDeposit: json['securityDeposit'],
      roomFacilityInfo:
          json['room_facility_info'] != null
              ? RoomFacilityInfo.fromJson(json['room_facility_info'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (roomType != null) 'room_type': roomType,
      if (rent != null) 'rent': rent,
      if (securityDeposit != null) 'securityDeposit': securityDeposit,
      if (roomFacilityInfo != null)
        'room_facility_info': roomFacilityInfo!.toJson(),
    };
  }
}

class RoomFacilityInfo {
  final bool? wifi;
  final bool? ac;
  final bool? tv;
  final bool? geyser;
  final bool? fridge;
  final bool? cupboard;
  final String? other;

  RoomFacilityInfo({
    this.wifi,
    this.ac,
    this.tv,
    this.geyser,
    this.fridge,
    this.cupboard,
    this.other,
  });

  factory RoomFacilityInfo.fromJson(Map<String, dynamic> json) {
    return RoomFacilityInfo(
      wifi: json['wifi'],
      ac: json['ac'],
      tv: json['tv'],
      geyser: json['geyser'],
      fridge: json['fridge'],
      cupboard: json['cupboard'],
      other: json['other'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (wifi != null) 'wifi': wifi,
      if (ac != null) 'ac': ac,
      if (tv != null) 'tv': tv,
      if (geyser != null) 'geyser': geyser,
      if (fridge != null) 'fridge': fridge,
      if (cupboard != null) 'cupboard': cupboard,
      if (other != null) 'other': other,
    };
  }
}

class FacilitiesInfo {
  // snake_case
  final int? minSeats;
  final int? numberOfCabins;
  final int? numberOfMeetingRooms;

  // camelCase duplicates also allowed by schema
  final int? minSeatsCamel;
  final int? numberOfCabinsCamel;
  final int? numberOfMeetingRoomsCamel;

  FacilitiesInfo({
    this.minSeats,
    this.numberOfCabins,
    this.numberOfMeetingRooms,
    this.minSeatsCamel,
    this.numberOfCabinsCamel,
    this.numberOfMeetingRoomsCamel,
  });

  Map<String, dynamic> toJson() => {
    if (minSeats != null) 'min_seats': minSeats,
    if (numberOfCabins != null) 'number_of_cabins': numberOfCabins,
    if (numberOfMeetingRooms != null)
      'number_of_meeting_rooms': numberOfMeetingRooms,
    if (minSeatsCamel != null) 'minSeats': minSeatsCamel,
    if (numberOfCabinsCamel != null) 'numberOfCabins': numberOfCabinsCamel,
    if (numberOfMeetingRoomsCamel != null)
      'numberOfMeetingRooms': numberOfMeetingRoomsCamel,
  };

  factory FacilitiesInfo.fromJson(Map<String, dynamic> json) => FacilitiesInfo(
    minSeats: asInt(json['min_seats']),
    numberOfCabins: asInt(json['number_of_cabins']),
    numberOfMeetingRooms: asInt(json['number_of_meeting_rooms']),
    minSeatsCamel: asInt(json['minSeats']),
    numberOfCabinsCamel: asInt(json['numberOfCabins']),
    numberOfMeetingRoomsCamel: asInt(json['numberOfMeetingRooms']),
  );
}

class PlotInfo {
  final double? plotArea;
  final String? plotAreaUnit;
  final double? plotLength;
  final double? plotWidth;
  final String? possessionStatus;
  final String? possessionDate;

  PlotInfo({
    this.plotArea,
    this.plotAreaUnit,
    this.plotLength,
    this.plotWidth,
    this.possessionStatus,
    this.possessionDate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (plotArea != null) data['plot_area'] = plotArea;
    if (plotAreaUnit != null)
      data['plot_area_unit'] = removeDots(plotAreaUnit!);
    if (plotLength != null) data['plot_length'] = plotLength;
    if (plotWidth != null) data['plot_width'] = plotWidth;

    if (possessionStatus != null)
      data['possession_status'] =
          possessionStatus == 'Immediate' || possessionStatus == 'InFuture'
              ? possessionStatus!.replaceAll('InFuture', 'In Future')
              : possessionStatus;

    if (possessionDate != null) {
      data['possession_date'] = possessionDate;
    }

    return data;
  }

  // factory PlotInfo.fromJson(Map<String, dynamic> json) => PlotInfo(
  //   plotArea: json['plot_area'].toDouble(),
  //   plotAreaUnit: json['plot_area_unit'],
  //   plotLength: json['plot_length'].toDouble(),
  //   plotWidth: json['plot_width'].toDouble(),
  //   possessionStatus: PossessionStatus.values.byName(
  //     json['possession_status']
  //         .replaceAll(' ', '')
  //         .replaceAll('InFuture', 'InFuture'),
  //   ),
  //   possessionDate: json['possession_date'] != null
  //       ? DateTime.parse(json['possession_date'])
  //       : null,
  // );
}

String removeDots(String input) {
  return input.replaceAll('.', '');
}

int? asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

String formatDateForBackend(String input) {
  try {
    final parts = input.split("/");
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);
      return date.toIso8601String(); // e.g. "2025-10-17T00:00:00.000"
    }
    return input; // fallback
  } catch (e) {
    return input;
  }
}
