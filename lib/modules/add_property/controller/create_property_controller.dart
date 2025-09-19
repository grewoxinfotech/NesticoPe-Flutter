import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

class CreatePropertyController extends GetxController {
  // Reactive states
  var isOwner = true.obs;
  var propertyType = "".obs;
  var lookingTo = "".obs;
  var countryCode = '+91'.obs;
  RxBool isLogin = false.obs;
  var stepIndex = 0.obs;
  var mealAvailable = " ".obs;

  // Text Controllers
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final localityController = TextEditingController();
  final pgNameController = TextEditingController();
  final noticPeriodController = TextEditingController();
  final lockPeriodController = TextEditingController();
  final monthlyRentController = TextEditingController();
  final depositeController = TextEditingController();
  RxString selectedIndex = "".obs;
  RxString roomType = ''.obs;

  var selectedItems = <String>[].obs;
  var mealAvailableList = <String>[].obs;

  var stepperSelectedIndex = 0.obs;

  var bestSuitedList = <String>[].obs;
  var commonAreasList = <String>[].obs;

  ///================================================================ Basic Details and UNLogin Screen=================
  void toggleItemInList(RxList<String> list, String item) {
    if (list.contains(item)) {
      list.remove(item);
    } else {
      list.add(item);
    }
  }

  void nextStep() {
    if (stepperSelectedIndex.value < 2)
      stepperSelectedIndex.value++; // total steps = 3
  }

  void previousStep() {
    if (stepperSelectedIndex.value > 0) stepperSelectedIndex.value--;
  }

  void finalsubmitForm() {
    // Final submit
  }

  bool isSelected(String item) => selectedItems.contains(item);

  void select(String index) {
    selectedIndex.value = index;
    print("$selectedIndex     =   === == = = == = = = $index");
  }

  void toggleOwner(bool ownerSelected) {
    isOwner.value = ownerSelected;
  }

  void setValue<T>(Rx<T> target, T value) {
    target.value = value;
  }

  void submitForm() {
    isLogin.value = !isLogin.value;
    Get.snackbar(
      "Form Submitted",
      "Owner: ${isOwner.value ? "Owner" : "Broker/Builder"}\n"
          "Property: ${propertyType.value}\n"
          "Looking to: ${lookingTo.value}\n"
          "Phone:$countryCode ${phoneController.text}\n"
          "Name: ${nameController.text}\n"
          "City: ${cityController.text}",
      snackPosition: SnackPosition.TOP,
      colorText: ColorRes.white,
      backgroundColor: ColorRes.primary.withOpacity(0.2),
    );
  }
}
