// import 'dart:convert';
//
// /// ✅ Root Response
// class TopPropertiesResponse {
//   final bool story;
//   final String message;
//   final TopPropertiesData data;
//
//   TopPropertiesResponse({
//     required this.story,
//     required this.message,
//     required this.data,
//   });
//
//   factory TopPropertiesResponse.fromMap(Map<String, dynamic> map) =>
//       TopPropertiesResponse(
//         story: map['story'] ?? false,
//         message: map['message'] ?? '',
//         data: TopPropertiesData.fromMap(map['data'] ?? {}),
//       );
//
//   Map<String, dynamic> toMap() => {
//     'story': story,
//     'message': message,
//     'data': data.toMap(),
//   };
//
//   factory TopPropertiesResponse.fromJson(String str) =>
//       TopPropertiesResponse.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
// }
//
// /// ✅ Data Section
// class TopPropertiesData {
//   final List<AreaTopProperty> properties;
//   final int total;
//   final int limit;
//   final Map<String, dynamic> filters;
//
//   TopPropertiesData({
//     required this.properties,
//     required this.total,
//     required this.limit,
//     required this.filters,
//   });
//
//   factory TopPropertiesData.fromMap(Map<String, dynamic> map) =>
//       TopPropertiesData(
//         properties: (map['properties'] as List? ?? [])
//             .map((e) => AreaTopProperty.fromMap(e))
//             .toList(),
//         total: map['total'] ?? 0,
//         limit: map['limit'] ?? 0,
//         filters: Map<String, dynamic>.from(map['filters'] ?? {}),
//       );
//
//   Map<String, dynamic> toMap() => {
//     'properties': properties.map((e) => e.toMap()).toList(),
//     'total': total,
//     'limit': limit,
//     'filters': filters,
//   };
// }
//
// /// ✅ Main Property Model
// class AreaTopProperty {
//   final TopPropertyMedia propertyMedia;
//   final String id;
//   final String propertyId;
//   final String type;
//   final String listingType;
//   final String propertyType;
//   final String propertyDescription;
//   final TopPropertyDetails propertyDetails;
//   final String address;
//   final String city;
//   final String state;
//   final String zipCode;
//   final String location;
//   final String? reraId;
//   final String ownerName;
//   final String ownerPhone;
//   final String ownerEmail;
//   final bool isVerified;
//   final String propertyStatus;
//   final String approvalStatus;
//   final double advancedScore;
//   final TopScoreDetails scoreDetails;
//
//   AreaTopProperty({
//     required this.propertyMedia,
//     required this.id,
//     required this.propertyId,
//     required this.type,
//     required this.listingType,
//     required this.propertyType,
//     required this.propertyDescription,
//     required this.propertyDetails,
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.location,
//     required this.reraId,
//     required this.ownerName,
//     required this.ownerPhone,
//     required this.ownerEmail,
//     required this.isVerified,
//     required this.propertyStatus,
//     required this.approvalStatus,
//     required this.advancedScore,
//     required this.scoreDetails,
//   });
//
//   factory AreaTopProperty.fromMap(Map<String, dynamic> map) => AreaTopProperty(
//     propertyMedia: TopPropertyMedia.fromMap(map['propertyMedia'] ?? {}),
//     id: map['id'] ?? '',
//     propertyId: map['propertyId'] ?? '',
//     type: map['type'] ?? '',
//     listingType: map['listingType'] ?? '',
//     propertyType: map['propertyType'] ?? '',
//     propertyDescription: map['propertyDescription'] ?? '',
//     propertyDetails: TopPropertyDetails.fromMap(map['propertyDetails'] ?? {}),
//     address: map['address'] ?? '',
//     city: map['city'] ?? '',
//     state: map['state'] ?? '',
//     zipCode: map['zipCode'] ?? '',
//     location: map['location'] ?? '',
//     reraId: map['reraId'],
//     ownerName: map['ownerName'] ?? '',
//     ownerPhone: map['ownerPhone'] ?? '',
//     ownerEmail: map['ownerEmail'] ?? '',
//     isVerified: map['isVerified'] ?? false,
//     propertyStatus: map['property_status'] ?? '',
//     approvalStatus: map['approval_status'] ?? '',
//     advancedScore: (map['advancedScore'] ?? 0).toDouble(),
//     scoreDetails: TopScoreDetails.fromMap(map['scoreDetails'] ?? {}),
//   );
//
//   Map<String, dynamic> toMap() => {
//     'propertyMedia': propertyMedia.toMap(),
//     'id': id,
//     'propertyId': propertyId,
//     'type': type,
//     'listingType': listingType,
//     'propertyType': propertyType,
//     'propertyDescription': propertyDescription,
//     'propertyDetails': propertyDetails.toMap(),
//     'address': address,
//     'city': city,
//     'state': state,
//     'zipCode': zipCode,
//     'location': location,
//     'reraId': reraId,
//     'ownerName': ownerName,
//     'ownerPhone': ownerPhone,
//     'ownerEmail': ownerEmail,
//     'isVerified': isVerified,
//     'property_status': propertyStatus,
//     'approval_status': approvalStatus,
//     'advancedScore': advancedScore,
//     'scoreDetails': scoreDetails.toMap(),
//   };
// }
//
// /// ✅ Media Section
// class TopPropertyMedia {
//   final List<String> images;
//   final List<String> videos;
//   final List<String> documents;
//
//   TopPropertyMedia({
//     required this.images,
//     required this.videos,
//     required this.documents,
//   });
//
//   factory TopPropertyMedia.fromMap(Map<String, dynamic> map) => TopPropertyMedia(
//     images: List<String>.from(map['images'] ?? []),
//     videos: List<String>.from(map['videos'] ?? []),
//     documents: List<String>.from(map['documents'] ?? []),
//   );
//
//   Map<String, dynamic> toMap() => {
//     'images': images,
//     'videos': videos,
//     'documents': documents,
//   };
// }
//
// /// ✅ Property Details
// class TopPropertyDetails {
//   final int bhk;
//   final int bathroom;
//   final int balcony;
//   final bool servantRoom;
//   final TopFurnishInfo propertyFurnishInfo;
//   final TopParkingInfo parkingInfo;
//   final String propertyFacing;
//   final TopPossessionInfo possessionInfo;
//   final double propertyBuiltUpArea;
//   final String propertyBuiltUpAreaUnit;
//   final double propertyCarpetArea;
//   final String propertyCarpetAreaUnit;
//   final TopFloorInfo floorInfo;
//   final TopFinancialInfo financialInfo;
//   final String? tenantType;
//   final bool? petFriendly;
//   final String? availableFrom;
//   final String? locality;
//   final String? subLocality;
//   final TopLiftInfo? liftInfo;
//
//   TopPropertyDetails({
//     required this.bhk,
//     required this.bathroom,
//     required this.balcony,
//     required this.servantRoom,
//     required this.propertyFurnishInfo,
//     required this.parkingInfo,
//     required this.propertyFacing,
//     required this.possessionInfo,
//     required this.propertyBuiltUpArea,
//     required this.propertyBuiltUpAreaUnit,
//     required this.propertyCarpetArea,
//     required this.propertyCarpetAreaUnit,
//     required this.floorInfo,
//     required this.financialInfo,
//     this.tenantType,
//     this.petFriendly,
//     this.availableFrom,
//     this.locality,
//     this.subLocality,
//     this.liftInfo,
//   });
//
//   factory TopPropertyDetails.fromMap(Map<String, dynamic> map) =>
//       TopPropertyDetails(
//         bhk: map['bhk'] ?? 0,
//         bathroom: map['bathroom'] ?? 0,
//         balcony: map['balcony'] ?? 0,
//         servantRoom: map['servant_room'] ?? false,
//         propertyFurnishInfo:
//         TopFurnishInfo.fromMap(map['property_furnish_info'] ?? {}),
//         parkingInfo: TopParkingInfo.fromMap(map['parking_info'] ?? {}),
//         propertyFacing: map['property_facing'] ?? '',
//         possessionInfo: TopPossessionInfo.fromMap(map['possession_info'] ?? {}),
//         propertyBuiltUpArea:
//         (map['property_built_up_area'] ?? 0).toDouble(),
//         propertyBuiltUpAreaUnit: map['property_built_up_area_unit'] ?? '',
//         propertyCarpetArea: (map['property_carpet_area'] ?? 0).toDouble(),
//         propertyCarpetAreaUnit: map['property_carpet_area_unit'] ?? '',
//         floorInfo: TopFloorInfo.fromMap(map['floor_info'] ?? {}),
//         financialInfo: TopFinancialInfo.fromMap(map['financial_info'] ?? {}),
//         tenantType: map['tenant_type'],
//         petFriendly: map['pet_friendly'],
//         availableFrom: map['available_from'],
//         locality: map['locality'],
//         subLocality: map['sub_locality'],
//         liftInfo: map['lift_info'] != null
//             ? TopLiftInfo.fromMap(map['lift_info'])
//             : null,
//       );
//
//   Map<String, dynamic> toMap() => {
//     'bhk': bhk,
//     'bathroom': bathroom,
//     'balcony': balcony,
//     'servant_room': servantRoom,
//     'property_furnish_info': propertyFurnishInfo.toMap(),
//     'parking_info': parkingInfo.toMap(),
//     'property_facing': propertyFacing,
//     'possession_info': possessionInfo.toMap(),
//     'property_built_up_area': propertyBuiltUpArea,
//     'property_built_up_area_unit': propertyBuiltUpAreaUnit,
//     'property_carpet_area': propertyCarpetArea,
//     'property_carpet_area_unit': propertyCarpetAreaUnit,
//     'floor_info': floorInfo.toMap(),
//     'financial_info': financialInfo.toMap(),
//     'tenant_type': tenantType,
//     'pet_friendly': petFriendly,
//     'available_from': availableFrom,
//     'locality': locality,
//     'sub_locality': subLocality,
//     'lift_info': liftInfo?.toMap(),
//   };
// }
//
// /// ✅ Sub Models
//
// class TopFurnishInfo {
//   final String furnishType;
//   final Map<String, dynamic>? furnishDetails;
//
//   TopFurnishInfo({
//     required this.furnishType,
//     this.furnishDetails,
//   });
//
//   factory TopFurnishInfo.fromMap(Map<String, dynamic> map) => TopFurnishInfo(
//     furnishType: map['furnish_type'] ?? '',
//     furnishDetails: map['furnish_details'],
//   );
//
//   Map<String, dynamic> toMap() => {
//     'furnish_type': furnishType,
//     if (furnishDetails != null) 'furnish_details': furnishDetails,
//   };
// }
//
// class TopParkingInfo {
//   final bool coveredParking;
//   final bool openParking;
//
//   TopParkingInfo({
//     required this.coveredParking,
//     required this.openParking,
//   });
//
//   factory TopParkingInfo.fromMap(Map<String, dynamic> map) => TopParkingInfo(
//     coveredParking: map['covered_parking'] ?? false,
//     openParking: map['open_parking'] ?? false,
//   );
//
//   Map<String, dynamic> toMap() => {
//     'covered_parking': coveredParking,
//     'open_parking': openParking,
//   };
// }
//
// class TopLiftInfo {
//   final bool? serviceLift;
//
//   TopLiftInfo({this.serviceLift});
//
//   factory TopLiftInfo.fromMap(Map<String, dynamic> map) =>
//       TopLiftInfo(serviceLift: map['service_lift']);
//
//   Map<String, dynamic> toMap() => {'service_lift': serviceLift};
// }
//
// class TopPossessionInfo {
//   final int? propertyAgeInYears;
//   final String? possessionStatus;
//
//   TopPossessionInfo({
//     this.propertyAgeInYears,
//     this.possessionStatus,
//   });
//
//   factory TopPossessionInfo.fromMap(Map<String, dynamic> map) =>
//       TopPossessionInfo(
//         propertyAgeInYears: map['property_age_in_years'],
//         possessionStatus: map['possession_status'],
//       );
//
//   Map<String, dynamic> toMap() => {
//     'property_age_in_years': propertyAgeInYears,
//     'possession_status': possessionStatus,
//   };
// }
//
// class TopFloorInfo {
//   final int floorNumber;
//   final int totalFloors;
//
//   TopFloorInfo({
//     required this.floorNumber,
//     required this.totalFloors,
//   });
//
//   factory TopFloorInfo.fromMap(Map<String, dynamic> map) => TopFloorInfo(
//     floorNumber: map['floor_number'] ?? 0,
//     totalFloors: map['total_floors'] ?? 0,
//   );
//
//   Map<String, dynamic> toMap() => {
//     'floor_number': floorNumber,
//     'total_floors': totalFloors,
//   };
// }
//
// class TopFinancialInfo {
//   final num? propertyPrice;
//   final num? propertyRentPerMonth;
//   final num? propertySecurityDeposit;
//   final num? brokerCommission;
//   final num? maintenanceCharges;
//   final num? pricePerSqft;
//   final num? lockInPeriod;
//   final num? noticePeriod;
//   final bool? negotiable;
//   final bool? brokerNegotiable;
//   final String? parkingCharges;
//   final String? paintingCharges;
//
//   TopFinancialInfo({
//     this.propertyPrice,
//     this.propertyRentPerMonth,
//     this.propertySecurityDeposit,
//     this.brokerCommission,
//     this.maintenanceCharges,
//     this.pricePerSqft,
//     this.lockInPeriod,
//     this.noticePeriod,
//     this.negotiable,
//     this.brokerNegotiable,
//     this.parkingCharges,
//     this.paintingCharges,
//   });
//
//   factory TopFinancialInfo.fromMap(Map<String, dynamic> map) =>
//       TopFinancialInfo(
//         propertyPrice: map['property_price'],
//         propertyRentPerMonth: map['property_rent_per_month'],
//         propertySecurityDeposit: map['property_security_deposit'],
//         brokerCommission: map['broker_commission'],
//         maintenanceCharges: map['maintenance_charges'],
//         pricePerSqft: map['price_per_sqft'],
//         lockInPeriod: map['lock_in_period'],
//         noticePeriod: map['notice_period'],
//         negotiable: map['negotiable'],
//         brokerNegotiable: map['broker_negotiable'],
//         parkingCharges: map['parking_charges'],
//         paintingCharges: map['painting_charges'],
//       );
//
//   Map<String, dynamic> toMap() => {
//     'property_price': propertyPrice,
//     'property_rent_per_month': propertyRentPerMonth,
//     'property_security_deposit': propertySecurityDeposit,
//     'broker_commission': brokerCommission,
//     'maintenance_charges': maintenanceCharges,
//     'price_per_sqft': pricePerSqft,
//     'lock_in_period': lockInPeriod,
//     'notice_period': noticePeriod,
//     'negotiable': negotiable,
//     'broker_negotiable': brokerNegotiable,
//     'parking_charges': parkingCharges,
//     'painting_charges': paintingCharges,
//   };
// }
//
// /// ✅ Scoring Details
// class TopScoreDetails {
//   final double basePerformance;
//   final double planBonus;
//   final double mediaScore;
//   final int imagesCount;
//   final int videosCount;
//   final int documentsCount;
//   final double favoritesScore;
//   final double inquiriesScore;
//   final double viewsScore;
//   final double premiumBonus;
//   final double totalScore;
//
//   TopScoreDetails({
//     required this.basePerformance,
//     required this.planBonus,
//     required this.mediaScore,
//     required this.imagesCount,
//     required this.videosCount,
//     required this.documentsCount,
//     required this.favoritesScore,
//     required this.inquiriesScore,
//     required this.viewsScore,
//     required this.premiumBonus,
//     required this.totalScore,
//   });
//
//   factory TopScoreDetails.fromMap(Map<String, dynamic> map) => TopScoreDetails(
//     basePerformance: (map['basePerformance'] ?? 0).toDouble(),
//     planBonus: (map['planBonus'] ?? 0).toDouble(),
//     mediaScore: (map['mediaScore'] ?? 0).toDouble(),
//     imagesCount: map['imagesCount'] ?? 0,
//     videosCount: map['videosCount'] ?? 0,
//     documentsCount: map['documentsCount'] ?? 0,
//     favoritesScore: (map['favoritesScore'] ?? 0).toDouble(),
//     inquiriesScore: (map['inquiriesScore'] ?? 0).toDouble(),
//     viewsScore: (map['viewsScore'] ?? 0).toDouble(),
//     premiumBonus: (map['premiumBonus'] ?? 0).toDouble(),
//     totalScore: (map['totalScore'] ?? 0).toDouble(),
//   );
//
//   Map<String, dynamic> toMap() => {
//     'basePerformance': basePerformance,
//     'planBonus': planBonus,
//     'mediaScore': mediaScore,
//     'imagesCount': imagesCount,
//     'videosCount': videosCount,
//     'documentsCount': documentsCount,
//     'favoritesScore': favoritesScore,
//     'inquiriesScore': inquiriesScore,
//     'viewsScore': viewsScore,
//     'premiumBonus': premiumBonus,
//     'totalScore': totalScore,
//   };
// }
