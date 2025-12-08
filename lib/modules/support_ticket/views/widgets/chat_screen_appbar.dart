import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/widgets/ticket_detail.dart';

import '../../../../app/constants/color_res.dart';

class ChatScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TicketItem ticket;
  const ChatScreenAppBar({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorRes.primary,
      foregroundColor: ColorRes.white,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorRes.white,
            child: Icon(Icons.support_agent, color: ColorRes.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support Team',
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.bold,
                    color: ColorRes.white,
                  ),
                ),
                // Text(
                //   'Ticket #12345',
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.white.withOpacity(0.9),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showOptions(context),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Close Ticket'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Ticket Details'),
                  onTap: () {
                    TicketDetailsBottomSheet.show(context, ticket);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.file_copy),
                  title: const Text('Export Chat'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }
}
