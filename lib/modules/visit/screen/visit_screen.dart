import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';

import '../../../../app/constants/color_res.dart';
import '../../../data/network/visit/model/visit_model.dart';
import '../controller/visit_controller.dart';

class VisitScreen extends StatelessWidget {
  const VisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VisitController controller = Get.put(VisitController());

    return Scaffold(
      appBar: AppBar(title: const Text("My Visits")),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return const Center(child: Text("No visits found"));
        }

        return NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
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
                final visit = controller.items[index];
                return _VisitCard(visit: visit);
              },
            ),
          ),
        );
      }),
    );
  }
}

class _VisitCard extends StatelessWidget {
  final VisitItem visit;

  const _VisitCard({required this.visit});

  @override
  Widget build(BuildContext context) {
    final property = visit.property;
    final image =
        property?.propertyMedia?.images != null &&
                property!.propertyMedia!.images!.isNotEmpty == true
            ? property.propertyMedia!.images!.first
            : null;

    final date = visit.visitDate;
    final formattedDate = "${date.day}/${date.month}/${date.year}";

    return GestureDetector(
      onTap: () {
        Get.to(() => PropertyDetailScreen(propertyId: property?.id ?? ''));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // /// Property Image
            // if (image != null)
            //   ClipRRect(
            //     borderRadius: const BorderRadius.vertical(
            //       top: Radius.circular(14),
            //     ),
            //     child: Image.network(
            //       image,
            //       height: 150,
            //       width: double.infinity,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Property Type & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        property?.propertyType.toUpperCase() ?? "PROPERTY",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      _StatusChip(status: visit.status),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Location
                  if (property != null)
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${property.location}, ${property.city}",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 10),

                  /// Visit Date & Time
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 6),
                      Text("Date: $formattedDate"),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 6),
                      Text(visit.timeSlot),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Notes
                  if (visit.notes?.isNotEmpty == true)
                    Text(
                      visit.notes!,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),

                  const SizedBox(height: 10),

                  /// Follow-up / Interest
                  if (visit.interestedLevel != null ||
                      visit.followUpDate != null)
                    Row(
                      children: [
                        if (visit.interestedLevel != null)
                          _InfoChip(
                            label:
                                "Interest: ${visit.interestedLevel!.toUpperCase()}",
                          ),
                        if (visit.followUpDate != null)
                          _InfoChip(
                            label:
                                "Follow-up: ${visit.followUpDate!.day}/${visit.followUpDate!.month}/${visit.followUpDate!.year}",
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'completed':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'rescheduled':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColorRes.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: ColorRes.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
