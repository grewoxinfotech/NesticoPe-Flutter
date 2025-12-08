// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
// import 'package:housing_flutter_app/modules/support_ticket/views/widgets/chat_screen_appbar.dart';
// import 'package:housing_flutter_app/modules/support_ticket/views/widgets/chat_text_field.dart';
// import 'package:housing_flutter_app/modules/support_ticket/views/widgets/message_list.dart';
//
// import '../../../data/network/support_ticket/models/chat_model/chat_model.dart';
// import '../../../data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
// import '../controllers/chat_socket_controller.dart';
//
// enum MessageStatus { sending, sent, delivered, read, failed }
//
// class SupportTicketChatScreen extends StatefulWidget {
//   final String ticketId;
//   final TicketItem ticket;
//   const SupportTicketChatScreen({
//     super.key,
//     required this.ticketId,
//     required this.ticket,
//   });
//
//   @override
//   State<SupportTicketChatScreen> createState() =>
//       _SupportTicketChatScreenState();
// }
//
// class _SupportTicketChatScreenState extends State<SupportTicketChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final SocketController _socketController = Get.find<SocketController>();
//   late final String roomId;
//   final RxString currentUser = ''.obs;
//
//   // final List<ChatMessage> _messages = [];
//   bool _isTyping = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     roomId = "${widget.ticketId}";
//     _socketController.joinTicket(roomId);
//     ever(_socketController.messages, (_) => _scrollToBottom());
//     loadUserId();
//   }
//
//   Future<void> loadUserId() async {
//     // final user = await SecureStorage.getUserData();
//     currentUser.value = await getUserId() ?? '';
//   }
//
//   Future<String?> getUserId() async {
//     final user = await SecureStorage.getUserData();
//     final userId = user?.user?.id;
//     if (userId != null) {
//       return userId;
//     }
//     return null;
//   }
//
//   // void _loadInitialMessages() {
//   //   // Sample messages
//   //   setState(() {
//   //     _messages.addAll([
//   //       ChatMessage(
//   //         id: '1',
//   //         text: 'Hello! How can I help you today?',
//   //         isUser: false,
//   //         timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
//   //       ),
//   //       ChatMessage(
//   //         id: '2',
//   //         text: 'I\'m having trouble with my order #12345',
//   //         isUser: true,
//   //         timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
//   //       ),
//   //       ChatMessage(
//   //         id: '3',
//   //         text:
//   //             'I understand your concern. Let me check the status of your order. Please give me a moment.',
//   //         isUser: false,
//   //         timestamp: DateTime.now().subtract(const Duration(minutes: 27)),
//   //       ),
//   //     ]);
//   //   });
//   // }
//   //
//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;
//
//     final message = SendChatMessage(
//       ticketId: widget.ticketId,
//       message: _messageController.text.trim(),
//     );
//
//     _socketController.send(message.toJson());
//     _messageController.clear();
//     // setState(() {
//     //   _messages.add(message);
//     //   _messageController.clear();
//     // });
//
//     _scrollToBottom();
//
//     // // Simulate message sent
//     // Future.delayed(const Duration(milliseconds: 500), () {
//     //   setState(() {
//     //     _messages.last = ChatMessage(
//     //       id: message.id,
//     //       text: message.text,
//     //       isUser: message.isUser,
//     //       timestamp: message.timestamp,
//     //       status: MessageStatus.sent,
//     //     );
//     //   });
//     // });
//     //
//     // // Simulate support agent typing
//     // Future.delayed(const Duration(seconds: 2), () {
//     //   setState(() => _isTyping = true);
//     // });
//     //
//     // // Simulate support agent response
//     // Future.delayed(const Duration(seconds: 4), () {
//     //   setState(() {
//     //     _isTyping = false;
//     //     _messages.add(
//     //       ChatMessage(
//     //         id: DateTime.now().millisecondsSinceEpoch.toString(),
//     //         text:
//     //             'Thank you for providing that information. I\'ll look into this right away.',
//     //         isUser: false,
//     //         timestamp: DateTime.now(),
//     //       ),
//     //     );
//     //   });
//     //   _scrollToBottom();
//     // });
//   }
//
//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _socketController.leaveTicket(widget.ticketId);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ChatScreenAppBar(ticket: widget.ticket),
//       body: Obx(() {
//         if (currentUser.value.isEmpty && _socketController.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return Column(
//           children: [
//             // Status Banner
//             // Container(
//             //   width: double.infinity,
//             //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             //   color: Colors.green.shade50,
//             //   child: Row(
//             //     children: [
//             //       Icon(Icons.check_circle, color: ColorRes.green, size: 16),
//             //       const SizedBox(width: 8),
//             //       Text(
//             //         'Ticket is open - Support agent will respond soon',
//             //         style: TextStyle(
//             //           color: ColorRes.green.shade800,
//             //           fontSize: 12,
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//
//             // Messages List
//             Expanded(
//               child: MessageList(
//                 scrollController: _scrollController,
//                 message: _socketController.messages.value,
//                 userId: currentUser.value,
//               ),
//             ),
//             // Spacer(),
//             // Input Area
//             ChatMessageInputField(
//               messageController: _messageController,
//               onSendTap: () {
//                 _sendMessage();
//               },
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/widgets/chat_screen_appbar.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/widgets/chat_text_field.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/widgets/message_list.dart';

import '../../../data/network/support_ticket/models/chat_model/chat_model.dart';
import '../../../data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
import '../controllers/chat_socket_controller.dart';

class SupportTicketChatScreen extends StatefulWidget {
  final String ticketId;
  final TicketItem ticket;
  const SupportTicketChatScreen({
    super.key,
    required this.ticketId,
    required this.ticket,
  });

  @override
  State<SupportTicketChatScreen> createState() =>
      _SupportTicketChatScreenState();
}

class _SupportTicketChatScreenState extends State<SupportTicketChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Rxn<PlatformFile> _pendingFile = Rxn<PlatformFile>(null);

  final SocketController _socketController = Get.find<SocketController>();

  final RxString currentUser = ''.obs;

  late final String roomId;

  @override
  void initState() {
    super.initState();

    roomId = widget.ticketId;

    /// Save roomId inside socket controller
    _socketController.roomId.value = roomId;

    /// Join ticket manually
    _socketController.joinTicket(roomId);

    /// Scroll to bottom on new message
    ever(_socketController.messages, (_) => _scrollToBottom());

    loadUserId();
  }

  Future<void> loadUserId() async {
    final user = await SecureStorage.getUserData();
    final id = user?.user?.id ?? "";
    currentUser.value = id;

    _socketController.currentUserId.value = id;
  }

  Future<void> _sendMessage() async {
    final hasText = _messageController.text.trim().isNotEmpty;
    final hasFile = _pendingFile.value != null;

    if (!hasText && !hasFile) return;

    // CASE 1 → Only Text
    if (hasText && !hasFile) {
      final msg = SendChatMessage(
        ticketId: roomId,
        message: _messageController.text.trim(),
      );

      _socketController.send(msg.toJson());
      _messageController.clear();
    }

    // CASE 2 → File (with or without text)
    if (hasFile) {
      final file = _pendingFile.value;
      final fileBytes = file!.bytes!;

      final payload = SendChatMessageAndFile(
        ticketId: roomId,
        message: hasText ? _messageController.text.trim() : "",
        fileBuffer: fileBytes,
        fileName: file.name,
        fileType: file.extension,
      );

      _socketController.send(payload.toJson());

      _pendingFile.value = null; // clear file after sending
      _messageController.clear(); // optional: clear text too
    }

    _scrollToBottom();
  }

  //
  // Future<void> _sendMessage() async {
  //   if (_messageController.text.trim().isEmpty) return;
  //
  //   final msg = SendChatMessage(
  //     ticketId: roomId,
  //     message: _messageController.text.trim(),
  //   );
  //
  //   _socketController.send(msg.toJson());
  //   _messageController.clear();
  //
  //   _scrollToBottom();
  // }
  //
  // Future<void> _sendMessageWithFile({
  //   required List<int>? fileBytes,
  //   required String? fileName,
  //   required String? fileType,
  // }) async {
  //   final payload = SendChatMessageAndFile(
  //     ticketId: roomId,
  //     message: _messageController.text.trim(),
  //     fileBuffer: fileBytes ?? [],
  //     fileName: fileName,
  //     fileType: fileType,
  //   );
  //
  //   _socketController.send(payload.toJson());
  //
  //   // Clear text box after sending
  //   _messageController.clear();
  //   _scrollToBottom();
  // }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    /// Leave the ticket properly
    _socketController.leaveTicket(roomId);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppBar(ticket: widget.ticket),
      body: Obx(() {
        /// Show loader if:
        /// - userId not loaded yet
        /// - OR socket initial chat loading
        if (currentUser.value.isEmpty || _socketController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: MessageList(
                scrollController: _scrollController,
                message: _socketController.messages.value,
                userId: currentUser.value,
              ),
            ),

            ChatMessageInputField(
              messageController: _messageController,
              onSendTap: _sendMessage,
              pendingFile: _pendingFile,
              // onDocumentPicked: (file) {
              //   _pendingFile = file; // <-- STORE FILE
              // },
            ),
          ],
        );
      }),
    );
  }
}
