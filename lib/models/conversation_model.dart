// Model for Conversation
class Conversation {
  final String senderName;
  final String lastMessage;
  final String time;
  final String recieverId;
  final String profileImageUrl;

  const Conversation({
    required this.senderName,
    required this.lastMessage,
    required this.time,
    required this.profileImageUrl,
    required this.recieverId,
  });
}