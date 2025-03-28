import 'dart:convert';
import '/models/item_model.dart';
import 'package:http/http.dart' as http;

class ItemsApi{
  static const String baseUrl = "http://127.0.0.1:5000";

  // LostItem api call
  static Future<Map<String,dynamic>> lostitem(Item item) async{
    final response = await http.post(
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
  // static Future<Map<String,dynamic>> founditem(Item item) async{
  //   item.found();
  //   final response = await http.post(
  //     Uri.parse("$baseUrl/foundAnItem/page3"),
  //     headers: {
  //       "Content-Type": "application/json"
  //     },
  //     body: jsonEncode(item.toJson())
  //   );
  //   if (response.statusCode == 200 || response.statusCode == 401) {
  //     return jsonDecode(response.body);//check status codes
  //   }
  //
  //   return {"message": "Unexpected error", "statusCode": 500};
  // }
}
