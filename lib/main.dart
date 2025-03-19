import 'package:final_project/pages/auth/reset_password_page.dart';
import 'package:final_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:final_project/pages/auth/signup.dart';
import 'package:final_project/pages/auth/user_login.dart';
import 'package:final_project/pages/auth/admin_login.dart';
import 'package:final_project/pages/profile_pages/profileform_page.dart';
import 'package:final_project/pages/auth/confirmation_code.dart';
import 'package:provider/provider.dart';
import 'pages/found_item_pages/found_item_page1.dart';
import 'pages/lost_found_post_list/found_item.dart';
import 'pages/lost_found_post_list/lost_item.dart';
import 'pages/found_item_pages/found_item_page2.dart';
import 'pages/found_item_pages/found_item_page3.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // Register UserProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/found/post/1',
      routes: {
        // auth routes
        '/user/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/admin/login': (context) => AdminLogin(),
        '/confirm-code': (context) => ConfirmationCode(),
        '/reset-password': (context) => ResetPasswordPage(),

        // profile routes
        '/create-profile': (context) => ProfileForm(),
        // '/profile-dashboard' : (context) => , // profile_dashboard page
        //
        // // home pages
        // '/': (context) => , // home interface
        // '/home': (context) => , // home page
        //
        // // lost item routes
        // '/lost/post/1' : (context) => , //lost postpage 1
        // '/lost/post/2' : (context) => , //lost postpage 2
        '/lost-items' : (context) => LostItem(), // lost_page
        //
        // // found items routes
        '/found/post/1' : (context) => FoundItemPage1(), // found post page1
         '/found/post/2' : (context) => FoundItemPage2(), // found post page2
         '/found/post/3' : (context) => FoundItemPage3(), // found post page3
         '/found-items': (context) => FoundItem(), // found_items
        //
        // // others
        // '/about' : (context) => , // about us page
        // '/notifications' : (context) => , //notifications
        // '/search' : (context) => , //search_page
      },
    );
  }
}
