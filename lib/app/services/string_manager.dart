String normalizeAmenity(String value) {
  return value
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'\s+'), '_') // multi spaces
      .replaceAll(RegExp(r'[^a-z0-9_]'), ''); // remove symbols
}
