import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostsApi {
  static const String baseUrl = "http://127.0.0.1:5000";

  // Fetch posts by type ('lost' or 'found')
  static Future<List<Post>> fetchPosts(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/posts?type=$type'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // Ensure your Post model has a fromJson constructor
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Delete a post by ID
  // Note: Only admin should be able to call this method.
  static Future<bool> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    return response.statusCode == 200;
  }
}
