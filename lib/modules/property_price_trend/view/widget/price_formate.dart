String formatNumber(dynamic value) {
  if (value >= 10000000) {
    return "${(value / 10000000).toStringAsFixed(1)} Cr"; // Crores
  } else if (value >= 100000) {
    return "${(value / 100000).toStringAsFixed(1)} L"; // Lakhs
  } else if (value >= 1000) {
    return "${(value / 1000).toStringAsFixed(0)}K"; // Thousands
  } else {
    return value.toInt().toString();
  }
}
