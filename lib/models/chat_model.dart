import 'dart:io';

class ChatDetails {
  String chatRoomId, recieverName;
  int senderId, recieverId, itemId;
  File? imageFile;

  ChatDetails({
    required this.senderId,
    required this.recieverId,
    required this.itemId,
    required this.chatRoomId,
    required this.recieverName,
    this.imageFile,
  });
}
