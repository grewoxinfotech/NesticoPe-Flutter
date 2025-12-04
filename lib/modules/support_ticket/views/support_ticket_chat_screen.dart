import 'package:flutter/material.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/widgets/chat_screen_appbar.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/widgets/chat_text_field.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/widgets/message_list.dart';

import '../../../data/network/support_ticket/models/chat_model/chat_model.dart';

enum MessageStatus { sending, sent, delivered, read, failed }

class SupportTicketChatScreen extends StatefulWidget {
  const SupportTicketChatScreen({super.key});

  @override
  State<SupportTicketChatScreen> createState() =>
      _SupportTicketChatScreenState();
}

class _SupportTicketChatScreenState extends State<SupportTicketChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // _loadInitialMessages();
  }

  // void _loadInitialMessages() {
  //   // Sample messages
  //   setState(() {
  //     _messages.addAll([
  //       ChatMessage(
  //         id: '1',
  //         text: 'Hello! How can I help you today?',
  //         isUser: false,
  //         timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
  //       ),
  //       ChatMessage(
  //         id: '2',
  //         text: 'I\'m having trouble with my order #12345',
  //         isUser: true,
  //         timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
  //       ),
  //       ChatMessage(
  //         id: '3',
  //         text:
  //             'I understand your concern. Let me check the status of your order. Please give me a moment.',
  //         isUser: false,
  //         timestamp: DateTime.now().subtract(const Duration(minutes: 27)),
  //       ),
  //     ]);
  //   });
  // }
  //
  // void _sendMessage() {
  //   if (_messageController.text.trim().isEmpty) return;
  //
  //   final message = ChatMessage(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     text: _messageController.text.trim(),
  //     isUser: true,
  //     timestamp: DateTime.now(),
  //     status: MessageStatus.sending,
  //   );
  //
  //   setState(() {
  //     _messages.add(message);
  //     _messageController.clear();
  //   });
  //
  //   _scrollToBottom();
  //
  //   // Simulate message sent
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     setState(() {
  //       _messages.last = ChatMessage(
  //         id: message.id,
  //         text: message.text,
  //         isUser: message.isUser,
  //         timestamp: message.timestamp,
  //         status: MessageStatus.sent,
  //       );
  //     });
  //   });
  //
  //   // Simulate support agent typing
  //   Future.delayed(const Duration(seconds: 2), () {
  //     setState(() => _isTyping = true);
  //   });
  //
  //   // Simulate support agent response
  //   Future.delayed(const Duration(seconds: 4), () {
  //     setState(() {
  //       _isTyping = false;
  //       _messages.add(
  //         ChatMessage(
  //           id: DateTime.now().millisecondsSinceEpoch.toString(),
  //           text:
  //               'Thank you for providing that information. I\'ll look into this right away.',
  //           isUser: false,
  //           timestamp: DateTime.now(),
  //         ),
  //       );
  //     });
  //     _scrollToBottom();
  //   });
  // }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppBar(),
      body: Column(
        children: [
          // Status Banner
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //   color: Colors.green.shade50,
          //   child: Row(
          //     children: [
          //       Icon(Icons.check_circle, color: ColorRes.green, size: 16),
          //       const SizedBox(width: 8),
          //       Text(
          //         'Ticket is open - Support agent will respond soon',
          //         style: TextStyle(
          //           color: ColorRes.green.shade800,
          //           fontSize: 12,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // Messages List
          MessageList(scrollController: _scrollController, message: _messages),

          // Input Area
          ChatMessageInputField(),
        ],
      ),
    );
  }
}
