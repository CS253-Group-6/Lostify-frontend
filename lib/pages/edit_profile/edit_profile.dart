import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EditProfilePage(),
  ));
}

// Stateful Widget for the Edit Profile Page
class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers for input fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  TextEditingController _rollNumberController = TextEditingController();

  File? _imageFile; // Variable to store the profile image

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to save the profile details
  void _saveProfile() {
    print("Profile Saved:");
    print("Name: ${_nameController.text}");
    print("Phone: ${_phoneController.text}");
    print("Campus Address: ${_addressController.text}");
    print("Designation: ${_designationController.text}");
    print("Roll Number: ${_rollNumberController.text}");
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
            image: AssetImage("assets/images/Admin Login.png"), // Background image
            
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
                        SizedBox(height: 20),

                        // Form Fields
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelText("Edit Name"),
                              _buildTextField(_nameController, "Name"),
                              _buildLabelText("Edit Phone Number"),
                              _buildTextField(
                                  _phoneController, "Phone Number", TextInputType.phone),
                              _buildLabelText("Edit Campus Address"),
                              _buildTextField(_addressController, "Campus Address"),
                              _buildLabelText("Edit Designation"),
                              _buildTextField(_designationController, "Designation"),
                              _buildLabelText("Edit Roll Number"),
                              _buildTextField(_rollNumberController, "Roll Number"),
                            ],
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
                            padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      child: TextField(
        controller: controller,
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
