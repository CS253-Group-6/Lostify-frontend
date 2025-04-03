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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _passwordErrorMessage;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        setState(() {
          _passwordErrorMessage = 'Passwords do not match!';
        });
      } else {
        setState(() {
          _passwordErrorMessage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password changed successfully',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.blue, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
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
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Admin Login.png"),
              fit: BoxFit.fill,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                  height: 20), // Reduced spacing since we have app bar
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputLabel("Old Password"),
                    const SizedBox(height: 10),
                    inputField(_oldPasswordController, "Enter Old Password"),
                    const SizedBox(height: 15),
                    inputLabel("New Password"),
                    const SizedBox(height: 10),
                    inputField(_newPasswordController, "Enter New Password"),
                    const SizedBox(height: 15),
                    inputLabel("Confirm Password"),
                    const SizedBox(height: 10),
                    inputField(_confirmPasswordController, "Confirm Password"),
                    if (_passwordErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _passwordErrorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputLabel(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

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
        } else if (hintText == 'Confirm Password' &&
            _newPasswordController.text != _confirmPasswordController.text) {
          return 'Passwords do not match!';
        }
        return null;
      },
    );
  }
}
