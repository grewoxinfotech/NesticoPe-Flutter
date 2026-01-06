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

  // static String formatNumber(num price) {
  //   String suffix = '';
  //   num value = price;
  //   String prefix = '₹';
  //
  //   if (price >= 10000000 || price <= -10000000) {
  //     // 1 Crore = 1 Cr = 10,000,000
  //     value = price / 10000000;
  //     suffix = 'Cr';
  //   } else if (price >= 100000 || price <= -100000) {
  //     // 1 Lakh = 1 Lac = 100,000
  //     value = price / 100000;
  //     suffix = 'L';
  //   } else if (price >= 1000 || price <= -1000) {
  //     // 1 Thousand
  //     value = price / 1000;
  //     suffix = 'K';
  //   } else {
  //     // Less than 1k, return with 2 decimal places
  //     return '${price}';
  //   }
  //
  //   // Remove trailing .0 for larger amounts
  //   String formatted = value.toStringAsFixed(1);
  //   if (formatted.endsWith('.0')) {
  //     formatted = formatted.substring(0, formatted.length - 2);
  //   }
  //
  //   return '$formatted$suffix';
  // }
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


  static String formatPriceInternational(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}
