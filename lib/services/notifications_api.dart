import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:final_project/main.dart';

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

}