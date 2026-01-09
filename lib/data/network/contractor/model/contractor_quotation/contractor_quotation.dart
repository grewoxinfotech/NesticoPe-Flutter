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
  final QuotationMeta meta;
  final bool isConverted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContractorQuotation({
    required this.id,
    required this.createdBy,
    this.updatedBy,
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
      'meta': meta.toMap(),
      'is_converted': isConverted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
class QuotationMeta {
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
