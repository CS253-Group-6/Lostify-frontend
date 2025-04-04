import 'dart:io';

import 'package:final_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/location/location.dart';
import '../../models/item_model.dart';
import '../../services/items_api.dart';

class LostAnItem2 extends StatefulWidget {
  final Map<String, dynamic> postDetails1;
  const LostAnItem2({super.key, required this.postDetails1});

  @override
  State<LostAnItem2> createState() => _LostAnItem2State();
}

class _LostAnItem2State extends State<LostAnItem2> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController locController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String? _location1;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0'); // Ensure 2 digits
    final minutes = time.minute.toString().padLeft(2, '0'); // Ensure 2 digits
    return '$hours:$minutes'; // Format as HH:mm
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void handleLostItemPost(Item item) async {
    try {
      print('itemDetails:');
      print('json: ${item.toJson()}');
      /*
      final response = await ItemsApi.postItem(item.toJson());
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      'Item posted successfully!',
      style: TextStyle(color: Colors.white), // Text color
    ),
    backgroundColor: Colors.blue, // Custom background color
    duration: Duration(seconds: 3), // Display duration
  ),
);

        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      'Failed to post item!',
      style: TextStyle(color: Colors.white), // Text color
    ),
    backgroundColor: Colors.red, // Custom background color
    duration: Duration(seconds: 3), // Display duration
  ),
);

      }
      */
      // TODO: uncomment upper part and comment navigator below
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Item posted successfully!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue, // Custom background color
          duration: Duration(seconds: 3), // Display duration
        ),
      );

      Navigator.pushNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error : $e',
            style: TextStyle(color: Colors.white), // Text color
          ),
          backgroundColor: Colors.red, // Custom background color
          duration: Duration(seconds: 3), // Display duration
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // var formData = widget.formdata;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Text(
            "Lost An Item",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add Location, Date and Time",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            LocationDropdown(
              onLocationSelected: (String? newValue) {
                setState(() {
                  _location1 = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add a Descriptive Location",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "More specific location where you lost it",
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey, // Change hint text color
                  fontSize: 15, // Change hint text size
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              focusNode: _focusNode1,
              controller: _dateController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Select Date',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon:
                    const Icon(Icons.calendar_today, color: Colors.grey),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Time",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              focusNode: _focusNode2,
              controller: _timeController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Select Time',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
              ),
              readOnly: true,
              onTap: () => _selectTime(context),
            ),

            const SizedBox(height: 210),
            // Next Button
            ElevatedButton(
              onPressed: () {
                try {
                  // Validate required fields (Date, Time, and Location)

                  if (_location1 == null) {
                    throw Exception("Location is required.");
                  }
                  if (locController.text.isEmpty) {
                    throw Exception(" Specific location cannot be empty.");
                  }
                  if (_selectedDate == null) {
                    throw Exception("Please select a date.");
                  }
                  if (_selectedTime == null) {
                    throw Exception("Please select a time.");
                  }

                  print('Image Path: ${widget.postDetails1['image']}');

                  // Create Item instance
                  Item item = Item(
                    type: 0,
                    creator: Provider.of<UserProvider>(context, listen: false)
                        .userId,
                    title: widget.postDetails1['title'],
                    description: widget.postDetails1['description'],
                    location2: locController.text,
                    location1: _location1!,
                    date: DateFormat('yyyy-MM-dd')
                        .format(_selectedDate!)
                        .toString(),
                    time: formatTimeOfDay(_selectedTime!),
                    image: (widget.postDetails1['image']),
                    // isFound: false,
                  );

                  // Call API function to post lost item
                  handleLostItemPost(item);
                } catch (e) {
                  // Show error message in a SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString(),
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Post",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
