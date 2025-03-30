import 'package:final_project/models/item_model.dart';
import 'package:final_project/services/items_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/form_data_provider.dart';
import 'package:intl/intl.dart';
import 'package:final_project/components/location/location.dart';

class LostAnItem2 extends StatefulWidget {
  final Map<String,dynamic> formdata;
  const LostAnItem2({super.key,required this.formdata});

  @override
  State<LostAnItem2> createState() => _LostAnItem2State();
}

class _LostAnItem2State extends State<LostAnItem2> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String? _location;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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

  void handleLostItemPost(Item item)async{
    try{
      Map<String,dynamic> response = await ItemsApi.lostitem(item);
      if(response['statusCode'] == 200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item posted successfully!!")));
        Navigator.of(context).pushNamed('/home');
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item posted failed!!")));
        Navigator.pushNamed(context, '/home');
        //Navigator.of(context).pushReplacementNamed('/home');
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item posted failed!!")));
      Navigator.pushNamed(context, '/home');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    var formData = widget.formdata;
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Add Location, Date and Time",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
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
                _location = newValue;
              });
            },
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
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
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
            
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
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
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Select Time',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: Icon(Icons.access_time, color: Colors.grey),
            ),
            readOnly: true,
            onTap: () => _selectTime(context),
          ),


          const SizedBox(height: 210),
          // Next Button
          ElevatedButton(
            onPressed: (){
              Item item = Item(
                title: formData['title'],
                description: formData['description'],
                location: _location!,
                date: _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
                time: _selectedTime != null ? _selectedTime!.format(context) : '',
                image: formData['image'],
                isFound: false,
              );
              handleLostItemPost(item);
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Post",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ]
        ),
      ),),
    );
  }
}
