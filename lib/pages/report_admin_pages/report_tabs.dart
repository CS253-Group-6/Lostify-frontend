import 'package:flutter/material.dart';

import '../../components/home/item_box.dart';
import '../../models/post.dart';
import '../../utils/load_all_posts.dart';

class ItemsTab extends StatefulWidget {
  const ItemsTab({super.key});

  @override
  State<ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  List<Post> reportedPosts = [];

  void _loadReportedItems() async {
    try {
      final itemGetter = LoadPosts();
      print('Fetching...');
      final posts = await itemGetter.loadReportedPosts(context);
      print('Reported posts: $posts');
      setState(() {
        reportedPosts = posts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error loading reported posts: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // get the reported post
    _loadReportedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/new_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        children: [
          for (var post in reportedPosts)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ItemBox(post: post, extraProperty: "Reports"),
            ),
        ],
      ),
    );
  }
}
