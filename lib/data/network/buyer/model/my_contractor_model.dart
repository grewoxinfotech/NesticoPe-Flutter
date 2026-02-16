class ContractorProjectsResponse {
  final bool success;
  final String message;
  final ContractorProjectsData data;

  ContractorProjectsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorProjectsResponse.fromJson(Map<String, dynamic> json) {
    return ContractorProjectsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ContractorProjectsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class ContractorProjectsData {
  final List<ContractorProjectItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  ContractorProjectsData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ContractorProjectsData.fromJson(Map<String, dynamic> json) {
    return ContractorProjectsData(
      items:
          (json['items'] as List? ?? [])
              .map((e) => ContractorProjectItem.fromJson(e))
              .toList(),
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
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
}

class ContractorProjectItem {
  final String id;
  final String createdBy;
  final String updatedBy;
  final String leadId;
  final String title;
  final String status;
  final int progress;
  final DateTime? deadline;
  final DateTime? startDate;
  final DateTime? completedAt;
  final Client client;
  final String? notes;
  final ProjectMeta meta;
  final String price;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory ContractorProjectItem.fromJson(Map<String, dynamic> json) {
    return ContractorProjectItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      leadId: json['leadId'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      progress: json['progress'] ?? 0,
      deadline:
          json['deadline'] != null ? DateTime.tryParse(json['deadline']) : null,
      startDate:
          json['startDate'] != null
              ? DateTime.tryParse(json['startDate'])
              : null,
      completedAt:
          json['completedAt'] != null
              ? DateTime.tryParse(json['completedAt'])
              : null,
      client: Client.fromJson(json['client'] ?? {}),
      notes: json['notes'],
      meta: ProjectMeta.fromJson(json['meta'] ?? {}),
      price: json['price'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
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
    'deadline': deadline?.toIso8601String(),
    'startDate': startDate?.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'client': client.toJson(),
    'notes': notes,
    'meta': meta.toJson(),
    'price': price,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

class Client {
  final String name;
  final String email;
  final String phone;
  final String? propertyType;
  final String? city;
  final String? location;
  final String? state;
  final int? carpetArea;
  final String? serviceDescription;

  Client({
    required this.name,
    required this.email,
    required this.phone,
    this.propertyType,
    this.city,
    this.location,
    this.state,
    this.carpetArea,
    this.serviceDescription,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      propertyType: json['propertyType'],
      city: json['city'],
      location: json['location'],
      state: json['state'],
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
    'carpetArea': carpetArea,
    'serviceDescription': serviceDescription,
  };
}

class ProjectMeta {
  final String? serviceId;
  final String? serviceName;
  final List<ProjectPhoto> beforePhotos;
  final List<ProjectPhoto> afterPhotos;
  final List<Employee> employees;

  ProjectMeta({
    this.serviceId,
    this.serviceName,
    required this.beforePhotos,
    required this.afterPhotos,
    required this.employees,
  });

  factory ProjectMeta.fromJson(Map<String, dynamic> json) {
    return ProjectMeta(
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      beforePhotos:
          (json['beforePhotos'] as List? ?? [])
              .map((e) => ProjectPhoto.fromJson(e))
              .toList(),
      afterPhotos:
          (json['afterPhotos'] as List? ?? [])
              .map((e) => ProjectPhoto.fromJson(e))
              .toList(),
      employees:
          (json['employees'] as List? ?? [])
              .map((e) => Employee.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'serviceId': serviceId,
    'serviceName': serviceName,
    'beforePhotos': beforePhotos.map((e) => e.toJson()).toList(),
    'afterPhotos': afterPhotos.map((e) => e.toJson()).toList(),
    'employees': employees.map((e) => e.toJson()).toList(),
  };
}

class ProjectPhoto {
  final String uid;
  final String name;
  final String url;
  final DateTime? uploadedAt;

  ProjectPhoto({
    required this.uid,
    required this.name,
    required this.url,
    this.uploadedAt,
  });

  factory ProjectPhoto.fromJson(Map<String, dynamic> json) {
    return ProjectPhoto(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      uploadedAt:
          json['uploadedAt'] != null
              ? DateTime.tryParse(json['uploadedAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'url': url,
    'uploadedAt': uploadedAt?.toIso8601String(),
  };
}

class Employee {
  final String id;

  Employee({required this.id});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(id: json['id'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id};
}
