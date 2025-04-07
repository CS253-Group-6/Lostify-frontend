import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ItemsApi {
  static const String baseUrl =
      "https://lostify-bqevbvadf6bwh0cn.centralindia-01.azurewebsites.net";

  // Post a lost Item api call
  static Future<http.Response> postItem(
      Map<String, dynamic> postDetails) async {
    /* 
        post details format: { 
            type, // integer 0-lost, 1-found
            title, // String
            description, // String
            location1, //  String
            location2, // String
            image // Blob
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
      final response = await http.post(
        Uri.parse("$baseUrl/items/post"),
        headers: {"Content-Type": "application/json", "Cookie": cookie},
        body: jsonEncode(postDetails),
      );
      return response;
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // get Item by Id
  static Future<http.Response> getItemById(int itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookies');
    if (cookie == null) {
      return http.Response(
          jsonEncode({"message": "No cookies found", "statusCode": 401}), 401);
    }

    ///  pass itemId as argument

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items/$itemId"),
        headers: {"Content-Type": "application/json", "Cookie": cookie},
      );
      return response; // response data has item details in json form
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // edit a post by its id
  static Future<http.Response> editItem(
      int itemId, Map<String, dynamic> postDetails) async {
    /* 
        post details format: { 
            title, // String
            description, // String
            location1, //  String
            location2, // String
            image // Blob
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
        Uri.parse("$baseUrl/items/$itemId"),
        headers: {"Content-Type": "application/json", "Cookie": cookie},
        body: jsonEncode(postDetails),
      );
      return response;
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // delete an item
  static Future<http.Response> deleteItem(int itemId) async {
    // get the cookies from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final cookie = prefs.getString('cookies');
    if (cookie == null) {
      return http.Response(
          jsonEncode({"message": "No cookies found", "statusCode": 401}), 401);
    }

    ///  pass itemId as argument

    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/items/$itemId"),
        headers: {"Content-Type": "application/json", "Cookie": cookie},
      );
      return response; // response data has item details in json form
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // get all items
  static Future<http.Response> getAllItems() async {
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
        Uri.parse("$baseUrl/items/all"),
        headers: {"Cookie": cookie},
      );
      print(jsonDecode(response.body)['posts']);
      // Parse the response body
      // final List<Map<String,dynamic>> jsonResponse = jsonDecode(response.body);
      // print(jsonResponse);

      // Ensure the response is a list of maps
      return response; // response data has items list
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // claim an item
  static Future<http.Response> claimItem(int itemId, int otherid) async {
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
          Uri.parse("$baseUrl/items/$itemId/claim"),
          headers: {"Content-Type": "application/json", "Cookie": cookie},
          body: {'otherid': otherid});
      return response; //  Status of claimed post in response body as JSON
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // report an item
  static Future<http.Response> getReportCount(int itemId) async {
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
        Uri.parse("$baseUrl/items/$itemId/report"),
        headers: {"Content-Type": "application/json", "Cookie": cookie},
      );
      return response; //  Report count in response body as JSON
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // report an item
  static Future<http.Response> reportItem(int itemId) async {
    try {
      // get the cookies from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('cookies');
      if (cookie == null) {
        return http.Response(
            jsonEncode({"message": "No cookies found", "statusCode": 401}),
            401);
      }
      final response = await http.put(
        Uri.parse("$baseUrl/items/$itemId/report"),
        headers: {"Content-Type": "application/json", "Cookie": cookie},
      );
      return response; //  Report count in response body as JSON
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }

  // delete reports for a post
  static Future<http.Response> deleteReports(int itemId) async {
    try {
      // get the cookies from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('cookies');
      if (cookie == null) {
        return http.Response(
            jsonEncode({"message": "No cookies found", "statusCode": 401}),
            401);
      }
      final response = await http.delete(
        Uri.parse("$baseUrl/items/$itemId/report"),
        headers: {"Content-Type": "application/json", "Cookie": cookie},
      );
      return response; //  Undo report of post with post id id
    } catch (e) {
      return http.Response(
          jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}),
          500);
    }
  }
}
