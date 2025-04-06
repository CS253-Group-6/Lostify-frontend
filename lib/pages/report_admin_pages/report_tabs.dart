import 'package:flutter/material.dart';

import '/components/home/item_box.dart';
import '../../models/post.dart';

class ItemsTab extends StatelessWidget {
  const ItemsTab({super.key});

  @override
  Widget build(BuildContext context) {
    List<Post> items = [
      // Replace with `context<lostItemsProvider>.watch().itemList`
      Post(
        postType: PostType.lost,
        id: 8,
        title: 'Hercules cycle',
        reports: 1,
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
        reports: 10,
        title: 'Keys',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.lost,
        id: 10,
        reports: 9,
        title: 'ID card',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.lost,
        id: 25,
        reports: 5,
        title: 'CHM111 lab report',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.found,
        id: 23,
        reports: 20,
        title: 'Mont Blanc pen',
        regDate: DateTime(2025, 03, 13),
      ),
      Post(
        postType: PostType.found,
        id: 43,
        reports: 5,
        title: 'Someone\'s baby',
        regDate: DateTime(2025, 03, 13),
      ),
    ];
    items.sort((a, b) => b.reports.compareTo(a.reports));

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
              child: ItemBox(post: post, extraProperty: "Reports"),
            ),
        ],
      ),
    );
  }
}
