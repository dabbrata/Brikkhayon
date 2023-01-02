import 'package:Brikkhayon/auth/auth.dart';
import 'package:Brikkhayon/auth/globals.dart';
import 'package:Brikkhayon/auth/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:Brikkhayon/blocks/auth_block.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:Brikkhayon/auth/globals.dart' as globals;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String str = "";
  @override
  void initState() {
    FirebaseDatabase.instance.ref().child('orders').child(FirebaseAuth.instance.currentUser!.uid).once().then((event){
      final snapshot = event.snapshot;
      setState(() {
        str = snapshot.children.length.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home, color: Theme.of(context).colorScheme.secondary),
                title: Text('Home'),
                onTap: () {
                  setState(() {

                  });
                  print(str);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.supervised_user_circle, color: Theme.of(context).colorScheme.secondary),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profilepage');
                },
              ),
              //search page
              ListTile(
                leading: Icon(Icons.search_sharp, color: Theme.of(context).colorScheme.secondary),
                title: Text('Search'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/searchpage');
                },
              ),
              ListTile(
                leading:
                Icon(Icons.category, color: Theme.of(context).colorScheme.secondary),
                title: Text('Categorise'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/categorise');
                },
              ),
              ListTile(
                leading:
                Icon(Icons.contact_mail, color: Theme.of(context).colorScheme.secondary),
                title: Text('Contact'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/chatbot');
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('My Orders'),
                trailing: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(str,
                      style: TextStyle(color: Colors.white, fontSize: 10.0)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/orders');
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.lock, color: Theme.of(context).colorScheme.secondary),
              //   title: Text('Login'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.pushNamed(context, '/signin');
              //   },
              // ),
              if(isAdmin == true)
                ListTile(
                  leading: Icon(Icons.admin_panel_settings, color: Theme.of(context).colorScheme.secondary),
                  title: Text('Admin'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin');
                  },
                ),
              Divider(),
              ListTile(
                leading:
                Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),

              ListTile(
                leading: Icon(Icons.exit_to_app,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('Logout'),
                onTap: () {
                  isAdmin = false;
                  FirebaseAuth.instance.signOut();
                  Fluttertoast.showToast(
                      msg: "Logged out successfully!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  Navigator.pushNamed(context, '/splash_screen');
                },
              )
            ],
          ),
        )
      ],
    );
  }
}


//  C:\Users\srsau.DESKTOP-T9VMR06.000\.android
//  8p6uEqqKWVea/3BpdTwLK3tRYIw=
//  jcrcLvNWQwps9TOP1Q==
//  8p6uEqqKWVea/3BpdTwLK3tRYIw=
//  keytool -exportcert -alias androiddebugkey -keystore "C:\Users\srsau.DESKTOP-T9VMR06.000\.android\debug.keystore" | "C:\Users\srsau.DESKTOP-T9VMR06.000\Desktop\openssl-0.9.8k_X64\bin\openssl" sha -binary | "C:\Users\srsau.DESKTOP-T9VMR06.000\Desktop\openssl-0.9.8k_X64\bin\openssl" base64