import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:final_project/providers/profile_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../services/notifications_api.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class ChatScreen extends StatefulWidget {
  final dynamic chatDetails;
  ChatScreen({super.key, required this.chatDetails});

  // create a firebase firestore instance to save and get chats.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  // for sending images in chat
  final ImagePicker _picker = ImagePicker(); // pick an image
  bool _isUploading = false; // check if image is in uploading.. state

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final newMessage = {
        'senderId': widget.chatDetails['senderId'],
        'text': _messageController.text,
        'type': 'text',
        'time': DateFormat('HH:mm').format(DateTime.now()),
      };
      // _messages.add(newMessage);
      _messageController.clear();
      await widget._firestore
          .collection("chatroom")
          .doc(widget.chatDetails['chatRoomId'])
          .collection("chats")
          .add(newMessage);
      
      FirebaseFirestore.instance.collection("chats").doc(widget.chatDetails['chatRoomId']).update(
        {
          'lastMessage': newMessage['text'],
          'lastMessageTime': newMessage['time'],
        }
      );
    }
  }

  Future<void> _uploadImage(String type) async {
    try {
      // set state to uploading image
      setState(() {
        _isUploading = true;
      });

      // get the image in XFile format
      XFile? image;
      if(type == "gallery"){
        image = await _picker.pickImage(source: ImageSource.gallery);
      }else{
        image = await _picker.pickImage(source: ImageSource.camera);
      }

      if (image != null) {
        // generate unique id for each image of some random string
        String fileName = Uuid().v1();

        // get the image file
        final File file = File(image.path);

        String imageURL = await _uploadImageToCloudinary(file.path);
        print(imageURL);

        final imageMessage = {
          'senderId': widget.chatDetails['senderId'],
          'text': imageURL,
          'type': 'image',
          'time': DateFormat('HH:mm').format(DateTime.now()),
        };
        print(imageMessage);
        await widget._firestore
            .collection("chatroom")
            .doc(widget.chatDetails['chatRoomId'])
            .collection("chats")
            .add(imageMessage);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error sending image: $e")));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<String> _uploadImageToCloudinary(String path) async{
    final url = Uri.parse("https://api.cloudinary.com/v1_1/drd9vsdwo/upload");
    final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = 'lostify' 
    ..files.add(await http.MultipartFile.fromPath('file',path));
    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = utf8.decode(responseData);
    final jsonMap = jsonDecode(responseString);
    return jsonMap['url'];

  }

  Future<void> _deleteImageFromCloudinary(String imageUrl) async{
    try{
      final publicId = imageUrl.split('/').last.split('.').first;
      final url = Uri.parse("https://api.cloudinary.com/v1_1/drd9vsdwo/image/destroy");
      const apiKey = '118881179379793';
      const apiSecret = 'U15kELYkke0rZp0pug5nxOGrF30';
      // Generate timestamp
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    // Generate signature
    // Signature is SHA-1 hash of public_id + timestamp + api_secret
    final signatureString = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
    final signature = sha1.convert(utf8.encode(signatureString)).toString();

      final request = http.MultipartRequest('POST', url)
      ..fields['public_id'] = publicId
      ..fields['api_key'] = apiKey 
      ..fields['api_secret'] = apiSecret
      ..fields['signature'] = signature
      ..fields['timestamp'] = timestamp;

      final response = await request.send();
        if (response.statusCode != 200) {
          final responseData = await response.stream.toBytes();
          final responseString = utf8.decode(responseData);
          print('Failed to delete image from Cloudinary: $responseString');
        }
    }catch(e){
      print("Error deleting image from cloudinary : $e");
    }
  }

  Future<void> _deleteChat() async{
    try{
      // get chatroom collection's doc ref
      final chatroomRef = widget._firestore.collection("chatroom").doc(widget.chatDetails['chatRoomId']);

      // get all the messgaes to filter out images
      final messagesSnapshot = await chatroomRef.collection("chats").get();

      // for cloudinary images delete using '_deleteImageFromCloudinary'
      for(var message in messagesSnapshot.docs){
        if(message['type'] == 'image'){
          await _deleteImageFromCloudinary(message['text']);
        }
      }

      // for message sanpshot's docs delete all the messages
      await Future.wait(messagesSnapshot.docs.map((doc)=>doc.reference.delete()));

      // delete the chat from chats collection
      await widget._firestore.collection("chats").doc(widget.chatDetails['chatRoomId']).delete();

      // display success messgae to frontend
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Chat deleted Successfully")));

      // pop context
      Navigator.pop(context);


    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting chat : $e")));
    }
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
              onPressed: _deleteChat,
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
              stream: widget._firestore
                  .collection("chatroom")
                  .doc(widget.chatDetails['chatRoomId'])
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
                              Image.network(
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      hintText: 'Write a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isUploading ? null : _sendMessage,
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
}
