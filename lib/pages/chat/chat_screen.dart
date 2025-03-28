import 'dart:async';
import 'package:final_project/models/chat_model.dart';
import 'package:final_project/providers/profile_provider.dart';
import 'package:final_project/services/chat_api.dart';
import 'package:final_project/utils/upload_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final ChatDetails chatDetails;
  ChatScreen({super.key, required this.chatDetails});

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
        'senderId': widget.chatDetails.senderId,
        'text': imageURL,
        'type': 'image',
        'time': DateFormat('HH:mm').format(DateTime.now()),
      };
      print(imageMessage);
      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatDetails.chatRoomId)
          .collection("chats")
          .add(imageMessage);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error sending image: $e")));
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

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://media.istockphoto.com/id/2151669184/vector/vector-flat-illustration-in-grayscale-avatar-user-profile-person-icon-gender-neutral.jpg?s=612x612&w=0&k=20&c=UEa7oHoOL30ynvmJzSCIPrwwopJdfqzBs0q69ezQoM8='),
            ),
            SizedBox(width: 10),
            Text("${context.watch<ProfileProvider>().name}"),
            Spacer(),
            ElevatedButton(
              onPressed: () async =>
                  await ChatServices.deleteChat(context, widget.chatDetails),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text("Close"),
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
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("No messages yet."));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data!.docs[index];
                    final isMe = message['senderId'] ==
                        context.watch<ProfileProvider>().id;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
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
                              Text(message['text']!,
                                  style: TextStyle(fontSize: 16))
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
                                    return CircularProgressIndicator();
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text('Error loading image');
                                  },
                                ),
                              ),
                            SizedBox(height: 5),
                            Text(message['time']!,
                                style: TextStyle(
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
                  icon: Icon(Icons.image),
                  onPressed: () => _uploadImage("gallery"),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      hintText: 'Write a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isUploading
                      ? null
                      : () => {
                        ChatServices.sendMessage(
                          context, _messageController, widget.chatDetails),
                          _scrollToBottom()
                          },
                  icon: Icon(Icons.send),
                ),
                IconButton(
                  icon: _isUploading
                      ? CircularProgressIndicator()
                      : Icon(Icons.camera_alt),
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
  Future<void> _showSentImagePreview(String imageFile) async {
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