class ContractorInquiry {
  final bool success;
  final String message;
  final ContractorInquiryData data;

  ContractorInquiry({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorInquiry.fromMap(Map<String, dynamic> map) {
    return ContractorInquiry(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      data: ContractorInquiryData.fromMap(map['data'] ?? {}),
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

class ContractorInquiryData {
  final List<ContractorInquiryItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  ContractorInquiryData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ContractorInquiryData.fromMap(Map<String, dynamic> map) {
    return ContractorInquiryData(
      items: List<ContractorInquiryItem>.from(
        (map['items'] ?? []).map((x) => ContractorInquiryItem.fromMap(x)),
      ),
      total: map['total'] ?? 0,
      currentPage: map['currentPage'] ?? 1,
      totalPages: map['totalPages'] ?? 1,
      hasMore: map['hasMore'] ?? false,
      fetchedAll: map['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((x) => x.toMap()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class ContractorInquiryItem {
  final String id;
  final String createdBy;
  final String? updatedBy;
  final String contractorId;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final List<InquiryService> services;
  final String inquiredAt;
  final String status;
  final String? submittedAt;
  final bool isConvertedToLead;
  final bool isConvertedToQuotation;
  final String? convertedToLeadAt;
  final List<String> convertedServices;
  final InquiryMeta meta;
  final String createdAt;
  final String updatedAt;

  ContractorInquiryItem({
    required this.id,
    required this.createdBy,
    this.updatedBy,
    required this.contractorId,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.services,
    required this.inquiredAt,
    required this.status,
    this.submittedAt,
    required this.isConvertedToLead,
    required this.isConvertedToQuotation,
    this.convertedToLeadAt,
    required this.convertedServices,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContractorInquiryItem.fromMap(Map<String, dynamic> map) {
    return ContractorInquiryItem(
      id: map['id'] ?? '',
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'],
      contractorId: map['contractorId'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      services: List<InquiryService>.from(
        (map['services'] ?? []).map((x) => InquiryService.fromMap(x)),
      ),
      inquiredAt: map['inquiredAt'] ?? '',
      status: map['status'] ?? '',
      submittedAt: map['submittedAt'],
      isConvertedToLead: map['isConvertedToLead'] ?? false,
      isConvertedToQuotation: map['isConvertedToQuotation'],
      convertedToLeadAt: map['convertedToLeadAt'],
      convertedServices: List<String>.from(map['convertedServices'] ?? []),
      meta: InquiryMeta.fromMap(map['meta'] ?? {}),
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'contractorId': contractorId,
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'services': services.map((x) => x.toMap()).toList(),
      'inquiredAt': inquiredAt,
      'status': status,
      'submittedAt': submittedAt,
      'isConvertedToLead': isConvertedToLead,
      'isConvertedToQuotation': isConvertedToQuotation,
      'convertedToLeadAt': convertedToLeadAt,
      'convertedServices': convertedServices,
      'meta': meta.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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

class InquiryMeta {
  final String propertyType;
  final String city;
  final String location;
  final String state;
  final int? bhk;
  final num carpetArea;
  final String serviceDescription;

  InquiryMeta({
    required this.propertyType,
    required this.city,
    required this.location,
    required this.state,
    this.bhk,
    required this.carpetArea,
    required this.serviceDescription,
  });

  factory InquiryMeta.fromMap(Map<String, dynamic> map) {
    return InquiryMeta(
      propertyType: map['propertyType'] ?? '',
      city: map['city'] ?? '',
      location: map['location'] ?? '',
      state: map['state'] ?? '',
      bhk: map['bhk'],
      carpetArea: map['carpetArea'] ?? 0,
      serviceDescription: map['serviceDescription'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propertyType': propertyType,
      'city': city,
      'location': location,
      'state': state,
      'bhk': bhk,
      'carpetArea': carpetArea,
      'serviceDescription': serviceDescription,
    };
  }
}
