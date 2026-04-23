// import 'dart:convert';

// class AppLogger {
//   AppLogger(String title, dynamic data) {
//     structured(title, data);
//   }

//   /// Pretty + structured + chunked logger
//   static void structured(String title, dynamic data) {
//     try {
//       // Convert to pretty JSON
//       String prettyJson = _toPrettyJson(data);

//       // Create a full structured message
//       String prefix = "\n===== 📌 $title START =====\n";
//       String suffix = "\n===== 📌 $title END =====\n";

//       String finalLog = prefix + prettyJson + suffix;

//       _printInChunks(finalLog);
//     } catch (e) {
//       print("Logger Error: $e");
//     }
//   }

//   /// Convert to pretty formatted JSON
//   static String _toPrettyJson(dynamic data) {
//     try {
//       if (data is String) {
//         final decoded = json.decode(data);
//         return const JsonEncoder.withIndent('  ').convert(decoded);
//       }
//       return const JsonEncoder.withIndent('  ').convert(data);
//     } catch (e) {
//       // If it's not JSON, return as-is
//       return data.toString();
//     }
//   }

//   /// Split into safe chunks to avoid truncation
//   static void _printInChunks(String text) {
//     const int chunkSize = 900;

//     for (int i = 0; i < text.length; i += chunkSize) {
//       final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
//       print(text.substring(i, end));
//     }
//   }
// }

import 'dart:convert';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';

class AppLogger {
  AppLogger(String title, dynamic data) {
    structured(title, data);
  }

  static void structured(String title, dynamic data) async {
    try {
      if (data is Future) {
        data = await data; // auto resolve future
      }

      final prettyJson = _toPrettyJson(data);

      final header = "\n===== $title START =====\n";
      final footer = "\n===== $title END =====\n";
      _printInChunks(header + prettyJson + footer);
    } catch (e, stack) {
      _printInChunks("Logger Error: $e\n$stack");
    }
  }

  static String _toPrettyJson(dynamic data) {
    try {
      if (data == null) return "null";

      if (data is String) {
        final decoded = jsonDecode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      }

      // IMPORTANT: dart:convert will auto-call `.toJson()` if present.
      // Some project models (e.g. PaginationResponse<T>) define toJson(mapper)
      // which is NOT compatible with jsonEncode's no-arg expectation.
      final safe = _safeJsonEncodable(data);
      return const JsonEncoder.withIndent('  ').convert(safe);
    } catch (_) {
      return data.toString();
    }
  }

  static dynamic _safeJsonEncodable(dynamic value) {
    if (value == null ||
        value is num ||
        value is bool ||
        value is String) {
      return value;
    }

    if (value is PaginationResponse) {
      return {
        'items': value.items.map(_safeJsonEncodable).toList(),
        'meta': value.meta.toJson(),
      };
    }

    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), _safeJsonEncodable(v)));
    }

    if (value is Iterable) {
      return value.map(_safeJsonEncodable).toList();
    }

    // Try common patterns but never let logger crash.
    try {
      final dynamic dyn = value;
      final res = dyn.toJson();
      return _safeJsonEncodable(res);
    } catch (_) {}

    try {
      final dynamic dyn = value;
      final res = dyn.toMap();
      return _safeJsonEncodable(res);
    } catch (_) {}

    return value.toString();
  }

  static void _printInChunks(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      print(text.substring(i, end));
    }
  }
}
