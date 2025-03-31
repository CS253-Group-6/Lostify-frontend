import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/chat_model.dart';
import '../../pages/chat/chat_screen.dart';

class ChatListItem extends StatefulWidget {
  // firebase data snapshot
  final QueryDocumentSnapshot chat;

  const ChatListItem({super.key, required this.chat});

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem>
    with WidgetsBindingObserver {
  void setStatus(String status) {
    // set status to be online
    FirebaseFirestore.instance.collection("chats").doc(widget.chat.id).update({
      'status': status,
    });
  }

  @override
  void initState() {
    super.initState();
    // add a widget binder observer to listen to app life cycle
    WidgetsBinding.instance.addObserver(this);
    // set status to be online
    setStatus('Online');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // check if life cycle state of app is resumed(Online)
    if (state == AppLifecycleState.resumed) {
      // update user status to online
      setStatus("Online");
    } else {
      // update user status to offline
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              'https://media.istockphoto.com/id/2151669184/vector/vector-flat-illustration-in-grayscale-avatar-user-profile-person-icon-gender-neutral.jpg?s=612x612&w=0&k=20&c=UEa7oHoOL30ynvmJzSCIPrwwopJdfqzBs0q69ezQoM8='),
        ),
        title: Text("${widget.chat['users'][0]}"),
        subtitle: Text(widget.chat['lastMessage']),
        trailing: Column(
          children: [
            Text(widget.chat['status']),
            Text(
              widget.chat['lastMessageTime'] is Timestamp
                  ? DateFormat('hh:mm').format(
                      (widget.chat['lastMessageTime'] as Timestamp).toDate(),
                    )
                  : widget.chat['lastMessageTime'] as String,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                    chatDetails: ChatDetails(
                        senderId: widget.chat['users'][0],
                        recieverId: widget.chat['users'][1],
                        itemId: widget.chat['itemId'],
                        chatRoomId: widget.chat.id))),
          );
        });
  }
}
