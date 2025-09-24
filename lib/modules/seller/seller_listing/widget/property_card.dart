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
        border: Border.all(color: ColorRes.grey.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Row: ID
            Text(
              "$id",
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
                  child: Image.asset(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container();
                    },
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6),
                          Builder(
                            builder: (iconContext) {
                              return GestureDetector(
                                onTap: () async {
                                  final RenderBox button =
                                      iconContext.findRenderObject()
                                          as RenderBox;
                                  final RenderBox overlay =
                                      Overlay.of(
                                            iconContext,
                                          ).context.findRenderObject()
                                          as RenderBox;

                                  final Offset buttonPosition = button
                                      .localToGlobal(
                                        Offset.zero,
                                        ancestor: overlay,
                                      );
                                  final Size buttonSize = button.size;

                                  final result = await showMenu<String>(
                                    context: iconContext,
                                    position: RelativeRect.fromLTRB(
                                      buttonPosition.dx - 90,
                                      buttonPosition.dy +
                                          buttonSize.height, // below the icon
                                      buttonPosition.dx + buttonSize.width,
                                      buttonPosition.dy,
                                    ),
                                    items: [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                    color: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  );

                                  if (result != null) {
                                    if (result == 'edit') {
                                      // handle edit
                                    } else if (result == 'delete') {
                                      // handle delete
                                    }
                                  }
                                },
                                child: const Icon(Icons.more_vert, size: 20),
                              );
                            },
                          ),
                        ],
                      ),

                      // const SizedBox(height: 4),
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
                      const SizedBox(height: 4),
                      if (status.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _buildStatusBadge(status),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🔹 Bottom Section
            Container(
              width: double.infinity,
              // padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // color: ColorRes.primary.withOpacity(0.03),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                    ],
                  ),

                  // const SizedBox(height: 8),

                  // GestureDetector(
                  //   onTap: onRepost,
                  //   child: const Text(
                  //     "Repost",
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       color: Colors.blue,
                  //       fontWeight: FontWeight.w600,
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Repost", style: TextStyle(fontSize: 12)),
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
