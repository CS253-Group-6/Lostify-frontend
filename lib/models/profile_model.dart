import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class ProfileModel {
  String name;
  String phoneNumber, address, designation,email;
  int rollNumber;
  File? profileImage;


  ProfileModel({
    required this.name,
    required this.address,
    this.designation = '',
    this.phoneNumber = '',
    this.rollNumber = 0,
    this.email = '',
    this.profileImage,
  });

  Future<Map<String,dynamic>> toJson()async{
    return {
      'name': name,
      'address': address,
      'designation': designation,
      'phoneNumber': phoneNumber,
      'rollNumber': rollNumber,
      'email': email,
      'profileImage': profileImage is FileImage
          ? base64Encode(await (profileImage as FileImage).file.readAsBytes())
          : '',
    };
  }
}
