

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/property/controllers/property_controller.dart';
import 'package:nesticope_app/modules/property/views/widgets/property_list_screen_card.dart';

import '../../../app/widgets/search_bar/custom_search_bar.dart';

class PropertyListScreen extends StatelessWidget {
  PropertyListScreen({super.key});

  final PropertyController controller = Get.put(PropertyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CustomSearchAppBar(),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: Text("No Property found."));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.atEdge && metrics.pixels != 0) {
                controller.loadMore();
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: controller.refreshList,
              child: ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final data = controller.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: PropertyListScreenCard(items: data),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
