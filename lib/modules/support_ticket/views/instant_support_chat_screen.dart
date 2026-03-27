import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
import 'package:nesticope_app/data/network/support_ticket/service/ticket_service/support_ticket_service.dart';
import 'package:nesticope_app/modules/support_ticket/controllers/chat_socket_controller.dart';
import 'package:nesticope_app/modules/support_ticket/views/support_ticket_chat_screen.dart';
import 'package:nesticope_app/modules/support_ticket/views/widgets/chat_text_field.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

class InstantSupportChatScreen extends StatefulWidget {
  const InstantSupportChatScreen({super.key});

  @override
  State<InstantSupportChatScreen> createState() =>
      _InstantSupportChatScreenState();
}

class _InstantSupportChatScreenState extends State<InstantSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final SocketController _socketController = Get.put(SocketController());
  final RxBool _isCreating = false.obs;

  String _titleFrom(String msg) {
    final trimmed = msg.trim();
    if (trimmed.isEmpty) return 'Chat Support';
    final cut =
        trimmed.length > 10 ? '${trimmed.substring(0, 10)}...' : trimmed;
    return 'Chat Support: $cut';
  }

  Future<void> _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    if (_isCreating.value) return;

    _isCreating.value = true;
    final service = TicketService();
    final payload = TicketCreateRequest(
      title: _titleFrom(text),
      description: text,
      category: 'other',
      ticketType: 'custom',
      priority: 'medium',
    );
    final created = await service.createTicketSimple(payload);
    _isCreating.value = false;

    if (created?.id != null) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: 'Ticket created successfully',
        contentType: ContentType.success,
      );
      final ticket = created!;
      final msg = _messageController.text;
      _messageController.clear();
      Get.off(
        () => SupportTicketChatScreen(ticketId: ticket.id!, ticket: ticket),
      );
      // Optionally, allow the user to continue typing; server will already
      // have the description as the first message context.
    } else {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to create ticket',
        contentType: ContentType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('NesticoPe Support'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent, color: ColorRes.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hello! How can we help you today?',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Obx(() {
            return IgnorePointer(
              ignoring: _isCreating.value,
              child: Opacity(
                opacity: _isCreating.value ? 0.6 : 1.0,
                child: ChatMessageInputField(
                  messageController: _messageController,

                  onSendTap: _handleSend,
                  pendingFile: Rxn(null),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
