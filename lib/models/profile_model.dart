import 'dart:convert';
import 'dart:io';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ProfileModel {
  String name;
  String phoneNumber, address,email;
  String? designation;
  int? rollNumber;
  File? profileImage;
  String playerId;
  bool isOnline = false;


  ProfileModel({
    required this.name,
    required this.address,
    this.designation = '',
    this.phoneNumber = '',
    this.rollNumber = 0,
    this.email = '',
    this.profileImage,
    this.playerId = '',
    this.isOnline = false,
  }){
    _fetchAndSavePlayerId();
  }

  void _fetchAndSavePlayerId()async{
    // Fetch OneSignal player ID
    String? fetchedPlayerId = await OneSignal.User.pushSubscription.id;
    print("playerId : $fetchedPlayerId");

    if (fetchedPlayerId != null && fetchedPlayerId != playerId) {
      this.playerId = fetchedPlayerId;
    }
  }

  Future<Map<String,dynamic>> toJson() async{
    return {
      'name': name,
      'address': address,
      'designation': designation,
      'phone': phoneNumber,
      'roll': rollNumber,
      'email': email,
      'image': profileImage != null
        ? base64Encode(await profileImage!.readAsBytesSync())
        : '',
      'playerId': playerId,
      'online': isOnline
    };
  }
}
