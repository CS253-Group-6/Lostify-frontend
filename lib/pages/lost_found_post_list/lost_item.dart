import 'dart:ui';
import 'package:flutter/material.dart';
import '/components/lost_items/lost_item_box.dart';
import '/models/post.dart';

class LostItem extends StatefulWidget {
  const LostItem({Key? key}) : super(key: key);

  @override
  State<LostItem> createState() => _LostItemState();
}

class _LostItemState extends State<LostItem> {
  final List<Post> posts = [
    Post(
      postType: PostType.lost,
      id: 1,
      title: 'Wallet',
      status: 'Missing',
      regDate: DateTime.parse('2025-01-18'),
      closedDate: null,
      imageUrl: 'assets/wallet.png',
    ),
    Post(
      postType: PostType.lost,
      id: 2,
      title: 'Phone',
      status: 'Found',
      regDate: DateTime.parse('2025-01-02'),
      closedDate: DateTime.parse('2025-01-06'),
      imageUrl: 'assets/phone.png',
    ),
    Post(
      postType: PostType.lost,
      id: 3,
      title: 'Keys',
      status: 'Missing',
      regDate: DateTime.parse('2025-03-11'),
      closedDate: null,
      imageUrl: 'assets/keys.png',
    ),
    Post(
      postType: PostType.lost,
      id: 4,
      title: 'Bottle',
      status: 'Found',
      regDate: DateTime.parse('2025-01-02'),
      closedDate: DateTime.parse('2025-01-06'),
      imageUrl: '',
    ),
    Post(
      postType: PostType.lost,
      id: 5,
      title: 'Cycle',
      status: 'Found',
      regDate: DateTime.parse('2025-01-02'),
      closedDate: DateTime.parse('2025-01-06'),
      imageUrl: '',
    ),
  ];

  bool _chatOpen = false;
  Post? _selectedPost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Lost Items', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: ItemBox(
                      post: posts[index],
                      onOpenChat: () {
                        setState(() {
                          _chatOpen = true;
                          _selectedPost = posts[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          if (_chatOpen)
            ...[
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.black12),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
                left: 16,
                right: 16,
                bottom: 16,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildChatContent(),
                  ),
                ),
              ),
            ],
        ],
      ),
    );
  }

  Widget _buildChatContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _selectedPost != null ? 'Chat for: ${_selectedPost!.title}' : 'Chat',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Expanded(
          child: Center(
            child: Text(
              "Chat messages appear here...\n(Integrate with backend)",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _chatOpen = false;
              _selectedPost = null;
            });
          },
          child: const Text('Close Chat'),
        ),
      ],
    );
  }
}
