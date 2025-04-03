import 'package:flutter/material.dart';

import 'found_item_page3.dart';

class FoundItemPage2 extends StatelessWidget {
   Map<String, dynamic> postDetails1;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  FoundItemPage2({super.key,required this.postDetails1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            image: AssetImage("assets/images/new_background.png"), // Updated background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Title and Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Title",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Change hint text color
                      fontSize: 15, // Change hint text size
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Found item Description",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey, // Change hint text color
                      fontSize: 15, // Change hint text size
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
                const SizedBox(height: 250),
                ElevatedButton(
                  onPressed: () {
                    try {
                      // Ensure controllers are not empty
                      if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                        throw Exception("Title and Description cannot be empty.");
                      }



                      Map<String,dynamic> postDetails2 = {
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'image': postDetails1['image']
                      };

                      // Navigate to next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoundItemPage3(postDetails2: postDetails2),
                        ),
                      );

                    } catch (e) {
                      // Show error message in a SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString(), style: TextStyle(color: Colors.white)),
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
      ),
    );
  }
}