import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:final_project/main.dart';
import 'package:http/http.dart' as http;

class NotificationsApi {
  // firebase messaging instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialise() async {
    // get the permission
    await _firebaseMessaging.requestPermission();
    // get the token
    final token = await _firebaseMessaging.getToken();
    // print token
    print("FCM Token $token");
  }

  static Future<void> sendNotification(
      String playerId, String title, String body) async {
    const String oneSignalApiUrl = "https://onesignal.com/api/v1/notifications";
    const String oneSignalRestApiKey = "os_v2_app_bpbjc4wf3vfghbdtseh74kgcrgxfdxtfqgvuxa5yg4vmia6csea43pc7otzqdbzs774huhxaui2jdvsdavghpbxeschk74wdr6ydsuy";

    final Map<String, dynamic> notificationData = {
      "app_id": "0bc29172-c5dd-4a63-8473-910ffe28c289", // Replace with your OneSignal App ID
      "include_player_ids": [playerId],
      "headings": {"en": title},
      "contents": {"en": body},
    };

    final response = await http.post(
      Uri.parse(oneSignalApiUrl),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Basic $oneSignalRestApiKey",
      },
      body: jsonEncode(notificationData),
    );
    if (response.statusCode == 200) {
      print("Notification sent successfully!");
    } else {
      print("Failed to send notification: ${response.body}");
    }
  }
}
