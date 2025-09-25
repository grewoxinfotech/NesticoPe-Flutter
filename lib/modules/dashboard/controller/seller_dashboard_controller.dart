import 'package:get/get.dart';

class SellerDashboardController extends GetxController {
  RxInt currentIndex = 0.obs;

  changeIndex(int i) => currentIndex(i);
}
