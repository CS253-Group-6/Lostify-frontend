import 'dart:convert';

import 'package:http/http.dart' as http;

class ProfileApi {
  static final String baseUrl = 'http://127.0.0.1:5000';

  // edit profile
  static Future<Map<String,dynamic>> editProfile(int userId,Map<String,dynamic> profileDetails) async{
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
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/users/$userId/profile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(profileDetails),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // get profile by Id
  static Future<Map<String,dynamic>> getProfileById(int userId) async{
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/users/$userId/profile"),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }
}