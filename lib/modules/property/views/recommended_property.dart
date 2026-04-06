import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/widgets/texts/headline_text.dart';
import 'package:nesticope_app/modules/property/controllers/property_controller.dart';
import 'package:nesticope_app/modules/property/views/widgets/recommended_card.dart';

class RecommendedProperty extends StatelessWidget {
  const RecommendedProperty({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PropertyController());
    final PropertyController controller = Get.find();

    return Column(
      children: [
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.items.isEmpty) {
            return SizedBox.shrink();
          }
          if (controller.recommendedProperties.isEmpty) {
            return SizedBox.shrink();
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: ColorRes.leadGreyColor.shade50,
            child: Column(
              children: [
                   const SizedBox(height: 12),
                          const TitleWithViewAll(title: 'Recommended Properties'),
                          const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                  child: SizedBox(
                    height: 320,
                    child: Obx(() {
                      final items = controller.recommendedProperties;
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: items.length, // ✅ Always up-to-date
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          if (index >= items.length) {
                            return const SizedBox.shrink(); // ✅ Prevents RangeError
                          }
                          final data = items[index];
                          return RecommendedCard(property: data);
                        },
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        }),
      ],
    );
  }
}
