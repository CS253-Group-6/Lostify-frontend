import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ChatScreen extends StatefulWidget {
  final String name;

  ChatScreen({required this.name});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [
    {
      'sender': 'Aaiisha Thakur',
      'text': 'Hello guys,',
      'time': '16:04'
    },
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({
          'sender': 'You',
          'text': _controller.text,
          'time': DateFormat('HH:mm').format(DateTime.now()),
        });
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/40'),
            ),
            SizedBox(width: 10),
            Text(widget.name),
            Spacer(),
            ElevatedButton(
                onPressed: (){},
                child: Text("Close Chat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white
                ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender'] == 'You';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(message['text']!, style: TextStyle(fontSize: 16)),
                        SizedBox(height: 5),
                        Text(message['time']!, style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: (){},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: _sendMessage, icon: Icon(Icons.send)),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}