import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String name;
  String email, phoneNumber, address, designation, rollNumber;
  int id;

  ProfileProvider(
      {this.name = '',
      this.email = '',
      this.address = '',
      this.designation = '',
      this.phoneNumber = '',
      this.rollNumber = '',
      this.id = 0});

  void setName({required String name}) async {
    this.name = name;
    notifyListeners();
  }

  void setProfile(
      {required String name,
      required String email,
      String address = '',
      String designation = '',
      String phoneNumber = '',
      int id = 0}) async {
    this.name = name;
    this.email = email;
    this.address = address;
    notifyListeners();
  }
}
