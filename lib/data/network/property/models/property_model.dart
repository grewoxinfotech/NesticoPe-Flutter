// class PropertyModel {
//   bool? story;
//   PropertyMessage? message;
//   dynamic data;
//
//   PropertyModel({this.story, this.message, this.data});
//
//   PropertyModel.fromJson(Map<String, dynamic> json) {
//     story = json['success'];
//     message = json['message'] != null
//         ? PropertyMessage.fromJson(json['message'])
//         : null;
//     data = json['data'];
//   }
//
//   Map<String, dynamic> toJson() => {
//     'story': story,
//     'message': message?.toJson(),
//     'data': data,
//   };
// }
//
// class PropertyMessage {
//   List<Items>? data;
//   Pagination? pagination;
//
//   PropertyMessage({this.data, this.pagination});
//
//   PropertyMessage.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = List<Items>.from(
//           (json['data'] as List).map((x) => Items.fromJson(x)));
//     }
//     pagination = json['pagination'] != null
//         ? Pagination.fromJson(json['pagination'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() => {
//     'data': data?.map((v) => v.toJson()).toList(),
//     'pagination': pagination?.toJson(),
//   };
// }
//
// class Pagination {
//   int? total;
//   int? current;
//   int? pageSize;
//   int? totalPages;
//   bool? hasMore;
//
//   Pagination({this.total, this.current, this.pageSize, this.totalPages, this.hasMore});
//
//   Pagination.fromJson(Map<String, dynamic> json) {
//     total = json['total'];
//     current = json['current'] ?? json['currentPage'];
//     pageSize = json['pageSize'];
//     totalPages = json['totalPages'];
//     hasMore = json['hasMore'];
//   }
//
//   Map<String, dynamic> toJson() => {
//     'total': total,
//     'current': current,
//     'pageSize': pageSize,
//     'totalPages': totalPages,
//     'hasMore': hasMore,
//   };
// }
//
// class Items {
//   PropertyMedia? propertyMedia;
//   String? id;
//   String? createdBy;
//   String? updatedBy;
//   String? title;
//   String? type;
//   String? listingType;
//   String? propertyType;
//   String? propertyDescription;
//   List<String>? keywords;
//   List<String>? propertyImages;
//   PropertyDetails? propertyDetails;
//   String? address;
//   String? city;
//   String? state;
//   String? zipCode;
//   Location? location;
//   List<NearbyLocations>? nearbyLocations;
//   String? reraId;
//   String? propertyStatus;
//   String? builderName;
//   String? projectName;
//   String? ownerPhone;
//   String? ownerName;
//   String? ownerEmail;
//   bool? isVerified;
//   String? verifiedBy;
//   String? verifiedAt;
//   int? totalInquiries;
//   int? totalViews;
//   String? approvalStatus;
//   String? approvalComment;
//   String? approvedBy;
//   String? approvedAt;
//   int? totalFavorites;
//   int? totalShares;
//   int? totalVisits;
//   int? totalSales;
//   String? totalCommissions;
//   String? assignedTo;
//   String? assignmentDate;
//   String? assignmentExpiryDate;
//   String? potentialEarnings;
//   String? assignmentStatus;
//   String? performanceScore;
//   String? expiryDate;
//   String? lastRenewalDate;
//   int? renewalCount;
//   bool? isExpired;
//   int? totalReports;
//   bool? isHiddenDueToReports;
//   String? lastReportedAt;
//   String? createdAt;
//   String? updatedAt;
//
//   Items({
//     this.propertyMedia,
//     this.id,
//     this.createdBy,
//     this.updatedBy,
//     this.title,
//     this.type,
//     this.listingType,
//     this.propertyType,
//     this.propertyDescription,
//     this.keywords,
//     this.propertyImages,
//     this.propertyDetails,
//     this.address,
//     this.city,
//     this.state,
//     this.zipCode,
//     this.location,
//     this.nearbyLocations,
//     this.reraId,
//     this.propertyStatus,
//     this.builderName,
//     this.projectName,
//     this.ownerPhone,
//     this.ownerName,
//     this.ownerEmail,
//     this.isVerified,
//     this.verifiedBy,
//     this.verifiedAt,
//     this.totalInquiries,
//     this.totalViews,
//     this.approvalStatus,
//     this.approvalComment,
//     this.approvedBy,
//     this.approvedAt,
//     this.totalFavorites,
//     this.totalShares,
//     this.totalVisits,
//     this.totalSales,
//     this.totalCommissions,
//     this.assignedTo,
//     this.assignmentDate,
//     this.assignmentExpiryDate,
//     this.potentialEarnings,
//     this.assignmentStatus,
//     this.performanceScore,
//     this.expiryDate,
//     this.lastRenewalDate,
//     this.renewalCount,
//     this.isExpired,
//     this.totalReports,
//     this.isHiddenDueToReports,
//     this.lastReportedAt,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   Items.fromJson(Map<String, dynamic> json) {
//     propertyMedia =
//         json['propertyMedia'] != null
//             ? PropertyMedia.fromJson(json['propertyMedia'])
//             : null;
//     id = json['id'];
//     createdBy = json['created_by'];
//     updatedBy = json['updated_by'];
//     title = json['title'];
//     type = json['type'];
//     listingType = json['listingType'];
//     propertyType = json['propertyType'];
//     propertyDescription = json['propertyDescription'];
//     keywords =
//         json['keywords'] != null ? List<String>.from(json['keywords']) : null;
//     propertyImages =
//         json['propertyImages'] != null
//             ? List<String>.from(json['propertyImages'])
//             : null;
//     propertyDetails =
//         json['propertyDetails'] != null
//             ? PropertyDetails.fromJson(json['propertyDetails'])
//             : null;
//     address = json['address'];
//     city = json['city'];
//     state = json['state'];
//     zipCode = json['zipCode'];
//     location =
//         json['location'] != null ? Location.fromJson(json['location']) : null;
//     if (json['nearbyLocations'] != null) {
//       nearbyLocations = <NearbyLocations>[];
//       json['nearbyLocations'].forEach((v) {
//         nearbyLocations!.add(NearbyLocations.fromJson(v));
//       });
//     }
//     reraId = json['reraId'];
//     propertyStatus = json['property_status'];
//     builderName = json['builderName'];
//     projectName = json['projectName'];
//     ownerPhone = json['ownerPhone'];
//     ownerName = json['ownerName'];
//     ownerEmail = json['ownerEmail'];
//     isVerified = json['isVerified'];
//     verifiedBy = json['verifiedBy'];
//     verifiedAt = json['verifiedAt'];
//     totalInquiries = json['totalInquiries'];
//     totalViews = json['totalViews'];
//     approvalStatus = json['approval_status'];
//     approvalComment = json['approval_comment'];
//     approvedBy = json['approved_by'];
//     approvedAt = json['approved_at'];
//     totalFavorites = json['totalFavorites'];
//     totalShares = json['totalShares'];
//     totalVisits = json['totalVisits'];
//     totalSales = json['totalSales'];
//     totalCommissions = json['totalCommissions'];
//     assignedTo = json['assignedTo'];
//     assignmentDate = json['assignmentDate'];
//     assignmentExpiryDate = json['assignmentExpiryDate'];
//     potentialEarnings = json['potentialEarnings'];
//     assignmentStatus = json['assignmentStatus'];
//     performanceScore = json['performanceScore'];
//     expiryDate = json['expiryDate'];
//     lastRenewalDate = json['lastRenewalDate'];
//     renewalCount = json['renewalCount'];
//     isExpired = json['isExpired'];
//     totalReports = json['totalReports'];
//     isHiddenDueToReports = json['isHiddenDueToReports'];
//     lastReportedAt = json['lastReportedAt'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (propertyMedia != null) data['propertyMedia'] = propertyMedia!.toJson();
//     data['id'] = id;
//     data['created_by'] = createdBy;
//     data['updated_by'] = updatedBy;
//     data['title'] = title;
//     data['type'] = type;
//     data['listingType'] = listingType;
//     data['propertyType'] = propertyType;
//     data['propertyDescription'] = propertyDescription;
//     data['keywords'] = keywords;
//     data['propertyImages'] = propertyImages;
//     if (propertyDetails != null)
//       data['propertyDetails'] = propertyDetails!.toJson();
//     data['address'] = address;
//     data['city'] = city;
//     data['state'] = state;
//     data['zipCode'] = zipCode;
//     if (location != null) data['location'] = location!.toJson();
//     if (nearbyLocations != null)
//       data['nearbyLocations'] =
//           nearbyLocations!.map((v) => v.toJson()).toList();
//     data['reraId'] = reraId;
//     data['property_status'] = propertyStatus;
//     data['builderName'] = builderName;
//     data['projectName'] = projectName;
//     data['ownerPhone'] = ownerPhone;
//     data['ownerName'] = ownerName;
//     data['ownerEmail'] = ownerEmail;
//     data['isVerified'] = isVerified;
//     data['verifiedBy'] = verifiedBy;
//     data['verifiedAt'] = verifiedAt;
//     data['totalInquiries'] = totalInquiries;
//     data['totalViews'] = totalViews;
//     data['approval_status'] = approvalStatus;
//     data['approval_comment'] = approvalComment;
//     data['approved_by'] = approvedBy;
//     data['approved_at'] = approvedAt;
//     data['totalFavorites'] = totalFavorites;
//     data['totalShares'] = totalShares;
//     data['totalVisits'] = totalVisits;
//     data['totalSales'] = totalSales;
//     data['totalCommissions'] = totalCommissions;
//     data['assignedTo'] = assignedTo;
//     data['assignmentDate'] = assignmentDate;
//     data['assignmentExpiryDate'] = assignmentExpiryDate;
//     data['potentialEarnings'] = potentialEarnings;
//     data['assignmentStatus'] = assignmentStatus;
//     data['performanceScore'] = performanceScore;
//     data['expiryDate'] = expiryDate;
//     data['lastRenewalDate'] = lastRenewalDate;
//     data['renewalCount'] = renewalCount;
//     data['isExpired'] = isExpired;
//     data['totalReports'] = totalReports;
//     data['isHiddenDueToReports'] = isHiddenDueToReports;
//     data['lastReportedAt'] = lastReportedAt;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     return data;
//   }
// }
//
// class PropertyMedia {
//   List<String>? images;
//   List<String>? videos;
//
//   PropertyMedia({this.images, this.videos});
//
//   PropertyMedia.fromJson(Map<String, dynamic> json) {
//     images = json['images']?.cast<String>();
//     videos = json['videos']?.cast<String>();
//   }
//
//   Map<String, dynamic> toJson() => {'images': images, 'videos': videos};
// }
//
// class PropertyDetails {
//   int? bhk;
//   int? balcony;
//   int? bathroom;
//   List<String>? amenities;
//   String? zoneType;
//   FloorInfo? floorInfo;
//   FurnishInfo? furnishInfo;
//   ParkingInfo? parkingInfo;
//   FinancialInfo? financialInfo;
//   PossessionInfo? possessionInfo;
//   String? propertyFacing;
//   String? propertyCondition;
//   double? propertyCarpetArea;
//   double? propertyBuiltUpArea;
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
//   PropertyDetails.fromJson(Map<String, dynamic> json) {
//     bhk = json['bhk'] is int ? json['bhk'] : int.tryParse(json['bhk']?.toString() ?? '0');
//     balcony = json['balcony'] is int ? json['balcony'] : int.tryParse(json['balcony']?.toString() ?? '0');
//     bathroom = json['bathroom'] is int ? json['bathroom'] : int.tryParse(json['bathroom']?.toString() ?? '0');
//     amenities = json['amenities']?.cast<String>();
//     zoneType = json['zone_type'];
//     floorInfo =
//         json['floor_info'] != null
//             ? FloorInfo.fromJson(json['floor_info'])
//             : null;
//     furnishInfo =
//         json['furnish_info'] != null
//             ? FurnishInfo.fromJson(json['furnish_info'])
//             : null;
//     parkingInfo =
//         json['parking_info'] != null
//             ? ParkingInfo.fromJson(json['parking_info'])
//             : null;
//     financialInfo =
//         json['financial_info'] != null
//             ? FinancialInfo.fromJson(json['financial_info'])
//             : null;
//     possessionInfo =
//         json['possession_info'] != null
//             ? PossessionInfo.fromJson(json['possession_info'])
//             : null;
//     propertyFacing = json['property_facing'];
//     propertyCondition = json['property_condition'];
//     propertyCarpetArea = TypeConverter.parseDouble(json['property_carpet_area'] );
//     propertyBuiltUpArea = TypeConverter.parseDouble(json['property_built_up_area'] );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['bhk'] = bhk;
//     data['balcony'] = balcony;
//     data['bathroom'] = bathroom;
//     data['amenities'] = amenities;
//     data['zone_type'] = zoneType;
//     if (floorInfo != null) data['floor_info'] = floorInfo!.toJson();
//     if (furnishInfo != null) data['furnish_info'] = furnishInfo!.toJson();
//     if (parkingInfo != null) data['parking_info'] = parkingInfo!.toJson();
//     if (financialInfo != null) data['financial_info'] = financialInfo!.toJson();
//     if (possessionInfo != null)
//       data['possession_info'] = possessionInfo!.toJson();
//     data['property_facing'] = propertyFacing;
//     data['property_condition'] = propertyCondition;
//     data['property_carpet_area'] = propertyCarpetArea;
//     data['property_built_up_area'] = propertyBuiltUpArea;
//     return data;
//   }
//
// }
//
// class FloorInfo {
//   int? floorNumber;
//   int? totalFloors;
//
//   FloorInfo({this.floorNumber, this.totalFloors});
//
//   FloorInfo.fromJson(Map<String, dynamic> json) {
//     floorNumber = json['floor_number'];
//     totalFloors = json['total_floors'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['floor_number'] = this.floorNumber;
//     data['total_floors'] = this.totalFloors;
//     return data;
//   }
// }
//
// class FurnishInfo {
//   String? furnishType;
//   FurnishDetails? furnishDetails;
//
//   FurnishInfo({this.furnishType, this.furnishDetails});
//
//   FurnishInfo.fromJson(Map<String, dynamic> json) {
//     furnishType = json['furnish_type'];
//     furnishDetails =
//         json['furnish_details'] != null
//             ? new FurnishDetails.fromJson(json['furnish_details'])
//             : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['furnish_type'] = this.furnishType;
//     if (this.furnishDetails != null) {
//       data['furnish_details'] = this.furnishDetails!.toJson();
//     }
//     return data;
//   }
// }
//
// class FurnishDetails {
//   int? bed;
//   int? fan;
//   String? other;
//   bool? balcony;
//   bool? kitchen;
//   bool? bathroom;
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
//   FurnishDetails.fromJson(Map<String, dynamic> json) {
//     bed = json['bed'];
//     fan = json['fan'];
//     other = json['other'];
//     balcony = json['balcony'];
//     kitchen = json['kitchen'];
//     bathroom = json['bathroom'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['bed'] = this.bed;
//     data['fan'] = this.fan;
//     data['other'] = this.other;
//     data['balcony'] = this.balcony;
//     data['kitchen'] = this.kitchen;
//     data['bathroom'] = this.bathroom;
//     return data;
//   }
// }
//
// class ParkingInfo {
//   bool? openParking;
//   bool? coveredParking;
//
//   ParkingInfo({this.openParking, this.coveredParking});
//
//   ParkingInfo.fromJson(Map<String, dynamic> json) {
//     openParking = json['open_parking'];
//     coveredParking = json['covered_parking'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['open_parking'] = this.openParking;
//     data['covered_parking'] = this.coveredParking;
//     return data;
//   }
// }
//
//
// class FinancialInfo {
//   bool? negotiable;
//   double? propertyPrice;
//   double? brokerCommission;
//
//   FinancialInfo({this.negotiable, this.propertyPrice, this.brokerCommission});
//
//   FinancialInfo.fromJson(Map<String, dynamic> json) {
//     negotiable = json['negotiable'];
//     propertyPrice = TypeConverter.parseDouble(json['property_price']);
//     brokerCommission = TypeConverter.parseDouble(json['broker_commission'] );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['negotiable'] = this.negotiable;
//     data['property_price'] = this.propertyPrice;
//     data['broker_commission'] = this.brokerCommission;
//     return data;
//   }
// }
//
// class PossessionInfo {
//   String? possessionStatus;
//   int? propertyAgeInYears;
//
//   PossessionInfo({this.possessionStatus, this.propertyAgeInYears});
//
//   PossessionInfo.fromJson(Map<String, dynamic> json) {
//     possessionStatus = json['possession_status'];
//     propertyAgeInYears = json['property_age_in_years'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['possession_status'] = this.possessionStatus;
//     data['property_age_in_years'] = this.propertyAgeInYears;
//     return data;
//   }
// }
//
// class Location {
//   double? latitude;
//   double? longitude;
//
//   Location({this.latitude, this.longitude});
//
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       latitude: TypeConverter.parseDouble(json['latitude']),
//       longitude: TypeConverter.parseDouble(json['longitude']),
//     );
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     return data;
//   }
// }
//
// class NearbyLocations {
//   String? name;
//   String? distance;
//
//   NearbyLocations({this.name, this.distance});
//
//   NearbyLocations.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     distance = json['distance'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['distance'] = this.distance;
//     return data;
//   }
//
//
//
// }
//
// class TypeConverter{
//   static int? parseInt(dynamic value) {
//     if (value == null) return null;
//     if (value is int) return value;
//     if (value is double) return value.toInt();
//     if (value is String) return int.tryParse(value);
//     return null;
//   }
//
//   static double? parseDouble(dynamic value) {
//     if (value == null) return null;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value);
//     return null;
//   }
//
// }
class PropertyModel {
  bool? success;
  PropertyMessage? message;
  dynamic data;

  PropertyModel({this.success, this.message, this.data});

  PropertyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool?;
    message =
        json['message'] != null
            ? PropertyMessage.fromJson(json['message'] as Map<String, dynamic>)
            : null;
    data = json['data'];
  }

  Map<String, dynamic> toJson() => {
    'story': success,
    'message': message?.toJson(),
    'data': data,
  };
}

class PropertyMessage {
  List<Items>? data;
  Pagination? pagination;

  PropertyMessage({this.data, this.pagination});

  PropertyMessage.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data =
          (json['data'] as List)
              .map((x) => Items.fromJson(x as Map<String, dynamic>))
              .toList();
    }
    pagination =
        json['pagination'] != null
            ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
            : null;
  }

  Map<String, dynamic> toJson() => {
    'data': data?.map((v) => v.toJson()).toList(),
    'pagination': pagination?.toJson(),
  };
}

class Pagination {
  int? total;
  int? current;
  int? pageSize;
  int? totalPages;
  bool? hasMore;

  Pagination({
    this.total,
    this.current,
    this.pageSize,
    this.totalPages,
    this.hasMore,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = TypeConverter.parseInt(json['total']);
    current = TypeConverter.parseInt(json['current'] ?? json['currentPage']);
    pageSize = TypeConverter.parseInt(json['pageSize']);
    totalPages = TypeConverter.parseInt(json['totalPages']);
    hasMore = json['hasMore'] as bool?;
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'current': current,
    'pageSize': pageSize,
    'totalPages': totalPages,
    'hasMore': hasMore,
  };
}

class Items {
  PropertyMedia? propertyMedia;
  String? id;
  String? createdBy;
  String? updatedBy;
  String? title;
  String? type;
  String? propertyId; // ADD THIS
  double? calculatedPerformanceScore;
  String? listingType;
  String? propertyType;
  double? performanceScorePercent;

  String? propertyDescription;

  List<String>? keywords;
  List<String>? propertyImages;
  PropertyDetails? propertyDetails;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  String? location;
  // Location? location;
  List<NearbyLocations>? nearbyLocations;
  String? reraId;
  String? propertyStatus;
  String? builderName;
  String? projectName;
  String? ownerPhone;
  String? ownerName;
  String? ownerEmail;
  bool? isVerified;
  String? verifiedBy;
  String? verifiedAt;
  int? totalInquiries;
  int? totalViews;
  String? approvalStatus;
  String? approvalComment;
  String? approvedBy;
  String? approvedAt;
  int? totalFavorites;
  int? totalShares;
  int? totalVisits;
  int? totalSales;
  String? totalCommissions;
  String? assignedTo;
  String? assignmentDate;
  String? assignmentExpiryDate;
  String? potentialEarnings;
  String? assignmentStatus;
  String? performanceScore;
  String? expiryDate;
  String? lastRenewalDate;
  int? renewalCount;
  bool? isExpired;
  int? totalReports;
  bool? isHiddenDueToReports;
  String? lastReportedAt;
  String? createdAt;
  String? updatedAt;

  Items({
    this.propertyMedia,
    this.id,
    this.createdBy,
    this.updatedBy,
    this.title,
    this.type,
    this.listingType,
    this.propertyType,
    this.propertyDescription,
    this.keywords,
    this.propertyImages,
    this.propertyDetails,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.location,
    this.performanceScorePercent,
    this.nearbyLocations,
    this.reraId,
    this.propertyStatus,
    this.builderName,
    this.propertyId,
    this.calculatedPerformanceScore,
    this.projectName,
    this.ownerPhone,
    this.ownerName,
    this.ownerEmail,
    this.isVerified,
    this.verifiedBy,
    this.verifiedAt,
    this.totalInquiries,
    this.totalViews,
    this.approvalStatus,
    this.approvalComment,
    this.approvedBy,
    this.approvedAt,
    this.totalFavorites,
    this.totalShares,
    this.totalVisits,
    this.totalSales,
    this.totalCommissions,
    this.assignedTo,
    this.assignmentDate,
    this.assignmentExpiryDate,
    this.potentialEarnings,
    this.assignmentStatus,
    this.performanceScore,
    this.expiryDate,
    this.lastRenewalDate,
    this.renewalCount,
    this.isExpired,
    this.totalReports,
    this.isHiddenDueToReports,
    this.lastReportedAt,
    this.createdAt,
    this.updatedAt,
  });

  Items.fromJson(Map<String, dynamic> json) {
    propertyMedia =
        json['propertyMedia'] != null
            ? PropertyMedia.fromJson(
              json['propertyMedia'] as Map<String, dynamic>,
            )
            : null;
    id = json['id'] as String?;
    createdBy = json['created_by'] as String?;
    updatedBy = json['updated_by'] as String?;
    title = json['title'] as String?;
    type = json['type'] as String?;
    listingType = json['listingType'] as String?;
    performanceScorePercent = TypeConverter.parseDouble(
      json['performanceScorePercent'],
    );

    propertyType = json['propertyType'] as String?;
    propertyDescription = json['propertyDescription'] as String?;
    propertyId = json['propertyId'] as String?;
    calculatedPerformanceScore = TypeConverter.parseDouble(
      json['calculatedPerformanceScore'],
    );
    keywords = (json['keywords'] as List?)?.map((e) => e as String).toList();
    propertyImages =
        (json['propertyImages'] as List?)?.map((e) => e as String).toList();
    propertyDetails =
        json['propertyDetails'] != null
            ? PropertyDetails.fromJson(
              json['propertyDetails'] as Map<String, dynamic>,
            )
            : null;
    address = json['address'] as String?;
    city = json['city'] as String?;
    state = json['state'] as String?;
    zipCode = json['zipCode'] as String?;
    location = json['location'];
    nearbyLocations =
        json['nearbyLocations'] != null
            ? (json['nearbyLocations'] as List)
                .map((v) => NearbyLocations.fromJson(v as Map<String, dynamic>))
                .toList()
            : null;
    reraId = json['reraId'] as String?;
    propertyStatus = json['property_status'] as String?;
    builderName = json['builderName'] as String?;
    projectName = json['projectName'] as String?;
    ownerPhone = json['ownerPhone'] as String?;
    ownerName = json['ownerName'] as String?;
    ownerEmail = json['ownerEmail'] as String?;
    isVerified = json['isVerified'] as bool?;
    verifiedBy = json['verifiedBy'] as String?;
    verifiedAt = json['verifiedAt'] as String?;
    totalInquiries = TypeConverter.parseInt(json['totalInquiries']);
    totalViews = TypeConverter.parseInt(json['totalViews']);
    approvalStatus = json['approval_status'] as String?;
    approvalComment = json['approval_comment'] as String?;
    approvedBy = json['approved_by'] as String?;
    approvedAt = json['approved_at'] as String?;
    totalFavorites = TypeConverter.parseInt(json['totalFavorites']);
    totalShares = TypeConverter.parseInt(json['totalShares']);
    totalVisits = TypeConverter.parseInt(json['totalVisits']);
    totalSales = TypeConverter.parseInt(json['totalSales']);
    totalCommissions = json['totalCommissions'] as String?;
    assignedTo = json['assignedTo'] as String?;
    assignmentDate = json['assignmentDate'] as String?;
    assignmentExpiryDate = json['assignmentExpiryDate'] as String?;
    potentialEarnings = json['potentialEarnings'] as String?;
    assignmentStatus = json['assignmentStatus'] as String?;
    performanceScore = json['performanceScore'] as String?;
    expiryDate = json['expiryDate'] as String?;
    lastRenewalDate = json['lastRenewalDate'] as String?;
    renewalCount = TypeConverter.parseInt(json['renewalCount']);
    isExpired = json['isExpired'] as bool?;
    totalReports = TypeConverter.parseInt(json['totalReports']);
    isHiddenDueToReports = json['isHiddenDueToReports'] as bool?;
    lastReportedAt = json['lastReportedAt'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['title'] = title ?? "Default Property Title";
    data['type'] = type ?? "residential";
    data['performanceScorePercent'] = performanceScorePercent;
    data['listingType'] = listingType ?? "Rent";
    data['propertyType'] = propertyType ?? "apartment";
    data['propertyDescription'] = propertyDescription ?? "No description";
    if (keywords != null && keywords!.isNotEmpty) data['keywords'] = keywords;
    if (propertyImages != null && propertyImages!.isNotEmpty)
      data['propertyImages'] = propertyImages;
    if (propertyDetails != null) {
      final details = propertyDetails!.toJson();
      details.removeWhere((key, value) => value == null);
      data['propertyDetails'] = details;
    } else {
      data['propertyDetails'] = {};
    }
    data['address'] = address ?? "";
    data['city'] = city ?? "";
    data['propertyId'] = propertyId;
    data['calculatedPerformanceScore'] = calculatedPerformanceScore;
    data['state'] = state ?? "";
    data['zipCode'] = zipCode ?? "";
    data['location'] = location ?? "";
    if (nearbyLocations != null && nearbyLocations!.isNotEmpty) {
      data['nearbyLocations'] =
          nearbyLocations!.map((v) => v.toJson()).toList();
    }
    data['reraId'] = reraId;
    data['property_status'] = propertyStatus;
    data['builderName'] = builderName;
    data['projectName'] = projectName;
    data['ownerPhone'] = ownerPhone ?? "";
    data['ownerName'] = ownerName ?? "";
    data['ownerEmail'] = ownerEmail ?? "";
    data['isVerified'] = isVerified ?? false;
    data['verifiedBy'] = verifiedBy;
    data['verifiedAt'] = verifiedAt;
    data['totalInquiries'] = totalInquiries ?? 0;
    data['totalViews'] = totalViews ?? 0;
    data['approval_status'] = approvalStatus;
    data['approval_comment'] = approvalComment;
    data['approved_by'] = approvedBy;
    data['approved_at'] = approvedAt;
    data['totalFavorites'] = totalFavorites ?? 0;
    data['totalShares'] = totalShares ?? 0;
    data['totalVisits'] = totalVisits ?? 0;
    data['totalSales'] = totalSales ?? 0;
    data['totalCommissions'] = totalCommissions ?? "0.00";
    data['assignedTo'] = assignedTo;
    data['assignmentDate'] = assignmentDate;
    data['assignmentExpiryDate'] = assignmentExpiryDate;
    data['potentialEarnings'] = potentialEarnings;
    data['assignmentStatus'] = assignmentStatus ?? "available";
    data['performanceScore'] = performanceScore ?? "0.0";
    data['expiryDate'] = expiryDate;
    data['lastRenewalDate'] = lastRenewalDate;
    data['renewalCount'] = renewalCount ?? 0;
    data['isExpired'] = isExpired ?? false;
    data['totalReports'] = totalReports ?? 0;
    data['isHiddenDueToReports'] = isHiddenDueToReports ?? false;
    data['lastReportedAt'] = lastReportedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

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

class PropertyDetails {
  int? bhk;
  int? balcony;
  int? bathroom;
  List<String>? amenities;
  String? zoneType;
  FloorInfo? floorInfo;
  FurnishInfo? furnishInfo;
  ParkingInfo? parkingInfo;
  FinancialInfo? financialInfo;
  PossessionInfo? possessionInfo;
  String? propertyFacing;
  bool? servantRoom; // ADD THIS
  String? locality; // ADD THIS
  String? subLocality; // ADD THIS
  LiftInfo? liftInfo; // ADD THIS
  String? tenantType; // ADD THIS
  bool? petFriendly; // ADD THIS
  String? availableFrom; // ADD THIS
  String? transactionType; // ADD THIS
  PlotInfo? plotInfo; // ADD THIS FOR PLOT PROPERTIES
  String? propertyCondition;
  double? propertyCarpetArea;
  double? propertyBuiltUpArea;
  String? propertyCarpetAreaUnit;
  String? propertyBuiltUpAreaUnit;
  PgInfo? pgInfo;
  FacilitiesInfo? facilitiesInfo;

  PropertyDetails({
    this.bhk,
    this.balcony,
    this.bathroom,
    this.amenities,
    this.zoneType,
    this.floorInfo,
    this.furnishInfo,
    this.parkingInfo,
    this.financialInfo,
    this.servantRoom,
    this.locality,
    this.subLocality,
    this.liftInfo,
    this.tenantType,
    this.petFriendly,
    this.availableFrom,
    this.transactionType,
    this.plotInfo,
    this.possessionInfo,
    this.propertyFacing,
    this.propertyCondition,
    this.propertyCarpetArea,
    this.propertyBuiltUpArea,
    this.propertyBuiltUpAreaUnit,
    this.propertyCarpetAreaUnit,
    this.pgInfo,
    this.facilitiesInfo,
  });

  PropertyDetails.fromJson(Map<String, dynamic> json) {
    bhk = TypeConverter.parseInt(json['bhk']);
    balcony = TypeConverter.parseInt(json['balcony']);
    bathroom = TypeConverter.parseInt(json['bathroom']);
    amenities = (json['amenities'] as List?)?.map((e) => e as String).toList();
    zoneType = json['zone_type'] as String?;
    floorInfo =
        json['floor_info'] != null
            ? FloorInfo.fromJson(json['floor_info'] as Map<String, dynamic>)
            : null;
    furnishInfo =
        json['property_furnish_info'] != null
            ? FurnishInfo.fromJson(
              json['property_furnish_info'] as Map<String, dynamic>,
            )
            : null;
    parkingInfo =
        json['parking_info'] != null
            ? ParkingInfo.fromJson(json['parking_info'] as Map<String, dynamic>)
            : null;
    financialInfo =
        json['financial_info'] != null
            ? FinancialInfo.fromJson(
              json['financial_info'] as Map<String, dynamic>,
            )
            : null;
    possessionInfo =
        json['possession_info'] != null
            ? PossessionInfo.fromJson(
              json['possession_info'] as Map<String, dynamic>,
            )
            : null;
    propertyFacing = json['property_facing'] as String?;
    propertyCondition = json['property_condition'] as String?;
    propertyCarpetArea = TypeConverter.parseDouble(
      json['property_carpet_area'],
    );
    servantRoom = json['servant_room'] as bool?;
    locality = json['locality'] as String?;
    subLocality = json['sub_locality'] as String?;
    liftInfo =
        json['lift_info'] != null ? LiftInfo.fromJson(json['lift_info']) : null;
    tenantType = json['tenant_type'] as String?;
    petFriendly = json['pet_friendly'] as bool?;
    availableFrom = json['available_from'] as String?;
    transactionType = json['transaction_type'] as String?;
    plotInfo =
        json['plot_info'] != null ? PlotInfo.fromJson(json['plot_info']) : null;
    propertyBuiltUpArea = TypeConverter.parseDouble(
      json['property_built_up_area'],
    );
    propertyCarpetAreaUnit = json["property_carpet_area_unit"];
    propertyBuiltUpAreaUnit = json["property_built_up_area_unit"];
    pgInfo = json['pg_info'] != null ? PgInfo.fromJson(json['pg_info']) : null;
    facilitiesInfo =
        json['facilities_info'] != null
            ? FacilitiesInfo.fromJson(json['facilities_info'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['bhk'] = bhk;
    data['balcony'] = balcony;
    data['bathroom'] = bathroom;
    if (amenities != null && amenities!.isNotEmpty)
      data['amenities'] = amenities;
    if (zoneType != null) data['zone_type'] = zoneType;

    if (floorInfo != null) data['floor_info'] = floorInfo!.toJson();
    if (furnishInfo != null) {
      final furnish = furnishInfo!.toJson();
      // remove null fields
      furnish.removeWhere((key, value) => value == null);
      data['property_furnish_info'] = furnish;
    }
    if (servantRoom != null) data['servant_room'] = servantRoom;
    if (locality != null) data['locality'] = locality;
    if (subLocality != null) data['sub_locality'] = subLocality;
    if (liftInfo != null) data['lift_info'] = liftInfo!.toJson();
    if (tenantType != null) data['tenant_type'] = tenantType;
    if (petFriendly != null) data['pet_friendly'] = petFriendly;
    if (availableFrom != null) data['available_from'] = availableFrom;
    if (transactionType != null) data['transaction_type'] = transactionType;
    if (plotInfo != null) data['plot_info'] = plotInfo!.toJson();
    if (parkingInfo != null) {
      final parking = parkingInfo!.toJson();
      parking.removeWhere((key, value) => value == null);
      data['parking_info'] = parking;
    }
    if (financialInfo != null) {
      final finance = financialInfo!.toJson();
      finance.removeWhere((key, value) => value == null);
      data['financial_info'] = finance;
    }
    if (possessionInfo != null)
      data['possession_info'] = possessionInfo!.toJson();

    if (propertyFacing != null) data['property_facing'] = propertyFacing;
    if (facilitiesInfo != null) data['facilities_info'] = facilitiesInfo;
    if (propertyCondition != null)
      data['property_condition'] = propertyCondition;
    if (propertyCarpetArea != null)
      data['property_carpet_area'] = propertyCarpetArea;
    if (propertyBuiltUpArea != null)
      data['property_built_up_area'] = propertyBuiltUpArea;
    if (propertyCarpetAreaUnit != null)
      data['property_carpet_area_unit'] = propertyCarpetAreaUnit;
    if (propertyBuiltUpAreaUnit != null)
      data['property_built_up_area_unit'] = propertyBuiltUpAreaUnit;
    if (pgInfo != null) data['pg_info'] = pgInfo!.toJson();
    return data;
  }
}

class LiftInfo {
  bool? serviceLift;

  LiftInfo({this.serviceLift});

  LiftInfo.fromJson(Map<String, dynamic> json) {
    serviceLift = json['service_lift'] as bool?;
  }

  Map<String, dynamic> toJson() => {'service_lift': serviceLift};
}

class PlotInfo {
  double? plotArea;
  String? plotAreaUnit;
  double? plotLength;
  double? plotWidth;
  String? ownership;
  String? zoneType;
  String? possessionStatus;

  PlotInfo({
    this.plotArea,
    this.plotAreaUnit,
    this.plotLength,
    this.plotWidth,
    this.ownership,
    this.zoneType,
    this.possessionStatus,
  });

  PlotInfo.fromJson(Map<String, dynamic> json) {
    plotArea = TypeConverter.parseDouble(json['plot_area']);
    plotAreaUnit = json['plot_area_unit'] as String?;
    plotLength = TypeConverter.parseDouble(json['plot_length']);
    plotWidth = TypeConverter.parseDouble(json['plot_width']);
    ownership = json['ownership'] as String?;
    zoneType = json['zone_type'] as String?;
    possessionStatus = json['possession_status'] as String?;
  }

  Map<String, dynamic> toJson() => {
    'plot_area': plotArea,
    'plot_area_unit': plotAreaUnit,
    'plot_length': plotLength,
    'plot_width': plotWidth,
    'ownership': ownership,
    'zone_type': zoneType,
    'possession_status': possessionStatus,
  };
}

class FloorInfo {
  int? floorNumber;
  int? totalFloors;

  FloorInfo({this.floorNumber, this.totalFloors});

  FloorInfo.fromJson(Map<String, dynamic> json) {
    floorNumber = TypeConverter.parseInt(json['floor_number']);
    totalFloors = TypeConverter.parseInt(json['total_floors']);
  }

  Map<String, dynamic> toJson() => {
    'floor_number': floorNumber,
    'total_floors': totalFloors,
  };
}

class FurnishInfo {
  final String? furnishType;
  final FurnishDetails? furnishDetails;
  bool? brokerNegotiable;
  String? parkingCharges;
  String? paintingCharges;
  double? maintenanceCharges;

  FurnishInfo({
    this.furnishType,
    this.furnishDetails,
    this.brokerNegotiable,
    this.parkingCharges,
    this.paintingCharges,
    this.maintenanceCharges,
  });

  factory FurnishInfo.fromJson(Map<String, dynamic> json) {
    return FurnishInfo(
      furnishType: json['furnish_type'] as String?,
      brokerNegotiable: json['broker_negotiable'] as bool?,
      parkingCharges: json['parking_charges'] as String?,
      paintingCharges: json['painting_charges'] as String?,
      maintenanceCharges: TypeConverter.parseDouble(
        json['maintenance_charges'],
      ),
      furnishDetails:
          json['furnish_details'] != null
              ? FurnishDetails.fromJson(json['furnish_details'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (furnishType != null) {
      data['furnish_type'] = furnishType!.toLowerCase().replaceAll(" ", "-");
    }
    if (furnishDetails != null) {
      data['furnish_details'] = furnishDetails!.toJson();
    }
    if (brokerNegotiable != null) {
      data['broker_negotiable'] = brokerNegotiable;
    }
    if (parkingCharges != null) {
      data['parking_charges'] = parkingCharges;
    }
    if (paintingCharges != null) {
      data['painting_charges'] = paintingCharges;
    }
    if (maintenanceCharges != null) {
      data['maintenance_charges'] = maintenanceCharges;
    }

    return data;
  }
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
    return {
      'washing_machine': washingMachine,
      'cupboard': cupboard,
      'stove': stove,
      'fridge': fridge,
      'water_purifier': waterPurifier,
      'modular_kitchen': modularKitchen,
      'ac': ac,
      'bed': bed,
      'geyser': geyser,
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
    minSeats: TypeConverter.parseInt(json['min_seats']),
    numberOfCabins: TypeConverter.parseInt(json['number_of_cabins']),
    numberOfMeetingRooms: TypeConverter.parseInt(
      json['number_of_meeting_rooms'],
    ),
    minSeatsCamel: TypeConverter.parseInt(json['minSeats']),
    numberOfCabinsCamel: TypeConverter.parseInt(json['numberOfCabins']),
    numberOfMeetingRoomsCamel: TypeConverter.parseInt(
      json['numberOfMeetingRooms'],
    ),
  );
}

class ParkingInfo {
  bool? covered;
  bool? open;

  ParkingInfo({this.covered, this.open});

  ParkingInfo.fromJson(Map<String, dynamic> json) {
    covered = json['covered_parking'];
    open = json['open_parking'];
  }

  Map<String, dynamic> toJson() => {
    'covered_parking': covered,
    'open_parking': open,
  };
}

class FinancialInfo {
  double price;
  double? maintenance;
  double propertyRentPerMonth;
  final double? monthlyRent;
  double pricePerSqft;
  double brokerCommission;
  double propertySecurityDeposit;
  bool negotiable;
  int? noticePeriod; // For PG properties
  int? lockInPeriod; // For PG properties

  FinancialInfo({
    this.price = 0,
    this.maintenance,
    this.propertyRentPerMonth = 0,
    this.monthlyRent,
    this.pricePerSqft = 0,
    this.brokerCommission = 0,
    this.propertySecurityDeposit = 0,
    this.negotiable = false,
    this.noticePeriod,
    this.lockInPeriod,
  });

  FinancialInfo.fromJson(Map<String, dynamic> json)
    : price = TypeConverter.parseDouble(json['property_price']) ?? 0,
      maintenance = TypeConverter.parseDouble(json['maintenance']) ?? 0,
      propertyRentPerMonth =
          TypeConverter.parseDouble(json['property_rent_per_month']) ?? 0,
      pricePerSqft = TypeConverter.parseDouble(json['price_per_sqft']) ?? 0,
      brokerCommission =
          TypeConverter.parseDouble(json['broker_commission']) ?? 0,
      propertySecurityDeposit =
          TypeConverter.parseDouble(json['property_security_deposit']) ?? 0,
      monthlyRent = TypeConverter.parseDouble(json['monthlyRent']) ?? 0,
      negotiable = json['negotiable'] ?? false,
      noticePeriod = TypeConverter.parseInt(json['notice_period']),
      lockInPeriod = TypeConverter.parseInt(json['lock_in_period']);

  Map<String, dynamic> toJson() {
    return {
      "property_price": price,
      "property_rent_per_month": propertyRentPerMonth,
      "maintenance": maintenance,
      "price_per_sqft": pricePerSqft,
      "broker_commission": brokerCommission,
      "property_security_deposit": propertySecurityDeposit,
      "negotiable": negotiable,
      if (noticePeriod != null) "notice_period": noticePeriod,
      if (lockInPeriod != null) "lock_in_period": lockInPeriod,
    };
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
    propertyAgeInYear = json['property_age_in_years'].toString();
    possessionDate = json['possession_date'] as String?;
  }

  Map<String, dynamic> toJson() => {
    'possession_status': possessionStatus,
    'property_age_in_years': propertyAgeInYear,
    if (possessionDate != null) 'possession_date': possessionDate,
  };
}

class NearbyLocations {
  String? name;
  double? distance;

  NearbyLocations({this.name, this.distance});

  NearbyLocations.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    distance = TypeConverter.parseDouble(json['distance']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'distance': distance};
}

/// PG Information

// class PgInfo {
//   final String? pgName;
//   final String? pgFor;
//   final String? pgSuitedFor;
//   final String? pgMealOffered;
//   final String? pgCommonArea;
//   final String? pgManageBy;
//   final bool? pgOwnerStaysAtPg;
//   final double? mealChargesPerMonth;
//   final double? electricityChargesPerMonth;
//   final PgRules? pgRules;
//   // final PgRoomInfo? pgRoomInfo;
//   final List<PgRoomInfo>? pgRoomInfo;
//
//   PgInfo({
//     this.pgName,
//     this.pgFor,
//     this.pgSuitedFor,
//     this.pgMealOffered,
//     this.pgCommonArea,
//     this.pgManageBy,
//     this.pgOwnerStaysAtPg,
//     this.mealChargesPerMonth,
//     this.electricityChargesPerMonth,
//     this.pgRules,
//     this.pgRoomInfo,
//   });
//
//   factory PgInfo.fromJson(Map<String, dynamic> json) {
//     return PgInfo(
//       pgName: json['pg_name'],
//       pgFor: json['pg_for'],
//       pgSuitedFor: json['pg_suited_for'],
//       pgMealOffered: json['pg_meal_offered'],
//       pgCommonArea: json['pg_common_area'],
//       pgManageBy: json['pg_manage_by'],
//       pgOwnerStaysAtPg: json['pg_owner_stays_at_pg'],
//       mealChargesPerMonth: json['meal_charges_per_month']?.toDouble(),
//       electricityChargesPerMonth:
//           json['electricity_charges_per_month']?.toDouble(),
//       pgRules:
//           json['pg_rules'] != null ? PgRules.fromJson(json['pg_rules']) : null,
//       pgRoomInfo:
//           json['pg_room_info'] != null
//               ? List<PgRoomInfo>.from(
//                 json['pg_room_info'].map((x) => PgRoomInfo.fromJson(x)),
//               )
//               : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (pgName != null) data['pg_name'] = pgName;
//     if (pgFor != null) data['pg_for'] = pgFor;
//     if (pgSuitedFor != null) data['pg_suited_for'] = pgSuitedFor;
//     if (pgMealOffered != null) data['pg_meal_offered'] = pgMealOffered;
//     if (pgCommonArea != null) data['pg_common_area'] = pgCommonArea;
//     if (pgManageBy != null) data['pg_manage_by'] = pgManageBy;
//     if (pgOwnerStaysAtPg != null)
//       data['pg_owner_stays_at_pg'] = pgOwnerStaysAtPg;
//     if (mealChargesPerMonth != null)
//       data['meal_charges_per_month'] = mealChargesPerMonth;
//     if (electricityChargesPerMonth != null)
//       data['electricity_charges_per_month'] = electricityChargesPerMonth;
//     if (pgRules != null) data['pg_rules'] = pgRules!.toJson();
//     if (pgRoomInfo != null) {
//       // ✅ Correct: convert each PgRoomInfo to JSON and return as list
//       data['pg_room_info'] = pgRoomInfo!.map((x) => x.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class PgRules {
//   final bool? nonVegAllowed;
//   final bool? smokingAllowed;
//   final bool? drinkingAllowed;
//   final bool? petsAllowed;
//   final bool? lateEntryAllowed;
//   final String? lateEntryTime;
//   final bool? visitorAllowed;
//   final bool? gurdianAllowed;
//
//   PgRules({
//     this.nonVegAllowed,
//     this.smokingAllowed,
//     this.drinkingAllowed,
//     this.petsAllowed,
//     this.lateEntryAllowed,
//     this.lateEntryTime,
//     this.visitorAllowed,
//     this.gurdianAllowed,
//   });
//
//   factory PgRules.fromJson(Map<String, dynamic> json) {
//     return PgRules(
//       nonVegAllowed: json['non_veg_allowed'],
//       smokingAllowed: json['smoking_allowed'],
//       drinkingAllowed: json['drinking_allowed'],
//       petsAllowed: json['pets_allowed'],
//       lateEntryAllowed: json['late_entry_allowed'],
//       lateEntryTime: json['late_entry_time'],
//       visitorAllowed: json['visitor_allowed'],
//       gurdianAllowed: json['gurdian_allowed'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (nonVegAllowed != null) data['non_veg_allowed'] = nonVegAllowed;
//     if (smokingAllowed != null) data['smoking_allowed'] = smokingAllowed;
//     if (drinkingAllowed != null) data['drinking_allowed'] = drinkingAllowed;
//     if (petsAllowed != null) data['pets_allowed'] = petsAllowed;
//     if (lateEntryAllowed != null) data['late_entry_allowed'] = lateEntryAllowed;
//     if (lateEntryTime != null) data['late_entry_time'] = lateEntryTime;
//     if (visitorAllowed != null) data['visitor_allowed'] = visitorAllowed;
//     if (gurdianAllowed != null) data['gurdian_allowed'] = gurdianAllowed;
//     return data;
//   }
// }
//
// class PgRoomInfo {
//   final String? roomType;
//   final int? totalBeds;
//   final RoomFacilityInfo? roomFacilityInfo;
//
//   PgRoomInfo({this.roomType, this.totalBeds, this.roomFacilityInfo});
//
//   factory PgRoomInfo.fromJson(Map<String, dynamic> json) {
//     return PgRoomInfo(
//       roomType: json['room_type'],
//       totalBeds: json['total_beds'],
//       roomFacilityInfo:
//           json['room_facility_info'] != null
//               ? RoomFacilityInfo.fromJson(json['room_facility_info'])
//               : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (roomType != null) data['room_type'] = roomType;
//     if (totalBeds != null) data['total_beds'] = totalBeds;
//     if (roomFacilityInfo != null)
//       data['room_facility_info'] = roomFacilityInfo!.toJson();
//     return data;
//   }
// }
//
// class RoomFacilityInfo {
//   final bool? wifi;
//   final bool? tv;
//   final bool? ac;
//   final String? other;
//
//   RoomFacilityInfo({this.wifi, this.tv, this.ac, this.other});
//
//   factory RoomFacilityInfo.fromJson(Map<String, dynamic> json) {
//     return RoomFacilityInfo(
//       wifi: json['wifi'],
//       tv: json['tv'],
//       ac: json['ac'],
//       other: json['other'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (wifi != null) data['wifi'] = wifi;
//     if (tv != null) data['tv'] = tv;
//     if (ac != null) data['ac'] = ac;
//     if (other != null) data['other'] = other;
//     return data;
//   }
// }

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
      'pg_name': pgName,
      'pg_for': pgFor,
      'pg_suited_for': pgSuitedFor,
      'pg_meal_offered': pgMealOffered,
      'total_beds': totalBed,
      'pg_common_area': pgCommonArea,
      'pg_manage_by': pgManageBy,
      'pg_owner_stays_at_pg': pgOwnerStaysAtPg,
      'meal_charges_per_month': mealChargesPerMonth,
      'electricity_charges_per_month': electricityChargesPerMonth,
      'pg_rules': pgRules?.toJson(),
      'pg_room_info': pgRoomInfo?.map((x) => x.toJson()).toList(),
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
      'non_veg_allowed': nonVegAllowed,
      'pets_allowed': petsAllowed,
      'late_entry_allowed': lateEntryAllowed,
      'smoking_allowed': smokingAllowed,
      'drinking_allowed': drinkingAllowed,
      'visitor_allowed': visitorAllowed,
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
      'room_type': roomType,
      'rent': rent,
      'securityDeposit': securityDeposit,
      'room_facility_info': roomFacilityInfo?.toJson(),
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
      'wifi': wifi,
      'ac': ac,
      'tv': tv,
      'geyser': geyser,
      'fridge': fridge,
      'cupboard': cupboard,
      'other': other,
    };
  }
}

class TypeConverter {
  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
