// // lib/components/lost_items/lost_item_box.dart
//
// import 'package:flutter/material.dart';
//
// import '../../models/post.dart';
//
// const double kItemBoxOpacity = 0.7;
// const double kItemBoxBorderRadius = 30.0;
//
// /// A widget displaying basic info about a [Post].
// /// When tapped, it triggers a callback to show the item details overlay
// /// on the same page (LostItem or FoundItem).
// class LostItemBox extends StatelessWidget {
//   const LostItemBox({
//     super.key,
//     required this.post,
//     required this.onViewDetails,
//   });
//
//   final Post post;
//   final VoidCallback onViewDetails;
//
//   String _formatDate(DateTime? date) =>
//     date != null ? date.toString().split(' ')[0] : 'NA';
//
//   Widget _buildImage() {
//     if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
//       final imageWidget = post.imageUrl!.startsWith('http')
//           ? Image.network(post.imageUrl!, width: 80, height: 80, fit: BoxFit.cover)
//           : Image.asset(post.imageUrl!, width: 80, height: 80, fit: BoxFit.cover);
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: imageWidget,
//       );
//     }
//     return Container(
//       width: 80,
//       height: 80,
//       color: Colors.grey[300],
//       child: const Icon(Icons.image, color: Colors.grey),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final lowerStatus = post.status.toLowerCase();
//     final statusColor = (lowerStatus == 'returned' || lowerStatus == 'found')
//         ? Colors.green
//         : (lowerStatus == 'not returned' || lowerStatus == 'missing')
//         ? Colors.red
//         : Colors.black;
//
//     final dateLabel = (lowerStatus == 'returned' || lowerStatus == 'not returned')
//         ? 'Returned Date'
//         : 'Found Date';
//
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.all(8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: kItemBoxOpacity),
//         borderRadius: BorderRadius.circular(kItemBoxBorderRadius),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildImage(),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   post.title,
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(height: 4),
//                 Text('Status: ${post.status}', style: TextStyle(color: statusColor)),
//                 const SizedBox(height: 4),
//                 Text('Registered Date: ${_formatDate(post.regDate)}'),
//                 const SizedBox(height: 4),
//                 Text('$dateLabel: ${_formatDate(post.closedDate)}'),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: onViewDetails,
//                   child: const Text('View'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../pages/home_page/item_details_page.dart';

/// Type of post (for lost item or for found item). Passed as argument
/// to the constructor of [PostType].
// enum PostType { lost, found }

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
  const ItemBox({super.key, required this.post, this.extraProperty});

  final Post post;
  final String? extraProperty;

  int get reports => post.reports;
  PostType get postType => post.postType;
  int get id => post.id;
  String get title => post.title;
  String get status => post.status;
  DateTime get regDate => post.regDate;
  DateTime? get closedDate => post.closedDate;
  String get description => post.description;
  String get address => post.address2;
  // DateTime? get foundDate => null; // Placeholder
  File? get itemImage => post.imageProvider;
  int get creatorId => post.creatorId;

  @override
  Widget build(BuildContext context) {
    // Determine color based on status text

    final Color statusColor =
        postType == PostType.found ? Colors.green : Colors.red;

    // function to add chat for the post in user's chat list
    void handleItemDetails() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsPage(
              itemId: id,
              postOwnerId: creatorId,
              post: post,
              extraProperty: extraProperty,
            ),
          ));
    }

    void deletePost(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Post"),
          content: const Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                //onDelete(); // Calls the delete function passed from parent
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

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
              child: Image.file(
                itemImage!,
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
                if (extraProperty != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Reports: $reports',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                  ),
                const SizedBox(height: 4),
                // Status text with dynamic color
                Text(
                  postType == PostType.lost ? 'Lost' : 'Found',
                  style: TextStyle(color: statusColor),
                ),
                const SizedBox(height: 4),
                if (extraProperty == null)
                  Text('Date: ${dateAsString(regDate)}'),
                const SizedBox(height: 4),
                if (extraProperty == null)
                  if (post.closedById != null) Text('Closed'),
                const SizedBox(height: 8),

                // "View Post" button navigates to ItemDetailsPage
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: handleItemDetails,
                      child: const Text('View'),
                    ),
                    // <-- Added delete callback
                    if (extraProperty != null)
                      IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          tooltip: "Delete Post",
                          onPressed: () => deletePost(context)),
                  ],
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
