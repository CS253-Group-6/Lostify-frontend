import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  String username;
  int id;
  UserProvider({this.username = '',this.id = 0});

  void setUserName({required String newUsername}) async{
    username = newUsername;
    notifyListeners();
  }
  void setId({required int id}) async{
    this.id = id;
    notifyListeners();
  }

}