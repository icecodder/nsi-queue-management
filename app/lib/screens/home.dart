import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title, required this.channel})
      : super(key: key);

  final String title;
  final WebSocketChannel channel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StatusTicket? ticket;

  bool clicked = false;

  @override
  void initState() {
    widget.channel.stream.listen((event) {
      Map<String, dynamic> data = jsonDecode(event);

      if (data["event_name"] == "ticket_update") {
        setState(() {
          ticket = StatusTicket(
              data["payload"]["ticket_number"], data["payload"]["counter"]);
        });
      }
    });

    super.initState();
  }

  void _getTicket() async {
    var req = jsonEncode({"event_name": "request_ticket"});

    widget.channel.sink.add(req);

    setState(() {
      clicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(color: Colors.black, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ticket == null
            ? const Text('Il ne semble rien avoir par ici :(')
            : Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Numero de ticket : ${ticket?.number}'),
                  ticket?.counter == null
                      ? const Text('En attente d\'un guichet disponible...')
                      : Text('Guichet n°${ticket?.counter?.split("_")[1]}')
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: clicked ? Colors.grey : Theme.of(context).primaryColor,
        onPressed: clicked ? null : _getTicket,
        label: const Text('OBTENIR UN TICKET'),
        icon: const Icon(Icons.confirmation_num),
      ),
    );
  }
}

class StatusTicket {
  final int number;
  final String? counter;

  StatusTicket(this.number, this.counter);
}
