import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final Function(String?) locationSelected;
  final String name;
  final List<String> dropdownItems;
  const DropDown({super.key,required this.name,required this.dropdownItems,required this.locationSelected});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? _location;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      padding: EdgeInsets.all(10),
      child: DropdownButton<String>(
        icon: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Icon(Icons.location_on_sharp,size: 40,),
        ),
        hint: Text(widget.name),
        value: _location,
        onChanged: (String? newValue) {
          setState(() {
            _location = newValue;
          });
          widget.locationSelected(newValue);
        },
        items:
        widget.dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
              value: value,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue.shade700,
                    ),
                    SizedBox(width: 10),
                    Text(
                      value,
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ],
                ),
              ));
        }).toList(),
      ),
    );
  }
}
