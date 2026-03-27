import 'dart:developer';

import 'package:get/get.dart';
import 'package:nesticope_app/data/network/referral/service/referrel_service.dart';

import '../../../data/network/referral/model/referrel_model.dart';

// Controller

class ReferralController extends GetxController {
  final referralCode = 'BF1D856F'.obs;
  final totalCodes = 1.obs;
  final activeResellers = 0.obs;
  final pendingResellers = 1.obs;
  final pointsEarned = 0.obs;
  final totalValue = 0.obs;
  final rewardsEarned = 0.obs;
  final requiredResellers = 10.obs;

  final isGenerate = false.obs;
  final isGenerated = false.obs;
  final isLoading = false.obs;
  Rxn<ReferralModel> dummyReferral = Rxn<ReferralModel>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchReferralService();
  }

  Future<void> referralCodeGenerator() async {
    try {
      isGenerate.value = true;
      final success = await Referral_Service.instance.generateReferCode();
      if (success) {
        await fetchReferralService();
      }
    } catch (e) {
    } finally {
      isGenerate.value = false;
    }
  }

  // Future<void> fetchReferralService() async {
  //   try {
  //     log("fvhgdhgffdfh ");
  //     isLoading.value = true;
  //     final data = await Referral_Service.instance.fetchReferrals();
  //     dummyReferral.value = data;
  //     if (dummyReferral.value != null) isGenerated.value = true;
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> fetchReferralService() async {
    try {
      final ReferralModel model =
      await Referral_Service.instance.fetchReferrals();

      // Save model to Rx variable
      dummyReferral.value = model;

      // Check if referrals list is not empty
      isGenerated.value = (model.data?.referrals?.isNotEmpty ?? false);

      print('Referrals fetched: ${model.data?.referrals?.length ?? 0}');
    } catch (e) {
      print('fetchReferralService error: $e');
    }
  }


}
