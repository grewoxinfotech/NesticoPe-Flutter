import '../../../data/network/property/models/property_model.dart';

class SearchFilterModel {
  final List<Prediction>? predictions;
  final String? status;

  SearchFilterModel({this.predictions, this.status});

  factory SearchFilterModel.fromJson(Map<String, dynamic> json) {
    return SearchFilterModel(
      predictions: json['predictions'] != null
          ? (json['predictions'] as List)
          .map((v) => Prediction.fromJson(v))
          .toList()
          : [],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predictions': predictions?.map((v) => v.toJson()).toList(),
      'status': status,
    };
  }
}

class Prediction {
  final Items? items;
  final String? description;
  final List<MatchedSubstring>? matchedSubstrings;
  final String? placeId;
  final String? reference;
  final StructuredFormatting? structuredFormatting;
  final List<Term>? terms;
  final List<String>? types;

  Prediction({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.items,
    this.types,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      matchedSubstrings: json['matched_substrings'] != null
          ? (json['matched_substrings'] as List)
          .map((v) => MatchedSubstring.fromJson(v))
          .toList()
          : [],
      placeId: json['place_id'],
      items: json['items'] != null ? Items.fromJson(json['items']) : null,
      reference: json['reference'],
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
      terms: json['terms'] != null
          ? (json['terms'] as List).map((v) => Term.fromJson(v)).toList()
          : [],
      types: json['types'] != null ? List<String>.from(json['types']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'matched_substrings':
      matchedSubstrings?.map((v) => v.toJson()).toList(),
      'items': items?.toJson(),
      'place_id': placeId,
      'reference': reference,
      'structured_formatting': structuredFormatting?.toJson(),
      'terms': terms?.map((v) => v.toJson()).toList(),
      'types': types,
    };
  }
}

class MatchedSubstring {
  final int? length;
  final int? offset;

  MatchedSubstring({this.length, this.offset});

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(
      length: json['length'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'offset': offset,
    };
  }
}

class StructuredFormatting {
  final String? mainText;
  final List<MatchedSubstring>? mainTextMatchedSubstrings;
  final String? secondaryText;

  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'],
      mainTextMatchedSubstrings: json['main_text_matched_substrings'] != null
          ? (json['main_text_matched_substrings'] as List)
          .map((v) => MatchedSubstring.fromJson(v))
          .toList()
          : [],
      secondaryText: json['secondary_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main_text': mainText,
      'main_text_matched_substrings':
      mainTextMatchedSubstrings?.map((v) => v.toJson()).toList(),
      'secondary_text': secondaryText,
    };
  }
}

class Term {
  final int? offset;
  final String? value;

  Term({this.offset, this.value});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      offset: json['offset'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'value': value,
    };
  }
}
