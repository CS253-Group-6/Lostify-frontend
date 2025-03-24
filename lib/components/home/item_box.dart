import 'package:flutter/material.dart';

import '../../pages/home_page/item_details_page.dart';

/// Type of post (for lost item or for found item). Passed as argument
/// to the constructor of [PostType].
enum PostType { lost, found }

/// Details of a post.
///
/// This class groups together attributes of a post, similar to a C `struct`.
///
/// #### Public members:
///
/// * `postType` – An instance of [PostType] indicating whether the post is
///                for a lost item or for a found item.
///
/// * `id` – The unique identifier assigned to the post in the database.
///
/// * `title` – The title given to the post.
///
/// * `status` – ?
///
/// * `regDate` – The date of creation of the post.
///
/// * `description` – Description of the post.
///
/// * `itemImage` – An optional image of the article concerned.
final class Post {
  const Post({
    required this.postType,
    required this.id,
    required this.title,
    this.status = '',
    required this.regDate,
    this.description = '',
    this.imageProvider,
    this.address = '',
  });

  /// An instance of [PostType] indicating whether the post is
  /// for a lost item or for a found item.
  final PostType postType;

  /// The unique identifier assigned to the post in the database.
  final int id;

  /// The title given to the post.
  final String title;

  /// ?
  final String status;

  /// The date of creation of the post.
  final DateTime regDate;

  /// Description of the post.
  final String description;

  /// An optional image of the article concerned.
  final ImageProvider? imageProvider;

  /// Address associated with the post.
  final String address;
}

/// Style constant for transparency of [ItemBox]
/// instances.
const double kItemBoxOpacity = 0.7;

/// Style constant for rounded corner radius of
/// [ItemBox] instances.
const double kItemBoxBorderRadius = 20.0;

/// A card displaying details of a post in brief.
///
/// Inherits from [StatelessWidget].
class ItemBox extends StatelessWidget {
  const ItemBox({super.key, required this.post});

  final Post post;

  PostType get postType => post.postType;
  int get id => post.id;
  String get title => post.title;
  String get status => post.status;
  DateTime get regDate => post.regDate;
  DateTime? get foundDate => null; // Placeholder
  ImageProvider? get itemImage => post.imageProvider;

  @override
  Widget build(BuildContext context) {
    // Determine color based on status text
    final Color statusColor =
        postType == PostType.found ? Colors.green : Colors.red;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: kItemBoxOpacity),
        borderRadius: BorderRadius.circular(kItemBoxBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display item image if provided, else show a placeholder
          if (itemImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                image: itemImage!,
                fit: BoxFit.contain,
                height: 80,
                width: 80,
              ),
            )
          else
            Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: const Icon(
                Icons.image,
                color: Colors.grey,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title in bold
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                // Status text with dynamic color
                Text(
                  postType == PostType.lost ? 'Lost' : 'Found',
                  style: TextStyle(color: statusColor),
                ),
                const SizedBox(height: 4),
                Text('Registered on: ${dateAsString(regDate)}'),
                const SizedBox(height: 4),
                Text('Found on: ${dateAsString(foundDate)}'),
                const SizedBox(height: 8),
                // "View Post" button navigates to ItemDetailsPage
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsPage(post: post),
                      ),
                    );
                  },
                  child: const Text('View'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String dateAsString(final DateTime? date) {
    if (date == null) {
      return '';
    }

    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');

    return '$d.$m.$y';
  }
}
