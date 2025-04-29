import 'package:flutter/material.dart';

import '../../components/home/item_box.dart';
import '../../components/utils/loader.dart';
import '../../models/post.dart';
import '../../utils/load_all_posts.dart';

class LostItemsTab extends StatefulWidget {
  const LostItemsTab({super.key});

  @override
  LostItemsTabState createState() => LostItemsTabState();
}

class LostItemsTabState extends State<LostItemsTab> {
  List<Post> _lostPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // uncomment after backend
    // if(Provider.of<AllItemsProvider>(context).allPosts.isNotEmpty){
    //   _lostPosts = Provider.of<AllItemsProvider>(context).allPosts;
    // }else{
      _loadLostPosts();
      print("Loading...");
    // }
  }

  Future<void> _loadLostPosts() async {
    final postGetter = LoadPosts();
    try {
      setState(() {
        _isLoading = true;
      });
      final posts = await postGetter.loadLostPosts(context); // Await the backend call
      setState(() {
        _lostPosts = posts; // Update the state with the loaded posts
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  // Dynamic version using API
  Widget _buildDynamicLostItems() {
    return _lostPosts.isNotEmpty
      ? ListView.builder(
        itemCount: _lostPosts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ItemBox(post: _lostPosts[index]),
          );
        },
      )
      : const Center(
        child: Text("No posts"),
      );
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
      child: _isLoading
        ? const Loader()
        : _buildDynamicLostItems()
    );
  }
}

class FoundItemsTab extends StatefulWidget {
  const FoundItemsTab({super.key});

  @override
  State<FoundItemsTab> createState() => _FoundItemsTabState();
}

class _FoundItemsTabState extends State<FoundItemsTab> {
  List<Post> _foundPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoundPosts();
  }

  Future<void> _loadFoundPosts() async {
    final postGetter = LoadPosts();
    try {
      setState(() {
        _isLoading = true;
      });
      final posts = await postGetter.loadFoundPosts(context); // Await the backend call
      setState(() {
        _foundPosts = posts; // Update the state with the loaded posts
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  // Dynamic version using API
  Widget _buildDynamicFoundItems() {
    return _foundPosts.isNotEmpty
      ? ListView.builder(
        itemCount: _foundPosts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ItemBox(post: _foundPosts[index]),
          );
        },
      )
      : const Center(
        child: Text("No posts"),
      );
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
      child: _isLoading
        ? const Loader()
        : _buildDynamicFoundItems()
    );
  }
}
