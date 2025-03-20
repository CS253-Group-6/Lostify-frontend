import '/pages/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/coversation_model.dart';


// Messages Screen
class MessagesScreen extends StatelessWidget {
  final List<Conversation> conversations = [
    Conversation(
      name: 'Aaiisha Thakur',
      lastMessage: 'So Aditya, can we meet today!',
      time: '18:31',
      profileImageUrl: 'https://via.placeholder.com/40', // Replace with actual URL
    ),
    Conversation(
      name: 'Riya Singh',
      lastMessage: 'Sure.',
      time: '06:12',
      profileImageUrl: 'https://via.placeholder.com/40',
    ),
    Conversation(
      name: 'Abel Joseph',
      lastMessage: '~~ Thanks dude 😊',
      time: 'Yesterday',
      profileImageUrl: 'https://via.placeholder.com/40',
    ),
    Conversation(
      name: 'Vineet Kumar',
      lastMessage: 'I\'m happy that you got bag',
      time: 'Yesterday',
      profileImageUrl: 'https://via.placeholder.com/40',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Messages'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(convo.profileImageUrl),
            ),
            title: Text(convo.name),
            subtitle: Text(convo.lastMessage),
            trailing: Text(convo.time),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(name: convo.name),
                ),
              );
            },
          );
        },
      ),
      
    );
  }
}