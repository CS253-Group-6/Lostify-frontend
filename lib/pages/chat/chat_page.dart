import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Default messages with a default receiver message "Hello Aayush"
  final List<Map<String, dynamic>> _messages = [
    {
      'text': "Hello Aayush",
      'isUser': false,
      'time': "16:00",
    },
    {
      'text': "I have lost my bottle somewhere in lecture Hall complex",
      'isUser': false,
      'time': "16:04",
    },
    {
      'text': "Ohkay, I have got one at the same place",
      'isUser': true,
      'time': "14:52",
    },
    {
      'text': "let me send you a photo of that",
      'isUser': true,
      'time': "14:52",
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen to text changes to update UI (e.g., toggle icons).
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Clears the chat messages and closes this page.
  void _closeChat() {
    setState(() {
      _messages.clear();
    });
    Navigator.pop(context);
  }

  /// Sends a text or image message.
  void _sendMessage({String? text, File? image}) {
    if ((text != null && text.trim().isNotEmpty) || image != null) {
      setState(() {
        _messages.add({
          'text': text,
          'image': image,
          'isUser': true,
          'time': _getCurrentTime(),
        });
      });
      _controller.clear();
      _scrollToBottom();
    }
  }

  /// Uses image_picker to select an image from the gallery and shows confirmation dialog.
  Future<void> _insertMedia() async {
    try {
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        await _showImageConfirmation(File(pickedFile.path));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting image: $e")),
      );
    }
  }

  /// Uses image_picker to capture an image from the camera and shows confirmation dialog.
  Future<void> _openCamera() async {
    try {
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        await _showImageConfirmation(File(pickedFile.path));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image captured.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error capturing image: $e")),
      );
    }
  }

  /// Shows a dialog (white background) to confirm or discard sending the image.
  Future<void> _showImageConfirmation(File file) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(file, fit: BoxFit.cover),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 30),
              onPressed: () => Navigator.pop(ctx, false),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green, size: 30),
              onPressed: () => Navigator.pop(ctx, true),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      _sendMessage(image: file);
    }
  }

  /// Returns the current time in HH:mm format.
  String _getCurrentTime() {
    final now = DateTime.now();
    final hours = now.hour.toString().padLeft(2, '0');
    final minutes = now.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for the chat page
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _closeChat,
        ),
        title: const Text("Chat", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          // A small red "Close" button on the right
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: _closeChat,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: const Text("Close", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(
                  text: msg['text'] as String?,
                  image: msg['image'] as File?,
                  isUser: msg['isUser'] as bool,
                  time: msg['time'] as String,
                );
              },
            ),
          ),
          // Bottom input row
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// Builds the bottom input row: media icon, text field, send, and camera.
  Widget _buildMessageInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Media insertion icon
          IconButton(
            icon: const Icon(Icons.insert_photo, color: Colors.blue),
            onPressed: _insertMedia,
          ),
          // Expanded text field
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Write a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
          // Send icon button
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () => _sendMessage(text: _controller.text),
          ),
          // Camera icon
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.blue),
            onPressed: _openCamera,
          ),
        ],
      ),
    );
  }

  /// Builds a chat message bubble with an optional image and text,
  /// displaying the timestamp on the left for sender messages and on the right for receiver messages.
  Widget _buildMessageBubble({
    String? text,
    File? image,
    required bool isUser,
    required String time,
  }) {
    // Only add a long-press context menu if there's text
    final bubbleGestureDetector = (text != null && text.trim().isNotEmpty)
        ? GestureDetector(
      onLongPress: () => _showTextCopyMenu(text),
      child: _buildBubbleLayout(isUser: isUser, time: time, text: text, image: image),
    )
        : _buildBubbleLayout(isUser: isUser, time: time, text: text, image: image);

    return bubbleGestureDetector;
  }

  /// The bubble layout is extracted so we can wrap it in a (conditional) GestureDetector above.
  Widget _buildBubbleLayout({
    required bool isUser,
    required String time,
    String? text,
    File? image,
  }) {
    final bubble = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              GestureDetector(
                onTap: () => _showSentImagePreview(image),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    image,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (text != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  text,
                  softWrap: true,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );

    // For sender messages, time on left; for receiver messages, time on right.
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: isUser
            ? [
          Text(time, style: _timeStyle()),
          const SizedBox(width: 6),
          bubble,
        ]
            : [
          bubble,
          const SizedBox(width: 6),
          Text(time, style: _timeStyle()),
        ],
      ),
    );
  }

  /// Shows a preview dialog for a sent image.
  Future<void> _showSentImagePreview(File imageFile) async {
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
            child: Image.file(imageFile, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  /// Shows a bottom sheet with "Copy text" for text messages only.
  void _showTextCopyMenu(String text) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("Copy text"),
                onTap: () {
                  Navigator.pop(ctx); // close bottom sheet
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Text copied to clipboard")),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Timestamp style.
  TextStyle _timeStyle() {
    return const TextStyle(fontSize: 12, color: Colors.grey);
  }
}