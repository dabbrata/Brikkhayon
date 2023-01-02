import 'dart:ffi';
import 'dart:math';

import 'package:Brikkhayon/product_detail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<String> list1 = [];
List<dynamic> list2 = [];

List<dynamic> listf = [];

String rangeStr = " ";
//Double? rangeDouble;
double rangeDouble = 0.0;




class NearbyPlants extends StatefulWidget {
  const NearbyPlants({Key? key}) : super(key: key);

  @override
  _NearbyPlantsState createState() => _NearbyPlantsState();
}

class _NearbyPlantsState extends State<NearbyPlants> {
  String? _currentAddress;
  Position? _currentPosition;
  double? _lat, _lng;

  Future getAddressInfo() async {
    FirebaseDatabase.instance.ref("allplants").onValue.listen((event) {
      list1.clear();
      //list2.clear();

      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );

      data.forEach((key, value) {
        setState(() {
          list1.add(value['address']);
        });
      });
    });
  }

  Future getDistanceInfo() async {
    for (int i = 0; i < list1.length; i++) {
      List<Location> location = await locationFromAddress(list1[i].toString());
      //print(location.first.latitude);
      setState(() {});
      list2.add(calculateDistance(
          _currentPosition?.latitude,
          _currentPosition?.longitude,
          location.first.latitude,
          location.first.longitude));
      print(list2.last);
    }
    print(list2.length);
  }

  @override
  void initState() {
    getAddressInfo();
    _handleLocationPermission();
    _getCurrentPosition();
    print(list1.length);
    //print(list1[0]);
    getDistanceInfo();
    //print(list2.length);
    super.initState();
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  final rangeController = TextEditingController();

  final dbRef = FirebaseDatabase.instance.ref().child('allplants');

  //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            color: Colors.transparent,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF056608),
              size: 30,
            ),
          ),
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
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: TextField(
                        controller: rangeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Range',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                'Available plants within ' +
                                    '${rangeDouble}' +
                                    ' KM',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            child: ElevatedButton(
                              child: Text('Search'),
                              onPressed: () {
                                try {
                                  rangeStr = rangeController.text.toString();
                                  rangeDouble = double.parse(rangeStr);
                                  if (rangeDouble == null) {
                                    print("empty");
                                  } else {
                                    print(rangeDouble);
                                  }
                                } catch (e) {
                                  print(e);
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: () async {
                    getAddressInfo();
                    _handleLocationPermission();
                    _getCurrentPosition();
                    //print(list1.length);
                    //print(list1[0]);
                    getDistanceInfo();

                    try {
                      rangeStr = rangeController.text.toString();
                      rangeDouble = double.parse(rangeStr);
                      if (rangeDouble == null) {
                        print("empty");
                      } else {
                        print(rangeDouble);
                      }
                    } catch (e) {
                      print(e);
                    }
                    setState(() {});
                  },
                  child: StreamBuilder(
                    stream: dbRef.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        Map<dynamic, dynamic> map =
                            snapshot.data!.snapshot.value as dynamic;
                        List<dynamic> list = [];
                        list.clear();
                        listf.clear();
                        //List<dynamic> listf = [];
                        list = map.values.toList();

                        //Double rangeDouble = double.parse(rangeStr) as Double;

                        try {
                          for (int i = 0; i < list2.length; i++) {
                            if (list2[i] < rangeDouble) {
                              listf.add(list[i]);
                            }
                          }
                        } catch (e) {

                          print("exception is : ");
                          print(e);
                        }

                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: listf.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Products(
                                          text: listf[index]['text'].toString(),
                                          name: listf[index]['name'].toString(),
                                          about:
                                              listf[index]['about'].toString(),
                                          address: listf[index]['address']
                                              .toString(),
                                          createdAt: listf[index]['createdAt']
                                              .toString(),
                                          image:
                                              listf[index]['image'].toString(),
                                          price:
                                              listf[index]['price'].toString(),
                                          email:
                                              listf[index]['email'].toString(),
                                          parentid:
                                              listf[index]['pid'].toString(),
                                        ),
                                      ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12),
                                  child: Card(
                                    elevation: 20,
                                    shadowColor: Colors.black,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: 150,
                                      height: 120,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, bottom: 0, right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // SizedBox(
                                            //   height: 1,
                                            // ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5.0), //or 15.0
                                              child: Container(
                                                height: 120.0,
                                                width: 120.0,
                                                color: Color(0xffFF0E58),
                                                child: Image.network(
                                                  listf[index]["image"],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ), //CircleAvatar
                                                SizedBox(
                                                  height: 10,
                                                ), //SizedBox
                                                Text(
                                                  listf[index]['name'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ), //Textstyle
                                                ), //Text
                                                // SizedBox(
                                                //   height: 10,
                                                // ), //SizedBox
                                                Text(
                                                  listf[index]['price'] + "Tk",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w300,
                                                  ), //Textstyle
                                                ),
                                                Text(
                                                  listf[index]['email'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ), //Textstyle
                                                ), //Text
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
                    },
                  ),
                )),
                SizedBox(
                  height: 40,
                  child: Container(
                    color: Colors.black45,
                    //margin: EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      "Please pull down to get updated plants",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

// getLoc(String list) async {
//
//   double distance =  calculateDistance(_currentPosition?.latitude, _currentPosition?.longitude, _lat, _lng);
//   return distance;
// }

// Future getDistanceList(List list) async{
//   for(int i = 0;i<list.length;i++){
//     List<Location> location = await locationFromAddress(list[i]["address"]);
//        _lat = location.first.latitude;
//        _lng = location.first.longitude;
//     double distance =  calculateDistance(_currentPosition?.latitude, _currentPosition?.longitude, _lat, _lng);
//     //print(distance);
//     list1.add(distance);
//   }
// }

}
