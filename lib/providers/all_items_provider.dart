import 'package:final_project/models/post.dart';
import 'package:flutter/material.dart';

class AllItemsProvider extends ChangeNotifier {
  List<Post> allPosts = [];

  void updateData(List<Post> allPosts) {
    this.allPosts = allPosts;
    notifyListeners();  // Notify UI to refresh
  }
}