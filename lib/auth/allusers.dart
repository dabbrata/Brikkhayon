//import 'dart:html';
//import 'dart:html';

import 'package:Brikkhayon/product_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../plantinfo.dart';
import '../userplantsfromadmin.dart';


void main() {
  runApp(Item());
}

class Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Allusers(),
    );
  }
}


class Allusers extends StatefulWidget {

  @override
  _AllusersState createState() => _AllusersState();
}

// class Plant {
//
//   final String name;
//   final String image;
//   final String price;
//
//   const Plant({
//     required this.name,
//     required this.image,
//     required this.price,
//   });
//   //
//   // Map toJson () => {
//   //   'name' : name,
//   //   'image' : image,
//   //   'price' : price,
//   // };
//
//   factory Plant.fromMap(Map<dynamic, dynamic> map) {
//     return Plant(
//       name: map['name'] ?? '',
//       image: map['image'] ?? '',
//       price: map['price'] ?? '',
//     );
//   }
// }




class _AllusersState extends State<Allusers> {

  //final List<dynamic> list = [];
  //List<dynamic> list2 = [];

  // getUsers() async {
  //   final snapshot = await FirebaseDatabase.instance.ref().child('allplants').get();
  //
  //   //final map = snapshot.value as Map<dynamic, dynamic>;
  //   Map<dynamic, dynamic> map = snapshot.value as dynamic;
  //
  //   map.forEach((key, value) {
  //     final getPlant = Plant.fromMap(value);
  //     list.add(getPlant);
  //   });
  //   // setState(() {
  //   //   list2 = list;
  //   // });
  //   //print(list[0].price);
  // }

  String imgUrl = " ";
  String userName = " ";
  String userEmail = " ";
  String createAcTime = " ";

  

 // final f = new DateFormat('yyyy-MM-dd hh:mm');


  // void showAllUsers() async {
  //   try{
  //     // final ref = FirebaseStorage.instance.ref().child("profilepic.jpg");//.child(DateTime.now().toString() + 'jpg');//
  //     // await ref.putFile(imageFile);
  //     //imgUrl = await ref.getDownloadURL();
  //     final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("userdetails").doc().get();
  //     setState(() {
  //       userName = userDoc.get('name');
  //       userEmail = userDoc.get('email');
  //       createAcTime = userDoc.get('createdAt');
  //
  //     });
  //     print("jskdfkldsajkjfkljdslfjsdklajfkljd0" + userName + createAcTime);
  //     //Fluttertoast.showToast(msg: "Completed upload");
  //   }
  //   catch(e){
  //     Fluttertoast.showToast(msg: "error occuerd for fetching data!");
  //   }
  // }



  @override
  void initState() {
    super.initState();

  }

  //delete all data from realtime database

  //delete all data from realtime database
  void deleteAllDataUnderThisUser(String userId) async {
    DatabaseReference dbRefrence = FirebaseDatabase.instance.ref().child("plantdetails");
    DatabaseReference dbGenRefrence = FirebaseDatabase.instance.ref().child("allplants");

    //final snapshot = dbGenRefrence!.get();
    dbRefrence.child(userId).remove();
    //Fluttertoast.showToast(msg: "removed from realtime all plants database");
    FirebaseDatabase.instance.ref("allplants").onValue.listen((event) {

      final data =
      Map<String, dynamic>.from(event.snapshot.value as Map,);

      data.forEach((key, value) {

        print('${value['curUid']}'.toString().trim());
        print(userId);
        if(value['curUid'].toString().trim() == userId.toString().trim()){
            dbGenRefrence.child(value['pid']).remove();
            //Fluttertoast.showToast(msg: 'Removed the plant');
            //Fluttertoast.showToast(msg: " if");
            return;

        }
        else{
          //Fluttertoast.showToast(msg: "not in if");
        }
      });
    }
    );
    //dbGenRefrence.child().remove();
    //Fluttertoast.showToast(msg: userId);
  }
  //delete profile list item alert dialog..

  Future<void> _listItemDeleteDialog(String userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            height: 120.0,
            width: 80.0,
            // decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.white54,
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left:8.0,right:8,top: 4,bottom:10),
                  child: Text(
                    'Delete the plant?',
                    style:
                    TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff999999),
                                //side: BorderSide(width:0, color:Colors.brown), //border width and color
                                //elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(10)
                            ),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Text(
                                'Cancel'
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                //side: BorderSide(width:0, color:Colors.brown), //border width and color
                                //elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(10)
                            ),
                            onPressed: (){
                              FirebaseFirestore.instance.collection('userdetails').doc(userId).delete();
                              deleteAllDataUnderThisUser(userId);
                              Fluttertoast.showToast(msg: "The user is successfully removed");
                              Navigator.of(context).pop();
                              //print(userId);
                            },
                            child: Text(
                                'Delete'
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                // title: Image.asset(
                //   'assets/images/splash.png',
                //   width: 50,
                //   height: 50,
                //   fit: BoxFit.cover,
                // ),
                title: Text("Admin",
                style: TextStyle(color: Colors.black87),),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.black),
                    onPressed: () {
                      Navigator.pushNamed(context, '/searchpage');
                    },
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.person, color: Colors.black),
                  //   onPressed: () {},
                  // )
                ],
                centerTitle: true,
              ),
            ),

          ),
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width*80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    child: Text("All Users",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        decoration: TextDecoration.none,
                        fontFamily:'RobotoMono'
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: new StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('userdetails').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    try{
                      if (!snapshot.hasData){
                        Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final data = snapshot.requireData;
                      return new ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index){
                          Timestamp t = data.docs[index]['createdAt'] as Timestamp;
                          DateTime date = t.toDate();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                //border: Border.all(color: Colors.black87,width: 1),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 2), // changes position of shadow
                                  ),
                                ],

                              ),
                              child: Column(
                                children: [
                                  Material(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserPlantFromAdmin(
                                                      userId: data.docs[index]['userId'].toString(),
                                                      userName: data.docs[index]['username'].toString(),
                                                      //name: list[index]['name'].toString(),

                                                    ),
                                              ));
                                        },
                                        leading:ClipRRect(
                                          borderRadius: BorderRadius.circular(5.0),//or 15.0
                                          child: Container(
                                            height: 60.0,
                                            width: 60.0,
                                            //color: Color(0xffFF0E58),
                                            child: Image.network(
                                              data.docs[index]['image'],
                                              fit: BoxFit.cover,
                                              //placeholder: (context, url) => new Icon(Icons.image),
                                              //errorWidget: (context, url, error) => new Icon(Icons.error), imageUrl: '',

                                            ),
                                          ),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text('${data.docs[index]['username']}\n${data.docs[index]['email']}',),
                                        ),
                                        subtitle : Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text('${(date.day)}-${(date.month)}-${(date.year)}'),
                                        ),
                                        trailing: IconButton(
                                            onPressed: (){
                                              _listItemDeleteDialog(data.docs[index]['userId'].toString());
                                              //Fluttertoast.showToast(msg: "ghjkh");
                                            },
                                            icon: Icon(Icons.delete)
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    catch(e){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

