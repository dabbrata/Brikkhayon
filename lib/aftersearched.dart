import 'package:Brikkhayon/recognition/home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product_detail.dart';
List<dynamic> items = [];
void main() {
  runApp(new MySearchPlant());
}


class MySearchPlant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brikkhayon',
      home: new SearchPlant(),
      theme: new ThemeData(primaryColor: Colors.black),
    );
  }
}

class SearchPlant extends StatefulWidget {
  @override
  _SearchPlantState createState() => new _SearchPlantState();
}

class _SearchPlantState extends State<SearchPlant> with TickerProviderStateMixin {
  late TabController tabController;

  DatabaseReference dbReference = FirebaseDatabase.instance.ref().child("allplants");


  late String name,name2 ;
  void getSearchMsg() async {
    final ref = await SharedPreferences.getInstance();
    name = ref.getString('searchMsg').toString();
    //name2 = ref.getString('searchRecMsg').toString();

    //print(name + "  " + name2);
    //print("assign "+name);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getSearchMsg();
    });

  }

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

        //iconTheme: IconThemeData(color: Color(0xff056608)),
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.green),
        //   onPressed: () {
        //    Navigator.of(context).pop();
        //   }
        // ),
        title: Text(
          'Searched Plants',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),

        centerTitle: true,
        elevation: 0,
      ),
      body: Container(

        child: StreamBuilder(
          stream: dbReference.onValue,
          builder: (context,
              AsyncSnapshot<DatabaseEvent>
              snapshot) {
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
              items.clear();
              list = map.values.toList();
              for(int i = 0;i<list.length;i++){
                String strn = list[i]['name'];
                if(strn.toLowerCase().contains(name.toString())){
                  items.add(list[i]);
                  print(list[i]['name']);
                }

              }
              //items = list;
              return new GridView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 220.0,),
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
                                  height: 140.0,
                                  width: MediaQuery.of(context).size.width*100,
                                  //color: Color(0xffFF0E58),
                                  child: CachedNetworkImage(imageUrl:items[index]["image"],fit: BoxFit.cover,
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
                                      items[index]
                                      ['name'],
                                      style: TextStyle(
                                        fontSize: 15,
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
                                      items[index][
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
                        String str = items[index]['pid'].toString();
                        //print(items[0]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Products(
                                    text: items[index]['text'].toString(),
                                    name: items[index]['name'].toString(),
                                    about: items[index]['about'].toString(),
                                    address: items[index]['address'].toString(),
                                    createdAt: items[index]['createdAt'].toString(),
                                    image: items[index]['image'].toString(),
                                    price: items[index]['price'].toString(),
                                    email: items[index]['email'].toString(),
                                    parentid: items[index]['pid'].toString(),
                                  ),
                            ));
                      },
                    );
                  });
            };
          },
        ),
      ),

    );
  }


}