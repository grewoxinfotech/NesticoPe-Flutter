/// Status matches your "Status" array
enum LeadStatus {
  new_,        // New
  contacted,
  qualified,
  negotiation,
  lost,
  convert,
  fake,
}

enum SourceType {
  app,
  website,
  referral,
  socialMedia,
  direct,
  other,
}

/// Stage matches your "Stage" array
enum LeadStage {

  newLead,     // New Lead
  contacted,
  interested,
  siteVisit,
  sell,
}

class Lead {
  final String id;
  final String name;
  final String company;
  final String email;
  final String phone;
  final double estimatedValue;
  final LeadStatus status;      // status of lead
  final LeadStage stage;        // stage of lead
  final String property;        // Add property field
  final String reseller;        // Add reseller field
  final String notes;
  final DateTime createdAt;

  Lead({
    required this.id,
    required this.name,
    required this.company,
    this.email = '',
    this.phone = '',
    required this.estimatedValue,
    required this.status,
    required this.stage,
    this.property = '',
    this.reseller = '',
    this.notes = '',
    required this.createdAt,
  });

  Lead copyWith({
    String? id,
    String? name,
    String? company,
    String? email,
    String? phone,
    double? estimatedValue,
    LeadStatus? status,
    LeadStage? stage,
    String? property,
    String? reseller,
    String? notes,
    DateTime? createdAt,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      status: status ?? this.status,
      stage: stage ?? this.stage,
      property: property ?? this.property,
      reseller: reseller ?? this.reseller,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'email': email,
      'phone': phone,
      'estimatedValue': estimatedValue,
      'status': status.toString().split('.').last,
      'stage': stage.toString().split('.').last,
      'property': property,
      'reseller': reseller,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      estimatedValue: (json['estimatedValue'] as num).toDouble(),
      status: LeadStatus.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() ==
            (json['status'] ?? '').toString().toLowerCase(),
        orElse: () => LeadStatus.new_,
      ),
      stage: LeadStage.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() ==
            (json['stage'] ?? '').toString().toLowerCase(),
        orElse: () => LeadStage.newLead,
      ),
      property: json['property'] ?? '',
      reseller: json['reseller'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Product {
  final String id;
  final String name;       // property name
  final String category;   // address
  final double price;      // monthly rent or price
  final double rating;
  final int stock;
  final String image;      // image URL
  final String description;

  final int beds;          // no. of bedrooms
  final double area;       // in m²
  final int garage;        // no. of garages

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.image,
    required this.description,
    required this.beds,
    required this.area,
    required this.garage,
  });
}

enum SortOption { name, priceAsc, priceDesc, rating }

class DashboardMetrics {
  final double totalSales;
  final int totalLeads;
  final int totalProducts;
  final double growthPercentage;

  DashboardMetrics({
    required this.totalSales,
    required this.totalLeads,
    required this.totalProducts,
    required this.growthPercentage,
  });
}