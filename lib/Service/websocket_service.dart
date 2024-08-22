import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel channel;
  void connect(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void incommingData(Map<String, dynamic> data) {
    print("Recieved Data: $data");
  }

  void sendMessage(Map<String, dynamic> message) {
    final jsonString = jsonEncode(message);
    channel.sink.add(jsonString);
  }

  void disconnect() {
    channel.sink.close();
  }
}
