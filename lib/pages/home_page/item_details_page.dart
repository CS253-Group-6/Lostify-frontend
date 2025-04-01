import 'package:flutter/material.dart';

import '../../components/home/item_box.dart';
import '../../models/post.dart';
import '../../services/chat_api.dart';

class ItemDetailsPage extends StatelessWidget {
  final Post post;
  final int itemId, postOwnerId;
  final String? extraProperty;

  const ItemDetailsPage({
    super.key,
    required this.itemId,
    required this.postOwnerId,
    required this.post,
    this.extraProperty
  });

  @override
  Widget build(BuildContext context) {
    void deletePost(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Post"),
          content: const Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // onDelete(); // Calls the delete function passed from parent
                
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title), // Display the title of the item
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white, 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image if available
            if (post.imageProvider != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: post.imageProvider!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Title
            Text(
              post.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Date of registration
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text('Registered on: ${ItemBox.dateAsString(post.regDate)}'),
              ],
            ),
            const SizedBox(height: 16),
            // Item type (Lost/Found)
            Row(
              children: [
                Icon(
                  post.postType == PostType.lost
                      ? Icons.search
                      : Icons.check_circle_outline,
                  size: 16,
                  color: post.postType == PostType.lost
                      ? Colors.red
                      : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  post.postType == PostType.lost ? 'Lost Item' : 'Found Item',
                  style: TextStyle(
                    fontSize: 16,
                    color: post.postType == PostType.lost
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Location
            Row(
              children: [
                const Icon(Icons.location_pin, size: 16),
                const SizedBox(width: 8),
                Text('Location: ${post.address}'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              post.description,
              // style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            // Action buttons (e.g., Report, Share, Chat)
            if (extraProperty != null)
              ElevatedButton(
                onPressed: () {
                  deletePost(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Delete", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            if (extraProperty == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${post.title} reported!')),
                      );
                    },
                    icon: const Icon(Icons.report),
                    label: const Text('Report'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Shared ${post.title}!')),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ChatServices.addChat(context,itemId,postOwnerId);
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
