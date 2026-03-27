// Bottom Sheet Widget
import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:intl/intl.dart';

import '../../../../data/network/support_ticket/models/ticket_model/support_ticket_model.dart';

class TicketDetailsBottomSheet extends StatelessWidget {
  final TicketItem ticket;

  const TicketDetailsBottomSheet({Key? key, required this.ticket})
    : super(key: key);

  // Method to show the bottom sheet
  static void show(BuildContext context, TicketItem ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TicketDetailsBottomSheet(ticket: ticket),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //     vertical: 8,
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Text(
              //           'Ticket Details',
              //           style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //       IconButton(
              //         icon: const Icon(Icons.close),
              //         onPressed: () => Navigator.pop(context),
              //       ),
              //     ],
              //   ),
              // ),
              //
              // const Divider(height: 1),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Title
                    if (ticket.title != null) ...[
                      Text(
                        ticket.title!,
                        style: TextStyle(
                          fontSize: AppFontSizes.title,
                          fontWeight: AppFontWeights.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Status, Priority, Category Row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (ticket.status != null)
                          _buildChip(
                            label: ticket.status!,
                            color: _getStatusColor(ticket.status!),
                          ),
                        if (ticket.priority != null)
                          _buildChip(
                            label: ticket.priority!,
                            color: _getPriorityColor(ticket.priority!),
                          ),
                        if (ticket.category != null)
                          _buildChip(
                            label: ticket.category!,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Description
                    if (ticket.description != null) ...[
                      _buildSectionTitle(context, 'Description'),
                      const SizedBox(height: 8),
                      Text(
                        ticket.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Details Grid
                    _buildDetailsGrid(context),

                    // Resolution Notes
                    if (ticket.resolutionNotes != null) ...[
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, 'Resolution Notes'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          ticket.resolutionNotes!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],

                    // Files
                    if (ticket.files != null && ticket.files!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, 'Attachments'),
                      const SizedBox(height: 8),
                      ...ticket.files!.map(
                        (file) => _buildFileItem(context, file),
                      ),
                    ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: AppFontSizes.bodyMedium,
        fontWeight: AppFontWeights.bold,
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Details'),
        const SizedBox(height: 12),

        if (ticket.ticketType != null)
          _buildDetailRow(context, 'Type', ticket.ticketType!),

        if (ticket.createdBy != null) ...[
          _buildDetailRow(
            context,
            'Created By',
            '${ticket.createdBy!.username ?? 'Unknown'} (${ticket.createdBy!.userType ?? 'N/A'})',
          ),
        ],

        if (ticket.createdAt != null)
          _buildDetailRow(
            context,
            'Created At',
            _formatDateTime(ticket.createdAt!),
          ),

        if (ticket.updatedAt != null)
          _buildDetailRow(
            context,
            'Updated At',
            _formatDateTime(ticket.updatedAt!),
          ),

        if (ticket.id != null)
          _buildDetailRow(context, 'Ticket ID', ticket.id!),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.headingTitle,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.headingTitle,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({required String label, required Color color}) {
    return Chip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: ColorRes.white),
      ),
      label: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: AppFontSizes.caption,
          fontWeight: AppFontWeights.medium,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildFileItem(BuildContext context, dynamic file) {
    final fileName = file.toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.attach_file, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Icon(Icons.download, color: Colors.grey[600], size: 20),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return ColorRes.warning;
      case 'in progress':
      case 'in_progress':
        return ColorRes.primary;
      case 'resolved':
      case 'closed':
        return ColorRes.success;
      case 'cancelled':
        return ColorRes.error;
      default:
        return ColorRes.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }
}
