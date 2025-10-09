import 'package:get/get.dart';

class BuilderNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
