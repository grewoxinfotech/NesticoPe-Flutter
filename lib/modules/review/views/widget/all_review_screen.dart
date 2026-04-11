import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/review/views/widget/property_review_card.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../controllers/review_controller.dart';

class AllReviewScreen extends StatefulWidget {
  final ReviewController reviewController;
  const AllReviewScreen({super.key, required this.reviewController});

  @override
  State<AllReviewScreen> createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Get.back();
          },
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: Text(
          'All Reviews',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // Reactive list
          final items = widget.reviewController.items;

          if (items.isEmpty) {
            return const Center(child: Text('No reviews available'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return PropertyReviewCard(reviewItem: items[index]);
            },
          );
        }),
      ),
    );
  }
}//ncj have andh"bsy hgfhbbedhyfeb  bdhbv usjb ndnb kcj 
