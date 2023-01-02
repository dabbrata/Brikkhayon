import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}
class _SettingsState extends State<Settings> {

  String userName = " ";
  String userEmail = " ";
  String currentPass = " ";

  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  final oldPassController = TextEditingController();
  final newUsernameController = TextEditingController();
  @override
  void dispose(){
    newPassController.dispose();
    confirmPassController.dispose();
    oldPassController.dispose();
    newUsernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showInfo();
  }
  void showInfo() async {
    final DocumentSnapshot userDetail = await FirebaseFirestore.instance.collection(
        "userdetails")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      userName = userDetail.get('username');
      userEmail = userDetail.get('email');
      currentPass = userDetail.get('password');
      //print(userName + userEmail);
    });
  }

  void updateUsername(String currUserName) async{

    if(currUserName.length < 4){
      Fluttertoast.showToast(msg: 'Length of username must be atleast 4');
      return;
    }
    FirebaseFirestore.instance.collection("userdetails").doc(FirebaseAuth.instance.currentUser!.uid).update({
      'username' : currUserName,
    });

    Fluttertoast.showToast(msg: 'Username updated successfully');
    newUsernameController.clear();
    Navigator.of(context).pop();
  }


  void updatePassword(String newPass, String confirmPass, String oldPassword) async {
    if(newPass != confirmPass) {
      Fluttertoast.showToast(msg: "Password are not matched!");
      return;
    }
    if(newPass.length<6){
      Fluttertoast.showToast(msg: "Password's length will be greater than 5!");
      return;
    }
    if(oldPassword != currentPass){
      Fluttertoast.showToast(msg: "Current password is incorrect!");
      return;
    }
    try{
      // final ref = FirebaseStorage.instance.ref().child("profilepic.jpg");//.child(DateTime.now().toString() + 'jpg');//
      // await ref.putFile(imageFile);
      //imgUrl = await ref.getDownloadURL();
      //String currentEmail = FirebaseAuth.instance.currentUser!.email.toString().trim();
      FirebaseAuth.instance.currentUser!.updatePassword(newPass);
      FirebaseFirestore.instance.collection("userdetails").doc(FirebaseAuth.instance.currentUser!.uid).update({
        'password' : newPass,
      });
      Fluttertoast.showToast(msg: "Password updated successfully");
      Navigator.of(context).pop();
      oldPassController.clear();
      newPassController.clear();
      confirmPassController.clear();
    }
    catch(e){
      Fluttertoast.showToast(msg: "Error occuerd for updating passsword!");
    }
  }


  Future<void> changeUsernameAlart() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.backspace),
                ),
              ),
              const Text('Update Username'),

            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Column(
                  children: [
                    //Text(imageName!),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller : newUsernameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Colors.black87),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2,color: Colors.black87)
                          ),
                          contentPadding: EdgeInsets.all(10),
                          labelText: "Username",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),

                      ),
                    ),



                    SizedBox(
                      height: 10,
                    ),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: (){
                      updateUsername(newUsernameController.text);

                    },
                    child:Text("Save")
                ),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[

          ],
        );
      },
    );
  }

  Future<void> changePasswordAlart() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.backspace),
                ),
              ),
              const Text('Update Password'),

            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Column(
                  children: [
                    //Text(imageName!),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller : oldPassController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Colors.black87),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2,color: Colors.black87)
                          ),
                          contentPadding: EdgeInsets.all(10),
                          labelText: "Old password",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),

                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller : newPassController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Colors.black87),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2,color: Colors.black87)
                          ),
                          contentPadding: EdgeInsets.all(10),
                          labelText: "New password",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),

                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 40,
                      child: TextField(
                        controller : confirmPassController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1,color: Colors.black87),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2,color: Colors.black87)
                          ),
                          contentPadding: EdgeInsets.all(10),
                          labelText: "Confirm password",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),

                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: (){
                      updatePassword(newPassController.text,confirmPassController.text,oldPassController.text);

                    },
                    child:Text("Save")
                ),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[

          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff056608)),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          title: Image.asset(
            'assets/images/splash.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.pushNamed(context, '/chatbot');
              },
              color: Color(0xff056608),
            )
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
              child: Column(
                children: <Widget>[
                  // Container(
                  //   alignment: Alignment(1, 1),
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 190,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       fit: BoxFit.fill,
                  //       image: NetworkImage("https://images.pexels.com/photos/236047/pexels-photo-236047.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                  //     ),
                  //   ),
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 10, bottom: 10),
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor,
                  //       borderRadius: new BorderRadius.circular(60),
                  //     ),
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: Icon(
                  //       Icons.camera_alt,
                  //       color: Colors.white, size: 32,
                  //     ),
                  //   ),
                  // ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border(
                            bottom: BorderSide( //                   <--- left side
                              color: Colors.grey.shade300,
                              width: 1.0,
                            )
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                          child: Text(
                            'Settings',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child:  ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, '/profilepage');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Card(
                              borderOnForeground: true,
                              child: ListTile(
                                leading: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.secondary, size: 28,),
                                title: Text('Profile', style: TextStyle(color: Colors.black, fontSize: 17)),
                                trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                          ),
                        ),
                       Container(
                         padding: EdgeInsets.all(15.0),
                         color: Colors.black26,
                         child: Column(

                           children: [
                             Card(
                               child: ListTile(
                                 onTap: (){
                                   Navigator.pushNamed(context, '/userallplants');
                                 },
                                 leading: Icon(Icons.upload, color: Theme.of(context).colorScheme.secondary, size: 28,),
                                 title: Text('Uploaded Plants', style: TextStyle(color: Colors.black, fontSize: 17)),
                                 trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).colorScheme.secondary),
                               ),
                             ),

                             Card(
                               child:  ListTile(
                                 onTap: (){
                                   changeUsernameAlart();
                                 },
                                 leading: Icon(Icons.manage_accounts_rounded, color: Theme.of(context).colorScheme.secondary, size: 28,),
                                 title: Text('Change Username', style: TextStyle(color: Colors.black, fontSize: 17)),
                                 trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).colorScheme.secondary),
                               ),
                             ),
                             Card(
                               child: ListTile(
                               onTap:(){
                                 changePasswordAlart();
                               },
                                 leading: Icon(Icons.vpn_key, color: Theme.of(context).colorScheme.secondary, size: 28,),
                                 title: Text('Change Password', style: TextStyle(color: Colors.black, fontSize: 17)),
                                 trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).colorScheme.secondary),
                               ),
                             ),
                             Card(
                               child: ListTile(
                                 onTap: () {
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
                                 leading: Icon(Icons.lock, color: Theme.of(context).colorScheme.secondary, size: 28,),
                                 title: Text('Logout', style: TextStyle(color: Colors.black, fontSize: 17)),
                                 trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).colorScheme.secondary),
                               ),
                             ),
                           ],
                         ),

                       ),
                      ],
                    ),
                  ),

                ],
              ),
        )
    );
  }
}
