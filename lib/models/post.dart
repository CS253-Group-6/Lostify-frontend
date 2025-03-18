import 'package:flutter/material.dart';

enum PostType { lost, found }

class Post {
  const Post({
    required this.postType,
    required this.id,
    required this.title,
    required this.status,
    required this.regDate,
    this.closedDate,
    this.imageUrl,
  });

  final PostType postType;
  final int      id;
  final String   title;
  final String   status;
  final DateTime regDate;
  final DateTime? closedDate;
  final String?  imageUrl;
}
