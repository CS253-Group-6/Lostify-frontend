import 'dart:ui';

import 'package:final_project/utils/load_all_posts.dart';
import 'package:flutter/material.dart';

import '../../components/lost_items/lost_item_box.dart';
import '../../models/post.dart';
import '../../pages/chat/chat_page.dart';

class LostItem extends StatefulWidget {
  const LostItem({super.key});

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
      address2: 'Hall 5',
      reports: 1,
      description: "This is the description of item id:1",
      imageProvider: Image.asset('assets/wallet.png').image,
    ),
    Post(
      postType: PostType.lost,
      id: 2,
      title: 'Phone',
      status: 'Found',
      regDate: DateTime.parse('2025-01-02'),
      closedDate: DateTime.parse('2025-01-06'),
      imageProvider: Image.asset('assets/phone.png').image,
    ),
    Post(
      postType: PostType.lost,
      id: 3,
      title: 'Keys',
      status: 'Missing',
      regDate: DateTime.parse('2025-03-11'),
      closedDate: null,
      imageProvider: Image.asset('assets/keys.png').image,
    ),
    Post(
      postType: PostType.lost,
      id: 4,
      title: 'Bottle',
      status: 'Found',
      creatorId: 0,
      regDate: DateTime.parse('2025-01-02'),
      closedDate: DateTime.parse('2025-01-06'),
      imageProvider: Image.asset('assets/keys.png').image,
    ),
    Post(
      postType: PostType.lost,
      id: 5,
      title: 'Cycle',
      status: 'Found',
      creatorId: 0,
      regDate: DateTime.parse('2025-01-02'),
      closedDate: DateTime.parse('2025-01-06'),
      imageProvider: null,
    ),
  ];

  bool _showDetails = false;
  Post? _selectedPost;
  @override
  void initState() {
    super.initState();
    _loadUserLostPosts(context);
  }

  List<Post> filteredPosts = [];
  Future<void> _loadUserLostPosts(BuildContext context) async {
    print('loading');
    final postGetter = LoadPosts();
    try {
      final posts =
          await postGetter.loadUserLostPosts(context); // Await the backend call
      print(posts);
      setState(() {
        filteredPosts = posts; // Update the state with the loaded posts
      });
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Lost Items',
            style: TextStyle(color: Colors.white)),
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
          // Background: list of lost items
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
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: ItemBox(
                      post: filteredPosts[index],
                      // onViewDetails: () {
                      //   setState(() {
                      //     _showDetails = true;
                      //     _selectedPost = filteredPosts[index];
                      //   });
                      // },
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
    // Hard-coded example info
    const String itemDescription =
        "This is a detailed description of the item. Condition, features, any identifying marks, etc.";
    const String itemTime = "07:55 PM";
    const String itemDate = "05 Sept 2025";
    const String itemPlace = "College ground, New SAC, IIT Kanpur";

    // Helper to format date strings (without time)
    String formatDate(DateTime? date) =>
        date != null ? date.toString().split(' ')[0] : 'NA';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row: back arrow + "Item Details"
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
              const SizedBox(width: 40), // Balance the back arrow space
            ],
          ),
          const SizedBox(height: 16),

          // Item image with smaller frame and complete image visible
          if (post.imageProvider != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: post.imageProvider!,
                fit: BoxFit.cover,
                height: 80,
                width: 80,
              ),
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

          // Status and dates
          Text("Status: ${post.status}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text("Registered Date: ${formatDate(post.regDate)}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text("Found/Returned Date: ${formatDate(post.closedDate)}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),

          // Separate rows for Time, Date, Venue
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

          // Buttons row: "Report" & "Open Chat"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTransparentButton("Report", onPressed: () {
                // TODO: Integrate report logic
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

  Widget _buildTransparentButton(String label,
      {required VoidCallback onPressed}) {
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
