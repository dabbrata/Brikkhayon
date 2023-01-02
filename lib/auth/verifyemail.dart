import 'dart:async';

import 'package:Brikkhayon/auth/profilepage.dart';
import 'package:Brikkhayon/auth/globals.dart';
import 'package:Brikkhayon/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    // final message = SnackBar(
    //     content: Text(
    //         'A verification email has been sent to your email. Please very to continue...'));

    if (!isEmailVerified) {
      try {
        sendVerificationMail();
        Fluttertoast.showToast(
            msg: "Verification email has been sent successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      // ScaffoldMessenger.of(context).showSnackBar(message);

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    } else {
      isLoggedIn = true;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationMail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      Fluttertoast.showToast(
          msg: "Verification email has been sent successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      // setState(() => canResendEmail = false);
      // await Future.delayed(Duration(seconds: 5));
      // setState(() => canResendEmail = true);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? Home()
      : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
              icon:
                  Icon(Icons.arrow_back_ios_new_outlined, color: Colors.green),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //color: Colors.blue,
                      alignment: Alignment.topCenter,
                      height: 105,
                      margin: EdgeInsets.only(top: 0.0),
                      child: Image.asset('assets/images/splash.png'),
                    ),
                    Container(
                      //color: Colors.amber,
                      margin: EdgeInsets.only(top: 60.0, left: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'A verification email has been sent to your registered email address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xff056608),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                          width: 500,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xff056608),
                          ),
                          child: TextButton.icon(
                            icon: Icon(Icons.email),
                            label: Text('Resend Email'),
                            style: TextButton.styleFrom(
                              //padding: EdgeInsets.only(left:205.0,right: 205.0,top:25.0,bottom: 25.0),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: sendVerificationMail,
                          )),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: Size.fromHeight(50),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () => FirebaseAuth.instance.signOut(),
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
}
