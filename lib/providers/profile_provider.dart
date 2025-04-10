import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:io';

class ProfileProvider extends ChangeNotifier {
  String name;
  String phoneNumber, address, designation;
  int rollNumber;
  int id;
  String email;
  String? playerId;
  File? profileImg;

  Future<void> _fetchAndSavePlayerId() async {
    // Fetch OneSignal player ID
    String? fetchedPlayerId = await OneSignal.User.pushSubscription.id;
    print("playerId : $fetchedPlayerId");

    if (fetchedPlayerId != null && fetchedPlayerId != playerId) {
      playerId = fetchedPlayerId;
      notifyListeners();

      // Update in DB
      // await FirebaseFirestore.instance.collection("users").doc(_id).update({
      //   'playerId': _playerId,
      // });
    }
  }

  ProfileProvider(
      {this.name = '',
      this.address = '',
      this.designation = '',
      this.phoneNumber = '',
      this.rollNumber = 0,
      this.id = 0,
      this.playerId,
      this.email = '',
      this.profileImg = null});

  void setName({required String name}) async {
    this.name = name;
    notifyListeners();
  }

  void setId({required int id}) async {
    this.id = id;
    notifyListeners();
  }

  void setProfile({
    required String name,
    String address = '',
    String designation = '',
    String phoneNumber = '',
    String email = '',
    int rollNumber = 0,
    File? profileImg,
    bool isOnline = false,
    int id = 0,
  }) async {
    this.name = name;
    this.address = address;
    this.designation = designation;
    this.phoneNumber = phoneNumber;
    this.email = email;
    this.rollNumber = rollNumber;
    this.id = id;
    this.profileImg;
    this.playerId = playerId;
    // Fetch and save player ID
    await _fetchAndSavePlayerId();
    notifyListeners();
  }

  void reset() {
    name = '';
    address = '';
    phoneNumber = '';
    email = '';
    rollNumber = 0;
    profileImg = null;
    playerId = '';
    notifyListeners();
  }
}
