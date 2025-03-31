import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../pages/chat/chat_screen.dart';
import '../../providers/profile_provider.dart';
import '../../services/notifications_api.dart';
import '../../utils/upload_handler.dart';

class ChatServices {
  // create a firebase firestore instance to save and get chats.
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseFirestore _chatInstance = FirebaseFirestore.instance;

  static void addChat(BuildContext context, int itemId, int postOwnerId) {
    String chatId = createChatId(context, postOwnerId);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    int currUserId = profileProvider.id;
    _chatInstance.collection("chats").doc(chatId).set({
      "users": [currUserId, postOwnerId],
      "lastMessage": "",
      "lastMessageTime": Timestamp.now(),
      "itemId": itemId,
      "status": "Offline",
      "unreadMessagesNumber": 0,
    });

    ChatDetails chatDetails = ChatDetails(
        senderId: currUserId,
        recieverId: postOwnerId,
        itemId: itemId,
        chatRoomId: chatId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(chatDetails: chatDetails),
      ),
    );
  }

  static createChatId(BuildContext context, int postOwnerId) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    int currUserId = profileProvider.id;
    if (currUserId < postOwnerId) {
      return '${currUserId}_$postOwnerId';
    } else {
      return '${postOwnerId}_$currUserId';
    }
  }

  static Future<void> deleteChat(
      BuildContext context, ChatDetails chatDetails) async {
    try {
      // get chatroom collection's doc ref
      final chatroomRef = FirebaseFirestore.instance
          .collection("chatroom")
          .doc(chatDetails.chatRoomId);

      // get all the messgaes to filter out images
      final messagesSnapshot = await chatroomRef.collection("chats").get();

      // for cloudinary images delete using '_deleteImageFromCloudinary'
      for (var message in messagesSnapshot.docs) {
        if (message['type'] == 'image') {
          await UploadHandler.deleteImageFromCloudinary(message['text']);
        }
      }

      // for message sanpshot's docs delete all the messages
      await Future.wait(
          messagesSnapshot.docs.map((doc) => doc.reference.delete()));

      // delete the chat from chats collection
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(chatDetails.chatRoomId)
          .delete();

      // display success messgae to frontend
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Chat deleted Successfully")));

      // pop context
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error deleting chat : $e")));
    }
  }

  static void notifyUser(BuildContext context,ChatDetails chatDetails) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (profileProvider.playerId != null) {
      await NotificationsApi.sendNotification(
        profileProvider.playerId!,
        "Lostify",
        "You have a new message in the chat from ${chatDetails.senderId}!",
      );
    }
  }

  static void sendMessage(BuildContext context,
      TextEditingController messageController, ChatDetails chatDetails) async {
    if (messageController.text.isNotEmpty) {
      final newMessage = {
        'senderId': chatDetails.senderId,
        'text': messageController.text,
        'type': 'text',
        'time': DateFormat('HH:mm').format(DateTime.now()),
      };
      // _messages.add(newMessage);
      messageController.clear();
      await _firestore
          .collection("chatroom")
          .doc(chatDetails.chatRoomId)
          .collection("chats")
          .add(newMessage);

      FirebaseFirestore.instance
          .collection("chats")
          .doc(chatDetails.chatRoomId)
          .update({
        'lastMessage': newMessage['text'],
        'lastMessageTime': newMessage['time'],
      });
      notifyUser(context, chatDetails);
    }
  }
}
