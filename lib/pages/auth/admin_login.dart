import 'dart:convert';

import 'package:final_project/services/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/auth/auth_input.dart';
import '../../components/auth/custom_auth_button.dart';
import '../../providers/user_provider.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => AdminLoginState();
}

class AdminLoginState extends State<AdminLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _adminKey = GlobalKey<FormState>();

  void handleSubmit() async {
    if (_adminKey.currentState!.validate()) {
      context
          .read<UserProvider>()
          .setUserName(newUsername: _usernameController.text.trim());
      var adminLoginDetails = {
        "username": _usernameController.text.trim(),
        "password": _passwordController.text.trim()
      };

      final response = await AuthApi.login(adminLoginDetails);
      if (response.statusCode == 200) {
        // set user name into userprovider
        context
            .read<UserProvider>()
            .setUserName(newUsername: _usernameController.text.trim());
        // Extract cookies from the response headers
        final cookie = response.headers['set-cookie'];
        print('Cookies: $cookie');
        final prefs = await SharedPreferences.getInstance();

        if (cookie != null) {
          // Save the cookies to shared preferences
          // await prefs.setString('cookies', cookie);
          // Parse user_id and user_role from the cookies
          final int userId = jsonDecode(response.body)['id'];
          final int userRole = jsonDecode(response.body)['role'];

          print('User ID: $userId');
          // print('User Role: $userRole');

          // save userId into UserProvier
          context.read<UserProvider>().setId(id: userId);
          print(Provider.of<UserProvider>(context, listen: false).userId);

          print('logged in user profile details: with id: $userId');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Logged in successfully!',
                style: TextStyle(color: Colors.white), // Text color
              ),
              backgroundColor: Colors.blue, // Custom background color
              duration: Duration(seconds: 3), // Display duration
            ),
          );

          Navigator.of(context).pushReplacementNamed('/home',
              arguments: {'user_id': userId, 'user_role': userRole});
        } else {
          print('No cookies found in the response.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid Credentials, Please try again!',
                style: TextStyle(color: Colors.white), // Text color
              ),
              backgroundColor: Colors.red, // Custom background color
              duration: Duration(seconds: 3), // Display duration
            ),
          );
        }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid credentials!',
                style: TextStyle(color: Colors.white), // Text color
              ),
              backgroundColor: Colors.red, // Custom background color
              duration: Duration(seconds: 3), // Display duration
            ),
          );
        }
      }

      // Navigator.of(context).pushReplacementNamed('/home');
    }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: BoxDecoration(
              color: Color(0xFF45BBDD).withValues(alpha: 0.4),
              image: DecorationImage(
                image: AssetImage("assets/images/Admin Login.png"),
                fit: BoxFit.cover,
              )),
          child: Column(
            children: [
              Image.asset(
                "assets/images/items.png",
                width: 452,
                height: 271,
              ),
              SizedBox(height: 51),
              Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                      child: Text(
                        "Welcome Admin!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: IntrinsicHeight(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          width: double.infinity,
                          child: Form(
                            key: _adminKey,
                            child: Column(
                              children: [
                                Input(
                                  textController: _usernameController,
                                  hintText: "Enter your IITK username",
                                  showEyeIcon: false,
                                ),
                                SizedBox(height: 16),
                                Input(
                                  textController: _passwordController,
                                  hintText: "Enter Password",
                                  showEyeIcon: true,
                                ),
                                SizedBox(height: 16),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  // margin: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                                  child: Text(
                                    "Forgot password?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Color(0xFF007AFF),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                SizedBox(height: 24),
                                Custombutton(
                                  text: "Login",
                                  onClick: handleSubmit,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
