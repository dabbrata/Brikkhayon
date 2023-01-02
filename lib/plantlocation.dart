import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlantLocation extends StatefulWidget {
  const PlantLocation({Key? key}) : super(key: key);

  @override
  _PlantLocationState createState() => _PlantLocationState();
}

class _PlantLocationState extends State<PlantLocation> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? googleMapController;
  double? lat, lng;
  late double _lat, _lng;
  late CameraPosition initalPosition;

  @override
  void initState() {
    getLatLng();
    super.initState();
  }

  void getLatLng() async {
    final pref = await SharedPreferences.getInstance();
    lat = pref.getDouble('latitute');
    lng = pref.getDouble('longitute');
    setState(() {
      _lat = lat!;
      _lng = lng!;
      initalPosition = CameraPosition(target: LatLng(_lat, _lng), zoom: 18);
    });
  }

  Set<Marker> markers = {};

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
      body: GoogleMap(
          initialCameraPosition: initalPosition,
          markers: markers,
          zoomControlsEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          }),
    );
  }
}
