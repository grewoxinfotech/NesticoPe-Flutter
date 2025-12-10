// contractor_project_model.dart

class ContractorProjectModel {
  final bool success;
  final String message;
  final ContractorProjectData data;

  ContractorProjectModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorProjectModel.fromJson(Map<String, dynamic> json) {
    return ContractorProjectModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ContractorProjectData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };

  Map<String, dynamic> toMap() => toJson();
}

class ContractorProjectData {
  final List<ContractorProjectItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  ContractorProjectData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ContractorProjectData.fromJson(Map<String, dynamic> json) {
    final itemsData = json['items'];

    List<ContractorProjectItem> parsedItems = [];
    if (itemsData is List) {
      parsedItems = itemsData
          .map((e) => ContractorProjectItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (itemsData is Map<String, dynamic>) {
      parsedItems = [ContractorProjectItem.fromJson(itemsData)];
    } else {
      parsedItems = [];
    }

    return ContractorProjectData(
      items: parsedItems,
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'total': total,
    'currentPage': currentPage,
    'totalPages': totalPages,
    'hasMore': hasMore,
    'fetchedAll': fetchedAll,
  };

  Map<String, dynamic> toMap() => toJson();
}

class ContractorProjectItem {
  final String id;
  final String createdBy;
  final String updatedBy;
  final String leadId;
  final String title;
  final String status;
  final int progress;
  final String? deadline;
  final String? startDate;
  final String? completedAt;
  final ContractorProjectClient client;
  final String? notes;
  final ContractorProjectMeta meta;
  final String createdAt;
  final String updatedAt;

  ContractorProjectItem({
    required this.id,
    required this.createdBy,
    required this.updatedBy,
    required this.leadId,
    required this.title,
    required this.status,
    required this.progress,
    this.deadline,
    this.startDate,
    this.completedAt,
    required this.client,
    this.notes,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
  });
  ContractorProjectItem copyWith({
    String? id,
    String? createdBy,
    String? updatedBy,
    String? leadId,
    String? title,
    String? status,
    int? progress,
    String? deadline,
    String? startDate,
    String? completedAt,
    ContractorProjectClient? client,
    String? notes,
    ContractorProjectMeta? meta,
    String? createdAt,
    String? updatedAt,
  }) {
    return ContractorProjectItem(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      leadId: leadId ?? this.leadId,
      title: title ?? this.title,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      deadline: deadline ?? this.deadline,
      startDate: startDate ?? this.startDate,
      completedAt: completedAt ?? this.completedAt,
      client: client ?? this.client,
      notes: notes ?? this.notes,
      meta: meta ?? this.meta,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  factory ContractorProjectItem.fromJson(Map<String, dynamic> json) {
    return ContractorProjectItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      leadId: json['leadId'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      progress: json['progress'] ?? 0,
      deadline: json['deadline'],
      startDate: json['startDate'],
      completedAt: json['completedAt'],
      client: ContractorProjectClient.fromJson(json['client'] ?? {}),
      notes: json['notes'],
      meta: ContractorProjectMeta.fromJson(json['meta'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'leadId': leadId,
    'title': title,
    'status': status,
    'progress': progress,
    'deadline': deadline,
    'startDate': startDate,
    'completedAt': completedAt,
    'client': client.toJson(),
    'notes': notes,
    'meta': meta.toJson(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  Map<String, dynamic> toMap() => toJson();
}


class ContractorProjectClient {
  final String name;
  final String email;
  final String phone;
  final String propertyType;
  final String city;
  final String location;
  final String state;
  final int? bhk;
  final num? carpetArea;
  final String? serviceDescription;

  ContractorProjectClient({
    required this.name,
    required this.email,
    required this.phone,
    required this.propertyType,
    required this.city,
    required this.location,
    required this.state,
    this.bhk,
    this.carpetArea,
    this.serviceDescription,
  });

  factory ContractorProjectClient.fromJson(Map<String, dynamic> json) {
    return ContractorProjectClient(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      propertyType: json['propertyType'] ?? '',
      city: json['city'] ?? '',
      location: json['location'] ?? '',
      state: json['state'] ?? '',
      bhk: json['bhk'],
      carpetArea: json['carpetArea'],
      serviceDescription: json['serviceDescription'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'propertyType': propertyType,
    'city': city,
    'location': location,
    'state': state,
    'bhk': bhk,
    'carpetArea': carpetArea,
    'serviceDescription': serviceDescription,
  };

  Map<String, dynamic> toMap() => toJson();
}

class ContractorProjectMeta {
  final String serviceId;
  final String serviceName;
  final String inquiryId;

  ContractorProjectMeta({
    required this.serviceId,
    required this.serviceName,
    required this.inquiryId,
  });

  factory ContractorProjectMeta.fromJson(Map<String, dynamic> json) {
    return ContractorProjectMeta(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      inquiryId: json['inquiryId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    'serviceName': serviceName,
    'inquiryId': inquiryId,
  };

  Map<String, dynamic> toMap() => toJson();
}