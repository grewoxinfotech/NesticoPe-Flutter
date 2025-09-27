class AreaRangeHelper {
  // Define ranges for each BHK in sq.ft.
  static final Map<String, List<int>> _sqftRanges = {
    "1 RK": [150, 1500],
    "1 BHK": [300, 1800],
    "2 BHK": [500, 2500],
    "3 BHK": [800, 3500],
    "4 BHK": [1200, 5000],
    "5 BHK": [1500, 6000],
    "6 BHK": [1800, 7000],
    "7 BHK": [2200, 8000],
    "8 BHK": [2500, 9000],
    "9 BHK": [2800, 10000],
    "10 BHK": [3000, 12000],
  };

  /// Conversion factors
  static const double sqftToSqyd = 0.1111; // 1 sq.ft = 0.1111 sq.yd
  static const double sqftToSqmt = 0.0929; // 1 sq.ft = 0.0929 sq.mt

  /// Get area range based on BHK type and unit
  static List<int> getAreaRange(String bhkType, String unit) {
    final sqftRange = _sqftRanges[bhkType];
    if (sqftRange == null) return [0, 0];

    switch (unit) {
      case "sq.ft.":
        return sqftRange;

      case "sq.yd.":
        return [
          (sqftRange[0] * sqftToSqyd).round(),
          (sqftRange[1] * sqftToSqyd).round()
        ];

      case "sq.mt.":
        return [
          (sqftRange[0] * sqftToSqmt).round(),
          (sqftRange[1] * sqftToSqmt).round()
        ];

      default:
        return [0, 0];
    }
  }
}
