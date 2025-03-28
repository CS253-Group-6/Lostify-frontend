import "dart:io";
import "package:final_project/models/profile_model.dart";
import "package:final_project/models/user_model.dart";
import "package:final_project/services/auth_api.dart";

import "/providers/profile_provider.dart";

import "/components/auth/custom_auth_button.dart";
import "/components/profile/profile_form_input.dart";
import "/pages/auth/confirmation_code.dart";
import "/providers/user_provider.dart";
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import "package:provider/provider.dart";

class ProfileForm extends StatefulWidget {
  final User user;
  const ProfileForm({super.key,required this.user});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      ProfileModel profileData = ProfileModel(
        name: _nameController.text, 
        address: _addressController.text,
        designation: _designationController.text,
        rollNumber: _rollNoController.text,
        phoneNumber: _phoneController.text
        );

      var signUpDetails = {
        "username": widget.user.username,
        "password": widget.user.password,
        "profile": profileData.toJson(),
      };
      var response = await AuthApi.signUp(signUpDetails);
      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful!!")));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
      }
      context.read<ProfileProvider>().setProfile(
          name: _nameController.text,
          id: 1);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ConfirmationCode()));
    }
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    // if (!status.isGranted) {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          print(_image);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/Admin Login.png"),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Create Profile",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ProfileFormInput(
                            label: "Name",
                            hintText: "Enter Name",
                            controller: _nameController,
                            validate: true,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ProfileFormInput(
                            label: "Phone Number",
                            hintText: "Enter Contact number",
                            controller: _phoneController,
                            validate: true,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ProfileFormInput(
                            label: "Campus address",
                            hintText: "Enter campus address",
                            controller: _addressController,
                            validate: true,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ProfileFormInput(
                            label: "Designation",
                            hintText: "Enter Designation",
                            controller: _designationController,
                            validate: false,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          ProfileFormInput(
                            label: "PF/Roll No.",
                            hintText: "Enter PF/Roll number",
                            controller: _rollNoController,
                            validate: false,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Upload Profile pic",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _image != null
                                        ? Text(
                                            "Selected File: ${_image!.path.split('/').last}")
                                        : Text("No file selected"),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: _pickImage,
                                      child: Text("Choose File"),
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Color(0xFF32ADE6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Custombutton(text: "Get OTP", onClick: handleSubmit)
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
