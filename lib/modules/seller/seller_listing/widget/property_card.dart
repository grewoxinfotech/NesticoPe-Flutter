import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';

class PropertyListCard extends StatelessWidget {
  final String id;
  final String title;
  final String location;
  final String price;
  final String roomType;
  final String imageUrl;
  final String status;
  final String lastAddedDate;
  final VoidCallback onRepost;

  const PropertyListCard({
    super.key,
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.roomType,
    required this.imageUrl,
    required this.status,
    required this.lastAddedDate,
    required this.onRepost,
  });

  @override
  Widget build(BuildContext context) {
    final isDeleted = status.toLowerCase() == "deleted";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        color: Colors.transparent,
        border: Border.all(
          color: ColorRes.grey.withOpacity(0.2),
          width:  1,
        ),

      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Row: ID
            Text(
              "ID $id",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            const SizedBox(height: 8),

            /// 🔹 Property Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.small),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                /// Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title + Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (status.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            _buildStatusBadge(status),
                          ],
                        ],
                      ),

                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$roomType : $price",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 Bottom Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.03),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last Added",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    lastAddedDate,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: onRepost,
                    child: const Text(
                      "Repost",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    String text;

    switch (status.toLowerCase()) {
      case "active":
        bgColor = Colors.green;
        text = "ACTIVE";
        break;
      case "inactive":
        bgColor = Colors.red;
        text = "INACTIVE";
        break;
      case "pending":
        bgColor = Colors.orange;
        text = "PENDING";
        break;
      case "deleted":
        bgColor = Colors.grey;
        text = "DELETED";
        break;
      default:
        bgColor = Colors.blueGrey;
        text = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.2),
        border: Border.all(color: bgColor, width: 1),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: bgColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
