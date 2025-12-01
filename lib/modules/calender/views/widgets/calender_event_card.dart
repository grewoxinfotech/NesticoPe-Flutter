import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../../widgets/dialogs/show_long_text_dialog.dart';

class EventDateSection extends StatelessWidget {
  final String date;
  final List<Widget> events;

  const EventDateSection({super.key, required this.date, required this.events});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style:  TextStyle(fontSize: AppFontSizes.bodySmall, color: ColorRes.textColor,fontWeight: AppFontWeights.semiBold),
          ),
          const SizedBox(height: 4),
          ...events,
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String tag;
  final Color tagColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EventCard({
    super.key,
    required this.title,
    required this.description,
    required this.tag,
    required this.tagColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left red dot
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, size: 10, color: ColorRes.error),
          ),

          const SizedBox(width: 12),

          // Content Section


      Expanded(
              child: InkWell(
                onTap: () {
                  showContentDialog(context: context,content: description);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Tag
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textColor
                            ),
                          ),
                        ),

                        // Tag chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: tagColor,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text('${
                        description
                    }',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: AppFontSizes.caption, color: ColorRes.leadGreyColor.shade600,fontWeight: AppFontWeights.medium),
                    ),
                  ],
                ),
              ),
            ),


          // ---- 3 DOT MENU ----
          PopupMenuButton<String>(
            elevation: 10,
            color: ColorRes.leadGreyColor[100],
            borderRadius: BorderRadius.circular(12),
            onSelected: (value) {
              if (value == "edit") onEdit();
              if (value == "delete") onDelete();
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: const [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Delete"),
                      ],
                    ),
                  ),
                ],
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
