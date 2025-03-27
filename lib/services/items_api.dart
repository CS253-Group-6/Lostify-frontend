import 'dart:convert';
import '/models/item_model.dart';
import 'package:http/http.dart' as http;

class AuthApi{
  static const String baseUrl = "http://127.0.0.1:5000";

  // LostItem api call
  static Future<Map<String,dynamic>> lostitem(Item item) async {
  try {
    final response = await http.post(
<<<<<<< HEAD
        Uri.parse("$baseUrl/lostAnItem/page2"),
        headers: {
          "Content-Type": "application/json"
        },
      body: jsonEncode(item.toJson())
    );
    if (response.statusCode == 200 || response.statusCode == 401) {
      return jsonDecode(response.body);//check status codes
    }

    return {"message": "Unexpected error", "statusCode": response.statusCode};
  }

  // FoundItem api call
  static Future<Map<String,dynamic>> founditem(Item item) async{
    // item.found();
    final response = await http.post(
      Uri.parse("$baseUrl/foundAnItem/page3"),
=======
      Uri.parse("$baseUrl/lostAnItem/page2"),
>>>>>>> dba698992e15b222c3dc47c9c82f67923dd5b397
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(item.toJson())
    );

    if (response.statusCode == 200 || response.statusCode == 401) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {
          "message": "Error decoding response body: $e",
          "statusCode": response.statusCode
        };
      }
    } else {
      return {
        "message": "Unexpected error, status code: ${response.statusCode}",
        "statusCode": response.statusCode
      };
    }
  } catch (e) {
    // Handle network errors or other exceptions
    return {
      "message": "Exception occurred: $e",
      "statusCode": 500
    };
  }
}


  // FoundItem api call
  static Future<Map<String,dynamic>> founditem(Item item) async {
  try {
    item.found();
    
    final response = await http.post(
      Uri.parse("$baseUrl/foundAnItem/page3"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 401) {
      // Check if the response body is valid JSON before decoding
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {"message": "Error decoding response body", "statusCode": 500};
      }
    }

    return {"message": "Unexpected error", "statusCode": response.statusCode};
  } catch (e) {
    // Catch errors like network issues or invalid JSON encoding
    return {"message": "Exception occurred: $e", "statusCode": 500};
  }
}
