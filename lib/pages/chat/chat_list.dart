import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/components/utils/loader.dart';
import 'package:final_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/chat/chat_list_item.dart';

// Messages Screen
class ChatList extends StatefulWidget {
  
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with WidgetsBindingObserver {
  bool isLoadingChats = false;
  void setLoadingChats(bool isLoading){
    setState(() {
      isLoadingChats = isLoading;
    });
  }
  @override
  Widget build(BuildContext context) {
    print(context.watch<UserProvider>().id);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Messages', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .where("users", arrayContains: context.watch<UserProvider>().id)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Check for NOT_FOUND error and handle it
              if (snapshot.error.toString().contains('NOT_FOUND')) {
                return const Center(child: Text('No chats available.'));
              }
              return Center(child: Text('Error ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No chats found'));
            }
            return isLoadingChats? Loader() : ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final convo = snapshot.data!.docs[index];
                print(convo);
                return ChatListItem(chat: convo);
              },
            );
          },
        ));
  }
}
