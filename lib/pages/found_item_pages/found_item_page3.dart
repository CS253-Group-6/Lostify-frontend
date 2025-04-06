import 'package:final_project/components/location/location.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/item_model.dart';
import '../../providers/user_provider.dart';
import '../../services/items_api.dart';

class FoundItemPage3 extends StatefulWidget {
  final Map<String, dynamic> postDetails2;

  const FoundItemPage3({super.key, required this.postDetails2});

  @override
  State<FoundItemPage3> createState() => _FoundItemPage3State();
}

class _FoundItemPage3State extends State<FoundItemPage3> {
  final TextEditingController locController = TextEditingController();

  String? selectedPresentLocation;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0'); // Ensure 2 digits
    final minutes = time.minute.toString().padLeft(2, '0'); // Ensure 2 digits
    return '$hours:$minutes'; // Format as HH:mm
  }

  void handleFoundItemPost(Item item) async {
    try {
      print('itemDetails:');
      print('json: ${item.toJson()}');

      final response = await ItemsApi.postItem(item.toJson());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Item posted successfully',
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

    // uncomment the above part and comment the below part after integration
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       'Item posted successfully!',
    //       style: TextStyle(color: Colors.white), // Text color
    //     ),
    //     backgroundColor: Colors.blue, // Custom background color
    //     duration: Duration(seconds: 3), // Display duration
    //   ),
    // );

    // Navigator.pushNamed(context, '/home');
  }

  // Opens the DatePicker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Opens the TimePicker
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Found an item', style: TextStyle(color: Colors.white)),
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
        // Gradient background
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/new_background.png"), // Updated background image
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: Back arrow + Page Title
                // Present location of item
                const Text(
                  "Approximate Location of Discovery",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                LocationDropdown(
                  onLocationSelected: (String? newValue) {
                    setState(() {
                      selectedPresentLocation = newValue;
                    });
                  },
                ),
                const SizedBox(height: 30),
                // Location where item was found
                const Text(
                  "Detailed Location Where Item Was Found",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Specific location where you found it",
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
                const SizedBox(height: 30),
                // Date and time of find
                const Text(
                  "Date and time of find",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Date picker box
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickDate(context),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDate != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(selectedDate!)
                                    : "DD/MM/YY",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: selectedTime != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              const Icon(Icons.calendar_today,
                                  color: Colors.grey), // Calendar icon
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Time picker box
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickTime(context),
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedTime != null
                                    ? selectedTime!.format(context)
                                    : "Time",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: selectedTime != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),

                              Icon(Icons.access_time,
                                  color: Colors.grey), // Clock icon
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Next Button
                ElevatedButton(
                  onPressed: () {
                    try {
                      // Validate required fields (Date, Time, and Location)

                      if (selectedPresentLocation == null) {
                        throw Exception("Location is required.");
                      }
                      if (locController.text.isEmpty) {
                        throw Exception(" Specific location cannot be empty.");
                      }
                      if (selectedDate == null) {
                        throw Exception("Please select a date.");
                      }
                      if (selectedTime == null) {
                        throw Exception("Please select a time.");
                      }

                      // Create Item instance
                      Item item = Item(
                        type: 1,
                        creator:
                            Provider.of<UserProvider>(context, listen: false)
                                .userId,
                        title: widget.postDetails2['title'],
                        description: widget.postDetails2['description'],

                        location2: locController.text,
                        location1: selectedPresentLocation!,
                        date: DateFormat('yyyy-MM-dd')
                            .format(selectedDate!)
                            .toString(),
                        time: formatTimeOfDay(selectedTime!),
                        image: (widget.postDetails2['image']),
                        // isFound: true,
                      );

                      // Call API function to post lost item
                      handleFoundItemPost(item);
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
