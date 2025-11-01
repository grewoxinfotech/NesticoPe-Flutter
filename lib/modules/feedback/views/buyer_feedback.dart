import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../controller/feedback_controller.dart';

class FeedbackForSellerScreen extends StatelessWidget {
  FeedbackForSellerScreen({super.key});

  final FeedbackController controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: ColorRes.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Feedback for Seller',
          style: TextStyle(
            color: ColorRes.black,
            fontWeight: AppFontWeights.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSellerInfoCard(),

              const SizedBox(height: 20),
              feedBackRating(controller),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildPropertyCardFeedBack(String name, String price, String location) {
  return Row(
    children: [
      // Property Image
      Container(
        height: 80,
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=400',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
SizedBox(width: 8,),
      // Property Details
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Modern Family Home in Suburbia',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '\$750,000',
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.primary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  // const Icon(
                  //   Icons.location_on,
                  //   size: 14,
                  //   color: ColorRes.textSecondary,
                  // ),
                  // const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '123 Main St, Springfield, IL',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 6),
    ],
  );
}

Widget buildSellerInfoCard() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Profile Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorRes.background,
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150?img=47'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Seller Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sarah Johnson',
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: ColorRes.homeYellow),
                      const SizedBox(width: 6),
                      Text(
                        '4.9 (24 Reviews)',
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          color: ColorRes.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '12 Properties Sold',
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.textSecondary,
                      fontWeight: AppFontWeights.regular,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Divider(
          color: ColorRes.leadGreyColor.withOpacity(0.4),
        ),
        buildPropertyCardFeedBack(
          'Angan Residency',
          '25Cr',
          'Manhaten Newyork City Usa',
        ),
      ],
    ),
  );
}

Widget feedBackRating(FeedbackController controller) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Feedback',
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.black,
          ),
        ),

        const SizedBox(height: 12),

        // Overall Rating
        Text(
          'Overall Rating',
          style: TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.textDisabled,
          ),
        ),

        const SizedBox(height: 12),

        _buildRatingStars(controller),
        const SizedBox(height: 12),
        Text(
          'Receive Message (Optional)',
          style: TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.black,
          ),
        ),   const SizedBox(height: 12),
        buildReviewTextField(controller),
        const SizedBox(height: 12),
        buildRecommendCheckbox(controller),
        const SizedBox(height: 12),
        buildSubmitButton(controller)
      ],
    ),
  );
}

Widget _buildRatingStars(FeedbackController controller) {
  return Obx(
    () => Row(
      children: List.generate(
        5,
        (index) => GestureDetector(
          onTap: () => controller.setRating((index + 1).toDouble()),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.star,
              size: 26,
              color:
                  index < controller.overallRating.value
                      ? ColorRes.homeYellow
                      : ColorRes.leadGreyColor.withOpacity(0.3),
            ),
          ),
        ),
      ),
    ),
  );
}
 Widget buildReviewTextField(FeedbackController controller) {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.border),
      ),
      child: TextField(
        onChanged: (value) => controller.setReviewMessage(value),
        maxLines: 6,
        style: TextStyle(
          fontSize: AppFontSizes.medium,
          color: ColorRes.black,
        ),
        decoration: InputDecoration(
          hintText: 'Share your experience with the seller...',
          hintStyle: TextStyle(
            fontSize: AppFontSizes.medium,
            color: ColorRes.textSecondary.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

Widget buildRecommendCheckbox(FeedbackController controller) {
    return Obx(
          () => Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: controller.recommendSeller.value,
              onChanged: controller.toggleRecommendation,
              activeColor: ColorRes.primary,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Recommend this seller',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              color: ColorRes.black,
            ),
          ),
        ],
      ),
    );
  }

Widget buildSubmitButton(FeedbackController controller) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => controller.submitFeedback(),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorRes.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Submit Feedback',
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.white,
          ),
        ),
      ),
    );
  }