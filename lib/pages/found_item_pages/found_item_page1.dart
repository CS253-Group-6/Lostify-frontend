import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'found_item_page2.dart';

class FoundItemPage1 extends StatefulWidget {
  const FoundItemPage1({super.key});

  @override
  State<FoundItemPage1> createState() => _FoundItemPage1State();
}

class _FoundItemPage1State extends State<FoundItemPage1> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Found an item', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.blue,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/new_background.png"), // Updated image path
          fit: BoxFit.cover, // Ensures the image covers the screen
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Image",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20), // Consistent spacing
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 30), // Consistent spacing
            ElevatedButton(
              onPressed: () {
                try {
                  // Ensure _image is not null if required
                  if (_image == null) {
                    throw Exception("Please upload an image.");
                  }

                  // Creating postDetails1 Map
                  final Map<String, dynamic> postDetails1 = {
                    'image': _image, // Ensure _image is a valid format
                  };

                  // Navigate to next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoundItemPage2(postDetails1: postDetails1),
                    ),
                  );
                } catch (e) {
                  // Show error message in a SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString(), style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}