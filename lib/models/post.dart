import 'package:flutter/cupertino.dart';

enum PostType { lost, found }
//
// class Post {
//   const Post({
//     required this.postType,
//     required this.id,
//     required this.title,
//     required this.status,
//     required this.regDate,
//     this.closedDate,
//     this.imageUrl,
//   });
//
//   final PostType postType;
//   final int      id;
//   final String   title;
//   final String   status;
//   final DateTime regDate;
//   final DateTime? closedDate;
//   final String?  imageUrl;
// }


final class Post {
  Post({
    required this.postType,
    required this.id,
    required this.title,
    this.creatorId = 123, // TODO: Change this: Once the provider for this is set up, make it required and remove the default value
    this.status = '',
    required this.regDate,
    this.closedDate,
    this.reports = 0,
    this.description = '',
    this.imageProvider,
    this.address = '',
  });

  /// An instance of [PostType] indicating whether the post is
  /// for a lost item or for a found item.
  final PostType postType;
  final int reports;
  /// The unique identifier assigned to the post in the database.
  final int id;

  /// The title given to the post.
  final String title;

  /// The ID of the user who created the post.
  final int creatorId;

  /// ?
  final String status;

  /// The date of creation of the post.
  final DateTime regDate;
  final DateTime? closedDate;

  /// Description of the post.
  final String description;

  /// An optional image of the article concerned.
  final ImageProvider? imageProvider;

  /// Address associated with the post.
  final String address;
}