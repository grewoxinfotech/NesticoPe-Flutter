import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/city_insigths_controller.dart';

class ProjectFilterController extends GetxController {
  // Dropdowns
  RxString selectedPropertyType = "".obs;
  RxString selectedCity = "".obs;
  RxString selectedLocality = "".obs;
  RxString bhkType = ''.obs;
  RxBool isRERAVerified=false.obs;
  RxBool isPropertyHaveImage=false.obs;
  RxBool isPropertyHaveVideo=false.obs;
  RxBool isPropertyHaveBroucher=false.obs;
  final txtStartDate = TextEditingController();
  final txtEndDate = TextEditingController();
  RxString builderProjectStatus = "".obs;
  RxString resellerVerified = "".obs;
  RxString resellerApprovalStatus = ''.obs;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  RxDouble min = 0.0.obs;
  RxDouble max = 0.0.obs;
  RxList<double> budgetValues = <double>[
    0,
    500000,
    1000000,
    1500000,
    2000000,
    2500000,
    3000000,
    3500000,
    4000000,
    4500000,
    5000000,
    6000000,
    7000000,
    8000000,
    9000000,
    10000000,
    20000000,
    50000000
  ].obs;

  RxList<String> bHkType =
      <String>["1 BHK", "2 BHK", "3 BHK", "4 BHK", "5 BHK", "5+ BHK"].obs;
  RxList<String> cityList = <String>[].obs;

  late final CityController cityController;
  void updateFilter<T>(Rx<T> filterValue, T value) {
    filterValue.value = value;
  }
  @override
  void onInit() {
    cityController =
        Get.isRegistered<CityController>()
            ? Get.find<CityController>()
            : Get.put(CityController());

    super.onInit();
    _loadData();
  }
  RxList<String> amenities=<String>[].obs;
  final showAllAmenities = false.obs;
  void addBuilderAmenities(String items) {
    if (amenities.contains(items)) {
      amenities.remove(items);
    } else {
      amenities.add(items);
    }
    amenities.refresh();
  }
  void toggleAmenitiesView() {
    showAllAmenities.value = !showAllAmenities.value;
  }

  Future<void> _loadData() async {
    cityList.value =
        cityController.allCities.map((city) => city.city).toSet().toList();
    if (cityList.isNotEmpty) {
      selectedCity.value = cityList.first;
    }
    if (propertyTypes.isNotEmpty) {
      selectedPropertyType.value = propertyTypes.first;
    }
  }
  void setValue<T>(Rx<T> target, T value) {
    target.value = value;
  }
  // Dropdown Data
  RxList<String> propertyTypes = <String>[].obs;

  // Localities based on city

  RxList<String> localityList = <String>[].obs;

  // Price Range
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  // Reset Filter
  void resetFilters() {
    selectedPropertyType.value = "All Types";
    selectedCity.value = "All Cities";
    selectedLocality.value = "";
    localityList.clear();
    minPriceController.clear();
    maxPriceController.clear();
  }
}
