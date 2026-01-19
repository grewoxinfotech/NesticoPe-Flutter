import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

Future<void> exportSellerInsightsToExcel(Map<String, dynamic> jsonData) async {
  try {
    final excel = Excel.createExcel();
    final sheet = excel['Seller Insights'];
    final data = Map<String, dynamic>.from(jsonData['data'] ?? {});

    // 🔹 Helper: add section header
    void addSection(String title) {
      sheet.appendRow([TextCellValue(''), TextCellValue('')]);
      sheet.appendRow([
        TextCellValue('📊 $title'),
        TextCellValue(''),
      ]);
      sheet.appendRow([
        TextCellValue('Metric'),
        TextCellValue('Value'),
      ]);
    }

    // 🔹 Helper: recursively add map data
    void addMapData(Map<String, dynamic> map, {String? parent}) {
      map.forEach((key, value) {
        if (value is Map) {
          sheet.appendRow([
            TextCellValue('📂 ${parent != null ? "$parent > " : ""}$key'),
            TextCellValue(''),
          ]);
          sheet.appendRow([
            TextCellValue('Metric'),
            TextCellValue('Value'),
          ]);
          addMapData(Map<String, dynamic>.from(value), parent: key);
        } else if (value is List) {
          sheet.appendRow([
            TextCellValue('📂 ${parent != null ? "$parent > " : ""}$key'),
            TextCellValue(''),
          ]);
          for (var i = 0; i < value.length; i++) {
            final item = value[i];
            if (item is Map) {
              sheet.appendRow([
                TextCellValue(''),
                TextCellValue(''),
              ]);
              sheet.appendRow([
                TextCellValue('🔸 $key [${i + 1}]'),
                TextCellValue(''),
              ]);
              sheet.appendRow([
                TextCellValue('Metric'),
                TextCellValue('Value'),
              ]);
              addMapData(Map<String, dynamic>.from(item), parent: key);
            } else {
              sheet.appendRow([
                TextCellValue('$key [$i]'),
                TextCellValue(item.toString()),
              ]);
            }
          }
        } else {
          sheet.appendRow([
            TextCellValue(key.toString()),
            TextCellValue(value.toString()),
          ]);
        }
      });
    }

    // 🏠 PROPERTY METRICS
    addSection('Property Metrics');
    addMapData(Map<String, dynamic>.from(data['propertyMetrics'] ?? {}));

    // 📈 LEAD ANALYTICS
    addSection('Lead Analytics');
    addMapData(Map<String, dynamic>.from(data['leadAnalytics'] ?? {}));

    // 💰 FINANCIAL METRICS
    addSection('Financial Metrics');
    addMapData(Map<String, dynamic>.from(data['financialMetrics'] ?? {}));

    // 🤝 ENGAGEMENT METRICS
    addSection('Engagement Metrics');
    addMapData(Map<String, dynamic>.from(data['engagementMetrics'] ?? {}));

    // 🎟️ SUBSCRIPTION INFO
    // addSection('Subscription Info');
    // addMapData(Map<String, dynamic>.from(data['subscriptionInfo'] ?? {}));
    //
    // // 🧾 OTHER DETAILS
    // addSection('Other Details');
    // sheet.appendRow([
    //   TextCellValue('Seller Type'),
    //   TextCellValue(data['sellerType']?.toString() ?? ''),
    // ]);
    // sheet.appendRow([
    //   TextCellValue('Last Updated'),
    //   TextCellValue(data['lastUpdated']?.toString() ?? ''),
    // ]);

    // ✅ SAVE FILE
    final bytes = excel.encode();
    Directory directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        directory = await getApplicationDocumentsDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath =
        '${directory.path}/seller_insights_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes!);

    print('✅ Seller Insights Excel exported successfully: $filePath');
    await OpenFilex.open(filePath);
  } catch (e, stack) {
    print('💥 Error exporting Seller Insights: $e');
    print('📚 Stack: $stack');
  }
}
