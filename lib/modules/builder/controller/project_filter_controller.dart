import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/city_insigths_controller.dart';

class ProjectFilterController extends GetxController {
  // Dropdowns
  RxString selectedPropertyType = "".obs;
  RxString selectedCity = "".obs;
  RxString selectedLocality = "".obs;

  RxList<String> cityList = <String>[].obs;

  late final CityController cityController;

  @override
  void onInit() {
    cityController =
        Get.isRegistered<CityController>()
            ? Get.find<CityController>()
            : Get.put(CityController());

    super.onInit();
    _loadData();
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

  // Dropdown Data
  final List<String> propertyTypes = ["Apartment", "Villa", "House"];

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
