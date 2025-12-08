import 'package:flutter/material.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../data/network/support_ticket/models/chat_model/chat_model.dart';
import '../support_ticket_chat_screen.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    print("Message: ${message.toJson()}");
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: ColorRes.primary.withOpacity(0.3),
              child: Icon(
                Icons.support_agent,
                size: 16,
                color: ColorRes.primary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isUser
                            ? ColorRes.primary
                            : ColorRes.leadGreyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    // if (message.isUser) ...[
                    //   const SizedBox(width: 4),
                    //   _buildStatusIcon(message.status),
                    // ],
                  ],
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: ColorRes.primary.withOpacity(0.7),
              child: Icon(Icons.person, size: 16, color: ColorRes.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case MessageStatus.sent:
        return Icon(Icons.check, size: 14, color: Colors.grey.shade600);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 14, color: Colors.grey.shade600);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 14, color: ColorRes.primary);
      case MessageStatus.failed:
        return const Icon(Icons.error_outline, size: 14, color: ColorRes.error);
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
