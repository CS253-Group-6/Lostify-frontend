import 'dart:convert';

import 'package:http/http.dart' as http;

class ProfileApi {
  static final String baseUrl = 'http://127.0.0.1:5000';
  static Future<Map<String,dynamic>> getProfileById(int id) async{
    try {
      final response = await http.post(Uri.parse("$baseUrl/users/$id/profile"),
          headers: {"Content-Type": "application/json"},);
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }
}