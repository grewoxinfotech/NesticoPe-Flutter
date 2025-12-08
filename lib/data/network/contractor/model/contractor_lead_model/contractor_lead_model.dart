import 'dart:convert';

class ContractorLeadResponse {
  bool? success;
  String? message;
  ContractorLeadData? data;

  ContractorLeadResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ContractorLeadResponse.fromMap(Map<String, dynamic> map) {
    return ContractorLeadResponse(
      success: map['success'],
      message: map['message'],
      data: map['data'] != null ? ContractorLeadData.fromMap(map['data']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory ContractorLeadResponse.fromJson(String source) =>
      ContractorLeadResponse.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

class ContractorLeadData {
  List<ContractorLeadItem>? items;
  int? total;
  int? currentPage;
  int? totalPages;
  bool? hasMore;
  bool? fetchedAll;

  ContractorLeadData({
    this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory ContractorLeadData.fromMap(Map<String, dynamic> map) {
    return ContractorLeadData(
      items: map['items'] != null
          ? List<ContractorLeadItem>.from(
        map['items'].map((x) => ContractorLeadItem.fromMap(x)),
      )
          : [],
      total: map['total'],
      currentPage: map['currentPage'],
      totalPages: map['totalPages'],
      hasMore: map['hasMore'],
      fetchedAll: map['fetchedAll'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items?.map((x) => x.toMap()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class ContractorLeadItem {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? source;
  String? status;
  String? stage;
  DateTime? createdAt;
  ContractorLeadCustomFields? customFields;

  ContractorLeadItem({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.source,
    this.status,
    this.stage,
    this.createdAt,
    this.customFields,
  });

  factory ContractorLeadItem.fromMap(Map<String, dynamic> map) {
    return ContractorLeadItem(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      source: map['source'],
      status: map['status'],
      stage: map['stage'],
      createdAt:
      map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      customFields: map['customFields'] != null
          ? ContractorLeadCustomFields.fromMap(
          Map<String, dynamic>.from(map['customFields']))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'source': source,
      'status': status,
      'stage': stage,
      'createdAt': createdAt?.toIso8601String(),
      'customFields': customFields?.toMap(),
    };
  }
}

class ContractorLeadCustomFields {
  String? serviceId;
  String? serviceName;
  String? contractorId;
  String? contractorUsername;
  String? serviceDescription;
  bool? isConvertedToProject;

  ContractorLeadCustomFields({
    this.serviceId,
    this.serviceName,
    this.contractorId,
    this.contractorUsername,
    this.serviceDescription,
    this.isConvertedToProject,
  });

  factory ContractorLeadCustomFields.fromMap(Map<String, dynamic> map) {
    return ContractorLeadCustomFields(
      serviceId: map['serviceId'],
      serviceName: map['serviceName'],
      contractorId: map['contractorId'],
      contractorUsername: map['contractorUsername'],
      serviceDescription: map['serviceDescription'],
      isConvertedToProject: map['isConvertedToProject'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'contractorId': contractorId,
      'contractorUsername': contractorUsername,
      'serviceDescription': serviceDescription,
      'isConvertedToProject': isConvertedToProject,
    };
  }
}
