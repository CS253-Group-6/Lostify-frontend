import "package:flutter/material.dart";

import "../../components/auth/custom_auth_button.dart";
import "../../models/user_model.dart";
import "../../pages/profile_pages/profileform_page.dart";

/// Signup of the application.
/// -----
/// #### Description:
///
/// The signup page has 3 input text fields
/// 1. Username
/// 2. Email
/// 3. Password

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // obscure password 
  bool _isObscuredpassword = true;
  bool _isObscuredConfirmPassword = true;

  // form key
  final _formKey = GlobalKey<FormState>();

  // text editing controllers for username,email,password to get the value in the TextFormFields 
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // create an user object instance
      User user = User(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      // redirect to profile form page
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Registered Successfully!")));
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProfileForm(user: user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/Admin Login.png"),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Create a new account to get started.",
                          style: TextStyle(color: Color(0xFF71727A)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Username",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              // color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color(0xFFC5C6CC), width: 2),
                            ),
                            child: TextFormField(
                              controller: _usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your username";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: 'Username',
                                hintStyle: TextStyle(color: Color(0xFF8F9098)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  // color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color(0xFFC5C6CC),
                                    width: 2,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your email";
                                    }else{
                                      RegExp emailValidate = RegExp(r"^[a-zA-Z0-9._%+-]+@iitk\.ac\.in$");
                                      if (!emailValidate.hasMatch(value)) {
                                        return "Please enter a valid IITK email address";
                                      }
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hintText: 'Email Address',
                                    hintStyle:
                                        TextStyle(color: Color(0xFF8F9098)),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  // color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color(0xFFC5C6CC),
                                    width: 2,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _isObscuredpassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your password";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                        color: Color(0xFF8F9098)),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscuredpassword =
                                              !_isObscuredpassword;
                                        });
                                      },
                                      icon: Icon(_isObscuredpassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  // color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color(0xFFC5C6CC), width: 2),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return "Passwords do not match";
                                    }
                                    return null;
                                  },
                                  obscureText: _isObscuredConfirmPassword,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hintText: 'Confirm Password',
                                    hintStyle: const TextStyle(
                                        color: Color(0xFF8F9098)),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isObscuredConfirmPassword =
                                                !_isObscuredConfirmPassword;
                                          });
                                        },
                                        icon: _isObscuredConfirmPassword
                                            ? const Icon(Icons.visibility_off)
                                            : const Icon(Icons.visibility)),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Custombutton(text: "Sign Up", onClick: handleSubmit)
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
