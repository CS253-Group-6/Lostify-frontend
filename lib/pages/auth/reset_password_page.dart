import 'package:flutter/material.dart';

import '../../components/auth/auth_input.dart';
import '../../components/auth/custom_auth_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();

  void handleResetPassword(){
    Navigator.pushReplacementNamed(context, '/user/login');
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
                fit: BoxFit.cover
              )
          ),
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
                                textController: _emailController,
                                hintText: "Enter email",
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
