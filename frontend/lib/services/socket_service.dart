import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  Function(dynamic)? _onShelterUpdate;
  
  static final String _baseUrl = ApiConfig.baseUrl;

  void initSocket({Function(dynamic)? onShelterUpdate}) {
    _onShelterUpdate = onShelterUpdate;
    
    if (socket != null) {
      if (socket!.connected) {
        debugPrint('✅ SOCKET ALREADY CONNECTED');
      } else {
        debugPrint('⏳ SOCKET REDIALLING...');
        socket!.connect();
      }
      return;
    }

    debugPrint('🔌 CONNECTING TO SOCKET: $_baseUrl');
    socket = IO.io(_baseUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      .enableAutoConnect()
      .build());

    socket!.onConnect((_) {
      debugPrint('✅ SOCKET.IO CONNECTED SUCCESS');
    });

    socket!.onDisconnect((_) {
      debugPrint('❌ SOCKET.IO DISCONNECTED');
    });

    socket!.on('shelter_updated', (data) {
      debugPrint('🔔 RECEIVED REAL-TIME SHELTER UPDATE: $data');
      if (_onShelterUpdate != null) {
        _onShelterUpdate!(data);
      }
    });

    socket!.onConnectError((err) => debugPrint('⚠️ SOCKET.IO CONNECT ERROR: $err'));
    socket!.onError((err) => debugPrint('🆘 SOCKET.IO ERROR: $err'));
  }

  void disconnect() {
    socket?.off('shelter_updated');
    socket?.disconnect();
    socket = null;
    _onShelterUpdate = null;
  }
}
