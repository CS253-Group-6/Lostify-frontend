import 'package:flutter/material.dart';
import '/models/post.dart';
import '/components/home/item_box.dart';

class LostItemsTab extends StatefulWidget {
  const LostItemsTab({super.key});

  @override
  LostItemsTabState createState() => LostItemsTabState();
}

class LostItemsTabState extends State<LostItemsTab> {
  @override
  void initState() {
    super.initState();
    // TODO: Load the lost posts
  }

  @override
  Widget build(BuildContext context) {
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
          address: 'Hall 5'),
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

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/new_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        children: [
          for (var post in lostItems)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ItemBox(post: post),
            ),
        ],
      ),
    );
  }
}

class FoundItemsTab extends StatefulWidget {
  const FoundItemsTab({super.key});

  @override
  State<FoundItemsTab> createState() => _FoundItemsTabState();
}

class _FoundItemsTabState extends State<FoundItemsTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // TODO: load the found items
  }
  @override
  Widget build(BuildContext context) {
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
          address: 'Hall 5'),
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

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/new_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        children: [
          for (var post in foundItems)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ItemBox(post: post),
            ),
        ],
      ),
    );
  }
}
