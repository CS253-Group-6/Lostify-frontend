import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  String email;
  int id;
  UserProvider({this.email = '',this.id = 0});

  void setEmail({required String newEmail}) async{
    email = newEmail;
    notifyListeners();
  }
  void setId({required int id}) async{
    this.id = id;
    notifyListeners();
  }

}