
import 'package:final_project/pages/login.dart';
import 'package:final_project/pages/AdminLogin.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    initialRoute: '/admin/login',
    routes: {
      '/user/login': (context)=> Login(),
      '/admin/login': (context) => AdminLogin()
    },
  ));
}