import 'dart:io';
import 'package:final_project/providers/profile_provider.dart';
import 'package:final_project/providers/user_provider.dart';
import 'package:final_project/services/profile_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EditProfilePage(),
  ));
}

// Stateful Widget for the Edit Profile Page
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();

  File? _imageFile; // Variable to store the profile image

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to save the profile details
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profileData = {
        "name": _nameController.text,
        "phoneNumber": _phoneController.text,
        "address": _addressController.text,
        "designation": _designationController.text,
        "rollNumber": _rollNumberController.text,
        "profileImage": _imageFile,
        "email": Provider.of<ProfileProvider>(context, listen: false).email
      };
      print(profileData);
      /*
    // Save the profile data to the database or API
    try {
      int userId = Provider.of<UserProvider>(context, listen: false).userId;
      final response = await ProfileApi.editProfile(userId, profileData);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile Updated successfully!',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.blue, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update profile!',
              style: TextStyle(color: Colors.white), // Text color
            ),
            backgroundColor: Colors.red, // Custom background color
            duration: Duration(seconds: 3), // Display duration
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: TextStyle(color: Colors.white), // Text color
          ),
          backgroundColor: Colors.red, // Custom background color
          duration: Duration(seconds: 3), // Display duration
        ),
      );
    }
    */
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile Updated successfully!',
            style: TextStyle(color: Colors.white), // Text color
          ),
          backgroundColor: Colors.blue, // Custom background color
          duration: Duration(seconds: 3), // Display duration
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a back button and title
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Background Image
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/images/Admin Login.png"), // Background image

            fit: BoxFit.cover,
          ),
        ),

        // Makes the content scrollable to avoid keyboard overflow issues
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),

                        // Profile Image Selection
                        Text(
                          "Profile Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : null,
                            child: _imageFile == null
                                ? Icon(Icons.camera_alt, size: 50)
                                : null,
                          ),
                        ),
                        // hardcoded
                        // GestureDetector(
                        //   onTap: _pickImage,
                        //   child: CircleAvatar(
                        //     radius: 50,
                        //     backgroundImage: _imageFile != null
                        //         ? FileImage(_imageFile!)
                        //         : AssetImage('assets/images/profile_hardcoded.png') as ImageProvider,
                        //   ),
                        // ),
                        SizedBox(height: 20),

                        // Form Fields
                        Container(
                          width: double.infinity,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabelText("Edit Name"),
                                _buildTextField(_nameController, "Name"),
                                _buildLabelText("Edit Phone Number"),
                                _buildTextField(_phoneController,
                                    "Phone Number", TextInputType.phone),
                                _buildLabelText("Edit Campus Address"),
                                _buildTextField(
                                    _addressController, "Campus Address"),
                                _buildLabelText("Edit Designation"),
                                _buildTextField(
                                    _designationController, "Designation"),
                                _buildLabelText("Edit Roll Number"),
                                _buildTextField(
                                    _rollNumberController, "Roll Number"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Save Button
                        ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: Text("Save Changes"),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to build a label for input fields
  Widget _buildLabelText(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  // Function to build text input fields
  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType? type]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (!(value == null || value.isEmpty) && label == 'Roll Number') {
            RegExp rollExp = RegExp(r'^[0-9]+$');
            if (!rollExp.hasMatch(value)) {
              return 'Enter a valid numeric PF/Roll No.';
            }
            return null;
          }
          if (!(value == null || value.isEmpty) && label == 'Phone Number') {
            RegExp phoneExp = RegExp(r'^[0-9]{10}$');
            if (!phoneExp.hasMatch(value)) {
              return 'Enter a valid 10 digit $label';
            }
            return null;
          }
          return null;
        },
        keyboardType: type ?? TextInputType.text,
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          filled: true,
          fillColor: Colors.white.withOpacity(0.4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
