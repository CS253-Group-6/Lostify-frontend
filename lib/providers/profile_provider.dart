import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  String name;
  String phoneNumber, address, designation;
  int rollNumber;
  int id;
  String email;
  String? playerId;
  ImageProvider profileImg;
  
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
      this.profileImg = const AssetImage('assets/images/bg1.png')
      });

  void setName({required String name}) async {
    this.name = name;
    notifyListeners();
  }

  void setProfile({
    required String name,
    String address = '',
    String designation = '',
    String phoneNumber = '',
    String email = '',
    int rollNumber = 0,
    ImageProvider? profileImg,
    int id = 0,

  }) async {
    this.name = name;
    this.address = address;
    _fetchAndSavePlayerId();
    notifyListeners();
  }
}
