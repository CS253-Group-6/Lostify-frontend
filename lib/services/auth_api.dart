import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  static const String baseUrl =
      "https://lostify-bqevbvadf6bwh0cn.centralindia-01.azurewebsites.net";

  // Sign up api call
  static Future<http.Response> signUp(Map<String, dynamic> userDetails) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/signup/get_otp"),
        headers: {"Content-Type": "application/json"}, 
        body: jsonEncode(userDetails),
      );
      print(response.body);
      return response;
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // Login api call
  static Future<http.Response> login(Map<String, dynamic> userloginData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userloginData),
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final cookieData = response.headers['set-cookie'];
        final cookieIdx = cookieData!.indexOf('session=');
        final cookie = cookieData.substring(cookieIdx);
        await prefs.setString('cookies', cookie);
      }
      return response;
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // otp verification
  static Future<http.Response> verifyOtp(Map<String, dynamic> otpData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup/verify_otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(otpData),
      );
      return response;
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          501);
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
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
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
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // change password
  static Future<http.Response> changePassword(
      Map<String, dynamic> changePasswordData) async {
    try {
      // get the cookies from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('cookies');
      if (cookie == null) {
        return http.Response(
            jsonEncode({"message": "No cookies found", "statusCode": 401}),
            401);
      }
      final response = await http.post(
        Uri.parse('$baseUrl/auth/change_password'),
        headers: {
          "Content-Type": "application/json",
          "Cookie": cookie,
        },
        body: jsonEncode(changePasswordData),
      );
      return response;
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }
}
