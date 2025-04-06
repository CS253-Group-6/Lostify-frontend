import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileApi {
  static final String baseUrl =
      'https://lostify-bqevbvadf6bwh0cn.centralindia-01.azurewebsites.net';

  // edit profile
  static Future<http.Response> editProfile(
      int userId, Map<String, dynamic> profileDetails) async {
    /*
      profile details format: { 
        name, //string
        phone, //string
        email, //string
        address, //string
        designation, //string
        roll, // int
        image //blob
    } 
     */
    // get the cookies from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookies');
    if (cookie == null) {
      return http.Response(
          jsonEncode({"message": "No cookies found", "statusCode": 401}), 401);
    }
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/users/$userId/profile"),
        headers: {
          "Content-Type": "application/json",
          "Cookie": cookie,
        },
        body: jsonEncode(profileDetails),
      );
      return response;
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // get profile by Id
  static Future<http.Response> getProfileById(int userId) async {
    try {
      // get the cookies from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('cookies');
      if (cookie == null) {
        return http.Response(
            jsonEncode({"message": "No cookies found", "statusCode": 401}),
            401);
      }
      final response = await http.get(
        Uri.parse("$baseUrl/users/$userId/profile"),
        headers: {"Cookie": cookie},
      );
      return response;
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }
}
