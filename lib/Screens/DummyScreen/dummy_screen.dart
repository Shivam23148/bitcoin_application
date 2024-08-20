import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  String uri = 'ws://prereg.ex.api.ampiy.com/prices';
  dynamic printedData = '';
  late WebSocketChannel webSocketChannel;
  void connectWebSocket() {
    webSocketChannel = WebSocketChannel.connect(Uri.parse(uri));
    webSocketChannel.stream.listen((data) {
      setState(() {
        printedData = data;
      });
      print("Data is ${data}");
    }, onError: (e) {
      print("Error is ${e}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dummy Screen"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("Send"),
            onPressed: () {
              final jsonString = jsonEncode({
                "method": "SUBSCRIBE",
                "params": ["all@ticker"],
                "cid": 1
              });
              webSocketChannel.sink.add(jsonString);
            },
          ),
          ElevatedButton(
              onPressed: () {
                webSocketChannel.sink.close();
              },
              child: Text("Close Connection ")),
          Expanded(child: Text(printedData))
        ],
      ),
    );
  }
}
