import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://your-backend.com/api';

  Future<List<dynamic>> fetchLostItems() async {
    final response = await http.get(Uri.parse('$baseUrl/lost-items'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load lost items');
    }
  }

  Future<bool> postLostItem(Map<String, dynamic> itemData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lost-items'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(itemData),
    );
    return response.statusCode == 201;
  }

  // Add similar methods for found items, chat messages, etc.
}
