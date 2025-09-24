import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';

class SellerListingController extends GetxController {
  var properties = <Map<String, dynamic>>[].obs;
  var isSelected = [true, false].obs;

  var listingFilter =
      ["All", "Active", "Expired", "Pending", "Under Review", "Deleted"].obs;
  var selectedFilter = "All".obs;

  void toggle(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = (i == index);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadProperties();
  }

  void loadProperties() {
    properties.assignAll([
      {
        "id": 1,
        "title": "Luxury Villa in LA",
        "price": "\$1,200,000",
        "status": "Active",
        "category": "buy",
        "location": "Los Angeles, CA",
        "lastAddedDate": "2025-09-01",
        "roomType": "4 BHK",
        "image": IMGRes.home1,
      },
      {
        "id": 2,
        "title": "Modern Apartment in NYC",
        "price": "\$850,000",
        "status": "deleted",
        "category": "buy",
        "location": "New York, NY",
        "lastAddedDate": "2025-09-10",
        "roomType": "2 BHK",
        "image": IMGRes.home2,
      },
      {
        "id": 3,
        "title": "Cozy Studio",
        "price": "\$1,200/month",
        "status": "Active",
        "category": "rent",
        "location": "San Francisco, CA",
        "lastAddedDate": "2025-08-25",
        "roomType": "Studio",
        "image": IMGRes.home3,
      },
      {
        "id": 4,
        "title": "Beachside Condo",
        "price": "\$2,500/month",
        "status": "Active",
        "category": "rent",
        "location": "Miami, FL",
        "lastAddedDate": "2025-09-05",
        "roomType": "3 BHK",
        "image": IMGRes.banner2,
      },
      {
        "id": 5,
        "title": "Downtown Office Space",
        "price": "\$5,000/month",
        "status": "Inactive",
        "category": "commercial",
        "location": "Chicago, IL",
        "lastAddedDate": "2025-09-12",
        "roomType": "Open Plan",
        "image": IMGRes.banner1,
      },
      {
        "id": 6,
        "title": "Suburban House",
        "price": "\$650,000",
        "status": "Active",
        "category": "buy",
        "location": "Austin, TX",
        "lastAddedDate": "2025-09-02",
        "roomType": "3 BHK",
        "image": IMGRes.banner3,
      },
      {
        "id": 7,
        "title": "Luxury Penthouse",
        "price": "\$3,500,000",
        "status": "Pending",
        "category": "buy",
        "location": "Dubai, UAE",
        "lastAddedDate": "2025-08-20",
        "roomType": "5 BHK",
        "image": IMGRes.bhk1,
      },
      {
        "id": 8,
        "title": "Retail Space",
        "price": "\$8,000/month",
        "status": "Active",
        "category": "commercial",
        "location": "Los Angeles, CA",
        "lastAddedDate": "2025-09-15",
        "roomType": "Open Plan",
        "image": IMGRes.bhk2,
      },
      {
        "id": 9,
        "title": "Mountain Cabin",
        "price": "\$350,000",
        "status": "Inactive",
        "category": "buy",
        "location": "Denver, CO",
        "lastAddedDate": "2025-07-30",
        "roomType": "2 BHK",
        "image": IMGRes.bhk3,
      },
      {
        "id": 10,
        "title": "Shared Co-living Apartment",
        "price": "\$700/month",
        "status": "Active",
        "category": "rent",
        "location": "Berlin, Germany",
        "lastAddedDate": "2025-09-18",
        "roomType": "Shared Studio",
        "image": IMGRes.furnished,
      },
    ]);
  }

  void deleteProperty(int id) {
    properties.removeWhere((item) => item["id"] == id);
  }

  /// 🔹 Returns filtered properties for a given category
  List<Map<String, dynamic>> getFilteredProperties(String category) {
    var filtered = properties.where((e) => e["category"] == category).toList();

    if (selectedFilter.value != "All") {
      filtered =
          filtered.where((e) => e["status"] == selectedFilter.value).toList();
    }
    return filtered;
  }
}
