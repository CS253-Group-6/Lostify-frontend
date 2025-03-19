import 'dart:io';
import 'package:first_project/components/lost_items/uploadImage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/form_data_provider.dart';

class LostAnItem1 extends StatefulWidget {
  const LostAnItem1({super.key});

  @override
  State<LostAnItem1> createState() => _LostAnItem1State();
}

class _LostAnItem1State extends State<LostAnItem1> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  void _setImage(File image){
    setState(() {
      _image = image;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              "Lost An Item",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          backgroundColor: Colors.lightBlue[300],
          leading: IconButton(onPressed: () {
            Navigator.pushNamed(context, '/lost_an_item/page2');},
            icon: Icon(Icons.arrow_back)),
            ),
            body: Container(
            decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage('assets/bg1.png'),
            fit: BoxFit.cover,
            ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
            children: [
            SizedBox(
            height: 30,
            ),
            Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Align(
            alignment: Alignment.centerLeft,
                    child: const Text(
                      "Add Title and Description",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _titleController,
                    keyboardType: TextInputType.name,
                    // autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      // label: Text("Title"),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Enter Title',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    // autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      // labelText: "Add Description...",
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Add the details of your lost item',
                    ),
                    maxLines: 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Upload Image",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5),
                    child: ImageUploadBox(onImageSelected: _setImage,),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FilledButton(
                  onPressed: () {
                    Map<String, dynamic> formData = {
                      'Title': _titleController.text,
                      'Description': _descriptionController.text,
                      'Image': _image,
                    };
                    Provider.of<FormDataProvider>(context, listen: false)
                        .updateData(formData);
                    Navigator.pushNamed(context, '/lost_an_item/page2');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blueAccent[700],
                    foregroundColor: Colors.white,
                    minimumSize: Size(300, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            )));
  }
}
