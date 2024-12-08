import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_conference_app/model/user.dart';
//import 'package:my_conference_app/providers/user_provider.dart';
import 'package:my_conference_app/utils/constants.dart';
//import 'package:provider/provider.dart';

class GroupChatScreen extends StatefulWidget {
  final String classid;
  final User user;

   GroupChatScreen({
    required this.classid,
    required this.user,
  });
  
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  
  final TextEditingController _controller = TextEditingController();

 

  Future<List<Map<String, dynamic>>> fetchMessages(String room) async {
  final url = Uri.parse('${Constants.uri}/chat/$room');

  try {
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      print("Error: ${response.body}");
      return [];
    }
  } catch (e) {
    print("Exception: $e");
    return [];
  }
}

Future<void> addChatMessage(String room, String name, String message, String id) async {
  final url = Uri.parse('${Constants.uri}/chat/$room');
  
  
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'room': room,
        'name': name,
        'message': message,
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Message added: $data");
    } else {
      print("Error: ${response.body}");
    }
  } catch (e) {
    print("Exception: $e");
  }
}

  void _sendMessage(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      
      setState(() {
        addChatMessage(widget.classid, widget.user.name, _controller.text, widget.user.id);
       // _messages.add({"text": _controller.text, "sender": "You", "isMe": true});
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> _messages = fetchMessages(widget.classid);

    return Scaffold(
      appBar: AppBar(
        title: Text("Group Chat"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _messages, // Your async fetch function
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true, // Latest message at the bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - index - 1];
                      return MessageBubble(
                        text: message["message"] ?? "",
                        sender: message["name"] ?? "",
                        isMe: message["id"] == widget.user.id?true:false,
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No messages found."));
                }
              },
            ),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                        _sendMessage(context);
                      },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  const MessageBubble({
    required this.text,
    required this.sender,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                sender,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.blueAccent : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
