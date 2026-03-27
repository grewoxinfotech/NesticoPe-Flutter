import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/property/controllers/property_controller.dart';
import 'package:nesticope_app/modules/seller/view/widget/seller_property_card.dart';

class SellerPropertyList extends StatelessWidget {
  SellerPropertyList({super.key});
  final PropertyController controller = Get.put(PropertyController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!controller.isLoading.value && controller.items.isEmpty) {
        return const Center(child: Text("No Property found."));
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge && metrics.pixels != 0) {
              controller.loadMore();
            }
            return false;
          },
          child: ListView.separated(
            itemCount: controller.items.length,
            shrinkWrap: true, // ✅ allow it to size itself
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index >= controller.items.length) {
                return const SizedBox();
              }
              final data = controller.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: SellerPropertyCard(property: data),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
