import 'dart:convert';
import 'dart:io';

class Item{
  String id = '';
  String title, description, location, date, time;
  File image;
  bool isFound = false;

  Item({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.image,
    required this.isFound,
  });

  void found(){
    isFound = true;
  }
  
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "location": location,
      "date": date,
      "time": time,
      "image": base64Encode(image.readAsBytesSync()), // Convert file to Base64
      "isFound": isFound,
    };
  }

  static Item fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      description: json['description'],
      location: json['location'],
      date: json['date'],
      time: json['time'],
      image: File.fromRawPath(base64Decode(json['image'])), // Convert Base64 back to File
      isFound: json['isFound'],
    );
  }
}
