import 'dart:convert';
import 'package:web_socket/web_socket.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;

  WebSocketService._internal();

  WebSocket? _socket;
  bool _isConnected = false;

  Function(dynamic message)? onMessage;
  Function()? onConnect;
  Function()? onDisconnect;
  Function(dynamic error)? onError;

  String? _roomId;

  /// CONNECT WITH DYNAMIC ROOM ID
  Future<void> connect(String roomId) async {
    _roomId = roomId;

    final wsUrl = Uri.parse("wss://yourserver.com/ws/room/$roomId");

    try {
      if (_isConnected) return;

      _socket = await WebSocket.connect(wsUrl);
      _isConnected = true;
      onConnect?.call();

      // Listen for messages
      _socket!.events.listen(
        (event) => onMessage?.call(event),
        onError: (err) {
          _isConnected = false;
          onError?.call(err);
        },
        onDone: () {
          _isConnected = false;
          onDisconnect?.call();
        },
      );
    } catch (e) {
      onError?.call(e);
    }
  }

  /// SEND TO SERVER
  void send(dynamic data) {
    if (!_isConnected || _socket == null) return;

    if (data is Map || data is List) {
      _socket!.sendText(jsonEncode(data));
    } else {
      _socket!.sendText(data.toString());
    }
  }

  /// DISCONNECT
  void disconnect() {
    if (_isConnected) {
      _socket?.close();
      _isConnected = false;
      onDisconnect?.call();
    }
  }

  bool get isConnected => _isConnected;

  String? get currentRoomId => _roomId;
}
