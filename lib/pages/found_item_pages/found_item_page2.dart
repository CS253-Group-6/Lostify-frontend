import 'package:flutter/material.dart';
import 'found_item_page3.dart';

class FoundItemPage2 extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/new_background.png"), // Updated background image
            fit: BoxFit.cover,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Found an Item",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text("Add Title and Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 10),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Title",
                  hintStyle: TextStyle(
                    color: Colors.grey, // Change hint text color
                    fontSize: 15, // Change hint text size
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
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
                  hintStyle: TextStyle(
                    color: Colors.grey, // Change hint text color
                    fontSize: 15, // Change hint text size
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 270),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FoundItemPage3()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}