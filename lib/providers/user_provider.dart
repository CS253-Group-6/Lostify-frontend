import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  String email;
  UserProvider({this.email = ''});

  void setEmail({required String newEmail}) async{
    email = newEmail;
    notifyListeners();
  }

}