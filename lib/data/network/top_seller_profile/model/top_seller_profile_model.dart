class TopSellersResponse {
  final bool success;
  final String message;
  final TopSellersData? data;

  TopSellersResponse({required this.success, required this.message, this.data});

  factory TopSellersResponse.fromJson(Map<String, dynamic> json) {
    return TopSellersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? TopSellersData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'story': success, 'message': message, 'data': data?.toJson()};
  }
}

class TopSellersData {
  final List<TopSeller> topSellers;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  TopSellersData({
    required this.topSellers,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory TopSellersData.fromJson(Map<String, dynamic> json) {
    return TopSellersData(
      topSellers:
          (json['topSellers'] as List<dynamic>?)
              ?.map((e) => TopSeller.fromJson(e))
              .toList() ??
          [],
      total: json['total'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
      fetchedAll: json['fetchedAll'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topSellers': topSellers.map((e) => e.toJson()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class TopSeller {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? profilePic;
  final String? city;
  final String? state;
  final String? sellerType;
  final SellerCounts? counts;

  TopSeller({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.city,
    this.state,
    this.sellerType,
    this.counts,
  });

  factory TopSeller.fromJson(Map<String, dynamic> json) {
    return TopSeller(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePic: json['profilePic'],
      city: json['city'],
      state: json['state'],
      sellerType: json['sellerType'],
      counts:
          json['counts'] != null ? SellerCounts.fromJson(json['counts']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'city': city,
      'profilePic': profilePic,
      'state': state,
      'sellerType': sellerType,
      'counts': counts?.toJson(),
    };
  }
}

class SellerCounts {
  final int? properties;
  final int? projects;

  SellerCounts({this.properties, this.projects});

  factory SellerCounts.fromJson(Map<String, dynamic> json) {
    return SellerCounts(
      properties: json['properties'],
      projects: json['projects'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'properties': properties, 'projects': projects};
  }
}
