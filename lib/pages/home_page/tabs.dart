import 'package:final_project/utils/load_all_posts.dart';
import 'package:flutter/material.dart';

import '/components/home/item_box.dart';
import '/models/post.dart';

class LostItemsTab extends StatefulWidget {
  const LostItemsTab({super.key});

  @override
  LostItemsTabState createState() => LostItemsTabState();
}

class LostItemsTabState extends State<LostItemsTab> {
  List<Post> _lostPosts = [];
  // Change this flag to false to use the hardcoded version.
  final bool _useDynamicData = false; //TODO: change to true

  @override
  void initState() {
    super.initState();
    // uncomment after backend
    /*
    _loadLostPosts();
    */
  }

  Future<void> _loadLostPosts() async {
    final postGetter = LoadPosts();
    try {
      final posts = await postGetter.loadLostPosts(); // Await the backend call
      setState(() {
        _lostPosts = posts; // Update the state with the loaded posts
      });
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  // Dynamic version using API
  Widget _buildDynamicLostItems() {
    return ListView.builder(
      itemCount: _lostPosts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ItemBox(post: _lostPosts[index]),
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
        address2: 'Hall 5',
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
      Post(
        postType: PostType.lost,
        id: 8,
        title: 'Hercules cycle',
        regDate: DateTime(2025, 03, 13),
        description: ' ',
        imageProvider: const NetworkImage(
          'https://www.pentathlon.in/wp-content/uploads/2021/10/brut-rf-24t.webp',
        ),
        address2: 'Hall 5',
      ),
      Post(
        postType: PostType.found,
        id: 645,
        title: 'Keys',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.lost,
        id: 1234,
        title: 'ID card',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.lost,
        id: 1235,
        title: 'CHM111 lab report',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.found,
        id: 15423,
        title: 'Mont Blanc pen',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.found,
        id: 234125,
        title: 'Someone\'s baby',
        regDate: DateTime(2025, 03, 13),
        address2: 'Hall 5',
      ),
    ];

    // Filter for lost items only
    List<Post> lostItems =
        items.where((post) => post.postType == PostType.lost && post.closedById == null).toList();

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
  List<Post> _foundPosts = [];
  // Change this flag to false to use the hardcoded version.
  final bool _useDynamicData = false; //TODO: change to true

  @override
  void initState() {
    super.initState();
    // uncomment this after backend
    /*
    _loadFoundPosts();
    */
  }

  Future<void> _loadFoundPosts() async {
    final postGetter = LoadPosts();
    try {
      final posts = await postGetter.loadFoundPosts(); // Await the backend call
      setState(() {
        _foundPosts = posts; // Update the state with the loaded posts
      });
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  // Dynamic version using API
  Widget _buildDynamicFoundItems() {
    return ListView.builder(
      itemCount: _foundPosts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ItemBox(post: _foundPosts[index]),
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
        address2: 'Hall 5',
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
        items.where((post) => post.postType == PostType.found && post.closedById==null).toList();

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
