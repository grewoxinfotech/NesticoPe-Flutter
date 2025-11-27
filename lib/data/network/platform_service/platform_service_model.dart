class PlatformServicesModel {
  bool? success;
  String? message;
  PlatformServicesData? data;

  PlatformServicesModel({this.success, this.message, this.data});

  factory PlatformServicesModel.fromJson(Map<String, dynamic> json) {
    return PlatformServicesModel(
      success: json['story'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? PlatformServicesData.fromJson(
                json['data'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'story': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class PlatformServicesData {
  List<PlatformServiceItem>? items;
  Pagination? pagination;

  PlatformServicesData({this.items, this.pagination});

  factory PlatformServicesData.fromJson(Map<String, dynamic> json) {
    return PlatformServicesData(
      items:
          (json['items'] as List?)
              ?.map(
                (x) => PlatformServiceItem.fromJson(x as Map<String, dynamic>),
              )
              .toList(),
      pagination: Pagination.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items?.map((x) => x.toJson()).toList(),
    'total': pagination?.total,
    'currentPage': pagination?.current,
    'totalPages': pagination?.totalPages,
    'hasMore': pagination?.hasMore,
    'fetchedAll': pagination?.fetchedAll,
  };
}

class PlatformServiceItem {
  String? id;
  String? createdBy;
  String? updatedBy;
  String? title;
  String? description;
  List<String>? features;
  String? icon;
  int? order;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  PlatformServiceItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.title,
    this.description,
    this.features,
    this.icon,
    this.order,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PlatformServiceItem.fromJson(Map<String, dynamic> json) {
    return PlatformServiceItem(
      id: json['id'] as String?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      features: (json['features'] as List?)?.map((e) => e as String).toList(),
      icon: json['icon'] as String?,
      order: TypeConverter.parseInt(json['order']),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'title': title,
    'description': description,
    'features': features,
    'icon': icon,
    'order': order,
    'isActive': isActive,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class Pagination {
  int? total;
  int? current;
  int? totalPages;
  bool? hasMore;
  bool? fetchedAll;

  Pagination({
    this.total,
    this.current,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: TypeConverter.parseInt(json['total']),
      current: TypeConverter.parseInt(json['currentPage']),
      totalPages: TypeConverter.parseInt(json['totalPages']),
      hasMore: json['hasMore'] as bool?,
      fetchedAll: json['fetchedAll'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'current': current,
    'totalPages': totalPages,
    'hasMore': hasMore,
    'fetchedAll': fetchedAll,
  };
}

/// Safe converter for numbers
class TypeConverter {
  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
