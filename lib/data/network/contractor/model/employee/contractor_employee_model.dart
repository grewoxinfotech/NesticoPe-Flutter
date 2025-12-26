class ContractorEmployeeResponse {
  final bool success;
  final String message;
  final ContractorEmployeeData? data;

  ContractorEmployeeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ContractorEmployeeResponse.fromJson(Map<String, dynamic> json) {
    return ContractorEmployeeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ContractorEmployeeData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ContractorEmployeeData {
  final List<ContractorEmployeeItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  ContractorEmployeeData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ContractorEmployeeData.fromJson(Map<String, dynamic> json) {
    return ContractorEmployeeData(
      items: (json['items'] as List?)
          ?.map((e) => ContractorEmployeeItem.fromJson(e))
          .toList() ??
          [],
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class ContractorEmployeeItem {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String experience;

  ContractorEmployeeItem({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.experience,
  });

  factory ContractorEmployeeItem.fromJson(Map<String, dynamic> json) {
    return ContractorEmployeeItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      experience: json['experience']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'experience': experience,
    };
  }
}
