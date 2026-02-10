import 'package:intl/intl.dart';

class Formatter {
  Formatter._();

  static String formatPriceIndian(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN', // Indian locale
      symbol: '₹', // Rupee symbol
      decimalDigits: 0, // No decimal for round prices
    );
    return formatter.format(value);
  }

  static String formatPriceCompact(double value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(0)} Cr';
    } else if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(0)} L';
    } else if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(0)} K';
    }
    return '₹$value';
  }
  /// Converts an ISO date string (e.g., "2025-12-30T07:07:57.000Z")
  /// into a readable format like "30 Dec 2025".
  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return '-';
    }
  }

  /// Converts to a detailed date-time format like "30 Dec 2025, 12:30 PM"
  static String formatDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return '-';
    }
  }

  /// Converts a [DateTime] object directly to "30 Dec 2025"
  static String formatDateFromDateTime(DateTime? date) {
    if (date == null) return '-';
    try {
      return DateFormat('dd MMM yyyy').format(date.toLocal());
    } catch (e) {
      return '-';
    }
  }
  static String formatPriceRangeFromString(String? range) {
    if (range == null || range.isEmpty || !range.contains('-')) {
      return '—';
    }

    final parts = range.split('-');
    if (parts.length != 2) return '—';

    final min = num.tryParse(parts[0].trim());
    final max = num.tryParse(parts[1].trim());

    if (min == null || max == null) return '—';

    return formatPriceRange(min, max);
  }


  static String formatPriceRange(num min, num max) {
    if (min == max) {
      return formatPrice(min);
    }

    return '${formatPrice(min)} – ${formatPrice(max)}';
  }

  static String formatPrice(num price) {
    const String prefix = '₹';
    String suffix = '';
    num value = price;

    if (price.abs() >= 10000000) {
      // 1 Crore = 10,000,000
      value = price / 10000000;
      suffix = 'Cr';
    } else if (price.abs() >= 100000) {
      // 1 Lakh = 100,000
      value = price / 100000;
      suffix = 'L';
    } else if (price.abs() >= 1000) {
      // 1 Thousand = 1,000
      value = price / 1000;
      suffix = 'K';
    } else {
      // Less than 1k
      return '$prefix ${price.toStringAsFixed(0)}';
    }

    // Keep up to 2 decimal places and remove unnecessary trailing zeros
    String formatted = value.toStringAsFixed(2);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    if (formatted.endsWith('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return '$prefix $formatted$suffix';
  }

  static String formatFullPrice(num price) {
    const String prefix = '₹';
    String suffix = '';
    num value = price;

    if (price.abs() >= 10000000) {
      // 1 Crore = 10,000,000
      value = price / 10000000;
      suffix = 'Cr';
    } else if (price.abs() >= 100000) {
      // 1 Lakh = 100,000
      value = price / 100000;
      suffix = 'L';
    } else if (price.abs() >= 1000) {
      // 1 Thousand = 1,000
      value = price / 1000;
      suffix = 'K';
    } else {
      return '$prefix ${price.toStringAsFixed(0)}';
    }

    // Keep up to 2 decimals (e.g. 2.45Cr)
    String formatted = value.toStringAsFixed(2);
    if (formatted.endsWith('0')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      if (formatted.endsWith('.')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
    }

    return '$prefix $formatted$suffix';
  }


  static String formatNumber(num price) {
    String suffix = '';
    num value = price;

    if (price.abs() >= 10000000) {
      // 1 Crore = 10,000,000
      value = price / 10000000;
      suffix = 'Cr';
    } else if (price.abs() >= 100000) {
      // 1 Lakh = 100,000
      value = price / 100000;
      suffix = 'L';
    } else if (price.abs() >= 1000) {
      // 1 Thousand = 1,000
      value = price / 1000;
      suffix = 'K';
    } else {
      // Less than 1k
      return price.toStringAsFixed(0);
    }

    // Keep up to 2 decimals (e.g. 2.45Cr)
    String formatted = value.toStringAsFixed(2);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    if (formatted.endsWith('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return '$formatted$suffix';
  }


  static String formatGraphPrice(num price) {
    const String prefix = '₹';
    String suffix = '';
    num value = price;

    if (price.abs() >= 10000000) {
      // 1 Crore = 10,000,000
      value = price / 10000000;
      suffix = 'Cr';
    } else if (price.abs() >= 100000) {
      // 1 Lakh = 100,000
      value = price / 100000;
      suffix = 'L';
    } else if (price.abs() >= 1000) {
      // 1 Thousand = 1,000
      value = price / 1000;
      suffix = 'K';
    } else {
      // Less than 1k
      return '$prefix ${price.toStringAsFixed(0)}';
    }

    // Keep up to 2 decimal places and remove unnecessary trailing zeros
    String formatted = value.toStringAsFixed(1);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    if (formatted.endsWith('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return '$prefix $formatted$suffix';
  }

  static String formatGraphFullPrice(num price) {
    const String prefix = '₹';
    String suffix = '';
    num value = price;

    if (price.abs() >= 10000000) {
      // 1 Crore = 10,000,000
      value = price / 10000000;
      suffix = 'Cr';
    } else if (price.abs() >= 100000) {
      // 1 Lakh = 100,000
      value = price / 100000;
      suffix = 'L';
    } else if (price.abs() >= 1000) {
      // 1 Thousand = 1,000
      value = price / 1000;
      suffix = 'K';
    } else {
      return '$prefix ${price.toStringAsFixed(0)}';
    }

    // Keep up to 2 decimals (e.g. 2.45Cr)
    String formatted = value.toStringAsFixed(1);
    if (formatted.endsWith('0')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      if (formatted.endsWith('.')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
    }

    return '$prefix $formatted$suffix';
  }


  static String formatGraphNumber(num price) {
    String suffix = '';
    num value = price;

    if (price.abs() >= 10000000) {
      // 1 Crore = 10,000,000
      value = price / 10000000;
      suffix = 'Cr';
    } else if (price.abs() >= 100000) {
      // 1 Lakh = 100,000
      value = price / 100000;
      suffix = 'L';
    } else if (price.abs() >= 1000) {
      // 1 Thousand = 1,000
      value = price / 1000;
      suffix = 'K';
    } else {
      // Less than 1k
      return price.toStringAsFixed(0);
    }

    // Keep up to 2 decimals (e.g. 2.45Cr)
    String formatted = value.toStringAsFixed(1);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    if (formatted.endsWith('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return '$formatted$suffix';
  }


  static String formatPriceInternational(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}
