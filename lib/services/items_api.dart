import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/item_model.dart';

class ItemsApi {
  static const String baseUrl = "http://10.0.2.2:5000";

  // Post a lost Item api call
  static Future<Map<String, dynamic>> postItem(
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
        body: {jsonEncode(postDetails)},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // get Item by Id
  static Future<Map<String, dynamic>> getItemById(int itemId) async {
    ///  pass itemId as argument

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items/$itemId"),
      );
      return jsonDecode(
          response.body); // response data has item details in json form
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // edit a post by its id
  static Future<Map<String, dynamic>> editItem(
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
        body: {jsonEncode(postDetails)},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // delete an item
  static Future<Map<String, dynamic>> deleteItem(int itemId) async {
    ///  pass itemId as argument

    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/items/$itemId"),
      );
      return jsonDecode(
          response.body); // response data has item details in json form
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
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
  static Future<Map<String, dynamic>> claimItem(int itemId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items/$itemId/claim"),
      );
      return jsonDecode(
          response.body); //  Status of claimed post in response body as JSON
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // report an item
  static Future<Map<String, dynamic>> getReportCount(int itemId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items/$itemId/report"),
      );
      return jsonDecode(
          response.body); //  Report count in response body as JSON
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // report an item
  static Future<Map<String, dynamic>> reportItem(int itemId) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/items/$itemId/report"),
      );
      return jsonDecode(
          response.body); //  Report count in response body as JSON
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }

  // delete reports for a post
  static Future<Map<String, dynamic>> deleteReports(int itemId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/items/$itemId/report"),
      );
      return jsonDecode(response.body); //  Undo report of post with post id id
    } catch (e) {
      return {"message": "Unexpected error: $e", "statusCode": 500};
    }
  }
}
