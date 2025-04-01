import 'dart:convert';
import 'dart:io';

class Item{
  int id = 0,type = 0,creator = 0;
  String title, description, location1,location2, date, time;
  File image;
  bool isFound = false;

  Item({
    required this.title,
    required this.description,
    required this.location1,
    required this.date,
    this.time = '',
    required this.image,
    this.isFound = false,
    required this.type,
    required this.creator,
    this.location2 = '',
  });

  void found(){
    isFound = true;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      "title": title,
      "description": description,
      "location1": location1,
      "location2": location2,
      "creator": creator,
      "date": date,
      "time": time,
      "image": base64Encode(image.readAsBytesSync()), // Convert file to Base64
      // "isFound": isFound,
    };
  }

  static Item fromJson(Map<String, dynamic> json) {
    return Item(
      type: json['type'],
      title: json['title'],
      creator: json['creator'],
      description: json['description'],
      location1: json['location'],
      date: json['date'],
      // time: json['time'],
      image: File.fromRawPath(base64Decode(json['image'])), // Convert Base64 back to File
      // isFound: json['isFound'],
    );
  }
}
