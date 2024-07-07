import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketScreen extends StatefulWidget {
  const WebSocketScreen({super.key});

  @override
  State<WebSocketScreen> createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {

  
  @override
  void initState() {
    connectWS();
    super.initState();
  }

  Future<void> connectWS() async {
    final wsUrl = Uri.parse('wss://demo.piesocket.com/v3/channel_123?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self');
    final channel = WebSocketChannel.connect(wsUrl);
    await channel.ready;

    channel.stream.listen((message) {
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap:(){
              connectWS();
            },
            splashColor: Colors.blue,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical:  10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1, color: Colors.black),
              ),
              width: size.width,
              height: 40,
              child: const Text(
                'Connect websocket',
              ),
            ),
          ),
        ],
      ),
    );
  }
}