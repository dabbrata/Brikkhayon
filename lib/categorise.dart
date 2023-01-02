//import 'dart:html';
//import 'dart:html';
import 'package:Brikkhayon/product_detail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'plantinfo.dart';

void main() {
  runApp(Item());
}

class Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Categorise(),
    );
  }
}


class Categorise extends StatefulWidget {

  @override
  _CategoriseState createState() => _CategoriseState();
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




class _CategoriseState extends State<Categorise> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

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


  List<Widget> itemsData = [];
  Map? plants;
  DatabaseReference dbGenReference = FirebaseDatabase.instance.ref().child("allplants");

  void getPostsData() {
    //print(list2[0].price);
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post["name"],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$ ${post["price"]}",
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "${post["image"]}",
                    height: 120,
                    width: 120,

                  ),
                )
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
      //list2 = list;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.25;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Image.asset(
            'assets/images/splash.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
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
        body: Container(
          height: size.height,
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Categories",
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer?0:1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer?0:categoryHeight,
                    child: categoriesScroller),
              ),
              // Expanded(
              //     child: ListView.builder(
              //         controller: controller,
              //         itemCount: itemsData.length,
              //         physics: BouncingScrollPhysics(),
              //         itemBuilder: (context, index) {
              //           double scale = 1.0;
              //           if (topContainer > 0.5) {
              //             scale = index + 0.5 - topContainer;
              //             if (scale < 0) {
              //               scale = 0;
              //             } else if (scale > 1) {
              //               scale = 1;
              //             }
              //           }
              //           return Opacity(
              //             opacity: scale,
              //             child: Transform(
              //               transform:  Matrix4.identity()..scale(scale,scale),
              //               alignment: Alignment.bottomCenter,
              //               child: Align(
              //                   heightFactor: 0.7,
              //                   alignment: Alignment.topCenter,
              //                   child: itemsData[index]),
              //             ),
              //           );
              //         })),

              Expanded(
                  child: StreamBuilder(
                    stream: dbGenReference.onValue,
                    builder: (context,
                        AsyncSnapshot<DatabaseEvent>
                        snapshot) {
                      try{
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          Map<dynamic, dynamic> map = snapshot
                              .data!.snapshot.value as dynamic;
                          List<dynamic> list = [];
                          list.clear();
                          list = map.values.toList();
                          //imgList.addAll(list[index]['image']);
                          return ListView.builder(
                            //         controller: controller,
                            //         itemCount: itemsData.length,
                            //         physics: BouncingScrollPhysics(),
                            //         itemBuilder: (context, index) {
                            //           double scale = 1.0;
                            //           if (topContainer > 0.5) {
                            //             scale = index + 0.5 - topContainer;
                            //             if (scale < 0) {
                            //               scale = 0;
                            //             } else if (scale > 1) {
                            //               scale = 1;
                            //             }
                            //           }
                            //           return Opacity(
                            //             opacity: scale,
                            //             child: Transform(
                            //               transform:  Matrix4.identity()..scale(scale,scale),
                            //               alignment: Alignment.bottomCenter,
                            //               child: Align(
                            //                   heightFactor: 0.7,
                            //                   alignment: Alignment.topCenter,
                            //                   child: itemsData[index]),
                            //             ),
                            //           );
                            //         }
                              scrollDirection: Axis.vertical,
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
                                                parentid: list[index]['parentid'].toString(),
                                              ),
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:12.0,right: 12),
                                    child: Card(
                                      elevation: 20,
                                      shadowColor: Colors.black,
                                      color: Colors.white,
                                      child: SizedBox(
                                        width: 150,
                                        height: 120,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets
                                              .only(top:0.0,bottom: 0,right: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // SizedBox(
                                              //   height: 1,
                                              // ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(5.0),//or 15.0
                                                child: Container(
                                                  height: 120.0,
                                                  width: 120.0,
                                                  color: Color(0xffFF0E58),
                                                  child: Image.network(list[index]["image"],fit: BoxFit.cover,),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ), //CircleAvatar
                                                  SizedBox(
                                                    height: 10,
                                                  ), //SizedBox
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
                                                    'price'] + "Tk",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors
                                                          .black87,
                                                      fontWeight: FontWeight.w300,
                                                    ), //Textstyle
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      list[index][
                                                      'email'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .black87,
                                                      ), //Textstyle
                                                    ),
                                                  ),//Text
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ), //SizedBox
                                                  //SizedBox
                                                ],
                                              ),
                                            ],
                                          ), //Column
                                        ), //Padding
                                      ), //SizedBox
                                    ),
                                  ),
                                );
                              });
                        }
                      }catch(e){
                        return LinearProgressIndicator();
                      }
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();

  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/categoriesitem_shrubs');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Shrubs\nCategory",
                          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "10 Items",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/categoriesitem_herbs');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Herbs\nPlants",
                            style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "20 Items",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.lightBlueAccent.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/categoriesitem_climbers');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Climbers\nPlants",
                          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "20 Items",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.orange.shade300, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/categoriesitem_trees');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Trees\nCategory",
                          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "15 Items",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
