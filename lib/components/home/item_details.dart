import 'dart:io';

import 'package:final_project/components/home/item_box.dart';
import 'package:final_project/pages/chat/chat_list.dart';
import 'package:final_project/pages/chat/chat_screen.dart';
import 'package:final_project/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ItemDetails extends StatefulWidget {
  final int itemId, postOwnerId;
  final Post post;
  const ItemDetails(
      {super.key,
      required this.itemId,
      required this.postOwnerId,
      required this.post});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final FirebaseFirestore _chatInstance = FirebaseFirestore.instance;

  String createChatId() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    int currUserId = profileProvider.id;
    if (currUserId < widget.postOwnerId) {
      return '${currUserId}_${widget.postOwnerId}';
    } else {
      return '${widget.postOwnerId}_$currUserId';
    }
  }

  void _addChat() {
    String chatId = createChatId();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    int currUserId = profileProvider.id;
    _chatInstance.collection("chats").doc(chatId).set({
      "users": [currUserId, widget.postOwnerId],
      "lastMessage": "",
      "lastMessageTime": Timestamp.now(),
      "itemId": widget.itemId,
      "status": "Offline",
      "unreadMessagesNumber": 0,
    });

    Map<String, dynamic> chatDetails = {
      "senderId": currUserId,
      "recieverId": widget.postOwnerId,
      "itemId": widget.itemId,
      "chatRoomId": chatId,
    };
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(chatDetails: chatDetails)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Item Details",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                // decoration: BoxDecoration(
                //   color: Colors.blueAccent[100],
                // ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child:  Image.asset('assets/images/items.png'),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.post.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 32),
                        ),
                      ),
                      Text(
                        widget.post.description,
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.lightBlue.shade100,
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.date_range),
                                Text(
                                  DateFormat('MMMM d, y').format(widget.post.regDate),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.watch_later_outlined),
                                Text(
                                  DateFormat('h:mm a').format(widget.post.regDate),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on),
                                Text(
                                  widget.post.address,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: _addChat,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade200,
                                  borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 20),
                              child: Text(
                                "Chat",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.lightBlue.shade200,
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 20),
                            child: Text(
                              "Report",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("Vinay Chavan"),
                  subtitle: Text("B.tech 2nd Year"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
