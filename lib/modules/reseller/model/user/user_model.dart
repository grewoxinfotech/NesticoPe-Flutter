class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String position;
  final String company;
  final String bio;
  final String avatarUrl;
  final double totalSales;
  final int leadsCount;
  final double rating;
  final DateTime joinedDate;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.company,
    required this.bio,
    required this.avatarUrl,
    required this.totalSales,
    required this.leadsCount,
    required this.rating,
    required this.joinedDate,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? position,
    String? company,
    String? bio,
    String? avatarUrl,
    double? totalSales,
    int? leadsCount,
    double? rating,
    DateTime? joinedDate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      position: position ?? this.position,
      company: company ?? this.company,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalSales: totalSales ?? this.totalSales,
      leadsCount: leadsCount ?? this.leadsCount,
      rating: rating ?? this.rating,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}