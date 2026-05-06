// import 'dart:convert';
//
// import 'package:nesticope_app/data/network/property/models/property_model.dart';
//
// class LeadItem {
//   final String? id;
//   final String? createdBy;
//   final String? updatedBy;
//   final String? name;
//   final String? email;
//   final String? phone;
//   final String? propertyId;
//   final String? resellerId;
//   final String? source;
//   final String? status;
//   final String? stage;
//   final String? notes;
//   final String? lastContactedAt;
//   final bool? isFake;
//   final String? fakeReason;
//   final String? markedFakeBy;
//   final String? markedFakeAt;
//   final Items? customFields;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   LeadItem({
//     this.id,
//     this.createdBy,
//     this.updatedBy,
//     this.name,
//     this.email,
//     this.phone,
//     this.propertyId,
//     this.resellerId,
//     this.source,
//     this.status,
//     this.stage,
//     this.notes,
//     this.lastContactedAt,
//     this.isFake,
//     this.fakeReason,
//     this.markedFakeBy,
//     this.markedFakeAt,
//     this.customFields,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory LeadItem.fromJson(Map<String, dynamic> json) => LeadItem(
//     id: json["id"],
//     createdBy: json["created_by"],
//     updatedBy: json["updated_by"],
//     name: json["name"],
//     email: json["email"],
//     phone: json["phone"],
//     propertyId: json["property_id"],
//     resellerId: json["reseller_id"],
//     source: json["source"],
//     status: json["status"],
//     stage: json["stage"],
//     notes: json["notes"],
//     lastContactedAt: json["lastContactedAt"],
//     isFake: json["isFake"],
//     fakeReason: json["fakeReason"],
//     markedFakeBy: json["markedFakeBy"],
//     markedFakeAt: json["markedFakeAt"],
//     customFields:
//         json["customFields"] != null && json["customFields"].isNotEmpty
//             ? Items.fromJson(json["customFields"])
//             : Items(),
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     if (id != null) "id": id,
//     if (createdBy != null) "created_by": createdBy,
//     if (updatedBy != null) "updated_by": updatedBy,
//     if (name != null) "name": name,
//     if (email != null) "email": email,
//     if (phone != null) "phone": phone,
//     if (propertyId != null) "property_id": propertyId,
//     if (resellerId != null) "reseller_id": resellerId,
//     if (source != null) "source": source,
//     if (status != null) "status": status,
//     if (stage != null) "stage": stage,
//     if (notes != null) "notes": notes,
//     if (lastContactedAt != null) "lastContactedAt": lastContactedAt,
//     if (isFake != null) "isFake": isFake,
//     if (fakeReason != null) "fakeReason": fakeReason,
//     if (markedFakeBy != null) "markedFakeBy": markedFakeBy,
//     if (markedFakeAt != null) "markedFakeAt": markedFakeAt,
//     if (customFields != null) "customFields": customFields?.toJson(),
//     if (createdAt != null) "createdAt": createdAt?.toIso8601String(),
//     if (updatedAt != null) "updatedAt": updatedAt?.toIso8601String(),
//   };
// }
//
// extension LeadItemCopy on LeadItem {
//   LeadItem copyWith({
//     String? id,
//     String? createdBy,
//     String? updatedBy,
//     String? name,
//     String? email,
//     String? phone,
//     String? propertyId,
//     String? resellerId,
//     String? source,
//     String? status,
//     String? stage,
//     String? notes,
//     String? lastContactedAt,
//     bool? isFake,
//     String? fakeReason,
//     String? markedFakeBy,
//     String? markedFakeAt,
//     Items? customFields,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return LeadItem(
//       id: id ?? this.id,
//       createdBy: createdBy ?? this.createdBy,
//       updatedBy: updatedBy ?? this.updatedBy,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       phone: phone ?? this.phone,
//       propertyId: propertyId ?? this.propertyId,
//       resellerId: resellerId ?? this.resellerId,
//       source: source ?? this.source,
//       status: status ?? this.status,
//       stage: stage ?? this.stage,
//       notes: notes ?? this.notes,
//       lastContactedAt: lastContactedAt ?? this.lastContactedAt,
//       isFake: isFake ?? this.isFake,
//       fakeReason: fakeReason ?? this.fakeReason,
//       markedFakeBy: markedFakeBy ?? this.markedFakeBy,
//       markedFakeAt: markedFakeAt ?? this.markedFakeAt,
//       customFields: customFields ?? this.customFields,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
// }

import 'dart:developer';

import '../../../../../data/network/property/models/property_model.dart';

int? _leadJsonInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  return int.tryParse(value.toString());
}

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
  CustomOldLeadFields? customFields; // 👈 can hold either Map or String
  final LeadResellerData? leadResellerData;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? commissionStatus;
  final String? projectName;
  final String? city;
  final String? propertyType;
  final String? projectStatus;
  /// Sale/listing state from API key `property_status` (e.g. unsold).
  final String? propertyListingStatus;
  final String? listingType;
  final int? bhk;
  final int? carpetArea;
  final String? priceRange;
  final int? price;

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
    this.commissionStatus,
    this.projectName,
    this.city,
    this.propertyType,
    this.projectStatus,
    this.propertyListingStatus,
    this.listingType,
    this.bhk,
    this.carpetArea,
    this.priceRange,
    this.price, this.leadResellerData,
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
    leadResellerData: json['reseller'] != null
        ? LeadResellerData.fromMap(
      Map<String, dynamic>.from(json['reseller']),
    )
        : null,

    stage: json["stage"],
    notes: json["notes"],
    lastContactedAt: json["lastContactedAt"],
    isFake: json["isFake"],
    fakeReason: json["fakeReason"],
    markedFakeBy: json["markedFakeBy"],
    markedFakeAt: json["markedFakeAt"],
    // customFields:
    //     (() {
    //       final data = json["customFields"];
    //       if (data == null) return null;
    //       if (data is Items) return data;
    //       if (data is Map<String, dynamic>) {
    //         try {
    //           return Items.fromJson(data);
    //         } catch (e) {
    //           log("Error parsing customFields as Map: $e");
    //           return null;
    //         }
    //       }
    //
    //       // if (data is String && data.isNotEmpty) {
    //       //   // Try to parse JSON string
    //       //   log("Parsing customFields from String: $data");
    //       //   try {
    //       //     // First, try to decode as JSON
    //       //     final decoded = jsonDecode(data);
    //       //     // Check if decoded result is a Map
    //       //     if (decoded is Map) {
    //       //       // Cast to Map<String, dynamic>
    //       //       return Items.fromJson(Map<String, dynamic>.from(decoded));
    //       //     } else {
    //       //       // If not a Map, return null (string is not valid)
    //       //       log("customFields String decoded to non-Map type: ${decoded.runtimeType}");
    //       //       return null;
    //       //     }
    //       //   } catch (e) {
    //       //     // If JSON decode fails, the string is just a plain value, not JSON
    //       //     log("customFields is a plain String (not JSON): $data");
    //       //     return null;
    //       //   }
    //       // }
    //       return null;
    //     })(),

    customFields: CustomOldLeadFields.fromJson(json["customFields"]),

    createdAt:
        json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    updatedAt:
        json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
    commissionStatus: json["commission_status"],
    projectName: json["projectName"],
    city: json["city"],
    propertyType: json["propertyType"],
    projectStatus: json["projectStatus"],
    propertyListingStatus: json["property_status"] as String?,
    listingType: json["listingType"] as String?,
    bhk: _leadJsonInt(json["bhk"]),
    carpetArea: _leadJsonInt(json["carpetarea"]),
    priceRange: json["priceRange"],
    price: _leadJsonInt(json["price"]),
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

    // ✅ Serialize safely
    if (customFields != null)
      "customFields":
          customFields is Items ? customFields : customFields.toString(),

    if (createdAt != null) "createdAt": createdAt?.toIso8601String(),
    if (updatedAt != null) "updatedAt": updatedAt?.toIso8601String(),
    if (commissionStatus != null) "commission_status": commissionStatus,
    if (projectName != null) "projectName": projectName,
    if (city != null) "city": city,
    if (propertyType != null) "propertyType": propertyType,
    if (projectStatus != null) "projectStatus": projectStatus,
    if (propertyListingStatus != null)
      "property_status": propertyListingStatus,
    if (listingType != null) "listingType": listingType,
    if (bhk != null) "bhk": bhk,
    if (carpetArea != null) "carpetarea": carpetArea,
    if (priceRange != null) "priceRange": priceRange,
    if (price != null) "price": price,
    if(leadResellerData!=null)"reseller":leadResellerData?.toMap()
  };
}

extension LeadItemCopy on LeadItem {
  LeadItem copyWith({
    String? id,
    String? createdBy,
    String? updatedBy,
    String? name,
    String? email,
    String? phone,
    String? propertyId,
    String? resellerId,
    String? source,
    String? status,
    String? stage,
    String? notes,
    String? lastContactedAt,
    bool? isFake,
    String? fakeReason,
    String? markedFakeBy,
    String? markedFakeAt,
    dynamic customFields, // can be Items or String
    DateTime? createdAt,
    DateTime? updatedAt,
    String? commissionStatus,
    String? projectName,
    String? city,
    String? propertyType,
    String? projectStatus,
    String? propertyListingStatus,
    String? listingType,
    int? bhk,
    int? carpetArea,
    String? priceRange,
    int? price,
  }) {
    return LeadItem(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      propertyId: propertyId ?? this.propertyId,
      resellerId: resellerId ?? this.resellerId,
      source: source ?? this.source,
      status: status ?? this.status,
      stage: stage ?? this.stage,
      notes: notes ?? this.notes,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      isFake: isFake ?? this.isFake,
      fakeReason: fakeReason ?? this.fakeReason,
      markedFakeBy: markedFakeBy ?? this.markedFakeBy,
      markedFakeAt: markedFakeAt ?? this.markedFakeAt,
      customFields: customFields ?? this.customFields, // flexible
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      commissionStatus: commissionStatus ?? this.commissionStatus,
      projectName: projectName ?? this.projectName,
      city: city ?? this.city,
      propertyType: propertyType ?? this.propertyType,
      projectStatus: projectStatus ?? this.projectStatus,
      propertyListingStatus:
          propertyListingStatus ?? this.propertyListingStatus,
      listingType: listingType ?? this.listingType,
      bhk: bhk ?? this.bhk,
      carpetArea: carpetArea ?? this.carpetArea,
      priceRange: priceRange ?? this.priceRange,
      price: price ?? this.price,
    );
  }
}



class LeadResellerData {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;

  LeadResellerData({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
  });

  /// 🔹 Computed Full Name
  String get fullName {
    final fn = firstName ?? '';
    final ln = lastName ?? '';
    final name = '$fn $ln'.trim();
    return name.isEmpty ? username : name;
  }

  /// 🔹 From Map
  factory LeadResellerData.fromMap(Map<String, dynamic> map) {
    return LeadResellerData(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }

  /// 🔹 To Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

class CustomOldLeadFields {
  final bool? isNegotiable;
  final String? timePeriod;
  final int? negotiablePrice;

  final String? visitDate;
  final String? visitTime;

  final String? inquiryType;

  // Project related
  final String? selectedVariantId;
  final String? selectedVariantName;
  final int? selectedVariantBhk;
  final int? selectedVariantPrice;

  // Property related
  final String? type;

  final int? margin;
  final String? marginType;
  final int? finalNegotiablePrice;

  final bool? isConvertedToProject;

  CustomOldLeadFields({
    this.isNegotiable,
    this.timePeriod,
    this.negotiablePrice,
    this.visitDate,
    this.visitTime,
    this.inquiryType,
    this.selectedVariantId,
    this.selectedVariantName,
    this.selectedVariantBhk,
    this.selectedVariantPrice,
    this.type,
    this.margin,
    this.marginType,
    this.finalNegotiablePrice,
    this.isConvertedToProject,
  });

  factory CustomOldLeadFields.fromJson(Map<String, dynamic> json) {
    return CustomOldLeadFields(
      isNegotiable: json['isNegotiable'],
      timePeriod: json['timePeriod'],
      negotiablePrice: json['negotiablePrice'],
      visitDate: json['visitDate'],
      visitTime: json['visitTime'],
      inquiryType: json['inquiryType'],
      selectedVariantId: json['selectedVariantId'],
      selectedVariantName: json['selectedVariantName'],
      selectedVariantBhk: json['selectedVariantBhk'],
      selectedVariantPrice: json['selectedVariantPrice'],
      type: json['type'],
      margin: json['margin'],
      marginType: json['marginType'],
      finalNegotiablePrice: json['finalNegotiablePrice'],
      isConvertedToProject: json['isConvertedToProject'],
    );
  }

  Map<String, dynamic> toJson() => {
    "isNegotiable": isNegotiable,
    "timePeriod": timePeriod,
    "negotiablePrice": negotiablePrice,
    "visitDate": visitDate,
    "visitTime": visitTime,
    "inquiryType": inquiryType,
    "selectedVariantId": selectedVariantId,
    "selectedVariantName": selectedVariantName,
    "selectedVariantBhk": selectedVariantBhk,
    "selectedVariantPrice": selectedVariantPrice,
    "type": type,
    "margin": margin,
    "marginType": marginType,
    "finalNegotiablePrice": finalNegotiablePrice,
    "isConvertedToProject": isConvertedToProject,
  };
}


// import 'dart:developer';

// import 'dart:developer';

class NewUpdatedLeadModel {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? name;
  final String? email;
  final String? phone;
  final String? propertyId;
  final String? resellerId;
  final String? inquiryId; // ✅ newly added
  final String? source;
  final String? status;
  final String? stage;
  final String? notes;
  final String? lastContactedAt;
  final bool? isFake;
  final String? fakeReason;
  final String? markedFakeBy;
  final String? markedFakeAt;
  final CustomFields? customFields;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NewUpdatedLeadModel({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.name,
    this.email,
    this.phone,
    this.propertyId,
    this.resellerId,
    this.inquiryId, // ✅ added
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

  factory NewUpdatedLeadModel.fromJson(
    Map<String, dynamic> json,
  ) => NewUpdatedLeadModel(
    id: json["id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    propertyId: json["property_id"],
    resellerId: json["reseller_id"],
    inquiryId: json["inquiry_id"], // ✅ map new field
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
        (() {
          final data = json["customFields"];
          if (data == null) return null;
          if (data is CustomFields) return data;
          if (data is Map<String, dynamic>) {
            try {
              return CustomFields.fromJson(data);
            } catch (e) {
              log("Error parsing customFields as Map: $e");
              return null;
            }
          }
          return null;
        })(),
    createdAt:
        json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    updatedAt:
        json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
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
    if (inquiryId != null) "inquiry_id": inquiryId, // ✅ added
    if (source != null) "source": source,
    if (status != null) "status": status,
    if (stage != null) "stage": stage,
    if (notes != null) "notes": notes,
    if (lastContactedAt != null) "lastContactedAt": lastContactedAt,
    if (isFake != null) "isFake": isFake,
    if (fakeReason != null) "fakeReason": fakeReason,
    if (markedFakeBy != null) "markedFakeBy": markedFakeBy,
    if (markedFakeAt != null) "markedFakeAt": markedFakeAt,
    if (customFields != null)
      "customFields":
          customFields is CustomFields ? customFields : customFields.toString(),
    if (createdAt != null) "createdAt": createdAt?.toIso8601String(),
    if (updatedAt != null) "updatedAt": updatedAt?.toIso8601String(),
  };
}

class CustomFields {
  final bool? isNegotiable;
  final String? timePeriod;
  final num? negotiablePrice;
  final String? visitDate;
  final String? visitTime;
  final num? margin;
  final String? marginType;
  final num? finalNegotiablePrice;
  final String? type;
  final bool? isConvertedToProject;

  // 🆕 New optional fields
  final String? serviceId;
  final String? serviceName;
  final String? contractorId;
  final String? contractorUsername;
  final String? serviceDescription;

  CustomFields({
    this.isNegotiable,
    this.timePeriod,
    this.negotiablePrice,
    this.visitDate,
    this.visitTime,
    this.margin,
    this.marginType,
    this.finalNegotiablePrice,
    this.type,
    this.isConvertedToProject,
    this.serviceId,
    this.serviceName,
    this.contractorId,
    this.contractorUsername,
    this.serviceDescription,
  });

  factory CustomFields.fromJson(Map<String, dynamic> json) => CustomFields(
    isNegotiable: json["isNegotiable"],
    timePeriod: json["timePeriod"],
    negotiablePrice: json["negotiablePrice"],
    visitDate: json["visitDate"],
    visitTime: json["visitTime"],
    margin: json["margin"],
    marginType: json["marginType"],
    finalNegotiablePrice: json["finalNegotiablePrice"],
    type: json["type"],
    isConvertedToProject: json["isConvertedToProject"],

    // 🆕 Added new fields
    serviceId: json["serviceId"],
    serviceName: json["serviceName"],
    contractorId: json["contractorId"],
    contractorUsername: json["contractorUsername"],
    serviceDescription: json["serviceDescription"],
  );

  Map<String, dynamic> toJson() => {
    if (isNegotiable != null) "isNegotiable": isNegotiable,
    if (timePeriod != null) "timePeriod": timePeriod,
    if (negotiablePrice != null) "negotiablePrice": negotiablePrice,
    if (visitDate != null) "visitDate": visitDate,
    if (visitTime != null) "visitTime": visitTime,
    if (margin != null) "margin": margin,
    if (marginType != null) "marginType": marginType,
    if (finalNegotiablePrice != null)
      "finalNegotiablePrice": finalNegotiablePrice,
    if (type != null) "type": type,
    if (isConvertedToProject != null)
      "isConvertedToProject": isConvertedToProject,

    // 🆕 Added new fields
    if (serviceId != null) "serviceId": serviceId,
    if (serviceName != null) "serviceName": serviceName,
    if (contractorId != null) "contractorId": contractorId,
    if (contractorUsername != null) "contractorUsername": contractorUsername,
    if (serviceDescription != null) "serviceDescription": serviceDescription,
  };
}

extension NewUpdatedLeadModelCopy on NewUpdatedLeadModel {
  NewUpdatedLeadModel copyWith({
    String? id,
    String? createdBy,
    String? updatedBy,
    String? name,
    String? email,
    String? phone,
    String? propertyId,
    String? resellerId,
    String? inquiryId, // ✅ added to copyWith
    String? source,
    String? status,
    String? stage,
    String? notes,
    String? lastContactedAt,
    bool? isFake,
    String? fakeReason,
    String? markedFakeBy,
    String? markedFakeAt,
    dynamic customFields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NewUpdatedLeadModel(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      propertyId: propertyId ?? this.propertyId,
      resellerId: resellerId ?? this.resellerId,
      inquiryId: inquiryId ?? this.inquiryId, // ✅ added
      source: source ?? this.source,
      status: status ?? this.status,
      stage: stage ?? this.stage,
      notes: notes ?? this.notes,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      isFake: isFake ?? this.isFake,
      fakeReason: fakeReason ?? this.fakeReason,
      markedFakeBy: markedFakeBy ?? this.markedFakeBy,
      markedFakeAt: markedFakeAt ?? this.markedFakeAt,
      customFields: customFields ?? this.customFields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
