import 'package:Brikkhayon/shop/checkout.dart';
import 'package:counter_button/counter_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _counterValue = 0;
  int sum = 0;
  String? pid;
  DatabaseReference? dRef;
  dynamic snapshot;
  Map<String, String>? data;
  Map<String, String>? dataSorted;

  @override
  void initState() {
    getPreferenceValue();
    super.initState();
  }

  void getPreferenceValue() async {
    final prefs = await SharedPreferences.getInstance();
    pid = prefs.getString('parentid');
    print(pid.toString());
    dRef = FirebaseDatabase.instance
        .ref()
        .child('allplants')
        .child(pid.toString());
    dRef!.onValue.listen((DatabaseEvent event) {
      data = Map<String, String>.from(
        event.snapshot.value as Map,
      );
      data!.forEach((key, value) {
        print('$value');
      });
      dataSorted = Map.fromEntries(
          data!.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
      setState(() {});
//      sum =
    });
    //   FirebaseDatabase.instance.ref("allplants").child(pid.toString()).listen((event) {
    //     final data =
    //     Map<String, dynamic>.from(event.snapshot.value as Map,);
    //     data.forEach((key, value) {
    //       // print('$value['name']');
    //     });
    //   });
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
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Check Out',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF056608),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 10),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Color(0xFFF5F5F5),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 5, 0, 5),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    dataSorted!.values.elementAt(5),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 10, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          dataSorted!.values.elementAt(6),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        dataSorted!.values.elementAt(0),
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 5, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                dataSorted!.values.elementAt(8),
                                                style: TextStyle(
                                                  color: Color(0xFF056608),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              child: CounterButton(
                                                loading: false,
                                                onChange: (int val) {
                                                  setState(() {
                                                    _counterValue = val;
                                                    if (_counterValue <= 0) {
                                                      _counterValue = 0;
                                                    }
                                                    sum = _counterValue *
                                                        int.parse(dataSorted!
                                                            .values
                                                            .elementAt(8));
                                                    if (sum != 0) {
                                                      sum = sum + 50;
                                                    }
                                                  });
                                                },
                                                count: _counterValue,
                                                countColor: Colors.black,
                                                buttonColor: Colors.black,
                                                progressColor:
                                                Colors.amberAccent,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Shipping: ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '৳ 50',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF056608),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Total: ',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              sum.toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF056608),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xFF056608),
                      ),
                      margin: EdgeInsets.only(right: 20, bottom: 7),
                      child: TextButton(
                          onPressed: () {
                            //Navigator.pushNamed(context, '/checkout');
                            //print(pid);
                            showConfirmationDialog(context);
                          },
                          child: Text(
                            'Check Out',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmation Alert!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Add this item to cart?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    String str = "${Uuid().v1()}".toString();
                    try {
                      FirebaseDatabase.instance
                          .ref()
                          .child("orders")
                          .child(FirebaseAuth.instance.currentUser!.uid)
                          .child(str)
                          .set({
                        "price": sum,
                        "orderTime": DateTime.now().toString(),
                        "pid": pid,
                        "ownerId": dataSorted!.values.elementAt(3),
                        "orderId": str,
                        "plantNum": _counterValue,
                        "image": dataSorted!.values.elementAt(5),
                        "name": dataSorted!.values.elementAt(6),
                      });
                      FirebaseDatabase.instance
                          .ref()
                          .child("allOrders")
                          .child(str)
                          .set({
                        "price": sum,
                        "orderTime": DateTime.now().toString(),
                        "pid": pid,
                        "ownerId": dataSorted!.values.elementAt(3),
                        "orderId": str,
                        "plantNum": _counterValue,
                        "image": dataSorted!.values.elementAt(5),
                        "name": dataSorted!.values.elementAt(6),
                      });
                      const snackBar = SnackBar(
                        content: Text('Order placed successfully!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      sendLatLng(dataSorted!.values.elementAt(1));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Checkout()));
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  void sendLatLng(String address) async{
    List<Location> location = await locationFromAddress(address);
    final shRef = await SharedPreferences.getInstance();
    shRef.setDouble('lat', location.first.latitude);
    shRef.setDouble('lng', location.first.longitude);
  }
}
