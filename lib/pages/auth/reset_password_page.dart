import 'package:final_project/services/auth_api.dart';
import 'package:flutter/material.dart';

import '../../components/auth/auth_input.dart';
import '../../components/auth/custom_auth_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _usernameController = TextEditingController();

  void handleResetPassword() async {
    if (_usernameController.text.isNotEmpty) {
      final response = await AuthApi.resetPassword(_usernameController.text);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password reset successfully.Please check your mail',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.blue, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
        );

        Navigator.pushReplacementNamed(context, '/user/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to reset password',
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
            'Please enter your username!',
            style: TextStyle(color: Colors.white), // Text color
          ),
          backgroundColor: Colors.red, // Custom background color
          duration: Duration(seconds: 3), // Display duration
        ),
      );
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
                        "Reset your password!",
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
                          child: Column(
                            children: [
                              Input(
                                textController: _usernameController,
                                hintText: "Enter CC username",
                                showEyeIcon: false,
                              ),
                              const SizedBox(height: 24),
                              Custombutton(
                                text: "Reset Password",
                                onClick: handleResetPassword,
                              ),
                            ],
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
