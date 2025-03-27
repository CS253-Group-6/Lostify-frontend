import 'package:final_project/components/home/item_details.dart';
import 'package:flutter/material.dart';

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
/// * `foundDate` – ?
///
/// * `itemImage` – An optional image of the article concerned.
final class Post {
  const Post(
      {required this.postType,
      required this.id,
      required this.title,
      this.status = '',
      required this.regDate,
      this.img});

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

  /// An optional image of the article concerned.
  final Image? img;
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
  final DateTime? foundDate = null; // ?
  Image? get itemImage => post.img;

  @override
  Widget build(BuildContext context) {
    // Determine color based on status text
    final Color statusColor =
        postType == PostType.found ? Colors.green : Colors.red;

    // function to add chat for the post in user's chat list
    void handleItemDetails() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(itemId: id, postOwnerId: 1,post:post)));
    }

    return Container(
      // Box takes full available width
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Semi-transparent white background
        color: Colors.white.withValues(alpha: kItemBoxOpacity),
        // Rounded corners
        borderRadius: BorderRadius.circular(kItemBoxBorderRadius),
        // Optional box shadow for depth
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Layout: image on the left, text on the right
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display item image if provided, else show a placeholder
          if (itemImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: itemImage,
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
          // Expanded column with text and "Open Chat" button
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
                // "Open Chat" button with a black background and white text
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: handleItemDetails,
                  child: const Text('View post'),
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
