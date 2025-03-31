import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  void handleReset(){
    Navigator.of(context).pushNamed('/reset-password');
  }

  void handleSubmit() async{
    if(_loginKey.currentState!.validate()){
      context.read<UserProvider>().setUserName(newUsername: _usernameController.text);
      
      var loginDetails = {
        "username": _usernameController.text,
        "password": _passwordController.text
      };
      // Map<String,dynamic> response = await AuthApi.login(loginDetails);
      // if(response['statusCode'] == 200){
      //   Navigator.of(context).pushReplacementNamed('/');
      // }else{
      //   Navigator.of(context).pushReplacementNamed('/');
      // }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in Successfully!"))
      );
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
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
