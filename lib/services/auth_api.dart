import 'dart:convert';

import '/models/user_model.dart';
import 'package:http/http.dart' as http;
class AuthApi{
  static const String baseUrl = "http://127.0.0.1:5000";

  // Sign up api call
  static Future<Map<String,dynamic>> signUp(User user) async{
    final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {
          "Content-Type": "application/json"
        },
      body: {
          jsonEncode(user.toJson())
      }
    );
    if (response.statusCode == 200 || response.statusCode == 401) {
      return jsonDecode(response.body);
    }

    return {"message": "Unexpected error", "statusCode": 500};
  }

  // Login api call
  static Future<Map<String,dynamic>> login(Map<String,dynamic> userloginData) async{
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Content-Type": "application/json"
      },
      body: {
        jsonEncode(userloginData)
      }
    );
    if (response.statusCode == 200 || response.statusCode == 401) {
      return jsonDecode(response.body);
    }

    return {"message": "Unexpected error", "statusCode": 500};
  }
}