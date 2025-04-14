import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/providers/profile_provider.dart';
import 'package:final_project/providers/user_provider.dart';
import 'package:final_project/services/items_api.dart';
import 'package:final_project/services/profile_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../pages/chat/chat_screen.dart';

class ChatListItem extends StatefulWidget {
  // firebase data snapshot
  final QueryDocumentSnapshot chat;
  // final Function(bool) setLoadingChats;

  const ChatListItem(
      {super.key, required this.chat});

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

  String? name;
  int recieverUserId = 0;
  String? postTitle;

  // loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // add a widget binder observer to listen to app life cycle
    WidgetsBinding.instance.addObserver(this);
    // set status to be online
    setStatus('Online');
    // load data
    _loadData();
  }

  Future<void> _loadData() async {
    if(mounted){
      setState(() {
        _isLoading = true;
      });
    }
    try {
      // Simulate async data loading
      // set the name of the user
      await getUserName();
      // set the post title
      await getPostTitle();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // widget.setLoadingChats(
        //     false); // Notify parent that this item is done loading
      }
    }
  }

  Future<void> getUserName() async {
    // get profile details of user by id
    recieverUserId = widget.chat['users'][0] ==
            Provider.of<UserProvider>(context, listen: false).id
        ? widget.chat['users'][1]
        : widget.chat['users'][0];
    // get the name of user
    final profileResponse = await ProfileApi.getProfileById(recieverUserId);
    final profileDetails = await jsonDecode(profileResponse.body);
    print(profileDetails['name']);
    if (mounted) {
      // check if the widget is still mounted before calling setState
      setState(() {
        name = profileDetails['name'] ?? '0';
        recieverUserId = profileDetails['id'] ?? 0;
      });
    }
  }

  Future<void> getPostTitle() async {
    // get the post title
    final resp = await ItemsApi.getItemById(widget.chat['itemId']);
    final postDetails = await jsonDecode(resp.body);
    if (mounted) {
      setState(() {
        postTitle = postDetails['title'] ?? 'title';
      });
    }
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
    return _isLoading
        ? Column(
            children: [
              SizedBox(
                width: 24, // Small width for the loader
                height: 24, // Small height for the loader
                child: CircularProgressIndicator(
                  strokeWidth: 2, // Thin stroke for a compact look
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              SizedBox(
                height: 14,
              )
            ],
          )
        : ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://media.istockphoto.com/id/2151669184/vector/vector-flat-illustration-in-grayscale-avatar-user-profile-person-icon-gender-neutral.jpg?s=612x612&w=0&k=20&c=UEa7oHoOL30ynvmJzSCIPrwwopJdfqzBs0q69ezQoM8='),
            ),
            title: Text("${name}($postTitle)"),
            subtitle: Text(widget.chat['lastMessage']),
            trailing: Column(
              children: [
                // Text(widget.chat['status']),
                Text(
                  widget.chat['lastMessageTime'] != null
                      ? (widget.chat['lastMessageTime'] is Timestamp
                          ? DateFormat('hh:mm').format(
                              (widget.chat['lastMessageTime'] as Timestamp)
                                  .toDate(),
                            )
                          : widget.chat['lastMessageTime'] as String)
                      : '...', // Fallback for null values
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        chatDetails: ChatDetails(
                            senderId: widget.chat['users'][0] == recieverUserId
                                ? widget.chat['users'][1]
                                : widget.chat['users'][0],
                            recieverId: recieverUserId,
                            recieverName: name ?? '0',
                            itemId: widget.chat['itemId'],
                            chatRoomId: widget.chat.id))),
              );
            });
  }
}
