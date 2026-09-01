import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:whatsapp/LoginScreen.dart';
import 'package:whatsapp/SettingsPage.dart';
import 'ChatPage.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<Map<String, String>> chats = [
    {'name': 'pratyaksh', 'message': 'hello'},
    {'name': 'Verma jagrati', 'message': 'hey'},
    {'name': 'Radha', 'message': 'hello guys'},
  ];

  final List<File> _myStatuses = [];
  final ImagePicker _picker = ImagePicker();

  void _updateChat(String name, String lastMessage) {
    setState(() {
      chats.removeWhere((chat) => chat['name'] == name);
      chats.insert(0, {'name': name, 'message': lastMessage});
    });
  }


  Future<void> _addStatus() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _myStatuses.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          title: Text(
            "WhatsApp Clone",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) async {
                if (value == 'Settings') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                } else if (value == 'Logout') {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                }
              },
              itemBuilder: (context) {
                return ['Settings', 'Logout'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // CHATS Tab
            ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade200,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    chats[index]['name']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chats[index]['message']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          name: chats[index]['name']!,
                          onMessageSent: _updateChat,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            Scaffold(
              body: _myStatuses.isEmpty
                  ? Center(child: Text("No Status Updates"))
                  : ListTile(
                      leading: CircleAvatar(
                        backgroundImage: FileImage(_myStatuses.last),
                      ),
                      title: Text("My Status"),
                      subtitle: Text("Tap to view all"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MyStatusViewer(files: _myStatuses),
                          ),
                        );
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFF075E54),
                onPressed: _addStatus,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),

            
            Center(child: Text("No Calls")),
          ],
        ),
      ),
    );
  }
}


class MyStatusViewer extends StatefulWidget {
  final List<File> files;
  const MyStatusViewer({super.key, required this.files});

  @override
  _MyStatusViewerState createState() => _MyStatusViewerState();
}

class _MyStatusViewerState extends State<MyStatusViewer> {
  int _currentIndex = 0;

  void _nextStatus() {
    if (_currentIndex < widget.files.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _nextStatus, 
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.file(widget.files[_currentIndex]),
        ),
      ),
    );
  }
}
