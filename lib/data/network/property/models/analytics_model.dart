class ScoreBreakdownModel {
  final double totalScore;
  final double maxScore;
  final ScoreComponents components;

  ScoreBreakdownModel({
    required this.totalScore,
    required this.maxScore,
    required this.components,
  });

  factory ScoreBreakdownModel.fromJson(Map<String, dynamic> json) {
    return ScoreBreakdownModel(
      totalScore: (json['totalScore'] ?? 0).toDouble(),
      maxScore: (json['maxScore'] ?? 0).toDouble(),
      components: ScoreComponents.fromJson(json['components'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalScore": totalScore,
      "maxScore": maxScore,
      "components": components.toJson(),
    };
  }
}

class ScoreComponents {
  final BasePerformanceComponent basePerformance;
  final SimpleComponent subscriptionPlan;
  final BreakdownComponent mediaQuality;
  final BreakdownComponent engagement;
  final PremiumComponent premium;

  ScoreComponents({
    required this.basePerformance,
    required this.subscriptionPlan,
    required this.mediaQuality,
    required this.engagement,
    required this.premium,
  });

  factory ScoreComponents.fromJson(Map<String, dynamic> json) {
    return ScoreComponents(
      basePerformance: BasePerformanceComponent.fromJson(
        json['basePerformance'] ?? {},
      ),
      subscriptionPlan: SimpleComponent.fromJson(
        json['subscriptionPlan'] ?? {},
      ),
      mediaQuality: BreakdownComponent.fromJson(json['mediaQuality'] ?? {}),
      engagement: BreakdownComponent.fromJson(json['engagement'] ?? {}),
      premium: PremiumComponent.fromJson(json['premium'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "basePerformance": basePerformance.toJson(),
      "subscriptionPlan": subscriptionPlan.toJson(),
      "mediaQuality": mediaQuality.toJson(),
      "engagement": engagement.toJson(),
      "premium": premium.toJson(),
    };
  }
}

/// Base Performance has "raw" extra field
class BasePerformanceComponent {
  final double score;
  final double max;
  final double raw;
  final String description;

  BasePerformanceComponent({
    required this.score,
    required this.max,
    required this.raw,
    required this.description,
  });

  factory BasePerformanceComponent.fromJson(Map<String, dynamic> json) {
    return BasePerformanceComponent(
      score: (json['score'] ?? 0).toDouble(),
      max: (json['max'] ?? 0).toDouble(),
      raw: (json['raw'] ?? 0).toDouble(),
      description: json['description'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"score": score, "max": max, "raw": raw, "description": description};
  }
}

/// Subscription & Similar simple components
class SimpleComponent {
  final double score;
  final double max;
  final String description;

  SimpleComponent({
    required this.score,
    required this.max,
    required this.description,
  });

  factory SimpleComponent.fromJson(Map<String, dynamic> json) {
    return SimpleComponent(
      score: (json['score'] ?? 0).toDouble(),
      max: (json['max'] ?? 0).toDouble(),
      description: json['description'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"score": score, "max": max, "description": description};
  }
}

/// Components with nested breakdown like images/videos/documents
class BreakdownComponent {
  final double score;
  final double max;
  final String description;
  final Map<String, SubBreakdown> breakdown;

  BreakdownComponent({
    required this.score,
    required this.max,
    required this.description,
    required this.breakdown,
  });

  factory BreakdownComponent.fromJson(Map<String, dynamic> json) {
    final rawBreakdown = json['breakdown'] as Map<String, dynamic>? ?? {};

    return BreakdownComponent(
      score: (json['score'] ?? 0).toDouble(),
      max: (json['max'] ?? 0).toDouble(),
      description: json['description'] ?? "",
      breakdown: rawBreakdown.map(
        (key, value) => MapEntry(key, SubBreakdown.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "score": score,
      "max": max,
      "description": description,
      "breakdown": breakdown.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

/// Inner breakdown items like images/videos/views/inquiries
class SubBreakdown {
  final int count;
  final double score;
  final double max;
  final int? maxCount;

  SubBreakdown({
    required this.count,
    required this.score,
    required this.max,
    this.maxCount,
  });

  factory SubBreakdown.fromJson(Map<String, dynamic> json) {
    return SubBreakdown(
      count: json['count'] ?? 0,
      score: (json['score'] ?? 0).toDouble(),
      max: (json['max'] ?? 0).toDouble(),
      maxCount: json.containsKey('maxcount') ? json['maxcount'] ?? 0 : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"count": count, "score": score, "max": max, "maxcount": maxCount};
  }
}

/// Premium has extra field "isPremium"
class PremiumComponent {
  final double score;
  final double max;
  final bool isPremium;
  final String description;

  PremiumComponent({
    required this.score,
    required this.max,
    required this.isPremium,
    required this.description,
  });

  factory PremiumComponent.fromJson(Map<String, dynamic> json) {
    return PremiumComponent(
      score: (json['score'] ?? 0).toDouble(),
      max: (json['max'] ?? 0).toDouble(),
      isPremium: json['isPremium'] ?? false,
      description: json['description'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "score": score,
      "max": max,
      "isPremium": isPremium,
      "description": description,
    };
  }
}
