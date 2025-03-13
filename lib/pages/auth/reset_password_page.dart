import 'package:final_project/components/auth/auth_input.dart';
import 'package:final_project/components/auth/custom_auth_button.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();

  void handleResetPassword(){

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
              color: Color(0xFF45BBDD).withOpacity(0.4),
              image: DecorationImage(
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
              SizedBox(height: 51,),
              Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0),
                      child: Text(
                        "Reset your password!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 24,),
                    Center(
                      child: IntrinsicHeight(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Input(textController: _emailController,hintText: "Enter email",showEyeIcon: false,),
                              SizedBox(height: 24,),

                              Custombutton(text: "Reset Password",onClick: handleResetPassword,)
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
