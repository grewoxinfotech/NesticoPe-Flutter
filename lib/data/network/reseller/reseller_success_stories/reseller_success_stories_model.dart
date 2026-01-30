class ResellerSuccessData {
  final List<ResellerSuccessItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  ResellerSuccessData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ResellerSuccessData.fromJson(Map<String, dynamic> json) =>
      ResellerSuccessData(
        items: json["items"] == null
            ? []
            : List<ResellerSuccessItem>.from(
            json["items"].map((x) => ResellerSuccessItem.fromJson(x))),
        total: json["total"] ?? 0,
        currentPage: json["currentPage"] ?? 1,
        totalPages: json["totalPages"] ?? 1,
        hasMore: json["hasMore"] ?? false,
        fetchedAll: json["fetchedAll"] ?? false,
      );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "total": total,
    "currentPage": currentPage,
    "totalPages": totalPages,
    "hasMore": hasMore,
    "fetchedAll": fetchedAll,
  };
}

class ResellerSuccessItem {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String resellerId;
  final String title;
  final String description;
  final String achievement;
  final DateTime monthYear;
  final int totalDeals;
  final String totalValue;
  final int rating;
  final String? image;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ResellerInfo? reseller; // 👈 added field for nested reseller object

  ResellerSuccessItem({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.resellerId,
    required this.title,
    required this.description,
    required this.achievement,
    required this.monthYear,
    required this.totalDeals,
    required this.totalValue,
    required this.rating,
    this.image,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.reseller,
  });

  factory ResellerSuccessItem.fromJson(Map<String, dynamic> json) =>
      ResellerSuccessItem(
        id: json["id"] ?? "",
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        resellerId: json["resellerId"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        achievement: json["achievement"] ?? "",
        monthYear:
        DateTime.tryParse(json["monthYear"] ?? "") ?? DateTime.now(),
        totalDeals: json["totalDeals"] ?? 0,
        totalValue: json["totalValue"]?.toString() ?? "0",
        rating: json["rating"] ?? 0,
        image: json["image"],
        status: json["status"] ?? "",
        createdAt:
        DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
        updatedAt:
        DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
        reseller: json["reseller"] != null
            ? ResellerInfo.fromJson(json["reseller"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "resellerId": resellerId,
    "title": title,
    "description": description,
    "achievement": achievement,
    "monthYear": monthYear.toIso8601String(),
    "totalDeals": totalDeals,
    "totalValue": totalValue,
    "rating": rating,
    "image": image,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "reseller": reseller?.toJson(),
  };
}

/// 👇 Nested reseller model
class ResellerInfo {
  final String id;
  final String username;
  final String userType;

  ResellerInfo({
    required this.id,
    required this.username,
    required this.userType,
  });

  factory ResellerInfo.fromJson(Map<String, dynamic> json) => ResellerInfo(
    id: json["id"] ?? "",
    username: json["username"] ?? "",
    userType: json["userType"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "userType": userType,
  };
}

