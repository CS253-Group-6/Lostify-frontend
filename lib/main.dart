import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';
import 'pages/auth/admin_login.dart';
import 'pages/auth/confirmation_code.dart';
import 'pages/auth/reset_password_page.dart';
import 'pages/auth/signup.dart';
import 'pages/auth/user_login.dart';
import 'pages/change_password_pages/change_password.dart';
import 'pages/chat/chat_list.dart';
import 'pages/edit_profile/edit_profile.dart';
import 'pages/found_item_pages/found_item_page1.dart';
import 'pages/home_page/home_interface.dart';
import 'pages/home_page/homepage.dart';
import 'pages/lost_found_post_list/found_item.dart';
import 'pages/lost_found_post_list/lost_item.dart';
import 'pages/lost_item_pages/lost_item_post_page1.dart';
import 'pages/profile_pages/profileform_page.dart';
import 'pages/report_admin_pages/reported_items_page.dart';
import 'pages/search/search_page.dart';
import 'providers/all_items_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/user_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("0bc29172-c5dd-4a63-8473-910ffe28c289");
  OneSignal.Notifications.requestPermission(true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserProvider()), // Register UserProvider
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => AllItemsProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/homeInterface',
      navigatorKey: navigatorKey,
      routes: {
        // auth routes
        '/user/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/admin/login': (context) => AdminLogin(),
        '/confirm-code': (context) => ConfirmationCode(
              signUpDetails: {},
            ),
        '/reset-password': (context) => ResetPasswordPage(),

        // profile routes
        '/create-profile': (context) => ProfileForm(
              user: User(
                  username: "vinay23",
                  email: "vinay23@iitk.ac.in",
                  password: "password"),
            ),
        '/edit-profile': (context) => EditProfilePage(),
        // '/profile-dashboard' : (context) => , // profile_dashboard page

        // home pages
        '/homeInterface': (context) => HomeInterface(), // home interface
        '/home': (context) => HomePage(), // home page
        // '/item-details': (context) => ItemDetails(
        //       itemId: 0,
        //       postOwnerId: 0,
        //       post: Post(
        //           postType: PostType.lost,
        //           id: 0,
        //           title: 'title',
        //           status: 'status',
        //           regDate: DateTime.now()),
        //     ),

        // // lost item routes
        '/lost/post/1': (context) => LostAnItem1(), //lost postpage 1
        // '/lost/post/2': (context) => LostAnItem2(), //lost postpage 2
        '/lost-items': (context) => LostItem(), // lost_page

        // found items routes
        '/found/post/1': (context) => FoundItemPage1(), // found post page1
        //'/found/post/2': (context) => FoundItemPage2(), // found post page2
        //'/found/post/3': (context) => FoundItemPage3(), // found post page3
        '/found-items': (context) => FoundItem(), // found_items

        // chat pages
        '/chat-list': (context) => ChatList(),
        // '/chat-screen': (context) => ChatScreen(
        //       chatDetails: ChatDetails(
        //           senderId: 1,
        //           recieverId: 1,
        //           itemId: 1,
        //           chatRoomId: '8_9',
        //           recieverName: 'Vinay'),
        //     ),
        // edit profile page
        // others
        // '/about' : (context) => , // about us page
        // '/notifications' : (context) => , //notifications
        '/search': (context) => SearchPage(), //search_page
        '/report': (context) => ReportedItemPage(), //reported_items_page
        '/change': (context) => ChangePasswordPage(), //change_password_page
      },
    );
  }
}
