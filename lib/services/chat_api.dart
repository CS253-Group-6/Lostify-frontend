import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/providers/user_provider.dart';
import 'package:final_project/services/items_api.dart';
import 'package:final_project/services/profile_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../pages/chat/chat_screen.dart';
import '../../providers/profile_provider.dart';
import '../../services/notifications_api.dart';
import '../../utils/upload_handler.dart';

class ChatServices {
  static Map<String, dynamic> recieverDetails = {};
  // create a firebase firestore instance to save and get chats.
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseFirestore _chatInstance = FirebaseFirestore.instance;

  // get receiver details
  static Future<Map<String, dynamic>> getRecieverDetails(
      BuildContext context, int recieverId) async {
    final profileResponse = await ProfileApi.getProfileById(recieverId);
    final profileDetails = jsonDecode(profileResponse.body);
    print(profileDetails);
    return profileDetails;

    /*
    void getUserName() async {
    // get profile details of user by id

    recieverUserId = widget.chat['users'][0] ==
            Provider.of<ProfileProvider>(context, listen: false).id
        ? widget.chat['users'][1]
        : widget.chat['users'][0];
    final profileResponse = await ProfileApi.getProfileById(recieverUserId);
    final profileDetails = jsonDecode(profileResponse.body);
    print(profileDetails);
    setState(() {
      name = profileDetails['name'] ?? '0';
      recieverUserId = profileDetails['id'] ?? 0;
    });
  } */
  }

  static void addChat(BuildContext context, int itemId, int postOwnerId) async {
    String chatId = createChatId(context, itemId, postOwnerId);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    int currUserId = Provider.of<UserProvider>(context, listen: false).id;

    print(
        'currUserId: $currUserId, postOwnerId: $postOwnerId,name: ${profileProvider.name}');
    _chatInstance.collection("chats").doc(chatId).set({
      "users": [currUserId, postOwnerId],
      "lastMessage": "",
      "lastMessageTime": Timestamp.now(),
      "itemId": itemId,
      "status": "Offline",
      "unreadMessagesNumber": 0,
    });
    // get reciever details
    recieverDetails = await getRecieverDetails(context, postOwnerId);

    ChatDetails chatDetails = ChatDetails(
        senderId: currUserId,
        recieverId: postOwnerId,
        recieverName: recieverDetails['name'],
        itemId: itemId,
        chatRoomId: chatId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(chatDetails: chatDetails),
      ),
    );
  }

  static createChatId(BuildContext context, int itemId, int postOwnerId) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    int currUserId = profileProvider.id;
    print('currUserId: $currUserId, postOwnerId: $postOwnerId');
    if (currUserId < postOwnerId) {
      return '${currUserId}_${postOwnerId}_${itemId}';
    } else {
      return '${postOwnerId}_${currUserId}_${itemId}';
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

      // delete the chat from flask
      // final response =
      //     await ItemsApi.claimItem(chatDetails.itemId, chatDetails.recieverId);

      // print('response: ${response.body}');

      // if (!(response.statusCode >= 200 && response.statusCode <= 300)) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text(
      //         'Claim to the post failed',
      //         style: TextStyle(color: Colors.white), // Text color
      //       ),
      //       backgroundColor: Colors.red, // Custom background color
      //       duration: Duration(seconds: 3), // Display duration
      //     ),
      //   );
      //   return;
      // }

      // display success messgae to frontend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Chat deleted successfully!',
            style: TextStyle(color: Colors.white), // Text color
          ),
          backgroundColor: Colors.red, // Custom background color
          duration: Duration(seconds: 3), // Display duration
        ),
      );

      // pop context
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error deleting chat : $e',
            style: TextStyle(color: Colors.white), // Text color
          ),
          backgroundColor: Colors.red, // Custom background color
          duration: Duration(seconds: 3), // Display duration
        ),
      );
    }
  }

  static void notifyUser(BuildContext context, ChatDetails chatDetails) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    // print('playerId: ${profileProvider.playerId}');
    List<String> ids = (chatDetails.chatRoomId.split('_'));
    print('ids : $ids');

    try {
      // get user profile details by id
      final recieverProfileResponse = await ProfileApi.getProfileById(
          Provider.of<ProfileProvider>(context, listen: false).id ==
                  int.parse(ids[0])
              ? int.parse(ids[1])
              : int.parse(ids[0]));
      print('recieverProfile: $recieverProfileResponse');
      // get reciever playerId
      final recieverPlayerId =
          jsonDecode(recieverProfileResponse.body)['playerId'];
      print('recieverPlayerId: $recieverPlayerId');
      if (recieverPlayerId != '' || recieverPlayerId != null) {
        // send notification to reciever player
        await NotificationsApi.sendNotification(
          recieverPlayerId,
          "Lostify",
          "${Provider.of<ProfileProvider>(context, listen: false).name} just messaged you!",
        );
      }
    } catch (e) {
      print('Error getting reciever profile: $e');
    }

    // if (profileProvider.playerId != null) {
    //   await NotificationsApi.sendNotification(
    //     profileProvider.playerId!,
    //     "Lostify",
    //     "You have a new message in the chat from ${Provider.of<ProfileProvider>(context, listen: false).name}!",
    //   );
    // }
  }

  static void sendMessage(BuildContext context,
      TextEditingController messageController, ChatDetails chatDetails) async {
    if (messageController.text.trim().isNotEmpty) {
      final newMessage = {
        'senderId': Provider.of<ProfileProvider>(context, listen: false).id,
        'text': messageController.text.trim(),
        'type': 'text',
        'time': FieldValue.serverTimestamp(),
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
