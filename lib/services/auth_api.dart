import 'dart:convert';

import '/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl = "http://127.0.0.1:5000";

  // Sign up api call
  static Future<Map<String, dynamic>> signUp(
      Map<String, dynamic> userDetails) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/auth/signup"),
          headers: {"Content-Type": "application/json"},
          body: {jsonEncode(userDetails)});
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // Login api call
  static Future<Map<String, dynamic>> login(
      Map<String, dynamic> userloginData) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/auth/login"),
          headers: {"Content-Type": "application/json"},
          body: {jsonEncode(userloginData)});
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }
}
