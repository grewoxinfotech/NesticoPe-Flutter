import 'dart:convert';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/support_ticket/models/chat_model/chat_model.dart';
import '../../../data/network/support_ticket/service/chat_service/chat_service.dart';
import '../../../utils/logger/app_logger.dart';

class SocketController extends GetxController {
  final WebSocketService _socketService = WebSocketService();

  /// Reactive variables (same structure as ChatController)
  var isConnected = false.obs;
  var isLoading = true.obs;

  var events = <SocketEvent>[].obs;
  var messages = <ChatMessage>[].obs;

  var connectionError = ''.obs;

  RxString currentUserId = ''.obs;
  RxString roomId = ''.obs;

  /// optional: typing indicators map
  var typingStatus = <String, bool>{}.obs;

  /// connect to the socket
  @override
  void onInit() {
    super.onInit();
  }

  /// CONNECT SOCKET WITH ROOM ID
  Future<void> connect(String room) async {
    print("Connecting to room: $room");

    if (room.isEmpty) {
      connectionError.value = "Room ID missing";
      return;
    }

    roomId.value = room;
    connectionError.value = "";

    await _socketService.connect(room);

    // joinTicket(room);

    _socketService.events.listen(
      (event) {
        events.add(event);
        // print('📱 Event received: ${event.type}');

        switch (event.type) {
          case 'connect':
            isConnected.value = true;
            connectionError.value = '';
            break;
          case 'initial_chat':
            initialChat(event.data);
            break;

          case 'disconnect':
            isConnected.value = false;
            break;

          case 'error':
            connectionError.value = event.data?.toString() ?? 'Unknown error';
            break;

          case 'ticket_new_message':
            handleRawChatMessage(event.data);
            break;

          default:
            break;
        }
      },
      onError: (error) {
        connectionError.value = 'Socket error: $error';
        print('❌ Socket stream error: $error');
      },
    );
  }

  void joinTicket(String ticketId) {
    _socketService.joinTicket(ticketId);
  }

  void leaveTicket(String ticketId) {
    _socketService.leaveTicket(ticketId);
  }

  /// LISTEN TO SOCKET EVENTS STREAM

  void handleRawChatMessage(Map<String, dynamic> data) {
    try {
      if (data.isNotEmpty) {
        final message = ChatMessage.fromJson(data['message']);
        print("Received message: ${message.toJson()}");
        handleMessage(message);
      }
    } catch (e) {
      print("❌ Error parsing message: $e");
    }
  }

  void handleMessage(ChatMessage message) {
    messages.add(message);
    print(
      "Message added: ${messages.any((element) => element.id == message.id)}",
    );

    // Sort messages every time a new one is added
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // ascending
  }

  void initialChat(Map<String, dynamic> data) {
    try {
      isLoading.value = true;
      AppLogger.structured('📩 Initial chat Message:', data);
      messages.clear();

      if (data.isNotEmpty && data['messages'] != null) {
        final List<dynamic> rawMessages = data['messages'];

        final List<ChatMessage> messages =
            rawMessages.map((msg) => ChatMessage.fromJson(msg)).toList();

        for (var message in messages) {
          handleMessage(message);
        }

        print("Parsed messages: ${messages.length}");
      }
    } catch (e) {
      print("❌ Error parsing message: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// SEND MESSAGE
  Future<void> send(dynamic data) async {
    _socketService.send(data);
  }

  /// SEND TYPING EVENT
  void sendTyping(bool isTyping) {
    final event = {
      "roomId": roomId.value,
      "userId": currentUserId.value,
      "isTyping": isTyping,
    };
    _socketService.send(event);
  }

  /// clean all variable
  void cleanAll() {
    isConnected.value = false;
    isLoading.value = true;
    events.clear();
    messages.clear();
    connectionError.value = "";
    currentUserId.value = "";
    roomId.value = "";
    typingStatus.clear();
  }

  /// DISCONNECT
  void disconnect() {
    print("❌ Disconnecting socket...");
    cleanAll();
    _socketService.disconnect();
    isConnected.value = false;
    connectionError.value = "";
  }

  @override
  void onClose() {
    messages.clear();
    disconnect();
    super.onClose();
  }

  @override
  void dispose() {
    messages.clear();
    disconnect();
    super.dispose();
  }
}
