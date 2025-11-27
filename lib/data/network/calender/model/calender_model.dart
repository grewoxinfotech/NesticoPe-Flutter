class CalenderEventModel {
  String id;
  String? createdBy;
  String? updatedBy;
  String? title;
  String? date;
  String? categoryId;
  String? categoryName;
  String? details;
  DateTime? createdAt;
  DateTime? updatedAt;

  CalenderEventModel({
    this.id = '',
    this.createdBy,
    this.updatedBy,
    this.title,
    this.categoryName,
    this.date,
    this.categoryId,
    this.details,
    this.createdAt,
    this.updatedAt,
  });

  factory CalenderEventModel.fromJson(Map<String, dynamic> json) {
    return CalenderEventModel(
      id: json['id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      title: json['title'],
      date: json['date'],
      categoryId: json['category'],
      details: json['details'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'category': categoryId,
      'details': details,
    };
  }
}
