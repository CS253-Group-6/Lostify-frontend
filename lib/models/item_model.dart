class Item{
  String id = '';
  String title,description,location,date,time;
  File image;
  bool isFound = false;

  Item({required this.title,required this.description,required this.location,
  required this.date,required this.time,required this.image,required this.isFound});
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "location": location,
      "date": date,
      "time": time,
      "image": image,
      "isFound": isFound,
    };
  }
}
