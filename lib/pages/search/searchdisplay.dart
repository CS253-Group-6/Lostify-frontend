import 'dart:convert';

import 'package:final_project/components/home/item_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../providers/user_provider.dart';
import '../../models/post.dart';
import '../../services/items_api.dart';
import '../../utils/post_filter.dart';
import 'package:provider/provider.dart';

class SearchDisplayPage extends StatefulWidget {
// The search criteria passed from SearchPage.
  final String searchLocation;
  final DateTime startDate;
  final DateTime endDate;

  const SearchDisplayPage({
    Key? key,
    required this.searchLocation,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _SearchDisplayPageState createState() => _SearchDisplayPageState();
}

class _SearchDisplayPageState extends State<SearchDisplayPage> {
  List<Post> searchResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSearchResults();
  }

// This method mimics the loadAllPosts functionality.
  Future<void> _loadSearchResults() async {
    try {
// Call the API to get all posts.
      final response = await ItemsApi.getAllItems();
      if (!(response.statusCode >= 200 && response.statusCode < 300)) {
        throw Exception("Failed to load posts");
      }
      List posts = jsonDecode(response.body)['posts']; //CHECK THIS
      List<Post> allPosts = [];
      // Convert each returned item into a Post object.
      // (Assuming response is a list of JSON items.)
      for (var item in posts) {
        Post post = await Post.fromJson(item);
        // print(post.)
        allPosts.add(post);
      }
      //final int userId = Provider.of<UserProvider>(context,listen: false).id;
      // Now filter posts based on search criteria:
      // -  Only include posts where postType is found.
      // -  The location1 matches the search location.
      // -  The regDate is between startDate and endDate (inclusive).
      List<Post> filteredPosts = PostFilter.filterPosts(
        posts: allPosts,
        postType: PostType.lost,
        location: widget.searchLocation,
        startDate: widget.startDate,
        endDate: widget.endDate,
      );
      print(filteredPosts);
      setState(() {
        searchResults = filteredPosts;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading posts: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to load posts."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// Using an app bar similar to homepage.dart
      appBar: AppBar(
        title: const Text("Search Results", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/new_background.png"), // use the same background image
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : searchResults.isEmpty
            ? const Center(child: Text("No posts found matching the criteria."))
            : ListView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            Post post = searchResults[index];
// Display each post in a Card widget.
//             return Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 3,
//               margin: const EdgeInsets.only(bottom: 15),
//               child: ListTile(
//                 title: Text(post.title ?? "No Title"),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(post.description ?? ""),
//                     Text("Location: ${post.address1 ?? ""}"),
//                     Text("Date: ${DateFormat('dd/MM/yyyy').format(post.regDate)}"),
//                   ],
//                 ),
//                 onTap: () {
// // Optionally, navigate to a detailed view of the post.
//                 },
//               ),
//             );
           return ItemBox(post: post);
          },
        ),
      ),
    );
  }
}
