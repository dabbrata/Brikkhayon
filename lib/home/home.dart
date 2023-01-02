import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Brikkhayon/localizations.dart';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../categoriesitem_shrubs.dart';
import '../product_detail.dart';
import 'drawer.dart';
import 'slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1597211684565-dca64d72bdfe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=457&q=80',
    'https://images.unsplash.com/photo-1510478946814-7229b607bfe0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'https://www.urbangardengal.com/wp-content/uploads/2021/04/luffa-vine-on-trellis.jpg',
    'https://www.thespruce.com/thmb/QFVLiybUHP7Y9J_RlNk05b_zfDM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/the-difference-between-trees-and-shrubs-3269804-01-686e6c92f4bd47e197475d2e58e16149.jpg'
  ];
  final List<String> cateName = ["Shrubs","Herbs","Climbers","Trees"];
  //Map<String, String> someMap = {};
  Map? plants;
  DatabaseReference dbGenReference = FirebaseDatabase.instance.ref().child("allplants");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff056608)),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          title: Image.asset(
            'assets/images/splash.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.pushNamed(context, '/chatbot');
              },
              color: Color(0xff056608),
            )
          ],
          centerTitle: true,
          elevation: 0,
        ),
        drawer: Drawer(child: AppDrawer()),
        body: RefreshIndicator(
          onRefresh: () async{
            initState();
          },
          child: Container(
            color: Colors.white,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: CustomScrollView(
                  // Add the app bar and list of items as slivers in the next steps.
                  slivers: <Widget>[
                    // SliverAppBar(
                    //
                    //   brightness: Brightness.light,
                    //   backgroundColor: Colors.white,
                    //   // Provide a standard title.
                    //   // title: Text('asdas'),
                    //   // pinned: true,
                    //   // Allows the user to reveal the app bar if they begin scrolling
                    //   // back up the list of items.
                    //   // floating: true,
                    //   // Display a placeholder widget to visualize the shrinking size.
                    //   flexibleSpace: HomeSlider(),
                    //   // Make the initial height of the SliverAppBar larger than normal.
                    //   expandedHeight: 270,
                    // ),

                    SliverList(
                      // Use a delegate to build items as they're scrolled on screen.
                      delegate: SliverChildBuilderDelegate(
                        // The builder function returns a ListTile with a title that
                        // displays the index of the current item.
                        (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 250,
                              width: double.infinity,
                              child: HomeSlider(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 14.0, left: 8.0, right: 8.0, bottom: 10),
                              child: Text('New Products',
                                  style: TextStyle(
                                      color: Color(0xff056608),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(),
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                height: 200.0,
                                width: MediaQuery.of(context).size.width * 80,
                                child: Column(
                                    //scrollDirection: Axis.horizontal,
                                    children: [
                                      Expanded(
                                          child: StreamBuilder(
                                        stream: dbGenReference.onValue,
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
                                              //imgList.addAll(list[index]['image']);
                                              return ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: snapshot.data!.snapshot
                                                      .children.length,
                                                  itemBuilder: (context, index) {
                                                    //imgList.insert(0,list[index]['image']);
                                                    //someMap["${list[index]['name']}"] = "${list[index]['image']}";
                                                    //print(list[index]['name']);
                                                    //print(list[index]['image']);
                                                    return InkWell(
                                                      onTap: () {
                                                        //Navigator.pushNamed(context, routeName)
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
                                                        //setPlantName(str);
                                                      },
                                                      child: Card(
                                                        elevation: 10,
                                                        shadowColor: Colors.black,
                                                        color: Colors.white,
                                                        child: SizedBox(
                                                          width: 150,
                                                          height: 300,
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
                                                                    height: 130.0,
                                                                    width: 150.0,
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
                                                                          fontSize: 16,
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
                                                          ), //Padding
                                                        ), //SizedBox
                                                      ),
                                                    );
                                                  });
                                            }
                                          }catch(e){
                                            return Center(
                                              child: Container(
                                                // decoration: new BoxDecoration(
                                                //     borderRadius:
                                                //     new BorderRadius.all(const Radius.circular(20.0))),
                                                // child: LinearProgressIndicator(
                                                //   valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD3D3D3)),
                                                //   backgroundColor: Color(0xffe5e5e5),
                                                //),
                                                child: Text(
                                                    'No plants available!',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                      ),
                                      // Expanded(
                                      //   child: FirebaseAnimatedList(
                                      //       query: dbGenReference,
                                      //       itemBuilder: (context,snapshot,animation,index){
                                      //         plants = snapshot.value as Map;
                                      //         plants!['key'] = snapshot.key;
                                      //         return Container(
                                      //           height: 90,
                                      //           padding: EdgeInsets.all(8),
                                      //           // decoration: BoxDecoration(
                                      //           //   borderRadius: BorderRadius.circular(20),
                                      //           //   color: Colors.black26,
                                      //           // ),
                                      //           child: Material(
                                      //             elevation: 3,
                                      //             shadowColor: Colors.grey,
                                      //             color: Colors.white,
                                      //             borderRadius: BorderRadius.circular(10),
                                      //
                                      //             child: ListTile(
                                      //               onTap: (){
                                      //                 //Navigator.pushNamed(context, routeName)
                                      //                 Navigator.push(
                                      //                     context,
                                      //                     MaterialPageRoute(
                                      //                       builder: (context) => Products(
                                      //                         text: snapshot.key.toString(),
                                      //                         name: snapshot.child('name').value.toString(),
                                      //                         about: snapshot.child('about').value.toString(),
                                      //                         address: snapshot.child('address').value.toString(),
                                      //                         createdAt: snapshot.child('createdAt').value.toString(),
                                      //                         image: snapshot.child('image').value.toString(),
                                      //                         price: snapshot.child('price').value.toString(),
                                      //                         email: snapshot.child('email').value.toString(),
                                      //
                                      //                       ),
                                      //                     ));
                                      //               },
                                      //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      //               selectedTileColor: Colors.orange[200],
                                      //               leading: ClipRRect(
                                      //                 borderRadius: BorderRadius.circular(10),
                                      //                 child : Image.network(snapshot.child('image').value.toString()),
                                      //               ),
                                      //               title: Text(
                                      //                 snapshot.child('name').value.toString(),
                                      //                 style: TextStyle(fontSize: 14,color: Colors.black),
                                      //               ),
                                      //               subtitle: Text(
                                      //                   snapshot.child('price').value.toString() + "Tk",
                                      //                   style: TextStyle(
                                      //                       color: Theme.of(context)
                                      //                           .colorScheme.secondary,
                                      //                       fontWeight:
                                      //                       FontWeight.w700)),
                                      //               // trailing: IconButton(
                                      //               //     onPressed: (){
                                      //               //       _listItemDeleteDialog();
                                      //               //     },
                                      //               //     icon: Icon(Icons.delete)
                                      //               // ),
                                      //             ),
                                      //           ),
                                      //         );
                                      //       }
                                      //   ),
                                      // ),
                                      // Builder(
                                      //   builder: (BuildContext context) {
                                      //     return Container(
                                      //       width: 140.0,
                                      //       child: Card(
                                      //         clipBehavior: Clip.antiAlias,
                                      //         child: InkWell(
                                      //           onTap: () {
                                      //             Navigator.pushNamed(
                                      //                 context, '/products',
                                      //                 arguments: i);
                                      //           },
                                      //           child: Column(
                                      //             crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //             children: <Widget>[
                                      //               SizedBox(
                                      //                 height: 160,
                                      //                 child: Hero(
                                      //                   tag: '$i',
                                      //                   child: CachedNetworkImage(
                                      //                     fit: BoxFit.cover,
                                      //                     imageUrl: i,
                                      //                     placeholder: (context, url) =>
                                      //                         Center(
                                      //                             child:
                                      //                             CircularProgressIndicator()),
                                      //                     errorWidget:
                                      //                         (context, url, error) =>
                                      //                     new Icon(Icons.error),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //               ListTile(
                                      //                 title: Text(
                                      //                   'Two Gold Rings',
                                      //                   style: TextStyle(fontSize: 14),
                                      //                 ),
                                      //                 subtitle: Text('\$200',
                                      //                     style: TextStyle(
                                      //                         color: Theme.of(context)
                                      //                             .colorScheme.secondary,
                                      //                         fontWeight:
                                      //                         FontWeight.w700)),
                                      //               )
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                    ]),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Text('Shop By Category',
                                      style: TextStyle(
                                          color: Color(0xff056608),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0,
                                      top: 8.0,
                                      left: 8.0,
                                      bottom: 10),
                                  child: SizedBox(
                                    height: 35,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Color(0xff056608)),
                                            padding: MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.all(9)),
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Color(0xff056608)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(25.0),
                                                    side: BorderSide(color: Color(0xff056608))))),
                                        child: Text(
                                          'View All',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 13),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/categorise');
                                        },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.lightGreen,
                            ),
                            Container(
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                padding: EdgeInsets.only(
                                    top: 8, left: 6, right: 6, bottom: 12),
                                children: List.generate(4, (index) {
                                  return Container(
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        onTap: () {
                                          if(cateName[index] == "Shrubs"){
                                            Navigator.pushNamed(context, '/categoriesitem_shrubs');print('shrubs');}
                                          else if(cateName[index] == "Herbs")
                                            Navigator.pushNamed(context, '/categoriesitem_herbs');
                                          else if(cateName[index] == "Climbers")
                                            Navigator.pushNamed(context, '/categoriesitem_climbers');
                                          else if(cateName[index] == "Trees")
                                            Navigator.pushNamed(context, '/categoriesitem_trees');

                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: (MediaQuery.of(context).size.width / 2) - 70,
                                              width: double.infinity,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: imgList[index],
                                                placeholder: (context, url) => Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              ),
                                            ),
                                            ListTile(
                                                title: Text(
                                                    cateName[index],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 100,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                //scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      //color: Colors.blue,
                                      height: 200,
                                      width: 110,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 6.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 10),
                                        child: Lottie.asset(
                                            'assets/images/homebottomleft.json'),
                                      ),
                                    ),
                                    Container(
                                      //color: Colors.green,
                                      //color: Colors.amber,
                                      height: 200,
                                      width: 120,
                                      //width: MediaQuery.of(context).size.width*40,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 6.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 10),
                                        child: Lottie.asset(
                                            'assets/images/homebottommidle.json'),
                                      ),
                                    ),
                                    Container(
                                      //color: Colors.amber,
                                      height: 200,
                                      width: 130,
                                      //width: MediaQuery.of(context).size.width*40,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 6.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 10),
                                        child: Lottie.asset(
                                            'assets/images/homebottomright.json'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        // Builds 1000 ListTiles
                        childCount: 1,
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Do you want to exit?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  } else {
                    exit(0);
                  }
                },
                child: const Text("Yes"),
              )
            ],
          );
        });
    return exitApp ?? false;
  }
  // void setPlantName(String str) async{
  //   final shRef = await SharedPreferences.getInstance();
  //   shRef.setString('plantKey', str);
  // }
}
