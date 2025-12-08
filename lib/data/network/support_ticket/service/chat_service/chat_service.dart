// import 'dart:async';
// import 'dart:convert';
// import 'package:housing_flutter_app/app/constants/api_constants.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// import '../../../../database/secure_storage_service.dart';
//
// class SocketEvent {
//   final String type;
//   final dynamic data;
//   SocketEvent(this.type, this.data);
// }
//
// class WebSocketService {
//   static final WebSocketService _instance = WebSocketService._internal();
//   factory WebSocketService() => _instance;
//
//   WebSocketService._internal();
//
//   IO.Socket? _socket;
//   final _eventController = StreamController<SocketEvent>.broadcast();
//
//   Stream<SocketEvent> get events => _eventController.stream;
//   bool _isConnected = false;
//
//   Function(dynamic message)? onMessage;
//   Function()? onConnect;
//   Function()? onDisconnect;
//   Function(dynamic error)? onError;
//
//   String? _roomId;
//
//   /// CONNECT WITH ROOM ID
//   Future<void> connect(String roomId) async {
//     _roomId = roomId;
//
//     try {
//       if (_isConnected) return;
//       final url = '${ApiConstants.ticketChat}';
//       // final query = {
//       //   'join_ticket': {'ticketId': roomId},
//       // };
//       // final query = {'roomId': roomId};
//       final token = await SecureStorage.getToken();
//
//       print("Connecting to room: $roomId");
//
//       // _socket = IO.io(
//       //   "url",
//       //   IO.OptionBuilder()
//       //       .setTransports(['websocket']) // required for Flutter
//       //       .enableAutoConnect()
//       //       .setQuery({'roomId': roomId}) // send room id
//       //       .build(),
//       // );
//
//       // _socket = IO.io(
//       //   url,
//       //   IO.OptionBuilder().setTransports(['websocket', 'polling'])
//       //     ..setQuery({
//       //           'token': token, // 👈 server authenticateSocket uses this!
//       //         })
//       //         .disableAutoConnect()
//       //         .setReconnectionAttempts(5)
//       //         .setReconnectionDelay(1000)
//       //         .setTimeout(10000)
//       //         .build(),
//       // );
//
//       _socket = IO.io(
//         url,
//         IO.OptionBuilder()
//             .setTransports(['websocket', 'polling'])
//             .setAuth({'token': token})
//             // .setQuery(query ?? {})
//             .disableAutoConnect()
//             .setReconnectionAttempts(5)
//             .setReconnectionDelay(1000)
//             .setTimeout(10000)
//             .build(),
//       );
//
//       _socket!.connect();
//
//       /// CONNECT CALLBACK
//       _socket!.onConnect((_) {
//         _isConnected = true;
//         print('✅ Connected with ID: ${_socket?.id}');
//         onConnect?.call();
//
//         /// Join room after connect
//         print('📡 Joining ticket: $roomId');
//         _socket!.emit('join_ticket', {'ticketId': roomId});
//         // print('✅ Connected with ID: ${_socket?.id}');
//       });
//
//       /// MESSAGE CALLBACK
//       // _socket!.on('message', (data) {
//       //   print('📡 Message received: $data');
//       //   onMessage?.call(data);
//       // });
//
//       /// ERROR CALLBACK
//       _socket!.onError((err) {
//         _isConnected = false;
//         print('❌ Socket error: $err');
//         onError?.call(err);
//       });
//
//       /// DISCONNECT CALLBACK
//       _socket!.onDisconnect((_) {
//         print('❌ Socket disconnected');
//         _isConnected = false;
//         onDisconnect?.call();
//       });
//
//       _socket!.onAny((event, data) {
//         print('📡 Event: $event → ${jsonEncode(data)}');
//         _safeAdd(SocketEvent(event, data));
//       });
//     } catch (e) {
//       print('❌ Socket initialization error: $e');
//       _safeAdd(SocketEvent('error', e.toString()));
//     }
//   }
//
//   /// SEND DATA
//   void send(dynamic data) {
//     if (!_isConnected || _socket == null) return;
//     print('📡 Sending message: $data');
//     if (data is Map || data is List) {
//       _socket!.emit('ticket_send_message', jsonEncode(data));
//     } else {
//       _socket!.emit('ticket_send_message', data.toString());
//     }
//   }
//
//   void joinTicket(String ticketId) {
//     if (!_isConnected || _socket == null) return;
//     print('📡 Joining ticket: $ticketId');
//     _socket!.emit('join_ticket', jsonEncode({'ticketId': ticketId}));
//   }
//
//   /// DISCONNECT
//   void disconnect() {
//     if (_isConnected) {
//       _socket?.disconnect();
//       _isConnected = false;
//       onDisconnect?.call();
//     }
//   }
//
//   bool get isConnected => _isConnected;
//
//   String? get currentRoomId => _roomId;
//
//   void _safeAdd(SocketEvent event) {
//     if (!_eventController.isClosed) _eventController.add(event);
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../../app/constants/api_constants.dart';
import '../../../../database/secure_storage_service.dart';

class SocketEvent {
  final String type;
  final dynamic data;
  SocketEvent(this.type, this.data);
}

class WebSocketService {
  /// Singleton class
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  /// Socket instance
  IO.Socket? _socket;

  /// Variables to handle socket events
  final _eventController = StreamController<SocketEvent>.broadcast();
  Stream<SocketEvent> get events => _eventController.stream;
  bool _isConnected = false;
  String? _roomId;

  /// CONNECT WITH TICKET ID
  Future<void> connect(String ticketId) async {
    _roomId = ticketId;

    if (_isConnected) return;

    try {
      final url = ApiConstants.ticketChat; // "http://localhost:19725"
      final token = await SecureStorage.getToken();

      print("🔄 Connecting to socket for ticket: $ticketId");

      _socket = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token}) // ⬅️ REQUIRED for backend
            .disableAutoConnect()
            .setReconnectionAttempts(999999)
            .setReconnectionDelay(1000)
            .setTimeout(20000)
            .build(),
      );

      _socket!.connect();

      // ===== CONNECT =====
      _socket!.onConnect((_) {
        _isConnected = true;
        print("✅ Socket connected: ${_socket!.id}");
        // onConnect?.call();

        // join ticket room
        // print("📡 Joining ticket room => $ticketId");
        // _socket!.emit('join_ticket', {'ticketId': ticketId});
        // print("✅ Ticket Joined: ${_socket!.id}");
        // _socket!.emit('get_ticket_messages', {'ticketId': ticketId});
        _socket!.emitWithAck(
          'join_ticket',
          {'ticketId': ticketId},
          ack: (data) {
            print("🎯 Server ACK (join_ticket): $data");
          },
        );

        _socket!.emit('get_ticket_messages', {'ticketId': ticketId});
        print("✅ Ticket Message Received: ${_socket!.id}");
      });

      // ===== MESSAGE EVENT =====
      // _socket!.on('ticket_new_message', (data) {
      //   print("📩 New Message: $data");
      //   // onMessage?.call(data);
      // });

      // _socket!.on('initial_chat', (data) {
      //   // print("📩 Initial chat Message: $data");
      //   // onMessage?.call(data);
      // });

      // ===== ERROR =====
      _socket!.onError((err) {
        print("❌ Socket error: $err");
        // onError?.call(err);
      });

      // ===== DISCONNECT =====
      _socket!.onDisconnect((_) {
        print("❌ Socket disconnected");
        _isConnected = false;
        // onDisconnect?.call();
      });

      // ===== ANY EVENT =====
      _socket!.onAny((event, data) {
        print("📡 $event = ${jsonEncode(data)}");
        _safeAdd(SocketEvent(event, data));
      });
    } catch (e) {
      print("❌ Socket initialization error: $e");
      _safeAdd(SocketEvent('error', e.toString()));
    }
  }

  /// SEND CHAT MESSAGE
  void send(Map<String, dynamic> data) {
    if (!_isConnected || _socket == null) return;

    print("📤 Sending message: $data");

    _socket!.emitWithAck(
      'ticket_send_message',
      data,

      ack: (response) {
        print("🎉 Message Sent ACK => $response");
      },
    );
  }

  /// JOIN ANY TICKET
  void joinTicket(String ticketId) {
    if (!_isConnected) return;

    print("📡 Joining ticket => $ticketId");
    _socket!.emit('join_ticket', {'ticketId': ticketId});
  }

  void leaveTicket(String ticketId) {
    if (!_isConnected) return;

    print("📡 Leaving ticket => $_roomId");
    _socket!.emit('leave_ticket', {'ticketId': ticketId});
  }

  /// DISCONNECT SOCKET
  void disconnect() {
    if (!_isConnected) return;

    print("🔌 Disconnecting socket...");
    _socket?.disconnect();
    _isConnected = false;
    // onDisconnect?.call();
  }

  bool get isConnected => _isConnected;
  String? get currentRoomId => _roomId;

  void _safeAdd(SocketEvent event) {
    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }
}
