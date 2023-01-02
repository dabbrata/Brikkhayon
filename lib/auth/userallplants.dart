import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../product_detail.dart';

void main() {
  runApp(new MyAppPlant());
}

class MyAppPlant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Brikkhayon',
      home: new UserPlant(),
      theme: new ThemeData(primaryColor: Colors.black),
    );
  }
}

class UserPlant extends StatefulWidget {
  @override
  _UserPlantState createState() => new _UserPlantState();
}

class _UserPlantState extends State<UserPlant> with TickerProviderStateMixin {
  late TabController tabController;

  DatabaseReference dbReference = FirebaseDatabase.instance.ref().child("plantdetails").child(FirebaseAuth.instance.currentUser!.uid);


  @override
  Widget build(BuildContext context) {
    // tabController = new TabController(length: 2, vsync: this);
    //
    // var tabBarItem = new TabBar(
    //   tabs: [
    //     new Tab(
    //       icon: new Icon(Icons.list,color: Color(0xff056608),),
    //
    //     ),
    //     new Tab(
    //       icon: new Icon(Icons.grid_on,color: Color(0xff056608),),
    //     ),
    //   ],
    //   controller: tabController,
    //   indicatorColor: Color(0xff056608),
    // );



    // var listItem = new ListView.builder(
    //
    //   itemCount: 20,
    //   itemBuilder: (BuildContext context, int index) {
    //     return new ListTile(
    //       title: new Card(
    //         elevation: 5.0,
    //         child: new Container(
    //           alignment: Alignment.center,
    //           margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
    //           child: new Text("ListItem $index"),
    //         ),
    //       ),
    //       onTap: () {
    //         showDialog(
    //             barrierDismissible: false,
    //             context: context,
    //             builder: (BuildContext context) {
    //             return CupertinoAlertDialog(
    //               title: new Column(
    //                 children: <Widget>[
    //                   new Text("ListView"),
    //                   new Icon(
    //                     Icons.favorite,
    //                     color: Colors.red,
    //                   ),
    //                 ],
    //               ),
    //               content: new Text("Selected Item $index"),
    //               actions: <Widget>[
    //                 new ElevatedButton(
    //                     onPressed: () {
    //                       Navigator.of(context).pop();
    //                     },
    //                     child: new Text("OK"))
    //               ],
    //             );
    //             }
    //             );
    //       },
    //     );
    //   },
    // );



    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xff056608)),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
              'Your All Plants',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),

        actions: <Widget>[

        ],
        centerTitle: true,
        elevation: 0,
      ),
        body: Container(
          child: StreamBuilder(
            stream: dbReference.onValue,
            builder: (context,
                AsyncSnapshot<DatabaseEvent>
                snapshot) {
               try{
                 if (!snapshot.hasData) {
                   return Container(
                     decoration: new BoxDecoration(
                         borderRadius:
                         new BorderRadius.all(const Radius.circular(20.0))),
                     child: LinearProgressIndicator(
                       valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD3D3D3)),
                       backgroundColor: Color(0xffe5e5e5),
                     ),
                   );
                 } else {
                   Map<dynamic, dynamic> map = snapshot
                       .data!.snapshot.value as dynamic;
                   List<dynamic> list = [];
                   list.clear();
                   list = map.values.toList();
                   return new GridView.builder(
                       itemCount: snapshot.data!.snapshot
                           .children.length,
                       shrinkWrap: true,
                       scrollDirection: Axis.vertical,
                       gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisExtent: 155.0,),
                       itemBuilder: (BuildContext context, int index) {

                         return new GestureDetector(
                           child: new Card(
                             elevation: 5,
                             shadowColor: Colors.black,
                             color: Colors.white,
                             child: Padding(
                               padding:
                               const EdgeInsets
                                   .all(0.0),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   // SizedBox(
                                   //   height: 5,
                                   // ),
                                   // CircleAvatar(
                                   //   backgroundColor:
                                   //       Colors.green[
                                   //           500],
                                   //   radius: 50,
                                   //   child:
                                   //       CircleAvatar(
                                   //     backgroundImage:
                                   //         NetworkImage(
                                   //             list[index]['image']), //NetworkImage
                                   //     radius: 50,
                                   //   ), //CircleAvatar
                                   // ),
                                   ClipRRect(
                                     borderRadius: BorderRadius.circular(5.0),//or 15.0
                                     child: Container(
                                       height: 90.0,
                                       width: MediaQuery.of(context).size.width*100,
                                       //color: Color(0xffFF0E58),
                                       child: CachedNetworkImage(imageUrl:list[index]["image"],fit: BoxFit.cover,
                                         placeholder: (context, url) => new Icon(Icons.image),
                                         errorWidget: (context, url, error) => new Icon(Icons.error),

                                       ),
                                     ),
                                   ),
                                   Container(
                                     //color:Colors.redAccent,
                                     padding: EdgeInsets.only(left: 8),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(
                                           list[index]
                                           ['name'],
                                           style: TextStyle(
                                             fontSize: 14,
                                             color: Colors
                                                 .black87,
                                             fontWeight:
                                             FontWeight
                                                 .bold,
                                           ), //Textstyle
                                         ), //Text
                                         // SizedBox(
                                         //   height: 10,
                                         // ), //SizedBox
                                         Text(
                                           list[index][
                                           'price'] + " Tk",
                                           style: TextStyle(
                                             fontSize: 16,
                                             color: Colors
                                                 .black87,
                                             fontWeight: FontWeight.w300,
                                           ), //Textstyle
                                         ), //Text
                                         SizedBox(
                                           height: 8,
                                         ), //SizedBox
                                         //SizedBox
                                       ],
                                     ),
                                   ),
                                 ],
                               ), //Column
                             ), //SizedBox
                           ),
                           onTap: () {
                             String str = list[index]['pid'].toString();

                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) =>
                                       Products(
                                         text: list[index]['text'].toString(),
                                         name: list[index]['name'].toString(),
                                         about: list[index]['about'].toString(),
                                         address: list[index]['address'].toString(),
                                         createdAt: list[index]['createdAt'].toString(),
                                         image: list[index]['image'].toString(),
                                         price: list[index]['price'].toString(),
                                         email: list[index]['email'].toString(),
                                         parentid: list[index]['pid'].toString(),
                                       ),
                                 ));
                           },
                         );
                       });
                 };
               }catch(e){
                 return Container(
                   child: Center(
                     child: Text("No Plants Available!"),
                   ),
                 );
               }
              },
            ),
        ),

    );
  }
}