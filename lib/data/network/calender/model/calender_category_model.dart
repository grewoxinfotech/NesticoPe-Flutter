class CalenderCategoryModel {
  final String id;
  final String createdBy;
  final String? updatedBy;
  String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  CalenderCategoryModel({
    required this.id,
    required this.createdBy,
    this.updatedBy,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CalenderCategoryModel.fromJson(Map<String, dynamic> json) {
    return CalenderCategoryModel(
      id: json['id'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
