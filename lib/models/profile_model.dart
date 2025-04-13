import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';

class ProfileModel {
  String name;
  int id;
  String phoneNumber, address, email;
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
    this.id = 0
  });

  

  // save image
  static Future<File> saveProfileImage(Uint8List bytes, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    return await file.writeAsBytes(bytes);
  }

  Future<Map<String, dynamic>> toJson() async {
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

  static Future<ProfileModel> fromJson(Map<String, dynamic> json) async{
    // Safely parse optional values and image URL
    return ProfileModel(
      name: json['name'] as String,
      id: json['id'] as int,
      address: json['address'] as String,
      designation: json['designation'] != '' ? json['designation'] as String : 'Student',
      phoneNumber: json['phone'] as String? ?? '',
      email: json['email'] as String,
      rollNumber: json['roll'] as int? ?? 0,
      profileImage:
          json['image'] != null && (json['image'] as String).isNotEmpty
              ? await saveProfileImage(base64Decode(json['image']), 'item ${json['id']}')
              : null,
      playerId: json['playerId'] as String,
      isOnline: json['online'] as bool
    );
  }
}
