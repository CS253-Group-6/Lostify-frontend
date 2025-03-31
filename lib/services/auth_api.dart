import 'dart:convert';

import '/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl = "http://127.0.0.1:5000";

  // Sign up api call
  static Future<Map<String, dynamic>> signUp(
      Map<String, dynamic> userDetails) async {
    try {
      final response = await http.post(
          Uri.parse("$baseUrl/auth/signup/get_otp"),
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

  // otp verification
  static Future<Map<String, dynamic>> verifyOtp(
      Map<String, dynamic> otpData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup/verify_otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(otpData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // logout user
  static Future<void> logout() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/logout'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return;
    }
  }

  // reset -password
  static Future<Map<String, dynamic>> resetPassword(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/reset_password'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // change password
  static Future<Map<String, dynamic>> changePassword(
      Map<String, dynamic> changePasswordData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/change_password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(changePasswordData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }
}
