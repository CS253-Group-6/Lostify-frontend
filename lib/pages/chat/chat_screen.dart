import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../providers/profile_provider.dart';
import '../../services/chat_api.dart';
import '../../utils/upload_handler.dart';

class ChatScreen extends StatefulWidget {
  final ChatDetails chatDetails;
  const ChatScreen({super.key, required this.chatDetails});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // for sending images in chat
  final ImagePicker _picker = ImagePicker(); // pick an image
  bool _isUploading = false; // check if image is in uploading.. state

  Future<void> _uploadImage(String type) async {
    try {
      // set state to uploading image
      setState(() {
        _isUploading = true;
      });
      String imageURL = await UploadHandler.handleUpload(_picker, type);

      final imageMessage = {
        'senderId': Provider.of<ProfileProvider>(context, listen: false).id,
        'text': imageURL,
        'type': 'image',
        'time': FieldValue.serverTimestamp(),
      };
      print(imageMessage);
      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatDetails.chatRoomId)
          .collection("chats")
          .add(imageMessage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error sending image : $e',
            style: TextStyle(color: Colors.white), // Text color
          ),
          backgroundColor: Colors.red, // Custom background color
          duration: Duration(seconds: 3), // Display duration
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  /// Scrolls the ListView to the bottom.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _closeChat() async {
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Close Chat"),
          content: Text("Do you want to close the chat permanently?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
            ),
          ],
        );
      },
    );

    if (shouldClose == true) {
      await ChatServices.deleteChat(context, widget.chatDetails);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.chatDetails);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://media.istockphoto.com/id/2151669184/vector/vector-flat-illustration-in-grayscale-avatar-user-profile-person-icon-gender-neutral.jpg?s=612x612&w=0&k=20&c=UEa7oHoOL30ynvmJzSCIPrwwopJdfqzBs0q69ezQoM8='),
            ),
            const SizedBox(width: 10),
            Text(widget.chatDetails.recieverName,
                style: TextStyle(color: Colors.white)),
            const Spacer(),
            if (widget.chatDetails.senderId ==
                Provider.of<ProfileProvider>(context, listen: false).id)
              ElevatedButton(
                onPressed: () async =>
                    await ChatServices.deleteChat(context, widget.chatDetails),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Close"),
              ),
            ElevatedButton(
              onPressed: _closeChat,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("Close"),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chatroom")
                  .doc(widget.chatDetails.chatRoomId)
                  .collection("chats")
                  .orderBy("time", descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Check for NOT_FOUND error and handle it
                  if (snapshot.error.toString().contains('NOT_FOUND')) {
                    return const Center(child: Text('Chat not found.'));
                  }
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No messages yet."));
                }
                // Auto-scroll to the bottom when new messages are received
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data!.docs[index];
                    final isMe = message['senderId'] ==
                        context.watch<ProfileProvider>().id;
                    print(
                        'iseMe: $isMe,profileId: ${context.watch<ProfileProvider>().id}, messageId: ${message['senderId']}');

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (message['type'] == 'text')
                              Text(
                                message['text']!,
                                style: const TextStyle(fontSize: 16),
                              )
                            else if (message['type'] == 'image')
                              GestureDetector(
                                onTap: () {
                                  _showSentImagePreview(message['text']);
                                },
                                child: Image.network(
                                  message['text']!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const CircularProgressIndicator();
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text('Error loading image');
                                  },
                                ),
                              ),
                            const SizedBox(height: 5),
                            Text(
                                message['time'] != null
                                    ? (message['time'] is Timestamp
                                        ? DateFormat('hh:mm').format(
                                            (message['time'] as Timestamp)
                                                .toDate(),
                                          )
                                        : message['time'] as String)
                                    : '...', // Fallback for null values
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () => _uploadImage("gallery"),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      hintText: 'Write a message...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isUploading
                      ? null
                      : () {
                          ChatServices.sendMessage(
                            context,
                            _messageController,
                            widget.chatDetails,
                          );
                          _scrollToBottom();
                        },
                  icon: const Icon(Icons.send),
                ),
                IconButton(
                  icon: _isUploading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.camera_alt),
                  onPressed: _isUploading ? null : () => _uploadImage("camera"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a preview dialog for a sent image.
  Future<void> _showSentImagePreview(final String imageFile) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageFile, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
