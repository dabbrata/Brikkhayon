import 'package:Brikkhayon/auth/forgotpass.dart';
import 'package:Brikkhayon/auth/profilepage.dart';
import 'package:Brikkhayon/auth/signup.dart';
import 'package:Brikkhayon/auth/verifyemail.dart';
import 'package:Brikkhayon/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter_login/twitter_login.dart';

import 'auth.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final _accessToken = FacebookAuth.instance.accessToken;
  // bool _checking = true;
  // Map<String, dynamic>? _userdata;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'signup': (context) => SignUp(),
        'forgotpass': (context) => ForgotPass(),
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return VerifyEmailPage();
              } else {
                return SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
//                    color: Colors.red,
                            alignment: Alignment.topCenter,
                            height: 105,
                            margin: EdgeInsets.only(top: 0.0),
                            child: Image.asset('assets/images/splash.png'),
                          ),
                          Container(
//                    color: Colors.amber,
                            margin: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xff056608),
                              ),
                            ),
                          ),
                          Container(
//                    color: Colors.amber,
                            margin: EdgeInsets.only(
                                top: 40.0, left: 20.0, right: 20.0),
                            child: TextField(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.green),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.green)),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          Container(
//                    color: Colors.amber,
                            margin: EdgeInsets.only(
                                top: 20.0, left: 20.0, right: 20.0),
                            child: TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.green),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.green)),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                                width: 500,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xff056608),
                                ),
                                child: TextButton(
                                  child: Text('Sign In'),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    //padding: EdgeInsets.only(left:205.0,right: 205.0,top:25.0,bottom: 25.0),
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: signIn,
                                )),
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 30.0, left: 20.0, right: 20.0),
                              child: Text('Forgot password?'),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, 'forgotpass');
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'signup');
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 60.0, left: 20.0, right: 20.0),
                            child: Text('Sign in with'),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // child: Image.asset('assets/images/google.png'),
                                    margin: EdgeInsets.only(right: 10.0),
                                    child: IconButton(
                                      icon: Image.asset(
                                          'assets/images/google.png'),
                                      iconSize: 50,
                                      onPressed: SignInWithGoogle,
                                    ),
                                  ),
                                  Container(
                                      child: IconButton(
                                        icon: Image.asset(
                                            'assets/images/facebook.png'),
                                        onPressed: SignInWithFacebook,
                                        iconSize: 50,
                                      )),
                                  Container(
                                    child: IconButton(
                                      icon: Image.asset(
                                          'assets/images/twitter.png'),
                                      onPressed: SignInWithTwitter,
                                      iconSize: 50,
                                    ),
                                    margin: EdgeInsets.only(left: 10.0),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    if(emailController.text.trim() == 'roy1807084@stud.kuet.ac.bd' && passwordController.text.trim()=='admin1')
    {
      isAdmin = true;
      const snackBar = SnackBar(
        content: Text('Welcome admin'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }


    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  SignInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
    await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Fluttertoast.showToast(
          msg: 'You are now logged in!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.of(context).pop();
    }
  }

  SignInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken!.token);

    //final userData = await FacebookAuth.instance.getUserData();
    // final userEmail = userData['email'];

    try {
      FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      Fluttertoast.showToast(
          msg: "You are now logged in!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/');
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 15.0);
      Navigator.of(context).pop();
    }
  }

  void SignInWithTwitter() async{
    final twitterLogin = new TwitterLogin(
        apiKey: '6ApGSaZuIFvbVIH0N7EtEI9gC',
        apiSecretKey: 'Gmxp9hzWmeROMyVyOpSMcTDdLpsOKQC0FdMGtIZXu6XCSxXhUW',
        redirectURI: 'flutter-twitter-login-brikkhayon://');

    await twitterLogin.login().then((value) async{

      final twitterAuthCredential = TwitterAuthProvider.credential(accessToken: value.authToken!, secret: value.authTokenSecret!);

      try {
        FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);

        Fluttertoast.showToast(
            msg: 'Successfully logged in',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 15.0
        );
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      } on FirebaseAuthException catch (e){
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 15.0
        );
        Navigator.of(context).pop();
      }

    });
  }
}