import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/components/location/location.dart';

class FoundItemPage3 extends StatefulWidget {
  final Map<String, dynamic> postDetails1;

  const FoundItemPage3({super.key,required this.postDetails1});

  @override
  State<FoundItemPage3> createState() => _FoundItemPage3State();
}

class _FoundItemPage3State extends State<FoundItemPage3> {
  final TextEditingController locController = TextEditingController();
  String? selectedFoundLocation;
  String? selectedPresentLocation;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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

  // Handle the found item post
  void handleFoundItemPost(){
    // TODO: get details of all foundpages in json format

    // TODO: make api call with correct data to backend using services class (use try-catch)

    // if success
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item posted successfully!!")));
    Navigator.pushNamed(context, '/home');

    // TODO: if error show ScaffoldMessenger with error message
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
        // Gradient background
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/new_background.png"), // Updated background image
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: Back arrow + Page Title



                // Location where item was found
                const Text(
                  "Location where item was found",
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
                                    ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                                    : "DD/MM/YY",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: selectedTime != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              const Icon(Icons.calendar_today, color: Colors.grey), // Calendar icon
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
                                selectedTime != null ? selectedTime!.format(context) : "Time",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: selectedTime != null ? Colors.black : Colors.grey,
                                ),
                              ),

                              Icon(Icons.access_time, color: Colors.grey), // Clock icon
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Present location of item
                const Text(
                  "Present location of the item",
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
                const SizedBox(height: 240),

                // Next Button
                ElevatedButton(
                  onPressed: handleFoundItemPost,
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