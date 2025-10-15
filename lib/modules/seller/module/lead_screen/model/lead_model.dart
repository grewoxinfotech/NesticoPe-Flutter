import 'dart:convert';

import 'package:housing_flutter_app/data/network/property/models/property_model.dart';

// LeadResponse leadResponseFromJson(String str) =>
//     LeadResponse.fromJson(json.decode(str));
//
// String leadResponseToJson(LeadResponse data) =>
//     json.encode(data.toJson());
//
// class LeadResponse {
//   final bool success;
//   final String message;
//   final LeadData data;
//
//   LeadResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//
//   factory LeadResponse.fromJson(Map<String, dynamic> json) => LeadResponse(
//     success: json["success"],
//     message: json["message"],
//     data: LeadData.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "message": message,
//     "data": data.toJson(),
//   };
// }

// class LeadData {
//   final List<LeadItem> items;
//   final int total;
//   final int currentPage;
//   final int totalPages;
//   final bool hasMore;
//   final bool fetchedAll;
//
//   LeadData({
//     required this.items,
//     required this.total,
//     required this.currentPage,
//     required this.totalPages,
//     required this.hasMore,
//     required this.fetchedAll,
//   });
//
//   factory LeadData.fromJson(Map<String, dynamic> json) => LeadData(
//     items: List<LeadItem>.from(
//         json["items"].map((x) => LeadItem.fromJson(x))),
//     total: json["total"],
//     currentPage: json["currentPage"],
//     totalPages: json["totalPages"],
//     hasMore: json["hasMore"],
//     fetchedAll: json["fetchedAll"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "items": List<dynamic>.from(items.map((x) => x.toJson())),
//     "total": total,
//     "currentPage": currentPage,
//     "totalPages": totalPages,
//     "hasMore": hasMore,
//     "fetchedAll": fetchedAll,
//   };
// }

class LeadItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? name;
  final String? email;
  final String? phone;
  final String? propertyId;
  final String? resellerId;
  final String? source;
  final String? status;
  final String? stage;
  final String? notes;
  final String? lastContactedAt;
  final bool? isFake;
  final String? fakeReason;
  final String? markedFakeBy;
  final String? markedFakeAt;
  final Items? customFields;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LeadItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.name,
    this.email,
    this.phone,
    this.propertyId,
    this.resellerId,
    this.source,
    this.status,
    this.stage,
    this.notes,
    this.lastContactedAt,
    this.isFake,
    this.fakeReason,
    this.markedFakeBy,
    this.markedFakeAt,
    this.customFields,
    this.createdAt,
    this.updatedAt,
  });

  factory LeadItem.fromJson(Map<String, dynamic> json) => LeadItem(
    id: json["id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    propertyId: json["property_id"],
    resellerId: json["reseller_id"],
    source: json["source"],
    status: json["status"],
    stage: json["stage"],
    notes: json["notes"],
    lastContactedAt: json["lastContactedAt"],
    isFake: json["isFake"],
    fakeReason: json["fakeReason"],
    markedFakeBy: json["markedFakeBy"],
    markedFakeAt: json["markedFakeAt"],
    customFields:
        json["customFields"] != null && json["customFields"].isNotEmpty
            ? Items.fromJson(json["customFields"])
            : null,
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    if (createdBy != null) "created_by": createdBy,
    if (updatedBy != null) "updated_by": updatedBy,
    if (name != null) "name": name,
    if (email != null) "email": email,
    if (phone != null) "phone": phone,
    if (propertyId != null) "property_id": propertyId,
    if (resellerId != null) "reseller_id": resellerId,
    if (source != null) "source": source,
    if (status != null) "status": status,
    if (stage != null) "stage": stage,
    if (notes != null) "notes": notes,
    if (lastContactedAt != null) "lastContactedAt": lastContactedAt,
    if (isFake != null) "isFake": isFake,
    if (fakeReason != null) "fakeReason": fakeReason,
    if (markedFakeBy != null) "markedFakeBy": markedFakeBy,
    if (markedFakeAt != null) "markedFakeAt": markedFakeAt,
    if (customFields != null) "customFields": customFields?.toJson(),
    if (createdAt != null) "createdAt": createdAt?.toIso8601String(),
    if (updatedAt != null) "updatedAt": updatedAt?.toIso8601String(),
  };
}

// class CustomFields {
//   final String? city;
//   final String? type;
//   final String? state;
//   final String? title;
//   final String? address;
//   final String? zipCode;
//   final String? builderName;
//   final String? listingType;
//   final String? projectName;
//   final String? propertyType;
//   final PropertyDetails? propertyDetails;
//
//   CustomFields({
//     this.city,
//     this.type,
//     this.state,
//     this.title,
//     this.address,
//     this.zipCode,
//     this.builderName,
//     this.listingType,
//     this.projectName,
//     this.propertyType,
//     this.propertyDetails,
//   });
//
//   factory CustomFields.fromJson(Map<String, dynamic> json) => CustomFields(
//     city: json["city"],
//     type: json["type"],
//     state: json["state"],
//     title: json["title"],
//     address: json["address"],
//     zipCode: json["zipCode"],
//     builderName: json["builderName"],
//     listingType: json["listingType"],
//     projectName: json["projectName"],
//     propertyType: json["propertyType"],
//     propertyDetails: json["propertyDetails"] != null
//         ? PropertyDetails.fromJson(json["propertyDetails"])
//         : null,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "city": city,
//     "type": type,
//     "state": state,
//     "title": title,
//     "address": address,
//     "zipCode": zipCode,
//     "builderName": builderName,
//     "listingType": listingType,
//     "projectName": projectName,
//     "propertyType": propertyType,
//     "propertyDetails": propertyDetails?.toJson(),
//   };
// }
//
// class PropertyDetails {
//   final int? bhk;
//   final int? balcony;
//   final int? bathroom;
//   final List<String>? amenities;
//   final String? zoneType;
//   final FloorInfo? floorInfo;
//   final FurnishInfo? furnishInfo;
//   final ParkingInfo? parkingInfo;
//   final FinancialInfo? financialInfo;
//   final PossessionInfo? possessionInfo;
//   final String? propertyFacing;
//   final String? propertyCondition;
//   final int? propertyCarpetArea;
//   final int? propertyBuiltUpArea;
//
//   PropertyDetails({
//     this.bhk,
//     this.balcony,
//     this.bathroom,
//     this.amenities,
//     this.zoneType,
//     this.floorInfo,
//     this.furnishInfo,
//     this.parkingInfo,
//     this.financialInfo,
//     this.possessionInfo,
//     this.propertyFacing,
//     this.propertyCondition,
//     this.propertyCarpetArea,
//     this.propertyBuiltUpArea,
//   });
//
//   factory PropertyDetails.fromJson(Map<String, dynamic> json) =>
//       PropertyDetails(
//         bhk: json["bhk"],
//         balcony: json["balcony"],
//         bathroom: json["bathroom"],
//         amenities: json["amenities"] != null
//             ? List<String>.from(json["amenities"].map((x) => x))
//             : [],
//         zoneType: json["zone_type"],
//         floorInfo: json["floor_info"] != null
//             ? FloorInfo.fromJson(json["floor_info"])
//             : null,
//         furnishInfo: json["furnish_info"] != null
//             ? FurnishInfo.fromJson(json["furnish_info"])
//             : null,
//         parkingInfo: json["parking_info"] != null
//             ? ParkingInfo.fromJson(json["parking_info"])
//             : null,
//         financialInfo: json["financial_info"] != null
//             ? FinancialInfo.fromJson(json["financial_info"])
//             : null,
//         possessionInfo: json["possession_info"] != null
//             ? PossessionInfo.fromJson(json["possession_info"])
//             : null,
//         propertyFacing: json["property_facing"],
//         propertyCondition: json["property_condition"],
//         propertyCarpetArea: json["property_carpet_area"],
//         propertyBuiltUpArea: json["property_built_up_area"],
//       );
//
//   Map<String, dynamic> toJson() => {
//     "bhk": bhk,
//     "balcony": balcony,
//     "bathroom": bathroom,
//     "amenities": amenities,
//     "zone_type": zoneType,
//     "floor_info": floorInfo?.toJson(),
//     "furnish_info": furnishInfo?.toJson(),
//     "parking_info": parkingInfo?.toJson(),
//     "financial_info": financialInfo?.toJson(),
//     "possession_info": possessionInfo?.toJson(),
//     "property_facing": propertyFacing,
//     "property_condition": propertyCondition,
//     "property_carpet_area": propertyCarpetArea,
//     "property_built_up_area": propertyBuiltUpArea,
//   };
// }
//
// class FloorInfo {
//   final int? floorNumber;
//   final int? totalFloors;
//
//   FloorInfo({
//     this.floorNumber,
//     this.totalFloors,
//   });
//
//   factory FloorInfo.fromJson(Map<String, dynamic> json) => FloorInfo(
//     floorNumber: json["floor_number"],
//     totalFloors: json["total_floors"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "floor_number": floorNumber,
//     "total_floors": totalFloors,
//   };
// }
//
// class FurnishInfo {
//   final String? furnishType;
//   final FurnishDetails? furnishDetails;
//
//   FurnishInfo({
//     this.furnishType,
//     this.furnishDetails,
//   });
//
//   factory FurnishInfo.fromJson(Map<String, dynamic> json) => FurnishInfo(
//     furnishType: json["furnish_type"],
//     furnishDetails: json["furnish_details"] != null
//         ? FurnishDetails.fromJson(json["furnish_details"])
//         : null,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "furnish_type": furnishType,
//     "furnish_details": furnishDetails?.toJson(),
//   };
// }
//
// class FurnishDetails {
//   final int? bed;
//   final int? fan;
//   final String? other;
//   final bool? balcony;
//   final bool? kitchen;
//   final bool? bathroom;
//
//   FurnishDetails({
//     this.bed,
//     this.fan,
//     this.other,
//     this.balcony,
//     this.kitchen,
//     this.bathroom,
//   });
//
//   factory FurnishDetails.fromJson(Map<String, dynamic> json) =>
//       FurnishDetails(
//         bed: json["bed"],
//         fan: json["fan"],
//         other: json["other"],
//         balcony: json["balcony"],
//         kitchen: json["kitchen"],
//         bathroom: json["bathroom"],
//       );
//
//   Map<String, dynamic> toJson() => {
//     "bed": bed,
//     "fan": fan,
//     "other": other,
//     "balcony": balcony,
//     "kitchen": kitchen,
//     "bathroom": bathroom,
//   };
// }
//
// class ParkingInfo {
//   final bool? openParking;
//   final bool? coveredParking;
//
//   ParkingInfo({
//     this.openParking,
//     this.coveredParking,
//   });
//
//   factory ParkingInfo.fromJson(Map<String, dynamic> json) => ParkingInfo(
//     openParking: json["open_parking"],
//     coveredParking: json["covered_parking"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "open_parking": openParking,
//     "covered_parking": coveredParking,
//   };
// }
//
// class FinancialInfo {
//   final bool? negotiable;
//   final int? propertyPrice;
//   final int? brokerCommission;
//
//   FinancialInfo({
//     this.negotiable,
//     this.propertyPrice,
//     this.brokerCommission,
//   });
//
//   factory FinancialInfo.fromJson(Map<String, dynamic> json) => FinancialInfo(
//     negotiable: json["negotiable"],
//     propertyPrice: json["property_price"],
//     brokerCommission: json["broker_commission"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "negotiable": negotiable,
//     "property_price": propertyPrice,
//     "broker_commission": brokerCommission,
//   };
// }
//
// class PossessionInfo {
//   final String? possessionStatus;
//   final int? propertyAgeInYears;
//
//   PossessionInfo({
//     this.possessionStatus,
//     this.propertyAgeInYears,
//   });
//
//   factory PossessionInfo.fromJson(Map<String, dynamic> json) => PossessionInfo(
//     possessionStatus: json["possession_status"],
//     propertyAgeInYears: json["property_age_in_years"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "possession_status": possessionStatus,
//     "property_age_in_years": propertyAgeInYears,
//   };
// }
