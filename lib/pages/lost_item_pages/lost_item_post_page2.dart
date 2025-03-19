import 'package:flutter/material.dart';
import 'package:first_project/components/lost_items/DropDown.dart';
import 'package:provider/provider.dart';
import '../../providers/form_data_provider.dart';

class LostAnItem2 extends StatefulWidget {
  const LostAnItem2({super.key});

  @override
  State<LostAnItem2> createState() => _LostAnItem2State();
}

class _LostAnItem2State extends State<LostAnItem2> {
  final FocusNode _focusNode1 = FocusNode();
  bool _isFocused1 = false;
  final FocusNode _focusNode2 = FocusNode();
  bool _isFocused2 = false;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _location;
  final List<String> _dropdownItems = [
    'Hall 1',
    'Hall 2',
    'Hall 3',
    'Hall 4',
    'Hall 5',
    'Hall 6',
    'Hall 7',
    'Hall 8',
    'Hall 9',
    'Hall 10',
    'Hall 11',
    'Hall 12',
    'Hall 13',
    'Hall 14',
    'RM',
    'LHC',
    'CC',
    'Library',
    'IME'
  ];
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
  void _setLocation(String? loc){
    _location = loc;
  }
  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      setState(() {
        _isFocused1 = _focusNode1.hasFocus;
      });
    });
    _focusNode2.addListener(() {
      setState(() {
        _isFocused2 = _focusNode2.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
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
        leading: Image.asset("assets/LostifyIcon.png"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
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
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Location",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          DropDown(
            name: "Choose the location where you lost it.",
            dropdownItems: _dropdownItems,
            locationSelected: _setLocation,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Date",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            focusNode: _focusNode1,
            controller: _dateController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Select Date',
              suffixIcon: _isFocused1?Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.calendar_month_rounded,size: 30,),
              ):Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.calendar_today_rounded,size: 30,),
              ),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Time",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            focusNode: _focusNode2,
            controller: _timeController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Select Time',
              suffixIcon: _isFocused2?Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.access_time_filled_rounded,size: 30,),
              ):Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.access_time_rounded,size: 30,),
              ),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () => _selectTime(context),
          ),
          SizedBox(
            height: 50,
          ),
          FilledButton(
            onPressed: () {
              Map<String, dynamic> formData = {
                'Location': _location,
                'Date': _dateController.text,
                'Time': _timeController.text,
              };
              Provider.of<FormDataProvider>(context, listen: false)
                  .updateData(formData);
              Navigator.pushNamed(context, '/lost_an_item/page3');
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
              'Post',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
