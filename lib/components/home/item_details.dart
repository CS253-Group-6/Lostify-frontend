import 'package:flutter/material.dart';
class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
            "Item Details",
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/background.png"),fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                          height: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(
                              "assets/phone.png",
                            fit: BoxFit.cover,
                          )
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Title",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 32
                            ),
                        ),
                      ),
                      Text(
                          "This a nice and detailed description of the product posted",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600
                          ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade200,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.date_range),
                                Text("5 May",style: TextStyle(fontSize: 20),),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.watch_later_outlined),
                                Text("7:55 PM",style: TextStyle(fontSize: 20),),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on),
                                Text("Auditorium",style: TextStyle(fontSize: 20),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.lightBlue.shade200,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 32,vertical: 20),
                            child: Text("Share",style: TextStyle(fontSize: 20),),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.lightBlue.shade200,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 32,vertical: 20),
                            child: Text("Report",style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
          
                    ],
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("Vinay Chavan"),
                  subtitle: Text("B.tech 2nd Year"),
                  trailing: ElevatedButton(onPressed: (){}, child: Text("Chat")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
