//import 'package:splash_screen/constants.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _coffeeController;
  bool copAnimated = false;
  bool animateCafeText = false;

  @override
  void initState() {
    super.initState();
    _coffeeController = AnimationController(vsync: this);
    _coffeeController.addListener(() {
      if (_coffeeController.value > 0.7) {
        _coffeeController.stop();
        copAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          animateCafeText = true;
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: cafeBrown,
        body: Stack(
          children: [
            // White Container top half
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: copAnimated ? screenHeight / 2 : screenHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(copAnimated ? 40.0 : 0.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Visibility(
                    visible: !copAnimated,
                    child: Lottie.asset(
                      'assets/splashplant.json',
                      controller: _coffeeController,
                      onLoaded: (composition) {
                        _coffeeController
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
                  ),
                  Visibility(
                    visible: copAnimated,
                    child: Image.asset(
                      'assets/images/splash.png',
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: animateCafeText ? 1 : 0,
                        duration: const Duration(seconds: 1),
                        child: const Text(
                          'BRIKKHAYON',
                          style: TextStyle(fontSize: 30.0, color: cafeBrown,letterSpacing: 4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Text bottom part
            Visibility(visible: copAnimated, child: const _BottomPart()),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async{
    bool? exitApp = await showDialog(context: context,
        builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Do you want to exit?"),
              actions: <Widget> [
                TextButton(
                  onPressed:(){
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No"),
                ),
                TextButton(
                    onPressed:(){
                      if(Platform.isAndroid) {
                        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                      }
                      else{
                        exit(0);
                      }
                    },
                    child: const Text("Yes"),
                )

              ],
            );
        }
    );
    return exitApp ?? false;
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30.0),
            const Text(
              'Find The Best Plant for You',
              style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 30.0),
            Text(
              'This is the platform to make environment greenful. '
                  'Buy and sell your all plants from here.',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50.0),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 55.0,
                //width: MediaQuery.of(context).size.width * 0.75,
                // decoration: BoxDecoration(
                //   shape: BoxShape.rectangle,
                //   border: Border.all(color: Colors.white, width: 2.0),
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(50),
                //   ),
                // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextButton(
                          child: Text('SIGN IN'),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            //padding: EdgeInsets.only(left:205.0,right: 205.0,top:25.0,bottom: 25.0),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 2
                            ),
                          ),

                          onPressed: () {
                            Navigator.pushNamed(context, '/signin');
                          },
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextButton(
                          child: Text('SIGN UP'),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            //padding: EdgeInsets.only(left:205.0,right: 205.0,top:25.0,bottom: 25.0),
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 2
                            ),
                          ),

                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                        ),
                      ),
                    ],
                  ),


              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}