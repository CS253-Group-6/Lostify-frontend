import 'package:final_project/pages/search/searchdisplay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/location/location.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedSearchLocation;
  DateTime? selectedDate1;
  DateTime? selectedDate2;

  // Sample dropdown options
  //List<String> locations = ["Library", "Cafeteria", "Park", "Classroom", "Gym"];

  void handleSearch() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchDisplayPage(
                searchLocation: selectedSearchLocation!,
                startDate: selectedDate1!,
                endDate: selectedDate2!)));
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate1 ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('en', 'GB'),
    );
    if (pickedDate != null && pickedDate != selectedDate1) {
      if (selectedDate2 != null && pickedDate.isAfter(selectedDate2!)) {
        // Show an error message if the start date is after the end date
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Start date cannot be later than the end date."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          selectedDate1 = pickedDate;
        });
      }
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate2 ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      if (selectedDate1 != null && pickedDate.isBefore(selectedDate1!)) {
        // Show an error message if the end date is before the start date
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("End date cannot be earlier than the start date."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          selectedDate2 = pickedDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Search Items', style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),
          ],
        ),
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
                // Location where item was lost
                const Text(
                  "Lost Place",
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
                      selectedSearchLocation = newValue;
                    });
                  },
                ),
                const SizedBox(height: 30),
                // Date and time of loss
                const Text(
                  "Expected Lost Date range",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickStartDate(context),
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
                                selectedDate1 != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(selectedDate1!)
                                    : "Start Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: selectedDate1 != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              const Icon(Icons.calendar_today,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickEndDate(context),
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
                                selectedDate2 != null
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(selectedDate2!)
                                    : "End Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: selectedDate2 != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              Icon(Icons.calendar_today, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 270),
                // Search Button
                ElevatedButton(
                  onPressed: () {
                    // Handle search action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Search",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.search, color: Colors.white), // Magnifier icon
                    ],
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
