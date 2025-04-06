import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post.dart';

class PostsApi {
  static const String baseUrl =
      "https://lostify-bqevbvadf6bwh0cn.centralindia-01.azurewebsites.net";

  // Fetch posts by type ('lost' or 'found')
  static Future<List<Post>> fetchPosts(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookies');
    if (cookie == null) {
      throw Exception('No cookies found');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/posts?type=$type'),
      headers: {
        "Cookie": cookie, // Replace with actual cookie if needed
      },
    );

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
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookies');
    if (cookie == null) {
      throw Exception('No cookies found');
    }
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {
        "Cookie": cookie,
      },
    );
    return response.statusCode == 200;
  }
}
