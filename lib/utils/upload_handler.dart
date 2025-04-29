import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

class UploadHandler {

  static Future<String> _uploadImageToCloudinary(String path) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/drd9vsdwo/upload");
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'lostify'
      ..files.add(await http.MultipartFile.fromPath('file', path));
    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = utf8.decode(responseData);
    final jsonMap = jsonDecode(responseString);
    return jsonMap['url'];
  }

  static Future<void> deleteImageFromCloudinary(String imageUrl) async {
    try {
      final publicId = imageUrl.split('/').last.split('.').first;
      final url =
          Uri.parse("https://api.cloudinary.com/v1_1/drd9vsdwo/image/destroy");
      const apiKey = '118881179379793';
      const apiSecret = 'U15kELYkke0rZp0pug5nxOGrF30';
      // Generate timestamp
      final timestamp =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      // Generate signature
      // Signature is SHA-1 hash of public_id + timestamp + api_secret
      final signatureString =
          'public_id=$publicId&timestamp=$timestamp$apiSecret';
      final signature = sha1.convert(utf8.encode(signatureString)).toString();

      final request = http.MultipartRequest('POST', url)
        ..fields['public_id'] = publicId
        ..fields['api_key'] = apiKey
        ..fields['api_secret'] = apiSecret
        ..fields['signature'] = signature
        ..fields['timestamp'] = timestamp;

      final response = await request.send();
      if (response.statusCode != 200) {
        final responseData = await response.stream.toBytes();
        final responseString = utf8.decode(responseData);
        print('Failed to delete image from Cloudinary: $responseString');
      }
    } catch (e) {
      print("Error deleting image from cloudinary : $e");
    }
  }

  static Future<String> handleUpload(ImagePicker picker, String type) async {
    // get the image in XFile format
    XFile? image;
    if (type == "gallery") {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await picker.pickImage(source: ImageSource.camera);
    }

    if (image != null) {
      // generate unique id for each image of some random string
      // String fileName = Uuid().v1();

      // get the image file
      final File file = File(image.path);

      String imageURL = await _uploadImageToCloudinary(file.path);
      print(imageURL);
      return imageURL;
    }

    // Handle the case where no image is selected
    throw Exception("No image selected for upload.");
  }

  

}
