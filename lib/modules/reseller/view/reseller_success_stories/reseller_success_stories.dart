import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/reseller_success_stories/reseller_success_stories_model.dart';
import 'package:housing_flutter_app/modules/reseller/view/reseller_success_stories/add_reseller_success_stories_screen.dart';
import 'package:intl/intl.dart';
import '../../../../app/constants/color_res.dart';
import '../../controller/reseller_success_stories_controller/reseller_success_stories_controller.dart';

class ResellerSuccessStoryScreen extends StatelessWidget {
  final ResellerSuccessStoryController controller = Get.put(
    ResellerSuccessStoryController(),
  );

  ResellerSuccessStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reseller Success Stories"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return const Center(
            child: Text(
              "No success stories found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
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
              padding: const EdgeInsets.all(12),
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                if (index < controller.items.length) {
                  final story = controller.items[index];
                  return _buildStoryCard(story);
                } else {
                  // Loading indicator for pagination
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddResellerSuccessStoryScreen());
        },
        child: Icon(Icons.add, color: ColorRes.white),
      ),
    );
  }

  Widget _buildStoryCard(ResellerSuccessItem story) {
    final formattedDate = DateFormat.yMMMM().format(
      DateTime.parse(story.monthYear.toIso8601String()),
    );

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  Get.to(() => AddResellerSuccessStoryScreen(
                        story: story,
                    isEditMode: true,
                      ));
                },
                icon: Icon(Icons.edit, color: ColorRes.primary),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Title ---
                Text(
                  story.title ?? "Untitled Story",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                // --- Description ---
                Text(
                  story.description ?? "",
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 10),

                // --- Achievement ---
                if (story.achievement != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          story.achievement!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),

                // --- Stats Row ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat("Deals", story.totalDeals?.toString() ?? "0"),
                    _buildStat("Value", "₹${story.totalValue ?? '0'}"),
                    _buildStat("Rating", "⭐ ${story.rating ?? 0}"),
                  ],
                ),

                const SizedBox(height: 8),
                // --- Footer ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(story.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        story.status ?? "draft",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'published':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}
