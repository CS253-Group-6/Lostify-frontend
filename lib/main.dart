import 'package:final_project/components/home/item_details.dart';
import 'package:final_project/pages/chat/chat_list.dart';
import 'package:final_project/pages/chat/chat_screen.dart';

import '/pages/lost_item_pages/lost_item_post_page1.dart';
import '/pages/lost_item_pages/lost_item_post_page2.dart';
import 'pages/auth/reset_password_page.dart';
import 'providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'pages/auth/signup.dart';
import 'pages/auth/user_login.dart';
import 'pages/auth/admin_login.dart';
import 'pages/profile_pages/profileform_page.dart';
import 'pages/auth/confirmation_code.dart';
import 'package:provider/provider.dart';
import 'pages/found_item_pages/found_item_page1.dart';
import 'pages/lost_found_post_list/found_item.dart';
import 'pages/lost_found_post_list/lost_item.dart';
import 'pages/found_item_pages/found_item_page2.dart';
import 'pages/found_item_pages/found_item_page3.dart';
import 'pages/home_page/homepage.dart';
import 'pages/search_page.dart';

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
      initialRoute: '/search',
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
        
        // home pages
        // '/': (context) => , // home interface
        '/home': (context) => HomePage(), // home page
        '/item-details' : (context) => ItemDetails(),
        
        // // lost item routes
        '/lost/post/1' : (context) => LostAnItem1(), //lost postpage 1
        '/lost/post/2' : (context) => LostAnItem2(), //lost postpage 2
        '/lost-items' : (context) => LostItem(), // lost_page
        
        // found items routes
        '/found/post/1' : (context) => FoundItemPage1(), // found post page1
         '/found/post/2' : (context) => FoundItemPage2(), // found post page2
         '/found/post/3' : (context) => FoundItemPage3(), // found post page3
         '/found-items': (context) => FoundItem(), // found_items
        
        // chat pages
        '/chat-list': (context) => MessagesScreen(),
        '/chat-screen' : (context) => ChatScreen(name: "Vinay"),
        // others
        // '/about' : (context) => , // about us page
        // '/notifications' : (context) => , //notifications
        '/search' : (context) => SearchPage() , //search_page
      },
    );
  }
}
