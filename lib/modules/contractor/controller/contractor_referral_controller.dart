import 'package:get/get.dart';

import '../../../data/network/contractor/model/contractor_quotation/contractor_referral_model.dart';
import '../../../data/network/contractor/service/contractor_referral_service.dart';

class ContractorReferralController extends GetxController {
  final String userId;

  ContractorReferralController({required this.userId});

  late final ContractorReferralService _service;

  // ────────────────── STATE FLAGS ──────────────────
  final RxBool isLoading = false.obs;
  final RxBool isSuccess = false.obs;
  final RxBool isError = false.obs;
  final RxBool isEmpty = false.obs;

  // ────────────────── PRICE & DISCOUNT OBS ──────────────────
  final RxInt originalPrice = 0.obs;
  final RxInt discountPercentageObs = 0.obs;
  final RxInt discountedPriceObs = 0.obs;
  final RxInt savedPriceObs = 0.obs;

  // ────────────────── DATA ──────────────────
  final Rxn<ReferralResponseModel> referralResponse =
      Rxn<ReferralResponseModel>();

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _service = ContractorReferralService(userId: userId);
    fetchReferralInfo();
  }

  // ────────────────── API CALL ──────────────────
  Future<void> fetchReferralInfo() async {
    _resetState();

    isLoading.value = true;

    try {
      final response = await _service.fetchReferralInfo();
      referralResponse.value = response;

      isSuccess.value = true;

      // Empty logic (you can tweak based on business rules)
      if (response.data.referrals.isEmpty && response.data.pointsEarned == 0) {
        isEmpty.value = true;
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ────────────────── HELPERS ──────────────────
  void _resetState() {
    isLoading.value = false;
    isSuccess.value = false;
    isError.value = false;
    isEmpty.value = false;
    errorMessage.value = '';
  }

  // ────────────────── QUICK GETTERS ──────────────────
  ReferralData? get data => referralResponse.value?.data;

  int get pointsBalance => data?.pointsBalance ?? 0;

  int get totalPointsEarned => data?.pointsEarned ?? 0;

  String get referralLink =>
      data?.referrals.isNotEmpty == true
          ? data!.referrals.first.referralLink
          : '';

  // /// discount percentage based on points balance
  int get discountPercentage {
    if (data?.moduleSettings.pointsForDiscount != null &&
        data?.moduleSettings.discountPercentage != null &&
        data?.pointsBalance != null &&
        data!.moduleSettings.pointsForDiscount != 0 &&
        data!.moduleSettings.discountPercentage != 0 &&
        data!.pointsBalance != 0) {
      final percent =
          ((data!.moduleSettings.discountPercentage /
                      data!.moduleSettings.pointsForDiscount) *
                  data!.pointsBalance)
              .clamp(0, 100)
              .toInt();
      discountPercentageObs.value = percent;
      print("Discount Percentage: $percent");
      return percent;
    }
    return 0;
  }

  //
  // /// discounted Price
  // int discountedPrice(int price) {
  //   if (price > 0 && discountPercentage > 0) {
  //     return (price - (price * discountPercentage / 100)).toInt();
  //   }
  //   return price;
  // }
  //
  // /// saved Price
  // int savePrice(int price) {
  //   return price - discountedPrice(price);
  // }

  void calculateDiscount(int price) {
    originalPrice.value = price;

    // calculate discount %
    int discount = 0;
    if (data != null) {
      final settings = data!.moduleSettings;

      if (settings.pointsForDiscount > 0 &&
          settings.discountPercentage > 0 &&
          data!.pointsBalance > 0) {
        discount =
            ((settings.discountPercentage / settings.pointsForDiscount) *
                    data!.pointsBalance)
                .clamp(0, 100)
                .toInt();
      }
    }

    // discountPercentageObs.value = discount;

    // discounted price
    if (price > 0 && discount > 0) {
      discountedPriceObs.value = (price - (price * discount / 100)).toInt();
    } else {
      discountedPriceObs.value = price;
    }

    // saved price
    savedPriceObs.value = originalPrice.value - discountedPriceObs.value;
  }

  /// resetAllData
  void resetAllData() {
    originalPrice.value = 0;
    discountedPriceObs.value = 0;
  }
}
