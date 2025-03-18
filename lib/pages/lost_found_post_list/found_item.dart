import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:final_project/components/lost_items/lost_item_box.dart';
import 'package:final_project/models/post.dart';

class FoundItem extends StatefulWidget {
  const FoundItem({Key? key}) : super(key: key);

  @override
  State<FoundItem> createState() => _FoundItemState();
}

class _FoundItemState extends State<FoundItem> {
  final List<Post> posts = [
    Post(
      postType: PostType.found,
      id: 1,
      title: 'Phone',
      status: 'Returned',
      regDate: DateTime.parse('2025-01-02'),
      closedDate: DateTime.parse('2025-01-06'),
      imageUrl: 'assets/phone.png',
    ),
    Post(
      postType: PostType.found,
      id: 2,
      title: 'Mouse',
      status: 'Not Returned',
      regDate: DateTime.parse('2025-01-02'),
      closedDate: null,
      imageUrl: '',
    ),
    Post(
      postType: PostType.found,
      id: 3,
      title: 'Wallet',
      status: 'Returned',
      regDate: DateTime.parse('2025-01-02'),
      closedDate: DateTime.parse('2025-01-06'),
      imageUrl: 'assets/wallet.png',
    ),
    Post(
      postType: PostType.found,
      id: 4,
      title: 'Keys',
      status: 'Not Returned',
      regDate: DateTime.parse('2025-03-11'),
      closedDate: null,
      imageUrl: 'assets/keys.png',
    ),
    Post(
      postType: PostType.found,
      id: 5,
      title: 'Bottle',
      status: 'Not Returned',
      regDate: DateTime.parse('2025-01-02'),
      closedDate: null,
      imageUrl: '',
    ),
    Post(
      postType: PostType.found,
      id: 6,
      title: 'Cycle',
      status: 'Returned',
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
        title: const Text('Found Items', style: TextStyle(color: Colors.white)),
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
          if (_chatOpen) ...[
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
