class ProjectValidators {
  static String? requiredText(String? v, {String field = 'Field'}) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? positiveNumber(num? v, {String field = 'Field'}) {
    if (v == null) return '$field is required';
    if (v <= 0) return '$field must be greater than 0';
    return null;
  }

  static String? minNumber(num? v, num min, {String field = 'Field'}) {
    if (v == null) return '$field is required';
    if (v < min) return '$field must be at least $min';
    return null;
  }

  static String? dateRequired(DateTime? v, {String field = 'Date'}) {
    if (v == null) return '$field is required';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.isEmpty) return null;
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!r.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  static String? possessionAfterLaunch(DateTime? possession, DateTime? launch) {
    if (possession == null || launch == null) return null;
    if (possession.isBefore(launch)) {
      return 'Possession must be after Launch';
    }
    return null;
  }

  static String? inEnum(String? v, List<String> allowed, {String field = 'Field'}) {
    if (v == null || v.isEmpty) return null;
    if (!allowed.contains(v)) return '$field is not valid';
    return null;
  }
}
