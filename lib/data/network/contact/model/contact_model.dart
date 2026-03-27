class ContactItem {
  final String? id;
  final List<String> phones;
  final List<String> emails;
  final List<ContactLocation> locations;
  final SocialMedia? socialMedia;

  ContactItem({
    this.id,
    this.phones = const [],
    this.emails = const [],
    this.locations = const [],
    this.socialMedia,
  });

  factory ContactItem.fromJson(Map<String, dynamic> json) {
    return ContactItem(
      id: json['id']?.toString(),
      phones: (json['phones'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      emails: (json['emails'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      locations: (json['locations'] as List<dynamic>?)
              ?.map((e) => ContactLocation.fromJson(e))
              .toList() ??
          const [],
      socialMedia: json['socialMedia'] != null
          ? SocialMedia.fromJson(json['socialMedia'])
          : null,
    );
  }
}

class ContactLocation {
  final String? city;
  final String? state;
  final String? address;
  final String? zipCode;

  ContactLocation({this.city, this.state, this.address, this.zipCode});

  factory ContactLocation.fromJson(Map<String, dynamic> json) {
    return ContactLocation(
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      address: json['address']?.toString(),
      zipCode: json['zipCode']?.toString(),
    );
  }
}

class SocialMedia {
  final String? twitter;
  final String? facebook;
  final String? linkedin;
  final String? instagram;

  SocialMedia({this.twitter, this.facebook, this.linkedin, this.instagram});

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      twitter: json['twitter']?.toString(),
      facebook: json['facebook']?.toString(),
      linkedin: json['linkedin']?.toString(),
      instagram: json['instagram']?.toString(),
    );
  }
}
