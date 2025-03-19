import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
class ImageUploadBox extends StatefulWidget {
  final Function(File) onImageSelected;//this is a callback fn
  const ImageUploadBox({super.key,required this.onImageSelected});

  @override
  ImageUploadBoxState createState() => ImageUploadBoxState();
}

class ImageUploadBoxState extends State<ImageUploadBox> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    // Request gallery permission
    var status = await Permission.photos.request();

    if (status.isGranted) {
      try {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
          widget.onImageSelected(_image!);
        }
      } catch (e) {
        print("Error picking image: $e");
      }
    } else {
      print("Permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 180,
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: _image == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upload_file, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text("Tap to upload image", style: TextStyle(color: Colors.grey)),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(_image!, fit: BoxFit.cover, width: 180, height: 130),
        ),
      ),
    );
  }
}
