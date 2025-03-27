import 'package:flutter/material.dart';

import '/components/home/item_box.dart';

class LostItemsTab extends StatelessWidget {
  const LostItemsTab({super.key});

  @override
  Widget build(BuildContext context) {
    List<Post> items = [
      // Replace with `context<lostItemsProvider>.watch().itemList`
      Post(
          postType: PostType.lost,
          id: 8,
          title: 'Hercules cycle',
          regDate: DateTime(2025, 03, 13),
          description: ' ',
          imageProvider: const NetworkImage(
            'https://www.pentathlon.in/wp-content/uploads/2021/10/brut-rf-24t.webp',
          ),
          address1: 'Hall 5'),
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

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/new_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        children: [
          for (var post in items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ItemBox(post: post),
            ),
        ],
      ),
    );
  }
}

class FoundItemsTab extends StatelessWidget {
  const FoundItemsTab({super.key});

  @override
  Widget build(BuildContext context) {
    List<Post> items = [
      // Replace with `context<foundItemsProvider>.watch().itemList`
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
          address1: 'Hall 5'),
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

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/new_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        children: [
          for (var post in items) ItemBox(post: post),
        ],
      ),
    );
  }
}
