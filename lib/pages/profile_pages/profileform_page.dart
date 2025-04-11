import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import "package:provider/provider.dart";

import "../../components/auth/custom_auth_button.dart";
import "../../components/profile/profile_form_input.dart";
import "../../models/profile_model.dart";
import "../../models/user_model.dart";
import "../../pages/auth/confirmation_code.dart";
import "../../providers/profile_provider.dart";
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

  // bool for is submitting
  bool _isSubmitting = false;

  void handleSubmit() async {
    // validate the form details filled
    if (_formKey.currentState!.validate()) {
      // final userProvider = Provider.of<UserProvider>(context, listen: false);

      // collect the profile details data
      ProfileModel profileData = ProfileModel(
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          designation: _designationController.text.trim(),
          rollNumber: int.tryParse(_rollNoController.text),
          phoneNumber: _phoneController.text.trim(),
          email: widget.user.email.trim(),
          profileImage: _image);

      // create a Json data compatible with signup api request body
      Map<String, dynamic> signUpDetails = {
        "username": widget.user.username,
        "password": widget.user.password,
        "profile": await profileData.toJson(),
      };
      print('signUp details:');
      print(signUpDetails);
      print('image: ${signUpDetails['image'] == null}');

      setState(() {
        _isSubmitting = true;
      });
      // api call to signup
      final response = await AuthApi.signUp(signUpDetails);
      print(response.statusCode);
      print(response.body);

      // on successfull signup
      if (response.statusCode >= 201 && response.statusCode < 210) {
        // store the profile details into the provider
        context.read<ProfileProvider>().setProfile(
            name: _nameController.text.trim(),
            address: _addressController.text.trim(),
            email: widget.user.email.trim(),
            designation: _designationController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            rollNumber: int.parse(_rollNoController.text),
            profileImg: _image != null ? _image! : null);
        setState(() {
          _isSubmitting = false;
        });
        // show a snack bar with success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'OTP sent successfully!',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.blue, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
        );

        // navigate to confirmation code page with signup details
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ConfirmationCode(signUpDetails: signUpDetails)));
      } else {
        print(jsonDecode(response.body)['message']);
        // show a snack bar with error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Error signing up: ${jsonDecode(response.body)['message']}",
                style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red, // Custom background color
            duration: Duration(seconds: 3), // Display duration
                )
                );
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length(); // Get file size in bytes

        // Check if the file size exceeds 10 MB (10 * 1024 * 1024 bytes)
        if (fileSize > 10 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "File size exceeds 10 MB. Please upload a smaller file."),
              backgroundColor: Colors.red,
            ),
          );
          return; // Do not set the image if it exceeds the size limit
        }

        setState(() {
          _image = file; // Set the image if the size is valid
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred while picking the image."),
          backgroundColor: Colors.red,
        ),
      );
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
                                  // Display the selected image in a small square box
                                  if (_image != null)
                                    Container(
                                      width: 70, // Set the width of the box
                                      height: 70, // Set the height of the box
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey), // Add a border
                                        borderRadius: BorderRadius.circular(
                                            8), // Optional rounded corners
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            8), // Match the box's rounded corners
                                        child: Image.file(
                                          _image!,
                                          fit: BoxFit
                                              .contain, // Ensure the entire image is visible within the box
                                        ),
                                      ),
                                    )
                                  else
                                    const Text("No file selected"),
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
                        Custombutton(
                            text: _isSubmitting ? "Getting OTP..." : "Get OTP",
                            onClick: _isSubmitting ? () => null : handleSubmit),
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
