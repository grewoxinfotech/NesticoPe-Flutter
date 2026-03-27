import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/modules/property/views/property_detail_screen.dart';

import '../../../../app/constants/color_res.dart';
import '../../../data/network/visit/model/visit_model.dart';
import '../../../utils/shimmer/buyer/my_visit/buyer_my_visit_list_screen_shimmer.dart';
import '../controller/visit_controller.dart';

class VisitScreen extends StatelessWidget {
  const VisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VisitController controller = Get.put(VisitController());

    return Scaffold(

      appBar: AppBar(title: const Text("My Visits"),backgroundColor: ColorRes.white,),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return BuyerMyVisitListScreenShimmer();
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

// class _VisitCard extends StatelessWidget {
//   final VisitItem visit;
//
//   const _VisitCard({required this.visit});
//
//   @override
//   Widget build(BuildContext context) {
//     final property = visit.property;
//     final image =
//         property?.propertyMedia?.images != null &&
//                 property!.propertyMedia!.images!.isNotEmpty == true
//             ? property.propertyMedia!.images!.first
//             : null;
//
//     final date = visit.visitDate;
//     final formattedDate = "${date.day}/${date.month}/${date.year}";
//
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => PropertyDetailScreen(propertyId: property?.id ?? ''));
//       },
//       child: Card(
//         margin: const EdgeInsets.only(bottom: 14),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         elevation: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // /// Property Image
//             // if (image != null)
//             //   ClipRRect(
//             //     borderRadius: const BorderRadius.vertical(
//             //       top: Radius.circular(14),
//             //     ),
//             //     child: Image.network(
//             //       image,
//             //       height: 150,
//             //       width: double.infinity,
//             //       fit: BoxFit.cover,
//             //     ),
//             //   ),
//             Padding(
//               padding: const EdgeInsets.all(14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Property Type & Status
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         property?.propertyType.toUpperCase() ?? "PROPERTY",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                         ),
//                       ),
//                       _StatusChip(status: visit.status),
//                     ],
//                   ),
//
//                   const SizedBox(height: 6),
//
//                   /// Location
//                   if (property != null)
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 16),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             "${property.location}, ${property.city}",
//                             style: TextStyle(color: Colors.grey.shade700),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                   const SizedBox(height: 10),
//
//                   /// Visit Date & Time
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_today, size: 16),
//                       const SizedBox(width: 6),
//                       Text("Date: $formattedDate"),
//                       const SizedBox(width: 16),
//                       const Icon(Icons.access_time, size: 16),
//                       const SizedBox(width: 6),
//                       Text(visit.timeSlot),
//                     ],
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   /// Notes
//                   if (visit.notes?.isNotEmpty == true)
//                     Text(
//                       visit.notes!,
//                       style: TextStyle(color: Colors.grey.shade800),
//                     ),
//
//                   const SizedBox(height: 10),
//
//                   /// Follow-up / Interest
//                   if (visit.interestedLevel != null ||
//                       visit.followUpDate != null)
//                     Row(
//                       children: [
//                         if (visit.interestedLevel != null)
//                           _InfoChip(
//                             label:
//                                 "Interest: ${visit.interestedLevel!.toUpperCase()}",
//                           ),
//                         if (visit.followUpDate != null)
//                           _InfoChip(
//                             label:
//                                 "Follow-up: ${visit.followUpDate!.day}/${visit.followUpDate!.month}/${visit.followUpDate!.year}",
//                           ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _StatusChip extends StatelessWidget {
//   final String status;
//
//   const _StatusChip({required this.status});
//
//   @override
//   Widget build(BuildContext context) {
//     Color color;
//
//     switch (status.toLowerCase()) {
//       case 'pending':
//         color = Colors.orange;
//         break;
//       case 'completed':
//         color = Colors.green;
//         break;
//       case 'cancelled':
//         color = Colors.red;
//         break;
//       case 'rescheduled':
//         color = Colors.blue;
//         break;
//       default:
//         color = Colors.grey;
//     }
//
//     return Chip(
//       label: Text(
//         status.toUpperCase(),
//         style: const TextStyle(color: Colors.white, fontSize: 11),
//       ),
//       backgroundColor: color,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//     );
//   }
// }
//
// class _InfoChip extends StatelessWidget {
//   final String label;
//
//   const _InfoChip({required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8, top: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: ColorRes.primary.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 11,
//           color: ColorRes.primary,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }

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
    final formattedTime = visit.timeSlot; // Assuming this is already formatted

    return GestureDetector(
      onTap: () {
        Get.to(() => PropertyDetailScreen(propertyId: property?.id ?? ''));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Property Title & Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          property != null
                              ? "${property.propertyType.replaceAll("_", " ").capitalize} ${property.listingType.replaceAll("_", " ").capitalize ?? 'sell'} in ${property.location.replaceAll("_", " ").capitalize}, ${property.city.replaceAll("_", " ").capitalize}"
                              : "Property Visit",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: ColorRes.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(status: visit.status),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
                  const SizedBox(height: 10),

                  /// Date & Time
                  _InfoRow(
                    icon: Icons.calendar_today,
                    iconColor: ColorRes.primary,
                    title: "Date & Time",
                    value: "$formattedDate at $formattedTime",
                  ),

                  const SizedBox(height: 16),

                  /// Property Type
                  if (property?.propertyType != null) ...[
                    _InfoRow(
                      icon: Icons.home,
                      iconColor: ColorRes.primary,
                      title: "Property Type",
                      value: property!.propertyType,
                    ),

                    const SizedBox(height: 16),
                  ],

                  /// Listing Type
                  if (property?.listingType != null) ...[
                    _InfoRow(
                      icon: Icons.receipt_long,
                      iconColor: ColorRes.primary,
                      title: "Listing Type",
                      value: property!.listingType!,
                    ),

                    const SizedBox(height: 16),
                  ],

                  /// Location
                  if (property != null) ...[
                    _InfoRow(
                      icon: Icons.location_on,
                      iconColor: ColorRes.primary,
                      title: "Location",
                      value: "${property.location}, ${property.city}",
                    ),
                    const SizedBox(height: 16),
                  ],

                  /// Notes
                  if (visit.notes?.isNotEmpty == true) ...[
                    _InfoRow(
                      icon: Icons.note,
                      iconColor: ColorRes.primary,
                      title: "Notes",
                      value: visit.notes!,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (visit.cancellationReason?.isNotEmpty == true) ...[
                    _InfoRow(
                      icon: Icons.not_interested,
                      iconColor: ColorRes.redAccentColor,
                      title: "cancellation Reason",
                      value: visit.cancellationReason!,
                    ),
                  ],

                  /// Follow-up / Interest
                  if (visit.interestedLevel != null ||
                      visit.followUpDate != null) ...[
                    const SizedBox(height: 16),

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSizes.bodySmall,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: Colors.grey.shade700,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
        ),
      ],
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
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
