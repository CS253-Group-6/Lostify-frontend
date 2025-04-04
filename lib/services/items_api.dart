import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/item_model.dart';

class ItemsApi {
  static const String baseUrl = "https://ktxzz6b2-5000.inc1.devtunnels.ms";

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
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/items/post"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(postDetails),
      );
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // get Item by Id
  static Future<http.Response> getItemById(int itemId) async {
    ///  pass itemId as argument

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items/$itemId"),
      );
      return response; // response data has item details in json form
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
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
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/items/$itemId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(postDetails),
      );
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // delete an item
  static Future<http.Response> deleteItem(int itemId) async {
    ///  pass itemId as argument
    // get the cookies from shared preferences
    final prefs = await SharedPreferences.getInstance();
    //hardcoded cookie
    final cookie = 'session=eyJ1c2VyX2lkIjoyNSwidXNlcl9yb2xlIjoxfQ.Z_BIuA.OsGKJErVnzjgsK6SO4QfToFxFok; HttpOnly; Path=/';// prefs.getString('cookies');
    if (cookie == null) {
      return http.Response(
          jsonEncode({"message": "No cookies found", "statusCode": 401}),
          401);
    }
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/items/$itemId"),
        headers: {"Cookie": cookie},
      );
      return response; // response data has item details in json form
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // get all items
  static Future<List<Map<String, dynamic>>> getAllItems() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items/all"),
      );
      print(jsonDecode(response.body));
      // Parse the response body
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      // Ensure the response is a list of maps
      return jsonResponse
          .map((item) => item as Map<String, dynamic>)
          .toList(); // response data has items list
    } catch (e) {
      return [
        {"message": "Unexpected error: $e", "statusCode": 500}
      ];
    }
  }

  // claim an item
  static Future<http.Response> claimItem(int itemId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items/$itemId/claim"),
      );
      return response; //  Status of claimed post in response body as JSON
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // report an item
  static Future<http.Response> getReportCount(int itemId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items/$itemId/report"),
      );
      return response; //  Report count in response body as JSON
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // report an item
  static Future<http.Response> reportItem(int itemId) async {
    // get the cookies from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final cookie = 'session=eyJ1c2VyX2lkIjoyLCJ1c2VyX3JvbGUiOjB9.Z_A24w.FNsRREbaInK147ygNZrdIA6XsnM; HttpOnly; Path=/';//prefs.getString('cookies');
    if (cookie == null) {
      return http.Response(
          jsonEncode({"message": "No cookies found", "statusCode": 401}),
          401);
    }
    try {
      final response = await http.put(
          Uri.parse("$baseUrl/items/$itemId/report"),
          headers: {"Cookie":cookie}
      );
      return response; //  Report count in response body as JSON
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }

  // delete reports for a post
  static Future<http.Response> deleteReports(int itemId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/items/$itemId/report"),
      );
      return response; //  Undo report of post with post id id
    } catch (e) {
      return http.Response(jsonEncode({"message": "Unexpected error: $e", "statusCode": 500}), 500);
    }
  }
}