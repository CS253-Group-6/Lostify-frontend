import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

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
    this.creatorId =
        123, // TODO: Change this: Once the provider for this is set up, make it required and remove the default value
    this.status = '',
    required this.regDate,
    this.closedDate,
    this.closedById,
    this.reports = 0,
    this.description = '',
    this.imageProvider,
    this.address1 = '',
    this.address2 = '',
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
  final int? closedById;

  /// Description of the post.
  final String description;

  /// An optional image of the article concerned.
  final File? imageProvider;

  ///Coarse Address associated with the post.
  final String address1;

  ///Detailed Address associated with the post.
  final String address2;

  // save image
  static Future<File> saveProfileImage(Uint8List bytes, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    return await file.writeAsBytes(bytes);
  }

  static Future<Post> fromJson(Map<String, dynamic> json) async{
    // Convert the postType string to the PostType enum
    final typeString = (json['type'] == 0 ? "lost" : "found");
    final postType = typeString == 'lost' ? PostType.lost : PostType.found;

    // Safely parse optional values and image URL
    return Post(
      postType: postType,
      id: json['id'] as int,
      title: json['title'] as String,
      creatorId: json['creator'] != null ? json['creator'] as int : 123,
      status: json['status'] as String? ?? '',
      regDate: DateTime.fromMillisecondsSinceEpoch(json['date'] * 1000),
      closedDate: json['closedDate'] != null && json['closedDate'] != ""
          ? DateTime.fromMicrosecondsSinceEpoch(json['closedDate'])
          : null,
      closedById: json['closedBy'] != null ? json['closedBy'] as int : null,
      reports: json['reportCount'] is int
          ? json['reportCount'] as int
          : int.tryParse(json['reports']?.toString() ?? '0') ?? 0,
      description: json['description'] as String? ?? '',
      imageProvider:
          json['image'] != null && (json['image'] as String).isNotEmpty
              ? await saveProfileImage(base64Decode(json['image']), 'item ${json['id']}')
              : null,
      address2: json['address'] as String? ?? '',
    );
  }
}
