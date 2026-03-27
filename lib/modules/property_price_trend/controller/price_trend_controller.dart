import 'package:get/get.dart';
import 'package:nesticope_app/modules/property_price_trend/view/property_price_trend.dart';

class PriceTrendController extends GetxController {
  var selectedIndex = 0.obs;
  var isFav = ''.obs;
  var currentDiscreteSliderValue = 3.0.obs;
  var year2023 = true.obs;
  var selectedFilter = FilterType.Locality.obs;
  var propertyType = 'Apartment'.obs;
  var selectedLocality = 'Locality'.obs;

  List<String> get filterList => [
    selectedLocality.value,
    propertyType.value,
    '${currentDiscreteSliderValue.value.toInt()} year',
  ];

  void getSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void getFav(String value) {
    isFav.value = value;
  }

  void getSliderValue(double value) {
    currentDiscreteSliderValue.value = value;
  }

  void getPropertyType(String value) {
    propertyType.value = value;
  }

  void getFilterValue(FilterType value) {
    selectedFilter.value = value;
    selectedLocality.value =
        value == FilterType.Locality ? 'Locality' : 'Projects';
  }

  void getAllFilter({String? locality, String? property, double? year}) {
    currentDiscreteSliderValue.value = year ?? 0.0;
    propertyType.value = property ?? 'Apartment';
    selectedFilter.value =
        locality == 'Locality' ? FilterType.Locality : FilterType.Projects;
    selectedLocality.value = locality ?? 'Locality';
  }
}
