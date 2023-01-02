import 'package:flutter/material.dart';

import '../home/home.dart';


class Logged extends StatefulWidget {
  const Logged({Key? key}) : super(key: key);

  @override
  _LoggedState createState() => _LoggedState();
}

class _LoggedState extends State<Logged> {
  final scaffoldKey = GlobalKey<ScaffoldState>();


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
      body: Center(
        child : ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            },
            child:Text("Home")
        ),
      ),
    );
  }
}