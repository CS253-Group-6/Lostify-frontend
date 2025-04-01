
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChangePasswordPage(),
  ));
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _passwordErrorMessage;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Check if new password and confirm password match
      if (_newPasswordController.text != _confirmPasswordController.text) {
        setState(() {
          _passwordErrorMessage = 'Passwords do not match!';
        });
      } else {
        setState(() {
          _passwordErrorMessage = null; // Clear the error message
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Custom Spacing Variables
    double titleSpacing = screenHeight * 0.05;  // Space after "Change Password"
    double fieldSpacing = screenHeight * 0.025; // Space between input fields
    double buttonSpacing = screenHeight * 0.07; // Space before Submit button

    return Scaffold(
      body: SingleChildScrollView( // Ensures smooth scrolling when keyboard opens
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height, // Ensures full-screen height
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Admin Login.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              Center(
                child: Text(
                  "Change Password",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputLabel("Old Password"),
                    SizedBox(height: 10),
                    inputField(_oldPasswordController, "Enter Old Password"),
                    SizedBox(height: 15),

                    inputLabel("New Password"),
                    SizedBox(height: 10),
                    inputField(_newPasswordController, "Enter New Password"),
                    SizedBox(height: 15),

                    inputLabel("Confirm Password"),
                    SizedBox(height: 10),
                    inputField(_confirmPasswordController, "Confirm Password"),
                    if (_passwordErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _passwordErrorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    SizedBox(height: 30),
                  ],
                ),
              ),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),

                  ),

                ),
              ),

              SizedBox(height: 50), // Bottom padding
            ],
          ),
        ),
      ),
    );

  }

  // Updated inputLabel function to make text bold
  Widget inputLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Bold text
    );
  }

  // Input field for password with validation
  Widget inputField(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.grey),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is required';
        } else if (hintText == 'Confirm Password' && _newPasswordController.text != _confirmPasswordController.text) {
          return 'Passwords do not match!';
        }
        return null;
      },
    );
  }
}
