import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final Function(String, String) onMessageSent; 

  const ChatPage({super.key, required this.name, required this.onMessageSent});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedChats = prefs.getString('chat_${widget.name}');

  if (savedChats != null) {
    List decoded = jsonDecode(savedChats);

    setState(() {
      messages = decoded
          .map((item) => {
                'text': item['text'].toString(),
                'time': item['time'].toString(),
              })
          .toList();
    });
  }
}


  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_${widget.name}', jsonEncode(messages));
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    String message = _controller.text.trim();
    String time = TimeOfDay.now().format(context);

    setState(() {
      messages.add({'text': message, 'time': time});
    });

    widget.onMessageSent(widget.name, message); 
    _saveMessages(); 

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF075E54), size: 18),
            ),
            const SizedBox(width: 9),
            Text(widget.name, style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(messages[index]['text']!, style: const TextStyle(fontSize: 16)),
                        Text(messages[index]['time']!,
                            style: const TextStyle(fontSize: 10, color: Colors.black54)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 8,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF075E54)),
                onPressed: _sendMessage,
              ),
            ],
          )
        ],
      ),
    );
  }
}
