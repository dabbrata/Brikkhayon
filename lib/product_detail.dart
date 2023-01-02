import 'package:Brikkhayon/cart.dart';
import 'package:Brikkhayon/plantlocation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Products extends StatelessWidget {
  String text,name,about,address,createdAt,image,price,email,parentid;


  Products(
      {   required this.text,
        required this.name,
        required this.about,
        required this.address,
        required this.createdAt,
        required this.image,
        required this.price,
        required this.email,
        required this.parentid,
      });

  //final reference = FirebaseDatabase.instance.ref().child("allplants").child("${text}");
  // final snapshot = reference.child('allplants/$text/price').get();
  //  String newTxt = text.toString();
  //DatabaseReference dbRefrence = FirebaseDatabase.instance.ref().child("allplants").child(text);

  //DateTime date = createdAt.toDate();

  @override
  Widget build(BuildContext context) {
    void getLocation(String address) async{
      final preference = await SharedPreferences.getInstance();
      List<Location> location = await locationFromAddress(address);
      print(location.first);
      double d1 = location.first.latitude;
      double d2 = location.first.longitude;
      preference.setDouble('latitute', d1);
      preference.setDouble('longitute', d2);
      Navigator.push(context, MaterialPageRoute(builder: (context) => PlantLocation()));
    }
    final imageUrl = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xFF056608),
        ),
        title: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.contain,
          height: 50,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ClipRRect(
                  child: SizedBox(
                    height: 320, // Image radius
                    width: double.infinity,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: image,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      new Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(-1.0, -1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${name}',
                              style: TextStyle(
                                  color: Color(0xFF056608),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text('Uploaded by\n' + email,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Color(0xFF056608),
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              price + " Tk",
                              style: TextStyle(
                                color: Color(0xFF056608),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: 200,
                            child: Text(
                              DateFormat.yMMMEd().format(DateTime.parse(createdAt)),

                            ),
                          ),
                          // Timestamp t = createdAt as Timestamp;
                          // DateTime date = t.toDate();
                          TextButton.icon(
                            onPressed: (){
                              print(address);
                              getLocation(address);
                            },
                            style: TextButton.styleFrom(
                                side: BorderSide(
                                    width: 1, color: Color(0xFF056608))),
                            label: Text(
                              'Find location',
                              style: TextStyle(color: Color(0xFF056608)),
                            ),
                            icon: Icon(
                              Icons.location_on,
                              size: 20,
                              color: Color(0xFF056608),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      elevation: 40,
                      shadowColor: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding:
                              EdgeInsets.only(left: 15, right: 15, top: 10),
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                          Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15.0, right: 15, bottom: 20),
                                child: Text(
                                  about,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFF056608)
                      ),
                      child: TextButton.icon(
                        onPressed: (){
                          //Navigator.pushNamed(context, '/cart');
                          sendToCart(parentid);
                          print(parentid);
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => CartList()));
                          //print(text);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CartList()));
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        label: Text(
                          'Add to cart',
                          style: TextStyle(color: Colors.white,fontSize: 20),
                        ),
                        icon: Icon(
                          Icons.add_circle_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  void sendToCart(String parentid) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parentid', parentid);
    print(parentid);
  }
}
