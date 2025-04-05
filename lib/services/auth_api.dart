import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl = "http://10.0.2.2:5000";

  // Sign up api call
  static Future<http.Response> signUp(
      Map<String, dynamic> userDetails) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/signup/get_otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userDetails),
      );
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // Login api call
  static Future<http.Response> login(

      Map<String, dynamic> userloginData) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userloginData),
      );
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // otp verification
  static Future<http.Response> verifyOtp(
      Map<String, dynamic> otpData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup/verify_otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(otpData),
      );
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // logout user
  static Future<http.Response> logout() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/logout'),
      );
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // reset - password
  static Future<http.Response> resetPassword(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset_password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username}),
      );
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // change password
  static Future<http.Response> changePassword(
      Map<String, dynamic> changePasswordData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/change_password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(changePasswordData),
      );
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }
}
