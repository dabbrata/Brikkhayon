import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

//const LatLng currentLocation = LatLng(25.1193, 55.3773);

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? googleMapController;
  //static final CameraPosition initalPosition  = const CameraPosition(target: LatLng(23.755613, 90.368591),zoom: 18);
  static CameraPosition? initalPosition;

  Set<Marker> markers = {};

  String name = " ";
  String email = " ";

  final dataRef = FirebaseDatabase.instance.ref().child('orders').child(FirebaseAuth.instance.currentUser!.uid);
  final dataRef2 = FirebaseDatabase.instance.ref().child('allOrders');

  Map? order;

  double? _lat,_lng;

  void getLatLng() async{
    final shRef = await SharedPreferences.getInstance();
    _lat = shRef.getDouble('lat');
    _lng = shRef.getDouble('lng');
    initalPosition  = CameraPosition(target: LatLng(_lat!, _lng!),zoom: 18);
    setState(() {

    });
  }

  void getData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("userdetails").doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      name = userDoc.get('username');
      email = userDoc.get('email');
    });
  }

  Future<void> _listItemDeleteDialog(String oid) async {
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
                              dataRef.child(oid).remove();
                              dataRef2.child(oid).remove();
                              const snackBar = SnackBar(
                                content: Text('Order was deleted!'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getLatLng();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Color(0xFF056608),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          title: Image.asset(
            'assets/images/splash.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF056608),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    elevation: 20,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Text(
                              'Owner:',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF056608),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            margin: EdgeInsets.only(bottom: 5),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'Name: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         'Address: ',
                          //         style: TextStyle(
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //       Text(
                          //         'Dhanmondi, Dhaka',
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: double.infinity,
                            ),
                            // padding: EdgeInsets.only(right: 17),
                            child: Row(
                              children: [
                                Text(
                                  'Email: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         'Phone: ',
                          //         style: TextStyle(
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //       Text(
                          //         '01765-010710',
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Text(
                      'Use provided email or phone number to know the details of your order.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.map,
                        size: 40,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text('Owner\'s location')
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Material(
                    elevation: 20,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 220,
                            child: GoogleMap(
                              initialCameraPosition: initalPosition!,
                              markers: markers ,
                              zoomControlsEnabled: true,
                              mapType: MapType.normal,
                              onMapCreated: (GoogleMapController controller){
                                googleMapController = controller;
                              },

                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: 40,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text('Your orders')
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:12.0,right:12),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    height: 240.0,
                    width: MediaQuery.of(context).size.width*80,
                    child: Column(
                      //scrollDirection: Axis.horizontal,
                        children:  [
                          Expanded(
                            child: FirebaseAnimatedList(
                                query: dataRef,
                                itemBuilder: (context,snapshot,animation,index){
                                  order = snapshot.value as Map;
                                  order!['key'] = snapshot.key;
                                  //print(snapshot.key);
                                  return Container(
                                    height: 90,
                                    padding: EdgeInsets.all(8),
                                    child: Material(
                                      elevation: 3,
                                      shadowColor: Colors.grey,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),

                                      child: ListTile(
                                        onTap: (){
                                          //Navigator.pushNamed(context, routeName)
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //       builder: (context) => Products(
                                          //         text: snapshot.key.toString(),
                                          //         name: snapshot.child('name').value.toString(),
                                          //         about: snapshot.child('about').value.toString(),
                                          //         address: snapshot.child('address').value.toString(),
                                          //         createdAt: snapshot.child('createdAt').value.toString(),
                                          //         image: snapshot.child('image').value.toString(),
                                          //         price: snapshot.child('price').value.toString(),
                                          //         email: snapshot.child('email').value.toString(),
                                          //         parentid: snapshot.child('parentid').value.toString(),
                                          //
                                          //       ),
                                          //     ));
                                        },
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        selectedTileColor: Colors.orange[200],
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            height: 70,
                                            width: 70,
                                            child : Image.network(snapshot.child('image').value.toString(),fit: BoxFit.cover,),
                                          ),
                                        ),
                                        title: Text(
                                          snapshot.child('name').value.toString(),
                                          style: TextStyle(fontSize: 14,color: Colors.black),
                                        ),
                                        subtitle: Text(
                                            'Total plants: '+snapshot.child('plantNum').value.toString()+'\n'+'Cost: '+snapshot.child('price').value.toString() + "Tk",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme.secondary,
                                                fontWeight:
                                                FontWeight.w700)
                                        ),
                                        trailing: IconButton(
                                            onPressed: (){
                                              //print(snapshot.child("name").value.toString());
                                              _listItemDeleteDialog(snapshot.child("orderId").value.toString());

                                            },
                                            icon: Icon(Icons.delete)
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
