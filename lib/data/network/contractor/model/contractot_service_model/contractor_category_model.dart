class ContractorServiceCategoryResponse {
  bool success;
  String message;
  ContractorServiceCategoryData data;

  ContractorServiceCategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorServiceCategoryResponse.fromMap(Map<String, dynamic> map) {
    return ContractorServiceCategoryResponse(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      data: ContractorServiceCategoryData.fromMap(map['data'] ?? {}),
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

class ContractorServiceCategoryData {
  List<ContractorServiceCategory> items;
  int total;
  int currentPage;
  int totalPages;
  bool hasMore;
  bool fetchedAll;

  ContractorServiceCategoryData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ContractorServiceCategoryData.fromMap(Map<String, dynamic> map) {
    return ContractorServiceCategoryData(
      items: List<ContractorServiceCategory>.from(
        (map['items'] ?? []).map((x) => ContractorServiceCategory.fromMap(x)),
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

class ContractorServiceCategory {
  String id;
  String createdBy;
  String? updatedBy;
  String name;
List<String> description; // ✅ FIXED
  String? icon;
  bool isActive;

  DateTime createdAt;
  DateTime updatedAt;

  ContractorServiceCategory({
    required this.id,
    required this.createdBy,
    this.updatedBy,
     this.icon,
    required this.name,
    required this.description,
    required this.isActive,
    
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContractorServiceCategory.fromMap(Map<String, dynamic> map) {
    return ContractorServiceCategory(
      id: map['id'] ?? '',
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'],
      icon: map['icon']??'',
      name: map['name'] ?? '',
       description: List<String>.from(map['description'] ?? []),
      isActive: map['isActive'] ?? false,
     
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'name': name,
      'icon':icon,
      'description': description,
      'isActive': isActive,
      
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
