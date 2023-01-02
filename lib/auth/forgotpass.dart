import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';

class ForgotPass extends StatefulWidget{
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}
class _ForgotPassState extends State<ForgotPass>{

  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.green),
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
                    child: Image.asset(
                        'assets/images/splash.png'
                    ),
                  ),
                  Container(
                    //color: Colors.amber,
                    margin: EdgeInsets.only(top: 60.0,left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Provide your registered email address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff056608),
                      ),
                    ),
                  ),
                  Container(
//                    color: Colors.amber,
                    margin: EdgeInsets.only(top: 20.0,left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email address'
                          : null,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1,color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.green)
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
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
                          borderRadius: BorderRadius.circular(5 ),
                          color: Color(0xff056608),
                        ),
                        child: TextButton(
                          child: Text('Reset password'),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            //padding: EdgeInsets.only(left:205.0,right: 205.0,top:25.0,bottom: 25.0),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: resetPassword,
                        )
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

  Future resetPassword() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );

    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      Fluttertoast.showToast(
          msg: 'Password reset mail sent successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    on FirebaseAuthException catch (e){
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.of(context).pop();
    }
  }
}