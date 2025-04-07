import 'package:final_project/models/post.dart';
import 'package:flutter/material.dart';

class AllItemsProvider extends ChangeNotifier {
  List<Post> allPosts = [];

  void updateData(List<Post> all_posts) {
    this.allPosts = all_posts;
    notifyListeners();  // Notify UI to refresh
  }
}