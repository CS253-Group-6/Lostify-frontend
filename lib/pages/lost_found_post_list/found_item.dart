// lib/pages/lost_found_post_list/found_item.dart

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../components/lost_items/lost_item_box.dart';
import '../../models/post.dart';
import '../../pages/chat/chat_page.dart';

class FoundItem extends StatefulWidget {
  const FoundItem({super.key});

  @override
  State<FoundItem> createState() => _FoundItemState();
}

class _FoundItemState extends State<FoundItem> {
  // Example data for found items
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

  bool _showDetails = false;
  Post? _selectedPost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Found Items', style: TextStyle(color: Colors.white)),
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
          // Background: list of found items
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
                    child: LostItemBox(
                      post: posts[index],
                      onViewDetails: () {
                        setState(() {
                          _showDetails = true;
                          _selectedPost = posts[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // Overlay for item details
          if (_showDetails && _selectedPost != null) ...[
            // Blurred backdrop
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black12),
              ),
            ),
            // Details card
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
                  child: _buildItemDetails(_selectedPost!),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemDetails(Post post) {
    // Hard-coded details for demonstration
    const String itemDescription = "Detailed description of the item, including condition, features, and any identifying marks.";
    const String itemTime = "07:55 PM";
    const String itemDate = "05 Sept 2025";
    const String itemPlace = "College ground, New SAC, IIT Kanpur";

    String formatDate(DateTime? date) =>
        date != null ? date.toString().split(' ')[0] : 'NA';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row with back arrow and "Item Details" title
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _showDetails = false;
                    _selectedPost = null;
                  });
                },
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Item Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 40), // Balancing space
            ],
          ),
          const SizedBox(height: 16),

          // Item image (smaller frame with rounded corners)
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: post.imageUrl!.startsWith('http')
                  ? Image.network(post.imageUrl!, height: 120, fit: BoxFit.contain)
                  : Image.asset(post.imageUrl!, height: 120, fit: BoxFit.contain),
            )
          else
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, color: Colors.grey, size: 50),
            ),
          const SizedBox(height: 16),

          // Title
          Text(
            post.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            itemDescription,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Status, Registered Date, Found/Returned Date
          Text("Status: ${post.status}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text("Registered Date: ${formatDate(post.regDate)}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text("Found/Returned Date: ${formatDate(post.closedDate)}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),

          // Additional info on separate rows for better wrapping
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Time: $itemTime",
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Date: $itemDate",
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Venue: $itemPlace",
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Buttons: "Report" and "Open Chat"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTransparentButton("Report", onPressed: () {
                // TODO: Implement report logic
              }),
              _buildTransparentButton("Open Chat", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatPage()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransparentButton(String label, {required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        side: const BorderSide(color: Colors.blue),
      ),
      child: Text(label),
    );
  }
}
