class ChatDetails {
  String chatRoomId, recieverName;
  int senderId, recieverId, itemId;

  ChatDetails({
    required this.senderId,
    required this.recieverId,
    required this.itemId,
    required this.chatRoomId,
    required this.recieverName,
  });
}
