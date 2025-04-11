// lib/pages/lost_found_post_list/found_item.dart

import 'dart:ui';

import 'package:final_project/components/utils/loader.dart';
import 'package:final_project/utils/load_all_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/post.dart';
import '../../pages/chat/chat_page.dart';
import '../../components/lost_items/lost_item_box.dart';
import '../../utils/post_filter.dart';

class FoundItem extends StatefulWidget {
  const FoundItem({super.key});

  @override
  State<FoundItem> createState() => _FoundItemState();
}

class _FoundItemState extends State<FoundItem> {

  bool _showDetails = false;
  Post? _selectedPost;

  @override
  void initState() {
    super.initState();
    _loadUserLostPosts(context);
  }

  List<Post> filteredPosts = [];
  bool _isLoading = false;
  Future<void> _loadUserLostPosts(BuildContext context) async {
    final postGetter = LoadPosts();
    try {
      setState(() {
        _isLoading = true;
      });
      final posts =
          await postGetter.loadUserFoundPosts(context); // Await the backend call
      print(posts);
      setState(() {
        filteredPosts = posts; // Update the state with the loaded posts
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Found Items',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading?const Loader(): Stack(
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
              child: filteredPosts.length>0? ListView.builder(
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
              ):Center(
                child: Text('No posts found',)
              )
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
    const String itemDescription =
        "Detailed description of the item, including condition, features, and any identifying marks.";
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
          if (post.imageProvider != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                post.imageProvider!,
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

          // Status, Registered Date, Found/Returned Date
          Text("Status: ${post.status}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text("Registered Date: ${formatDate(post.regDate)}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text("Found/Returned Date: ${formatDate(post.closedDate)}",
              style: const TextStyle(fontSize: 16)),
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
