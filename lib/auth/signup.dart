import 'dart:convert';

import 'package:Brikkhayon/auth/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();

  @override
  void dispose(){

    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    conpasswordController.dispose();

    super.dispose();
  }
  String imageUrl = " ";
  void getImage() async{
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("sourceimage").doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      imageUrl = userDoc.get('image');
      print(imageUrl);
    });
  }

  void uploadData() async {
    try{

      getImage();
      FirebaseFirestore.instance.collection("userdetails").doc(FirebaseAuth.instance.currentUser!.uid).set({
        'username':usernameController.text.trim(),
        'email':emailController.text.trim(),
        'password' : passwordController.text.trim(),
        'createdAt' : DateTime.now(),
        'image' : imageUrl,
        'userId' : FirebaseAuth.instance.currentUser!.uid,
      });
      //Fluttertoast.showToast(msg: "Completed upload");
    }
    catch(e){
      Fluttertoast.showToast(msg: "error occuerd for storing user info!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'signIn' : (context) => SignIn(),
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 105,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/splash.png'),
                        fit: BoxFit.fitHeight,
                      ),

                    ),

                  ),
                  Container(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:24,
                              color: Color(0xff056608),
                            ),
                          ),
                          SizedBox(height: 30),
                          //user text field
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                //border: Border.all(color: Colors.green),
                                //borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: TextFormField(
                                  controller: usernameController,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (uname) => uname == '' ? 'Enter a valid username' : null,
                                  decoration: InputDecoration(
                                    //contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.green),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: Colors.green),
                                    ),
                                    labelText: 'Username',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //email text field
                          SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                //border: Border.all(color: Colors.green),
                                //borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: TextFormField(
                                  controller: emailController,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (email) =>
                                      email != null && !EmailValidator.validate(email)
                                        ? 'Enter a valid email address'
                                          : null,
                                  decoration: InputDecoration(
                                    //contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.green),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: Colors.green),
                                    ),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //password text field
                          SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                //border: Border.all(color: Colors.green),
                                //borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (pass) => pass != null && (pass.length<6) ? 'Password minimum of 6 characters' : null,
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    //contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.green),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: Colors.green),
                                    ),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //confirm password text field
                          SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                //border: Border.all(color: Colors.green),
                                //borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (cpass) => cpass != null && (cpass.length<6) ? 'Password minimum of 6 characters' : null,
                                  controller: conpasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    //contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.green),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: Colors.green),
                                    ),
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                                width: 500,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5 ),
                                  color: Color(0xff056608),
                                ),
                                child: TextButton(
                                  child: Text('Register'),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    //padding: EdgeInsets.only(left:205.0,right: 205.0,top:25.0,bottom: 25.0),
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: () {
                                    if(passwordController.text.toString()==conpasswordController.text.toString()){
                                      signUp();
                                    }
                                    else{
                                      Fluttertoast.showToast(
                                          msg: 'Passwords do not match!',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    }
                                  },
                                )
                            ),
                          ),


                          //already have an account?
                          SizedBox(height: 50),
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize:15,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 1),
                          TextButton(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:15,
                                color: Colors.black54,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => SignIn()));
                            },
                          ),

                        ],),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async{
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;

    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        }
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: 'Registered successfully! Please verify your email to sign in...',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    uploadData();
  }
}
