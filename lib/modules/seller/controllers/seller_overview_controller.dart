import 'package:get/get.dart';
import '../../../data/network/seller/seller_overview_service.dart';
import '../model/overview_model.dart';

class SellerOverviewController extends GetxController {
  final SellerOverviewService _service = SellerOverviewService();

  var isLoading = false.obs;
  var overviewData = Rxn<SellerOverviewModel>();

  Future<void> loadOverview(String token) async {
    try {
      isLoading.value = true;
      final data = await _service.fetchSellerOverview(token: token);
      if (data != null) {
        overviewData.value = data;
      }
    } finally {
      isLoading.value = false;
    }
  }

  final Map<String, dynamic> overview = {
    "success": true,
    "message": "Seller insights fetched successfully",
    "data": {
      "propertyMetrics": {
        "activeListings": 10,
        "viewsHistory": [
          {"date": "2025-10-03", "views": 3},
          {"date": "2025-10-04", "views": 1},
        ],
        "statusDistribution": {"active": 10, "sold": 1, "rented": 1},
      },
      "leadAnalytics": {
        "totalLeads": 4,
        "sourceDistribution": {"website": 4},
        "conversionRate": 0,
        "leadsTimeline": [
          {"date": "2025-10-03", "count": 1},
          {"date": "2025-10-04", "count": 2},
          {"date": "2025-10-06", "count": 1},
        ],
      },
      "financialMetrics": {
        "totalRevenue": 0,
        "averagePropertyValue": 0,
        "revenueHistory": [
          {"month": "2025-10", "revenue": 0},
        ],
      },
      "engagementMetrics": {
        "inquiryResponseRate": 0,
        "averageResponseTime": 0,
        "visitConversionRate": 0,
        "totalVisits": 0,
        "convertedVisits": 0,
      },
      "lastUpdated": "2025-10-06T09:20:09.593Z",
    },
  };

  late final overviewModel = SellerOverviewModel.fromJson(overview);
}
