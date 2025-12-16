import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';

import '../../../data/network/property/services/top_seller_profile_service.dart';
import '../../profile/model/seller_profile.dart';

class TopSellerProfileController extends GetxController {
  final TopSellerProfileService _service = TopSellerProfileService();

  final isLoading = true.obs;
  final sellerProfile = Rxn<ProfileSellerModel>();
  final userModel = Rxn<User>();

  Future<void> loadSellerProfile(String sellerId) async {
    isLoading.value = true;
    await getSellerProfileById(sellerId);
    await getUserModelById(sellerId);
    isLoading.value = false;
  }

  Future<ProfileSellerModel> getSellerProfileById(String sellerId) async {
    try {
      final response = await _service.fetchSellerProfileById(sellerId);
      print("SELLER PROFILE RESPONSE: ${response.toJson()}");
      sellerProfile.value = response;
      return response;
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> getUserModelById(String userId) async {
    try {
      final response = await _service.fetchUserModelById(userId);
      userModel.value = response;
      return response;
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }
}
