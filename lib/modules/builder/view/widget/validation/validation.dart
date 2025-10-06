class ProjectValidators {
  static String? requiredText(String? v, {String field = 'Field'}) {
    if (v == null || v.trim().isEmpty) return '$field જરૂરી છે';
    return null;
  }

  static String? positiveNumber(num? v, {String field = 'Field'}) {
    if (v == null) return '$field જરૂરી છે';
    if (v <= 0) return '$field 0 થી મોટું હોવું જોઈએ';
    return null;
  }

  static String? minNumber(num? v, num min, {String field = 'Field'}) {
    if (v == null) return '$field જરૂરી છે';
    if (v < min) return '$field ઓછામાં ઓછું $min હોવું જોઈએ';
    return null;
  }

  static String? dateRequired(DateTime? v, {String field = 'તારીખ'}) {
    if (v == null) return '$field જરૂરી છે';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.isEmpty) return null;
    final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!r.hasMatch(v)) return 'માન્ય ઇમેઇલ દાખલ કરો';
    return null;
  }

  static String? possessionAfterLaunch(DateTime? possession, DateTime? launch) {
    if (possession == null || launch == null) return null;
    if (possession.isBefore(launch)) {
      return 'Possession Launch પછી હોવું જોઈએ';
    }
    return null;
  }

  static String? inEnum(String? v, List<String> allowed, {String field = 'Field'}) {
    if (v == null || v.isEmpty) return null;
    if (!allowed.contains(v)) return '$field માન્ય નથી';
    return null;
  }
}