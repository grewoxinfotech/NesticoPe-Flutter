import 'package:flutter/material.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/support_ticket_chat_screen.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../data/network/support_ticket/models/chat_model/chat_model.dart';
import 'chat_message_bubble.dart';

class MessageList extends StatelessWidget {
  final ScrollController scrollController;
  final String userId;
  final List<ChatMessage> message;
  final bool isTyping;
  const MessageList({
    super.key,
    required this.scrollController,
    required this.message,
    this.isTyping = false,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: message.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == message.length && isTyping) {
          return _buildTypingIndicator();
        }

        final isUser = message[index].senderId == userId;
        return ChatMessageBubble(message: message[index], isUser: isUser);
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: ColorRes.primary.withOpacity(0.2),
            child: Icon(Icons.support_agent, size: 16, color: ColorRes.primary),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: (value + index * 0.3) % 1.0,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      // onEnd: () => setState(() {}),
    );
  }
}
