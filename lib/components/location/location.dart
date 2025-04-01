import 'package:flutter/material.dart';

class LocationDropdown extends StatefulWidget {
  final Function(String?) onLocationSelected;

  const LocationDropdown({super.key, required this.onLocationSelected});

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  final TextEditingController _controller = TextEditingController();
  String? selectedLocation;
  bool showDropdown = false; // Controls dropdown visibility

  List<String> locations = [
    "Academic area canteen",
    "ACMS Building",
    "Advanced center of material sciences",
    "Aerospace building",
    "Air strip",
    "Apollo Pharmacy",
    "ATM",
    "Auditorium",
    "Basketball court",
    "Biometric office",
    "BSBE Building",
    "Campus Bustand",
    "CCD",
    "Centre for Environmental Science & Engineering",
    "Chemical Engg Department",
    "Civil Engg Lab",
    "Community center",
    "Computer center",
    "Control Room",
    "Counselling Service",
    "Cricket Net Practice",
    "CSE canteen",
    "D shop",
    "Department of Materials Science And Engineering",
    "Department of Nuclear Engineering",
    "Diamond Jubilee Building",
    "Directors Bungalow",
    "DOAA Canteen",
    "DOAA office",
    "DOSA office",
    "E cell club",
    "Earth science building",
    "Electrical Engg Building",
    "Electronics and ICT academy",
    "Engine Research Laboratory IIT Kanpur",
    "ESB building -1",
    "ESB building -2",
    "Events Ground",
    "Faculty building",
    "Flight Lab",
    "GH-1",
    "GYM",
    "Hall 1",
    "Hall 10",
    "Hall 11",
    "Hall 12",
    "Hall 13",
    "Hall 13 Shiva temple",
    "Hall 14",
    "Hall 2",
    "Hall 3",
    "Hall 4",
    "Hall 5",
    "Hall 6",
    "Hall 7",
    "Hall 8",
    "Hall 9",
    "Health center",
    "Hockey Ground",
    "Hydraulics Lab",
    "ICICI Bank",
    "IITK main Gate",
    "IME Building",
    "IWD",
    "JVS tower",
    "KD Building",
    "Kinder garden School",
    "KV school",
    "Lecture hall 1",
    "Lecture hall 2",
    "Lecture hall 3",
    "Lecture hall 4",
    "Lecture hall 5",
    "Lecture hall 6",
    "Lecture hall 7",
    "Lecture hall 8",
    "Lecture hall 9",
    "Lecture hall 10",
    "Lecture hall 11",
    "Lecture hall 12",
    "Lecture hall 13",
    "Lecture hall 14",
    "Lecture hall 15",
    "Lecture hall 16",
    "Lecture hall 17",
    "Lecture hall 18",
    "Lecture hall 19",
    "Lecture hall 20",
    "Library",
    "Main Gate Cycle Parking",
    "Mama Mio",
    "Mechanical Engg Building",
    "Media Center",
    "Mehta Family Centre for Engg Sciences",
    "MNCC Office",
    "Motor sports club",
    "MT",
    "New Core Lab",
    "NEW SAC",
    "Northern Labs",
    "NSS office",
    "Nuclear Physics Lab",
    "Nursery",
    "NW Labs",
    "OAT",
    "Old RA hostel",
    "OLD SAC",
    "Opportunity School IITK",
    "Outreach Building",
    "Oxidation pond",
    "Park 67",
    "PE Ground",
    "Petrol Pump",
    "Post office",
    "Pronite Ground",
    "Ram Leela Ground",
    "Residential Building",
    "RM Building",
    "Robotics Club",
    "SAC",
    "SAMTEL",
    "Security Office",
    "Shopping Centre (E shop)",
    "Shopping complex",
    "SIDBI",
    "SIIC",
    "Southern Labs",
    "Sports Centre",
    "Squash court",
    "Stadium",
    "State Bank of India",
    "Student Lounge",
    "Student placement office",
    "Swimming Pool",
    "Techno park",
    "Tennis court",
    "Tutorial Complex",
    "Union Bank of India",
    "Visitors Hostel 1",
    "Visitors Hostel 2",
    "Volley ball ground",
    "Western Lab",
    "Western Lab extension",
    "Wind Tunnel Facility"
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Search location...",
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(Icons.arrow_drop_down),
              onPressed: () {
                setState(() {
                  showDropdown = !showDropdown;
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              showDropdown = value.isNotEmpty;
            });
          },
        ),
        if (showDropdown)
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
            ),
            child: SizedBox(
              height: 200,
              width: 350,// Set a fixed height to enable scrolling
              child: SingleChildScrollView(
                child: Column(
                  children: locations
                      .where((loc) => loc.toLowerCase().contains(_controller.text.toLowerCase()))
                      .map((loc) => ListTile(
                    title: Text(loc),
                    onTap: () {
                      setState(() {
                        selectedLocation = loc;
                        _controller.text = loc;
                        showDropdown = false;
                      });
                      widget.onLocationSelected(loc);
                    },
                  ))
                      .toList(),
                ),
              ),
            ),
          ),

      ],
    );
  }
}
