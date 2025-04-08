import 'dart:convert';
import 'dart:io';

import 'package:final_project/pages/home_page/home_interface.dart';
import 'package:final_project/providers/profile_provider.dart';
import 'package:final_project/services/auth_api.dart';
import 'package:final_project/services/profile_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/auth/auth_input.dart';
import '../../components/auth/custom_auth_button.dart';
import '../../providers/user_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void handleReset() {
    Navigator.of(context).pushNamed('/reset-password');
  }

  void handleSubmit() async {
    if (_loginKey.currentState!.validate()) {
      // collect login details i.e username,password
      var loginDetails = {
        "username": _usernameController.text.trim(),
        "password": _passwordController.text.trim()
      };

      // api call for login
      final response = await AuthApi.login(loginDetails);
      print(response.body);
      print(response.statusCode);

      if (jsonDecode(response.body)['role'] == 1) {
        // user is admin
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You are admin! Please use Admin Login',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.red, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeInterface()));
        return;
      }
      // if successfull login
      if (response.statusCode >= 200 && response.statusCode < 210) {
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

          // get profile details form userId
          final profileResponse = await ProfileApi.getProfileById(userId);
          print(profileResponse.body);

          // save image
          Future<File> saveProfileImage(
              Uint8List bytes, String filename) async {
            final directory = await getApplicationDocumentsDirectory();
            final file = File('${directory.path}/$filename');
            return await file.writeAsBytes(bytes);
          }

          // write the current logged in user's profile details into Profile Provider
          context.read<ProfileProvider>().setProfile(
              name: jsonDecode(profileResponse.body)['name'],
              id: userId,
              address: jsonDecode(profileResponse.body)['address'],
              designation: jsonDecode(profileResponse.body)['designation'],
              phoneNumber: jsonDecode(profileResponse.body)['phone'],
              email: jsonDecode(profileResponse.body)['email'],
              rollNumber: jsonDecode(profileResponse.body)['roll'],
              profileImg: jsonDecode(profileResponse.body)['image'] != null
                  ? await saveProfileImage(
                      base64Decode(jsonDecode(profileResponse.body)['image']),
                      'profile${userId}.jpg')
                  : null);
          print(profileResponse.body);
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

        // Navigator.of(context).pushReplacementNamed('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error logging in: ${jsonDecode(response.body)['message']}',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.red, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
        );

        // Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          decoration: BoxDecoration(
              color: Color(0xFF45BBDD).withValues(alpha: 0.4),
              image: const DecorationImage(
                  image: AssetImage("assets/images/Admin Login.png"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Image.asset(
                "assets/images/items.png",
                width: 452,
                height: 271,
              ),
              const SizedBox(height: 51),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                      child: const Text(
                        "Welcome User!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: IntrinsicHeight(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          width: double.infinity,
                          child: Form(
                            key: _loginKey,
                            child: Column(
                              children: [
                                Input(
                                  textController: _usernameController,
                                  hintText: "Enter your IITK username",
                                  showEyeIcon: false,
                                ),
                                const SizedBox(height: 16),
                                Input(
                                  textController: _passwordController,
                                  hintText: "Enter Password",
                                  showEyeIcon: true,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  // margin: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                                  child: GestureDetector(
                                    onTap: handleReset,
                                    child: const Text(
                                      "Forgot password?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Color(0xFF007AFF),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Custombutton(
                                  text: "Login",
                                  onClick: handleSubmit,
                                ),
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
