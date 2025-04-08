import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/home/item_box.dart';
import '../../models/post.dart';
import '../../providers/user_provider.dart';
import '../../services/chat_api.dart';
import '../../services/items_api.dart';

class ItemDetailsPage extends StatelessWidget {
  final Post post;
  final int itemId, postOwnerId;
  final String? extraProperty;

  const ItemDetailsPage({
    super.key,
    required this.itemId,
    required this.postOwnerId,
    required this.post,
    this.extraProperty,
  });

  @override
  Widget build(BuildContext context) {
    int logged_in_userId =
        Provider.of<UserProvider>(context, listen: false).userId;
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${post.title} deleted!',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                    backgroundColor: Colors.blue, // Custom background color
                    duration: Duration(seconds: 3), // Display duration
                  ),
                );
                Navigator.pop(context);
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
        title: Text(post.title, style: const TextStyle(color: Colors.white)),
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
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background.png'), // Path to your background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the image if available
                if (post.imageProvider != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        post.imageProvider!,
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
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Date of registration
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      'Registered on: ${ItemBox.dateAsString(post.regDate)}',
                      style: const TextStyle(
                        fontSize: 16, // Smaller font size for consistency
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Item type (Lost/Found)
                Row(
                  children: [
                    Icon(
                      post.postType == PostType.lost
                          ? Icons.search
                          : Icons.check_circle_outline,
                      size: 18,
                      color: post.postType == PostType.lost
                          ? Colors.red
                          : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post.postType == PostType.lost
                          ? 'Lost Item'
                          : 'Found Item',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_pin, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Location: ${post.address2}, ${post.address1}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.visible, // Ensure text wraps to the next line
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Description
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.description, size: 18, color: Colors.black),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Description: ${post.description}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.visible, // Ensure text wraps to the next line
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action buttons (e.g., Report, Share, Chat)
                // if (extraProperty != null)
                if (extraProperty != null || postOwnerId == logged_in_userId)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Delete Button
                      ElevatedButton.icon(
                        onPressed: () {
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
                                  onPressed: () async {
                                    try {
                                      // Call the delete API using the given itemId
                                      final response = await ItemsApi.deleteItem(itemId);
                                      // final responseData = jsonDecode(response.body);

                                      if (response.statusCode == 204) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${post.title} deleted successfully!',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.blue,
                                            duration: const Duration(seconds: 3),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Failed to delete ${post.title}.',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                            duration: const Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'An error occurred: $e',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    } finally {
                                      Navigator.pop(context); // Close the dialog
                                      Navigator.pushReplacementNamed(
                                        context,
                                        post.postType == PostType.found ? '/found-items' : '/lost-items'
                                      );
                                    }
                                  },
                                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        } ,
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      // Chat Button
                      ElevatedButton.icon(
                        onPressed: () {
                          ChatServices.addChat(context, itemId, postOwnerId);
                        },
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: Colors.white),
                        label: const Text('Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Blue background
                          foregroundColor: Colors.white, // White text
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Report Button
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            // Call the report API using the given itemId
                            final response = await ItemsApi.reportItem(itemId);
                            // final responseData = jsonDecode(response.body);

                            if (response.statusCode == 204) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${post.title} reported successfully!',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.blue,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to report ${post.title}.',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'An error occurred: $e',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.report, color: Colors.white),
                        label: const Text('Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      // Chat Button
                      ElevatedButton.icon(
                        onPressed: () {
                          ChatServices.addChat(context, itemId, postOwnerId);
                        },
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: Colors.white),
                        label: const Text('Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Blue background
                          foregroundColor: Colors.white, // White text
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
