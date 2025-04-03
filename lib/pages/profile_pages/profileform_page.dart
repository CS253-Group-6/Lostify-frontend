import "dart:io";

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import "package:provider/provider.dart";

import "../../components/auth/custom_auth_button.dart";
import "../../components/profile/profile_form_input.dart";
import "../../pages/auth/confirmation_code.dart";
import "../../providers/profile_provider.dart";
import "../../models/profile_model.dart";
import "../../models/user_model.dart";
import "../../services/auth_api.dart";

/// Create Profile Page of the application.
/// -----
/// #### Description:
///
/// The Profile Form page has 5 input text fields
/// 1. Name                                      --- required
/// 2. Phone Number                              --- required
/// 3. Campus address                            --- required
/// 4. Designation i.e. Student / Faculty        --- optional
/// 5. PF/Roll No. (IITK roll number)            --- optional
/// 6. Profile Picture                           --- optional
///

class ProfileForm extends StatefulWidget {
  // get user details from signup page
  final User user;
  const ProfileForm({super.key, required this.user});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  // controllers to handle the value of text in TextFormField
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();

  void handleSubmit() async {
    // validate the form details filled
    if (_formKey.currentState!.validate()) {
      // final userProvider = Provider.of<UserProvider>(context, listen: false);

      // collect the profile details data
      ProfileModel profileData = ProfileModel(
          name: _nameController.text,
          address: _addressController.text,
          designation: _designationController.text,
          rollNumber: int.tryParse(_rollNoController.text),
          phoneNumber: _phoneController.text,
          email: widget.user.email,
          profileImage: _image);

      // create a Json data compatible with signup api request body
      Map<String, dynamic> signUpDetails = {
        "username": widget.user.username,
        "password": widget.user.password,
        "profile": await profileData.toJson(),
      };
      print('signUp details:');
      print(signUpDetails);
      // api call to signup
      /*
      var response = await AuthApi.signUp(signUpDetails);

      // on successfull signup
      if (response['statusCode'] == 200) {
        // store the profile details into the provider
        context.read<ProfileProvider>().setProfile(
              name: _nameController.text,
              address: _addressController.text,
              email: widget.user.email,
              designation: _designationController.text,
              phoneNumber: _phoneController.text,
              rollNumber: int.parse(_rollNoController.text),
              profileImg: _image != null ? FileImage(_image!) : AssetImage('assets/images/bg1.png')
            );

        // show a snack bar with success message
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Signup successful!!")));

        // navigate to confirmation code page with signup details
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ConfirmationCode(signUpDetails: signUpDetails)));
      } else {
        // show a snack bar with error message
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error signing up: ${response['message']}")));
            // TODO: on failure do not redirect.
            Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ConfirmationCode(signUpDetails: signUpDetails)));
      } */

     // TODO: comment this after intergration with backend and uncomment the upper part
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ConfirmationCode(signUpDetails: signUpDetails)));
    }
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/Admin Login.png"),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Column(
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
                  const SizedBox(height: 24),
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
                        const SizedBox(height: 8),
                        ProfileFormInput(
                          label: "Phone Number",
                          hintText: "Enter Contact number",
                          controller: _phoneController,
                          validate: true,
                        ),
                        const SizedBox(height: 8),
                        ProfileFormInput(
                          label: "Campus address",
                          hintText: "Enter campus address",
                          controller: _addressController,
                          validate: true,
                        ),
                        const SizedBox(height: 8),
                        ProfileFormInput(
                          label: "Designation",
                          hintText: "Enter Designation",
                          controller: _designationController,
                          validate: false,
                        ),
                        const SizedBox(height: 8),
                        ProfileFormInput(
                          label: "PF/Roll No.",
                          hintText: "Enter PF/Roll number",
                          controller: _rollNoController,
                          validate: false,
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Upload Profile pic",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _image != null
                                      ? Text(
                                          "Selected File: ${_image!.path.split('/').last}")
                                      : const Text("No file selected"),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _pickImage,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xFF32ADE6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    child: const Text("Choose File"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Custombutton(text: "Get OTP", onClick: handleSubmit),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
