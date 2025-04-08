import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/post.dart';
import '../../pages/chat/chat_screen.dart';
import '../../providers/profile_provider.dart';

class ItemDetails extends StatefulWidget {
  final int itemId, postOwnerId;
  final Post post;
  const ItemDetails({
    super.key,
    required this.itemId,
    required this.postOwnerId,
    required this.post,
  });

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

    ChatDetails chatDetails = ChatDetails(
        senderId: currUserId,
        recieverId: widget.postOwnerId,
        recieverName: 'Vinay Chavan', // Placeholder for the receiver's name
        itemId: widget.itemId,
        chatRoomId: chatId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(chatDetails: chatDetails),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Item details',
          style: TextStyle(color: Colors.blue, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full-width image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(0), // No border radius for full-width
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'assets/images/items.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.post.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    widget.post.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  // Date, Time, and Location in a row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('d MMM').format(widget.post.regDate),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('h:mm a').format(widget.post.regDate),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_pin,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.address2,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  // Action buttons (Report, Chat)
                  if (widget.post.closedById == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.post.title} reported!',
                                  style: TextStyle(
                                      color: Colors.white), // Text color
                                ),
                                backgroundColor:
                                    Colors.blue, // Custom background color
                                duration:
                                    Duration(seconds: 3), // Display duration
                              ),
                            );
                          },
                          icon: const Icon(Icons.report, color: Colors.white),
                          label: const Text('Report'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Blue background
                            foregroundColor: Colors.white, // White text
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _addChat,
                          icon: const Icon(Icons.chat, color: Colors.white),
                          label: const Text('Chat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Blue background
                            foregroundColor: Colors.white, // White text
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const Divider(),
                  // User profile and Chat button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Vinay Chavan', // Kept your user data
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14, // Consistent font size
                                ),
                              ),
                              const Text(
                                'B.tech 2nd Year', // Kept your user data
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _addChat,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Chat'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
