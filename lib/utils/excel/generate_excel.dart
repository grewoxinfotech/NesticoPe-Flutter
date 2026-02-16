import 'dart:io';
import 'package:excel/excel.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

Future<void> exportSellerInsightsToExcel(Map<String, dynamic> jsonData) async {
  try {
    final excel = Excel.createExcel();
    final sheet = excel['Seller Export Data'];
    final data = Map<String, dynamic>.from(jsonData['data'] ?? {});

    // 🔹 Helper: Blank Row
    void gap() => sheet.appendRow([TextCellValue('')]);

    // 🔹 Helper: Section Header
    void header(String title) {
      gap();
      sheet.appendRow([TextCellValue('📊 $title')]);
      gap();
    }

    // 🔹 Helper: format key name like "totalRevenue" → "Total Revenue"
    String _formatKey(String key) {
      return key
          .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
          .split('_')
          .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');
    }

    // 🏠 1️⃣ PROPERTY METRICS
    header('Property Metrics');
    final propertyMetrics = Map<String, dynamic>.from(data['propertyMetrics'] ?? {});
    propertyMetrics.forEach((key, value) {
      if (value is! List && value is! Map) {
        sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
      }
    });

    // 🔸 Views History
    final viewsHistory = List<Map<String, dynamic>>.from(propertyMetrics['viewsHistory'] ?? []);
    if (viewsHistory.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Views History')]);
      sheet.appendRow([TextCellValue('Month'), TextCellValue('Views')]);
      for (var v in viewsHistory) {
        sheet.appendRow([
          TextCellValue(v['month']?.toString() ?? ''),
          TextCellValue(v['views']?.toString() ?? ''),
        ]);
      }
    }

    // 🔸 Property Timeline
    final propertyTimeline = List<Map<String, dynamic>>.from(propertyMetrics['propertyTimeline'] ?? []);
    if (propertyTimeline.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Properties Created')]);
      sheet.appendRow([TextCellValue('Month'), TextCellValue('Count')]);
      for (var v in propertyTimeline) {
        sheet.appendRow([
          TextCellValue(v['month']?.toString() ?? ''),
          TextCellValue(v['count']?.toString() ?? ''),
        ]);
      }
    }

    // 🧭 2️⃣ LEAD ANALYTICS
    header('Lead Analytics');
    final leadAnalytics = Map<String, dynamic>.from(data['leadAnalytics'] ?? {});
    leadAnalytics.forEach((key, value) {
      if (value is! List && value is! Map) {
        sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
      }
    });

    // 🔸 Status Breakdown
    final statusBreakdown = Map<String, dynamic>.from(leadAnalytics['statusBreakdown'] ?? {});
    if (statusBreakdown.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Status Breakdown')]);
      sheet.appendRow([TextCellValue('Status'), TextCellValue('Count')]);
      statusBreakdown.forEach((k, v) {
        sheet.appendRow([TextCellValue(_formatKey(k)), TextCellValue(v.toString())]);
      });
    }

    // 🔸 Source Distribution
    final sourceDistribution = Map<String, dynamic>.from(leadAnalytics['sourceDistribution'] ?? {});
    if (sourceDistribution.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Source Distribution')]);
      sheet.appendRow([TextCellValue('Source'), TextCellValue('Count')]);
      sourceDistribution.forEach((k, v) {
        sheet.appendRow([TextCellValue(_formatKey(k)), TextCellValue(v.toString())]);
      });
    }

    // 🔸 Leads Timeline
    final leadsTimeline = List<Map<String, dynamic>>.from(leadAnalytics['leadsTimeline'] ?? []);
    if (leadsTimeline.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Leads Timeline')]);
      sheet.appendRow([TextCellValue('Month'), TextCellValue('Count')]);
      for (var item in leadsTimeline) {
        sheet.appendRow([
          TextCellValue(item['month']?.toString() ?? ''),
          TextCellValue(item['count']?.toString() ?? ''),
        ]);
      }
    }

    // 💰 3️⃣ FINANCIAL METRICS
    header('Financial Metrics');
    final financialMetrics = Map<String, dynamic>.from(data['financialMetrics'] ?? {});
    financialMetrics.forEach((key, value) {
      if (value is! List && value is! Map) {
        sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
      }
    });

    // 🔸 Revenue History
    final revenueHistory = List<Map<String, dynamic>>.from(financialMetrics['revenueHistory'] ?? []);
    if (revenueHistory.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Revenue History')]);
      sheet.appendRow([TextCellValue('Month'), TextCellValue('Revenue')]);
      for (var r in revenueHistory) {
        sheet.appendRow([
          TextCellValue(r['month']?.toString() ?? ''),
          TextCellValue(r['revenue']?.toString() ?? ''),
        ]);
      }
    }

    // 🤝 4️⃣ ENGAGEMENT METRICS
    header('Engagement Metrics');
    final engagement = Map<String, dynamic>.from(data['engagementMetrics'] ?? {});
    engagement.forEach((key, value) {
      sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
    });

    // ✅ SAVE FILE
    final bytes = excel.encode();
    if (bytes == null) throw Exception('Failed to encode Excel file');

    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!dir.existsSync()) dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final filePath =
        '${dir.path}/seller_insights_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    print('✅ Seller Insights Excel exported successfully: $filePath');
    await OpenFilex.open(filePath);
  } catch (e, stack) {
    print('💥 Error exporting Seller Insights: $e');
    print('📚 Stack: $stack');
  }
}


Future<void> exportLeadsToExcel(List<LeadItem> leads) async {
  try {
    final excel = Excel.createExcel();
    final sheet = excel['Leads Export'];

    /// 🔹 HEADER ROW (Same as your image)
    sheet.appendRow([
      TextCellValue('ID'),
      TextCellValue('Name'),
      TextCellValue('Email'),
      TextCellValue('Phone'),
      TextCellValue('Source'),
      TextCellValue('Status'),
      TextCellValue('Stage'),
      TextCellValue('Created At'),
      TextCellValue('Property'),
      TextCellValue('Partner'),
    ]);

    /// 🔹 DATA ROWS
    for (var lead in leads) {
      sheet.appendRow([
        TextCellValue(lead.id ?? ''),
        TextCellValue(lead.name ?? ''),
        TextCellValue(lead.email ?? ''),
        TextCellValue(lead.phone ?? ''),
        TextCellValue(lead.source ?? ''),
        TextCellValue(lead.status ?? ''),
        TextCellValue(lead.stage ?? ''),
        TextCellValue(_formatDate(lead.createdAt?.toIso8601String())),
        TextCellValue(lead.projectName ?? 'N/A'),
        TextCellValue(lead.leadResellerData?.fullName?? 'N/A'),
      ]);
    }

    /// ✅ SAVE FILE
    final bytes = excel.encode();
    if (bytes == null) throw Exception('Failed to encode Excel');

    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!dir.existsSync()) {
        dir = await getApplicationDocumentsDirectory();
      }
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final filePath =
        '${dir.path}/leads_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';

    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    print('✅ Leads Excel exported successfully: $filePath');
    await OpenFilex.open(filePath);

  } catch (e, stack) {
    print('💥 Error exporting Leads: $e');
    print('📚 Stack: $stack');
  }
}
Future<void> downloadLeadImportExample() async {
  try {
    final excel = Excel.createExcel();
    final sheet = excel['Leads'];

    /// 🔹 Header Row (Exactly like your image)
    sheet.appendRow([
      TextCellValue('name'),
      TextCellValue('email'),
      TextCellValue('phone'),
      TextCellValue('source'),
      TextCellValue('status'),
      TextCellValue('notes'),
    ]);

    /// 🔹 Example Row 1
    sheet.appendRow([
      TextCellValue('John Doe'),
      TextCellValue('john@example.com'),
      TextCellValue('+1 555-1234'),
      TextCellValue('website'),
      TextCellValue('new'),
      TextCellValue('Interested in 2BHK'),
    ]);

    /// 🔹 Example Row 2
    sheet.appendRow([
      TextCellValue('Jane Smith'),
      TextCellValue('jane@example.com'),
      TextCellValue('5551234567'),
      TextCellValue('referral'),
      TextCellValue('contacted'),
      TextCellValue('Follow up next week'),
    ]);

    final bytes = excel.encode();
    if (bytes == null) throw Exception('Failed to encode Excel');

    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!dir.existsSync()) {
        dir = await getApplicationDocumentsDirectory();
      }
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final filePath = '${dir.path}/lead_import_example.xlsx';

    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    print('✅ Example file created: $filePath');
    await OpenFilex.open(filePath);

  } catch (e, stack) {
    print('💥 Error creating example: $e');
    print(stack);
  }
}



Future<void> exportContractorInsightsToExcel(Map<String, dynamic> jsonData) async {
  try {
    final excel = Excel.createExcel();
    final sheet = excel['Contractor Export Data'];
    final data = Map<String, dynamic>.from(jsonData['data'] ?? {});

    // 🔹 Helper: Add blank line
    void gap() => sheet.appendRow([TextCellValue('')]);

    // 🔹 Helper: Add section header
    void header(String title) {
      gap();
      sheet.appendRow([TextCellValue(title)]);
      gap();
    }

    // 🏗️ 1️⃣ PERFORMANCE METRICS
    header('Performance Metrics');
    final performance = Map<String, dynamic>.from(data['performance'] ?? {});
    performance.forEach((key, value) {
      sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
    });

    // 🧱 2️⃣ SERVICE DISTRIBUTION
    header('Service Distribution');
    sheet.appendRow([
      TextCellValue('Service Name'),
      TextCellValue('Category'),
      TextCellValue('Description'),
      TextCellValue('Total Reviews'),
      TextCellValue('Average Rating'),
    ]);

    final topServices = List<Map<String, dynamic>>.from(data['services']?['topRatedServices'] ?? []);
    for (var s in topServices) {
      sheet.appendRow([
        TextCellValue(s['serviceName']?.toString() ?? ''),
        TextCellValue(s['category']?.toString() ?? ''),
        TextCellValue(s['description']?.toString() ?? ''),
        TextCellValue(s['totalReviews']?.toString() ?? ''),
        TextCellValue(s['averageRating']?.toString() ?? ''),
      ]);
    }

    // ⭐ 3️⃣ RATINGS DISTRIBUTION
    header('Ratings Distribution');
    sheet.appendRow([TextCellValue('Rating'), TextCellValue('Count')]);
    final ratingDist = Map<String, dynamic>.from(data['services']?['ratingsDistribution'] ?? {});
    const starLabels = {'5': '5 Stars', '4': '4 Stars', '3': '3 Stars', '2': '2 Stars', '1': '1 Star'};
    for (final entry in starLabels.entries) {
      sheet.appendRow([TextCellValue(entry.value), TextCellValue(ratingDist[entry.key]?.toString() ?? '0')]);
    }

    // 💬 4️⃣ RECENT REVIEWS
    header('Recent Reviews');
    sheet.appendRow([
      TextCellValue('Reviewer'),
      TextCellValue('Rating'),
      TextCellValue('Title'),
      TextCellValue('Content'),
      TextCellValue('Date'),
    ]);

    final recentReviews = List<Map<String, dynamic>>.from(data['reviews']?['recentReviews'] ?? []);
    for (var r in recentReviews) {
      sheet.appendRow([
        TextCellValue(r['reviewerName']?.toString() ?? ''),
        TextCellValue(r['rating']?.toString() ?? ''),
        TextCellValue(r['title']?.toString() ?? ''),
        TextCellValue(r['content']?.toString() ?? ''),
        TextCellValue(_formatDate(r['createdAt']?.toString())),
      ]);
    }

    // 📈 5️⃣ TRENDS (Inquiries, Leads, Projects)
    header('Trends');

    void addTrend(String title, List<dynamic>? list, String colName) {
      gap();
      sheet.appendRow([TextCellValue('$title Trend')]);
      sheet.appendRow([TextCellValue('Month'), TextCellValue(colName)]);
      if (list != null) {
        for (var i in list) {
          sheet.appendRow([
            TextCellValue(i['month']?.toString() ?? ''),
            TextCellValue(i[colName.toLowerCase()]?.toString() ?? ''),
          ]);
        }
      }
    }

    addTrend('Inquiries', data['inquiriesTrend'], 'Inquiries');
    addTrend('Leads', data['leadsTrend'], 'Leads');
    addTrend('Projects', data['projectsTrend'], 'Projects');

    // ✅ SAVE FILE
    final bytes = excel.encode();
    if (bytes == null) throw Exception('Failed to encode Excel');

    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!dir.existsSync()) dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final filePath = '${dir.path}/contractor_insights_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    print('✅ Excel exported successfully: $filePath');
    await OpenFilex.open(filePath);
  } catch (e, stack) {
    print('💥 Error exporting Contractor Insights: $e');
    print('📚 Stack: $stack');
  }
}

String _formatKey(String key) {
  return key
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .split('_')
      .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}

// 🧩 Utility: Format date to dd-MM-yyyy
String _formatDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  try {
    final d = DateTime.parse(iso).toLocal();
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  } catch (_) {
    return iso;
  }
}
Future<void> exportBuilderInsightsToExcel(Map<String, dynamic> jsonData) async {
  try {
    final excel = Excel.createExcel();
    final sheet = excel['Builder Export Data'];
    final data = Map<String, dynamic>.from(jsonData['data'] ?? {});

    // 🔹 Helper: Blank Row
    void gap() => sheet.appendRow([TextCellValue('')]);

    // 🔹 Helper: Section Header
    void header(String title) {
      gap();
      sheet.appendRow([TextCellValue(title)]);
      gap();
    }

    // 🔹 Helper: format key name like "totalRevenue" → "Total Revenue"
    // String formatKey(String key) {
    //   return key
    //       .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
    //       .split('_')
    //       .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
    //       .join(' ');
    // }
    //
    // // 🔹 Helper: format date
    // String formatDate(String? iso) {
    //   if (iso == null || iso.isEmpty) return '';
    //   try {
    //     final d = DateTime.parse(iso).toLocal();
    //     return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
    //   } catch (_) {
    //     return iso;
    //   }
    // }

    // 🏠 1️⃣ PROPERTY METRICS
    header('Property Metrics');
    final propertyMetrics = Map<String, dynamic>.from(data['propertyMetrics'] ?? {});
    propertyMetrics.forEach((key, value) {
      if (value is! List && value is! Map) {
        sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
      }
    });

    // 🔹 Property Views Trend
    final viewsHistory = List<Map<String, dynamic>>.from(propertyMetrics['viewsHistory'] ?? []);
    if (viewsHistory.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Views History')]);
      sheet.appendRow([TextCellValue('Month'), TextCellValue('Views')]);
      for (var v in viewsHistory) {
        sheet.appendRow([
          TextCellValue(v['month']?.toString() ?? ''),
          TextCellValue(v['views']?.toString() ?? ''),
        ]);
      }
    }
final propertyTimeline = List<Map<String, dynamic>>.from(propertyMetrics['propertyTimeline'] ?? []);
    if (propertyTimeline.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Properties Created')]);
      sheet.appendRow([TextCellValue('Month'), TextCellValue('Count')]);
      for (var v in propertyTimeline) {
        sheet.appendRow([
          TextCellValue(v['month']?.toString() ?? ''),
          TextCellValue(v['count']?.toString() ?? ''),
        ]);
      }
    }

    // 🧭 2️⃣ LEAD ANALYTICS
    header('Lead Analytics');
    final leadAnalytics = Map<String, dynamic>.from(data['leadAnalytics'] ?? {});
    leadAnalytics.forEach((key, value) {
      if (value is! List && value is! Map) {
        sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
      }
    });

    // 🔸 Status Breakdown
    final statusBreakdown = Map<String, dynamic>.from(leadAnalytics['statusBreakdown'] ?? {});
    if (statusBreakdown.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Status Breakdown')]);
      sheet.appendRow([TextCellValue('Status'), TextCellValue('Count')]);
      statusBreakdown.forEach((k, v) {
        sheet.appendRow([TextCellValue(_formatKey(k)), TextCellValue(v.toString())]);
      });
    }

    // 🔸 Source Distribution
    final sourceDistribution = Map<String, dynamic>.from(leadAnalytics['sourceDistribution'] ?? {});
    if (sourceDistribution.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Source Distribution')]);
      sheet.appendRow([TextCellValue('Source'), TextCellValue('Count')]);
      sourceDistribution.forEach((k, v) {
        sheet.appendRow([TextCellValue(_formatKey(k)), TextCellValue(v.toString())]);
      });
    }

    // 🔸 Stage Breakdown
    final stageBreakdown = Map<String, dynamic>.from(leadAnalytics['stageBreakdown'] ?? {});
    if (stageBreakdown.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Stage Breakdown')]);
      sheet.appendRow([TextCellValue('Stage'), TextCellValue('Count')]);
      stageBreakdown.forEach((k, v) {
        sheet.appendRow([TextCellValue(_formatKey(k)), TextCellValue(v.toString())]);
      });
    }

    // 🔸 Leads Timeline
    final leadsTimeline = List<Map<String, dynamic>>.from(leadAnalytics['leadsTimeline'] ?? []);
    if (leadsTimeline.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Leads Timeline')]);
      sheet.appendRow([TextCellValue('Month'), TextCellValue('Count')]);
      for (var item in leadsTimeline) {
        sheet.appendRow([
          TextCellValue(item['month']?.toString() ?? ''),
          TextCellValue(item['count']?.toString() ?? ''),
        ]);
      }
    }

    // 💰 3️⃣ FINANCIAL METRICS
    header('Financial Metrics');
    final financialMetrics = Map<String, dynamic>.from(data['financialMetrics'] ?? {});
    financialMetrics.forEach((key, value) {
      if (value is! List) {
        sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
      }
    });

    // 🔹 Revenue History
    final revenueHistory = List<Map<String, dynamic>>.from(financialMetrics['revenueHistory'] ?? []);
    if (revenueHistory.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Revenue History')]);
      sheet.appendRow([TextCellValue('Month'), TextCellValue('Revenue')]);
      for (var r in revenueHistory) {
        sheet.appendRow([
          TextCellValue(r['month']?.toString() ?? ''),
          TextCellValue(r['revenue']?.toString() ?? ''),
        ]);
      }
    }

    // 🤝 4️⃣ ENGAGEMENT METRICS
    header('Engagement Metrics');
    final engagement = Map<String, dynamic>.from(data['engagementMetrics'] ?? {});
    engagement.forEach((key, value) {
      sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
    });

    // // 🎟️ 5️⃣ SUBSCRIPTION INFO
    // header('Subscription Info');
    // final subscription = Map<String, dynamic>.from(data['subscriptionInfo'] ?? {});
    // subscription.forEach((key, value) {
    //   sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value?.toString() ?? '')]);
    // });
    //
    // // 🧾 6️⃣ OTHER DETAILS
    // header('Other Details');
    // sheet.appendRow([TextCellValue('Seller Type'), TextCellValue(data['sellerType']?.toString() ?? '')]);
    // sheet.appendRow([TextCellValue('Last Updated'), TextCellValue(_formatDate(data['lastUpdated']?.toString()))]);

    // ✅ SAVE FILE
    final bytes = excel.encode();
    if (bytes == null) throw Exception('Failed to encode Excel');

    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!dir.existsSync()) dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final filePath = '${dir.path}/builder_insights_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    print('✅ Builder Insights Excel exported successfully: $filePath');
    await OpenFilex.open(filePath);
  } catch (e, stack) {
    print('💥 Error exporting Builder Insights: $e');
    print('📚 Stack: $stack');
  }
}
Future<void> exportResellerInsightsToExcel(Map<String, dynamic> jsonData) async {
  try {
    final excel = Excel.createExcel();
    final sheet = excel['Partner Export Data'];
    final data = Map<String, dynamic>.from(jsonData['data'] ?? {});

    // 🔹 Helper: add spacing
    void gap() => sheet.appendRow([TextCellValue('')]);

    // 🔹 Helper: add section header
    void header(String title) {
      gap();
      sheet.appendRow([TextCellValue(title)]);
      gap();
    }

    // 🔹 Helper: format key name (e.g. totalDealsAmount → Total Deals Amount)


    // 🏠 1️⃣ BASIC METRICS
    header('Partner Overview');
    sheet.appendRow([
      TextCellValue('Metric'),
      TextCellValue('Value'),
    ]);
    sheet.appendRow([
      TextCellValue('Total Assigned Properties'),
      TextCellValue(data['totalAssignedProperties']?.toString() ?? '0'),
    ]);

    // 💰 2️⃣ EARNINGS
    header('Earnings');
    final earnings = Map<String, dynamic>.from(data['earnings'] ?? {});
    earnings.forEach((key, value) {
      sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
    });

    // 📊 3️⃣ PERFORMANCE
    header('Performance Metrics');
    final performance = Map<String, dynamic>.from(data['performance'] ?? {});
    performance.forEach((key, value) {
      sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
    });

    // 🏆 4️⃣ LEADERBOARD
    header('Leaderboard Top Reseller');
    sheet.appendRow([TextCellValue('Rank'), TextCellValue('Name'), TextCellValue('Email'),
      TextCellValue('City'), TextCellValue('Level'), TextCellValue('Total Commission'),
      TextCellValue('Total Deals')]);

    final topResellers = List<Map<String, dynamic>>.from(data['leaderboard']?['topResellers'] ?? []);
    for (var r in topResellers) {
      sheet.appendRow([
        TextCellValue(r['rank']?.toString() ?? ''),
        TextCellValue(r['name']?.toString() ?? ''),
        TextCellValue(r['email']?.toString() ?? ''),
        TextCellValue(r['city']?.toString() ?? ''),
        TextCellValue(r['level']?.toString() ?? ''),
        TextCellValue(r['totalCommission']?.toString() ?? ''),
        TextCellValue(r['totalDeals']?.toString() ?? ''),
      ]);
    }

    // 🏘️ 5️⃣ TOP PROPERTIES
    final topProperties = List<Map<String, dynamic>>.from(data['leaderboard']?['topProperties'] ?? []);
    if (topProperties.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Top Properties')]);
      final keys = topProperties.first.keys.toList();
      sheet.appendRow(keys.map((k) => TextCellValue(_formatKey(k))).toList());
      for (var p in topProperties) {
        sheet.appendRow(keys.map((k) => TextCellValue(p[k]?.toString() ?? '')).toList());
      }
    }

    // 🎯 6️⃣ DAILY GOALS
    header('Daily Goals');
    final dailyGoals = Map<String, dynamic>.from(data['dailyGoals'] ?? {});
    dailyGoals.forEach((key, value) {
      sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
    });

    // 🧩 7️⃣ LEVEL DETAILS
    header('Level Information');
    final level = Map<String, dynamic>.from(data['level'] ?? {});
    level.forEach((key, value) {
      if (value is! List) {
        sheet.appendRow([TextCellValue(_formatKey(key)), TextCellValue(value.toString())]);
      }
    });

    // ➕ Level Benefits (list of strings)
    final benefits = List.from(level['benefits'] ?? []);
    if (benefits.isNotEmpty) {
      gap();
      sheet.appendRow([TextCellValue('Benefits')]);
      for (var b in benefits) {
        sheet.appendRow([TextCellValue('- $b')]);
      }
    }

    // 🌟 8️⃣ SUCCESS STORIES
    final successStories = List<Map<String, dynamic>>.from(data['successStories'] ?? []);
    if (successStories.isNotEmpty) {
      header('Success Stories');
      final keys = successStories.first.keys.toList();
      sheet.appendRow(keys.map((k) => TextCellValue(_formatKey(k))).toList());
      for (var s in successStories) {
        sheet.appendRow(keys.map((k) => TextCellValue(s[k]?.toString() ?? '')).toList());
      }
    }

    // 📈 9️⃣ LEADS TREND
    header('Leads Trend');
    sheet.appendRow([TextCellValue('Month'), TextCellValue('Leads')]);
    final leadsTrend = List<Map<String, dynamic>>.from(data['leadsTrend'] ?? []);
    for (var t in leadsTrend) {
      sheet.appendRow([
        TextCellValue(t['name']?.toString() ?? ''),
        TextCellValue(t['leads']?.toString() ?? ''),
      ]);
    }

    // 💵 🔟 COMMISSION TREND
    header('Commission Trend');
    sheet.appendRow([TextCellValue('Month'), TextCellValue('Commission')]);
    final commissionTrend = List<Map<String, dynamic>>.from(data['commissionTrend'] ?? []);
    for (var t in commissionTrend) {
      sheet.appendRow([
        TextCellValue(t['name']?.toString() ?? ''),
        TextCellValue(t['commission']?.toString() ?? ''),
      ]);
    }
    header('Partner Milestones');
    final milestones = Map<String, dynamic>.from(data['milestones'] ?? {});

    if (milestones.isNotEmpty) {
      sheet.appendRow([
        TextCellValue('Total Fees Generated'),
        TextCellValue(milestones['totalFeesGenerated']?.toString() ?? '0')
      ]);
      sheet.appendRow([
        TextCellValue('Progress (%)'),
        TextCellValue(milestones['progress']?.toString() ?? '0')
      ]);

      // ➕ Next Milestone
      final next = Map<String, dynamic>.from(milestones['nextMilestone'] ?? {});
      if (next.isNotEmpty) {
        gap();
        sheet.appendRow([TextCellValue('Next Milestone')]);
        next.forEach((k, v) {
          sheet.appendRow([TextCellValue(_formatKey(k)), TextCellValue(v.toString())]);
        });
      }

      // 🎁 Bonuses
      final bonuses = List<Map<String, dynamic>>.from(milestones['bonuses'] ?? []);
      if (bonuses.isNotEmpty) {
        gap();
        sheet.appendRow([TextCellValue('Unlocked Bonuses')]);
        final keys = bonuses.first.keys.toList();
        sheet.appendRow(keys.map((k) => TextCellValue(_formatKey(k))).toList());
        for (var b in bonuses) {
          sheet.appendRow(keys.map((k) => TextCellValue(b[k]?.toString() ?? '')).toList());
        }
      }

      // 🎯 All Milestones
      final all = List<Map<String, dynamic>>.from(milestones['allMilestones'] ?? []);
      if (all.isNotEmpty) {
        gap();
        sheet.appendRow([TextCellValue('All Milestones')]);
        sheet.appendRow([TextCellValue('Limit'), TextCellValue('Gift')]);
        for (var m in all) {
          sheet.appendRow([
            TextCellValue(m['limit']?.toString() ?? ''),
            TextCellValue(m['gift']?.toString() ?? ''),
          ]);
        }
      }
    }

    // 🧾 11️⃣ OTHER DETAILS
    header('Other Details');
    sheet.appendRow([TextCellValue('Last Updated'), TextCellValue(_formatDate(data['lastUpdated']?.toString()))]);

    // ✅ SAVE FILE
    final bytes = excel.encode();
    if (bytes == null) throw Exception('Failed to encode Excel');

    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!dir.existsSync()) dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final filePath = '${dir.path}/reseller_insights_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    print('✅ Reseller Insights Excel exported successfully: $filePath');
    await OpenFilex.open(filePath);
  } catch (e, stack) {
    print('💥 Error exporting Reseller Insights: $e');
    print('📚 Stack: $stack');
  }
}

