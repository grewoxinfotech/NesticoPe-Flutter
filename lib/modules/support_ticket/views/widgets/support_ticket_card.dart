import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/support_ticket/models/ticket_model/support_ticket_model.dart';

class SupportTicketCard extends StatelessWidget {
  final TicketItem ticket;

  const SupportTicketCard({super.key, required this.ticket});

  // Color mapping
  Color getStatusColor(String status) {
    switch (status) {
      case 'open':
        return ColorRes.primary;
      case 'resolved':
        return ColorRes.success;
      case 'closed':
        return ColorRes.error;
      case 'in_progress':
        return ColorRes.warning;
      default:
        return ColorRes.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Colored priority/status bar
            if (ticket.status != null)
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: getStatusColor(ticket.status!),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.title ?? '',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticket.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.leadGreyColor.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (ticket.status != null)
                          Text(
                            'Status: ${ticket.status}',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.bold,
                              color: getStatusColor(ticket.status!),
                            ),
                          ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(ticket.createdAt!) ??
                              '',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: AppFontWeights.regular,
                            color: ColorRes.leadGreyColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
