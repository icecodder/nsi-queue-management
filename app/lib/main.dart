import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queue_management_app/screens/home.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const QueueManagementApp());
}

class QueueManagementApp extends StatefulWidget {
  const QueueManagementApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QueueManagementAppState();
}

class _QueueManagementAppState extends State<QueueManagementApp> {
  WebSocketChannel channel =
      IOWebSocketChannel.connect('wss://nsi-max.developershouse.xyz');

  @override
  Widget build(BuildContext context) {
    const title = 'Queue Management App';

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(title: title, channel: channel),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
