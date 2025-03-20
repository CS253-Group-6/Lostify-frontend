// Model for Conversation
class Conversation {
  final String name;
  final String lastMessage;
  final String time;
  final String profileImageUrl;

  Conversation({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.profileImageUrl,
  });
}