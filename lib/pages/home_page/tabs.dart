import 'package:flutter/material.dart';

import '/components/home/item_box.dart';
import '/models/post.dart';
import '../../services/posts_api.dart';

class LostItemsTab extends StatefulWidget {
  const LostItemsTab({super.key});

  @override
  LostItemsTabState createState() => LostItemsTabState();
}

class LostItemsTabState extends State<LostItemsTab> {
  late Future<List<Post>> _lostPosts;
  // Change this flag to false to use the hardcoded version.
  final bool _useDynamicData = true;

  @override
  void initState() {
    super.initState();
    _lostPosts = PostsApi.fetchPosts('lost');
  }

  // Dynamic version using API
  Widget _buildDynamicLostItems() {
    return FutureBuilder<List<Post>>(
      future: _lostPosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No lost items found.'));
        }
        final lostItems = snapshot.data!;
        return ListView.builder(
          itemCount: lostItems.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ItemBox(post: lostItems[index]),
            );
          },
        );
      },
    );
  }

  // Hardcoded version using static data
  Widget _buildHardcodedLostItems() {
    List<Post> items = [
      // Replace with context.watch<LostItemsProvider>().itemList in a real app.
      Post(
        postType: PostType.lost,
        id: 8,
        title: 'Hercules cycle',
        regDate: DateTime(2025, 03, 13),
        description: ' ',
        imageProvider: const NetworkImage(
          'https://www.pentathlon.in/wp-content/uploads/2021/10/brut-rf-24t.webp',
        ),
        address: 'Hall 5',
      ),
      Post(
        postType: PostType.found,
        id: 9,
        title: 'Keys',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.lost,
        id: 10,
        title: 'ID card',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.lost,
        id: 25,
        title: 'CHM111 lab report',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.found,
        id: 23,
        title: 'Mont Blanc pen',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.found,
        id: 43,
        title: 'Someone\'s baby',
        regDate: DateTime(2025, 03, 13),
      ),
    ];

    // Filter for lost items only
    List<Post> lostItems =
        items.where((post) => post.postType == PostType.lost).toList();

    return ListView(
      children: [
        for (var post in lostItems)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ItemBox(post: post),
          ),
      ],
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
      child: _useDynamicData
          ? _buildDynamicLostItems()
          : _buildHardcodedLostItems(),
    );
  }
}

class FoundItemsTab extends StatefulWidget {
  const FoundItemsTab({super.key});

  @override
  State<FoundItemsTab> createState() => _FoundItemsTabState();
}

class _FoundItemsTabState extends State<FoundItemsTab> {
  late Future<List<Post>> _foundPosts;
  // Change this flag to false to use the hardcoded version.
  final bool _useDynamicData = true;

  @override
  void initState() {
    super.initState();
    _foundPosts = PostsApi.fetchPosts('found');
  }

  // Dynamic version using API
  Widget _buildDynamicFoundItems() {
    return FutureBuilder<List<Post>>(
      future: _foundPosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No found items available.'));
        }
        final foundItems = snapshot.data!;
        return ListView.builder(
          itemCount: foundItems.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ItemBox(post: foundItems[index]),
            );
          },
        );
      },
    );
  }

  // Hardcoded version using static data
  Widget _buildHardcodedFoundItems() {
    List<Post> items = [
      // Replace with context.watch<FoundItemsProvider>().itemList in a real app.
      Post(
        postType: PostType.lost,
        id: 8,
        title: 'Hercules cycle',
        regDate: DateTime(2025, 03, 13),
        description:
            'I lost my cycle pls find it pls pls pls I\'ll give u Anirudh\'s gf for a night',
        imageProvider: const NetworkImage(
          'https://www.pentathlon.in/wp-content/uploads/2021/10/brut-rf-24t.webp',
        ),
        address: 'Hall 5',
      ),
      Post(
        postType: PostType.found,
        id: 9,
        title: 'Keys',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.lost,
        id: 10,
        title: 'ID card',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.lost,
        id: 25,
        title: 'CHM111 lab report',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.found,
        id: 23,
        title: 'Mont Blanc pen',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.found,
        id: 43,
        title: 'Someone\'s baby',
        regDate: DateTime(2025, 03, 13),
      ),
    ];

    // Filter for found items only
    List<Post> foundItems =
        items.where((post) => post.postType == PostType.found).toList();

    return ListView(
      children: [
        for (var post in foundItems)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ItemBox(post: post),
          ),
      ],
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
      child: _useDynamicData
          ? _buildDynamicFoundItems()
          : _buildHardcodedFoundItems(),
    );
  }
}
