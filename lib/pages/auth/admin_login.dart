import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/auth/auth_input.dart';
import '../../components/auth/custom_auth_button.dart';
import '../../providers/user_provider.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _adminKey = GlobalKey<FormState>();

  void handleSubmit() async{
    if(_adminKey.currentState!.validate()){
      context.read<UserProvider>().setUserName(newUsername: _usernameController.text);
      var adminLoginDetails = {
        "username": _usernameController.text,
        "password": _passwordController.text
      };
      
      // Map<String,dynamic> response = await AuthApi.login(loginDetails);
      // if (response['statusCode'] == 200) {
      //   Navigator.of(context).pushReplacementNamed('/');
      // } else {
      //   Navigator.of(context).pushReplacementNamed('/');
      // }

      Navigator.of(context).pushReplacementNamed('/home');
    }
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
            )
          ),
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
                                //TODO: add custom button
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
