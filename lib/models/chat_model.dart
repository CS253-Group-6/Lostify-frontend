class ChatDetails {
  String chatRoomId;
  int senderId, recieverId, itemId;

  ChatDetails(
      {required this.senderId,
      required this.recieverId,
      required this.itemId,
      required this.chatRoomId});
}
