import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/components/chat/chat_list_item.dart';
import 'package:final_project/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';


// Messages Screen
class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Messages'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .where("users",
                  arrayContains: context.watch<ProfileProvider>().id)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No chats found'));
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final convo = snapshot.data!.docs[index];
                  return ChatListItem(chat: convo);
                });
          },
        ));
  }
}
