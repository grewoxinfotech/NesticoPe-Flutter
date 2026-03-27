import 'dart:developer';

import 'package:get/get.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';

import '../../../data/network/user/service/user_service.dart';

class BuyerProfileDataController extends GetxController {
  // Add your controller variables and methods here
  UserService _userService=UserService();
  Rxn<User> userProfile = Rxn<User>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserProfile();
  }
  Future<void> getUserProfile()  async {
    final data = await SecureStorage.getUserData();
    final userId=data?.user?.id;
    User? user = await _userService.getUserById(userId??'');
    if (user != null) {
      userProfile.value = user;
      log("jfhuefhr ${userProfile.value?.toJson()}");
    } else {
      print("Failed to fetch user profile");
    }
  }

}