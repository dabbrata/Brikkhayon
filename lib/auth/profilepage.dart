//import 'dart:html';
//import 'dart:html';
import 'dart:io';
import 'package:Brikkhayon/product_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

const List<String> list = <String>['Shrubs', 'Herbs', 'Climbers', 'Trees'];

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final plantnameController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final aboutController = TextEditingController();
  String? cat;
  String dropdownValue = list.first;

  @override
  void dispose(){

    plantnameController.dispose();
    addressController.dispose();
    priceController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getUserData();
  }

  Map? plants;
  String imgUrl = " ";
  String plantimgUrl = " ";
  String imageUrl = " ";
  File? imageFile;
  String userName = " ";
  String userEmail = " ";
  final fieldText = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.ref().child("plantdetails").child(FirebaseAuth.instance.currentUser!.uid);
  //Query databaseReference = FirebaseDatabase.instance.ref().child("plantdetails").child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference dbRefrence = FirebaseDatabase.instance.ref().child("plantdetails").child(FirebaseAuth.instance.currentUser!.uid);
  DatabaseReference dbGenRefrence = FirebaseDatabase.instance.ref().child("allplants");
  //FirebaseDatabase databaseRealtime = FirebaseDatabase.instance;
  //DatabaseReference refer = FirebaseDatabase.instance.ref();

  void getFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 75,maxWidth: 520,maxHeight: 520);
    Reference ref = FirebaseStorage.instance.ref().child("profileimages").child(DateTime.now().toString() + '.jpg');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imgUrl = value;
        _showMyDialogAgain();
      });
    });

  }

  void getFromGalleryForPlantImages() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 85,maxWidth: 520,maxHeight: 520);
    Reference ref = FirebaseStorage.instance.ref().child("plantimages").child(DateTime.now().toString() + '.jpg');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        plantimgUrl = value;
        //_showMyDialogAgain();
      });
    });

  }

  void clearTextField(){
    plantnameController.clear();
    addressController.clear();
    priceController.clear();
    aboutController.clear();
    //plantimgUrl = " ";

  }


  void uploadImage() async {
    if(imgUrl == null){
      Fluttertoast.showToast(msg: "Please select an image");
      return;
    }
    try{
      // final ref = FirebaseStorage.instance.ref().child("profilepic.jpg");//.child(DateTime.now().toString() + 'jpg');//
      // await ref.putFile(imageFile);
      //imgUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection("sourceimage").doc(FirebaseAuth.instance.currentUser!.uid).set({
        'id':_auth.currentUser!.uid,
        'email':_auth.currentUser!.email,
        'image' : imgUrl,
        'createdAt' : DateTime.now(),
      });

      FirebaseFirestore.instance.collection("userdetails").doc(FirebaseAuth.instance.currentUser!.uid).update({
        'image' : imgUrl,
      });
      //Fluttertoast.showToast(msg: "Completed upload");
    }
    catch(e){
      Fluttertoast.showToast(msg: "error occuerd for store data of image!");
    }
  }

  void uploadPlantDetails(String plantName, String planTAddress, String plantPrice, String plantAbout, String imageUrl ) {
    try{

      if(plantnameController.text.trim() == " " || addressController.text.trim() == " " || priceController.text.trim() == " " || aboutController.text.trim() == " " || plantimgUrl == " " || dropdownValue.toString().trim() == " "){
        Fluttertoast.showToast(msg: "Please Provide all info!");
        return;
      }
      String uniqueKey = "${Uuid().v1()}";
      FirebaseDatabase.instance.ref().child("plantdetails").child(FirebaseAuth.instance.currentUser!.uid).child(uniqueKey).set({
          "name": plantName,
          "address":planTAddress,
          "price":plantPrice,
          "about":plantAbout,
          "image":imageUrl,
          "createdAt": DateTime.now().toString(),
          "email" : userEmail.toString(),
          "pid" : uniqueKey,
          "z_category" : dropdownValue.toString(),
      });

      FirebaseDatabase.instance.ref().child("allplants").child(uniqueKey).set({
        "name": plantName,
        "address":planTAddress,
        "price":plantPrice,
        "about":plantAbout,
        "image":imageUrl,
        "createdAt": DateTime.now().toString(),
        "email" : userEmail.toString(),
        "curUid" : FirebaseAuth.instance.currentUser!.uid,
        "pid" : uniqueKey,
        "z_category" : dropdownValue.toString(),
      });

      Fluttertoast.showToast(msg: "Successfully uploaded");
      clearTextField();
    }
    catch(e){
      Fluttertoast.showToast(msg: "error occuerd for storing user info!");
    }
  }


  void getData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("sourceimage").doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      imageUrl = userDoc.get('image');
      print(imageUrl);
    });
  }

  void getUserData() async {
    final DocumentSnapshot userDetail = await FirebaseFirestore.instance.collection("userdetails").doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      userName = userDetail.get('username');
      userEmail = userDetail.get('email');
      //print(userName + userEmail);
    });
  }

  //delete profile pic

  void profilePicDelete() async {
    FirebaseFirestore.instance.collection("sourceimage").doc(FirebaseAuth.instance.currentUser!.uid).delete();
    Navigator.of(context).pop();
    setState(() {
      imageUrl = " ";
    });

  }

  //delete profile pic delete alert box

  Future<void> _profileDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            height: 120.0,
            width: 80.0,
            // decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.white54,
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left:8.0,right:8,top: 4,bottom:10),
                  child: Text(
                    'Do you want to delete your\n'
                        'profile picture?',
                    style:
                    TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff999999),
                                //side: BorderSide(width:0, color:Colors.brown), //border width and color
                                //elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(10)
                            ),
                            onPressed: (){
                                Navigator.of(context).pop();
                            },
                            child: Text(
                                'Cancel'
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                //side: BorderSide(width:0, color:Colors.brown), //border width and color
                                //elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(10)
                            ),
                            onPressed: (){
                              profilePicDelete();
                            },
                            child: Text(
                                'Delete'
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //delete profile list item alert dialog..

  Future<void> _listItemDeleteDialog(String pid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            height: 120.0,
            width: 80.0,
            // decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.white54,
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left:8.0,right:8,top: 4,bottom:10),
                  child: Text(
                    'Delete the plant?',
                    style:
                    TextStyle(color: Colors.black, fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff999999),
                                //side: BorderSide(width:0, color:Colors.brown), //border width and color
                                //elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(10)
                            ),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Text(
                                'Cancel'
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                //side: BorderSide(width:0, color:Colors.brown), //border width and color
                                //elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(10)
                            ),
                            onPressed: (){
                              dbRefrence.child(pid).remove();
                              dbGenRefrence.child(pid).remove();
                              Fluttertoast.showToast(msg: "Deleted");
                              Navigator.of(context).pop();
                            },
                            child: Text(
                                'Delete'
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _showMyDialog() async {
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
              const Text('Profile Photo'),

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
                      child: TextButton(
                        child: Text('Choose a photo\n',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        onPressed: (){
                          getFromGallery();
                          Navigator.of(context).pop();
                          showDialog(context: context, builder: (context){
                            return Center(
                                child:CircularProgressIndicator()
                            );
                          });

                        },
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color:
                        Colors.black,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Image.asset(
                            'assets/images/defaultprofile.jpg',
                          ).image,
                        ),
                        borderRadius: BorderRadius.circular(75),
                      ),

                      // decoration: BoxDecoration(
                      //
                      //   image: DecorationImage(
                      //     image: Image.asset(
                      //       'assets/images/defaultprofile.jpg',
                      //     ).image,
                      //     //image: NetworkImage(imageUrl),
                      //     fit: BoxFit.cover, ),
                      //   borderRadius: BorderRadius.circular(75),
                      // ),

                    ),
                  ],
                ),
                // ElevatedButton(
                //     onPressed: (){
                //   //uploadImage();
                // },
                //     child:Text("Upload")
                // ),
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


  Future<void> _showMyDialogAgain() async {
    Navigator.of(context).pop();
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
              const Text('Profile Photo'),

            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Column(
                  children: [
                    //Text(imageName!),
                    // SizedBox(
                    //   height: 40,
                    //   child: TextButton(
                    //     child: Text('Choose a photo\n',
                    //       style: TextStyle(
                    //         fontSize: 13,
                    //       ),
                    //     ),
                    //     onPressed: (){
                    //       //_showMyDialog();
                    //     },
                    //   ),
                    // ),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color:
                        Colors.black,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: imgUrl == " " ?Image.asset(
                            'assets/images/defaultprofile.jpg',
                          ).image : NetworkImage(imgUrl),
                        ),
                        borderRadius: BorderRadius.circular(75),
                      ),

                      // decoration: BoxDecoration(
                      //
                      //   image: DecorationImage(
                      //     image: Image.asset(
                      //       'assets/images/defaultprofile.jpg',
                      //     ).image,
                      //     //image: NetworkImage(imageUrl),
                      //     fit: BoxFit.cover, ),
                      //   borderRadius: BorderRadius.circular(75),
                      // ),

                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: (){
                      uploadImage();
                      Fluttertoast.showToast(msg: "Successfully Uploaded");
                      getData();
                      Navigator.of(context).pop();
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
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 720,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, -1),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.asset(
                                'assets/images/coverimage.png',
                              ).image,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    //color: Colors.yellow,
                                    child: IconButton(
                                      iconSize: 22,
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/');
                                      },
                                      icon: Icon(Icons.arrow_back),

                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    // color: Colors.yellow,
                                    child: IconButton(
                                      iconSize: 22,
                                      color: Colors.white,
                                      onPressed: () {
                                          Navigator.pushNamed(context, '/profilepage');
                                      },
                                      icon: Icon(Icons.refresh),

                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Align(
                              alignment: AlignmentDirectional(0, 0.01),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.12, .9),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.85,
                                      height: MediaQuery.of(context).size.height * 0.8,
                                      decoration: BoxDecoration(
                                        color:
                                        Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 6,
                                            color: Color(0x33000000),
                                            offset: Offset(0, 2),
                                            spreadRadius: 4,
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(0, -0.98),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),

                                                  child:Container(
                                                    //color: Colors.yellow,
                                                    child: IconButton(
                                                      iconSize: 25,
                                                      color: Colors.black,
                                                      onPressed: () {
                                                        _profileDeleteDialog();
                                                      },
                                                      icon: Icon(Icons.delete),

                                                    ),
                                                  ),

                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    // color: Colors.yellow,
                                                    child: IconButton(
                                                      iconSize: 25,
                                                      color: Colors.black,
                                                      onPressed: () {
                                                          Navigator.pushNamed(context, '/settings');
                                                      },
                                                      icon: Icon(Icons.settings),

                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional(0, -0.80),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    //color: Colors.yellow,
                                                    child: Text(
                                                      userName == " " ? 'username' : userName,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Align(
                                          //   alignment: AlignmentDirectional(0, -0.63),
                                          //   child: Row(
                                          //     mainAxisSize: MainAxisSize.max,
                                          //     mainAxisAlignment: MainAxisAlignment.center,
                                          //     children: [
                                          //       Container(
                                          //         //color: Colors.yellow,
                                          //         child: Text(
                                          //           'This is your bio field.Please set your bio.',
                                          //           textAlign: TextAlign.center,
                                          //           style: TextStyle(
                                          //             fontSize: 14,
                                          //             color: Colors.black87,
                                          //             fontWeight: FontWeight.normal,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          Align(
                                            alignment: AlignmentDirectional(0, -0.65),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(bottom: 70),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      Icons.email,
                                                      color: Colors.black87,
                                                      size: 19.0,
                                                      //semanticLabel: 'Text to announce in accessibility modes',
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  //color: Colors.yellow,
                                                  margin: EdgeInsets.only(bottom: 70),
                                                  child: Text(
                                                    userEmail == " " ? 'email@gmail.com' : userEmail,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional(0, -0.45),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // Padding(
                                                //   padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0,top: 13),
                                                //   child: Icon(
                                                //     Icons.location_pin,
                                                //     color: Colors.black87,
                                                //     size: 18.0,
                                                //     //semanticLabel: 'Text to announce in accessibility modes',
                                                //   ),
                                                // ),

                                                Container(
                                                  // padding: EdgeInsets.only(bottom: 30),
                                                  //color: Colors.yellow,
                                                  // child: Text(
                                                  //   'Kuet road - 9208, fullbarigate, Khulna',
                                                  //   textAlign: TextAlign.center,
                                                  //   style: TextStyle(
                                                  //     fontSize: 13,
                                                  //     color: Colors.black87,
                                                  //     fontWeight: FontWeight.normal,
                                                  //   ),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(0, -0.27),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      //color:Colors.red,
                                                      padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8),
                                                      //margin: EdgeInsets.only(top: 20),
                                                      //color: Colors.yellow,
                                                      child: Text(
                                                        'Plant details :',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                              Align(
                                                alignment: AlignmentDirectional(0, 0),

                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      //color:Colors.green,
                                                      height: 70,

                                                      margin: EdgeInsets.only(bottom: 10),

                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height:40,
                                                            width:40,
                                                            decoration: BoxDecoration(
                                                              color:
                                                              Colors.black,
                                                              image: DecorationImage(
                                                                fit: BoxFit.fill,
                                                                image: plantimgUrl == " " ?Image.asset(
                                                                  'assets/images/defaultprofile.jpg',
                                                                ).image : NetworkImage(plantimgUrl),
                                                              ),
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                            child: TextButton(
                                                              child: Text('Choose a photo\n',
                                                                style: TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              onPressed: () async {
                                                                getFromGalleryForPlantImages();
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
                                                      child: Container(
                                                        child: SizedBox(
                                                          height: 52,
                                                          child: TextField(
                                                            controller : plantnameController,
                                                            decoration: InputDecoration(
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1,color: Colors.black87),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(width: 2,color: Colors.black87)
                                                              ),
                                                              contentPadding: EdgeInsets.all(10),
                                                              labelText: "Plant's name",
                                                              labelStyle: TextStyle(
                                                                color: Colors.black87,
                                                              ),
                                                            ),

                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
                                                      child: Container(
                                                        child: SizedBox(
                                                          height:52,
                                                          child: TextField(
                                                            controller : addressController,
                                                            decoration: InputDecoration(
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1,color: Colors.black87),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(width: 2,color: Colors.black87)
                                                              ),
                                                              contentPadding: EdgeInsets.all(10),
                                                              labelText: 'Address',
                                                              labelStyle: TextStyle(
                                                                color: Colors.black87,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
                                                      child: Container(
                                                        child: SizedBox(
                                                          height:52,
                                                          child: TextField(
                                                            controller : priceController,
                                                            obscureText: false,
                                                            decoration: InputDecoration(
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1,color: Colors.black87),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(width: 2,color: Colors.black87)
                                                              ),
                                                              contentPadding: EdgeInsets.all(10),
                                                              labelText: 'Price',
                                                              labelStyle: TextStyle(
                                                                color: Colors.black87,
                                                              ),
                                                            ),

                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                                      child: Container(
                                                        height:85,
                                                        child: TextField(
                                                          controller : aboutController,
                                                          keyboardType: TextInputType.multiline,
                                                          maxLines: null,
                                                          //obscureText: true,
                                                          decoration: InputDecoration(

                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 1,color: Colors.black87),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 2,color: Colors.black87)
                                                            ),
                                                            labelText: 'About plant',
                                                            labelStyle: TextStyle(
                                                              color: Colors.black87,
                                                            ),
                                                          ),

                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8, right: 8),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 8.0),
                                                            child: Text(
                                                                'Select plant category:',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          DropdownButton<String>(
                                                            value: dropdownValue,
                                                            icon: const Icon(Icons.arrow_downward),
                                                            elevation: 16,
                                                            style: const TextStyle(
                                                                color: Color(0xff056608),
                                                              fontSize: 16,
                                                            ),
                                                            underline: Container(
                                                              height: 2,
                                                              color: Color(0xff056608),
                                                            ),
                                                            onChanged: (String? value) {
                                                              // This is called when the user selects an item.
                                                              setState(() {
                                                                dropdownValue = value!;
                                                                print(dropdownValue);
                                                              });
                                                            },
                                                            items: list.map<DropdownMenuItem<String>>((String value) {
                                                              return DropdownMenuItem<String>(
                                                                value: value,
                                                                child: Text(value),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    Padding(
                                                      //padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Container(
                                                          width: 550,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5 ),
                                                            color: Color(0xff056608),
                                                          ),
                                                          child: TextButton(
                                                            child: Text('Upload'),
                                                            style: TextButton.styleFrom(
                                                              primary: Colors.white,
                                                              //padding: EdgeInsets.only(left:205.0,right: 205.0,top:25.0,bottom: 25.0),
                                                              textStyle: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              uploadPlantDetails(plantnameController.text,addressController.text,priceController.text,aboutController.text,plantimgUrl);
                                                              print('changed');
                                                            },
                                                          )
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ),
                                  ),

                                ],

                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.04, -0.85),
                              child: InkWell(
                                onTap: (){
                                  _showMyDialog();
                                },
                                child: Container(
                                  width: 140,
                                  height: 140,

                                  // decoration: BoxDecoration(
                                  //   color:
                                  //   Colors.black,
                                  //   image: DecorationImage(
                                  //     fit: BoxFit.fill,
                                  //     image: Image.asset(
                                  //       'assets/images/banner-1.png',
                                  //     ).image,
                                  //   ),
                                  //   borderRadius: BorderRadius.circular(75),
                                  // ),
                                  // child: Center(
                                  //   child: imageUrl == " " ? const Icon(
                                  //       Icons.person,size: 80,color:Colors.white,
                                  //   ):Image.network(imageUrl),
                                  //
                                  // ),
                                  child:  Container(
                                    height: 40,
                                    width: 40,
                                    //color: Colors.white,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffD1D1D1).withOpacity(.5),

                                    ),
                                    child: Icon(Icons.camera_alt, color: Colors.black),

                                  ),
                                  alignment: Alignment.bottomRight,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xffffffff),width: 2),
                                    image: DecorationImage(
                                      image: imageUrl == " " ?Image.asset(
                                        'assets/images/defaultprofile.jpg',
                                      ).image : NetworkImage(imageUrl,),
                                      fit: BoxFit.cover, ),
                                    borderRadius: BorderRadius.circular(75),
                                  ),

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 8.0, left: 28.0, right: 28.0),
                    child: Text('Your Plants',
                        style: TextStyle(
                            color: Color(0xff056608),
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0,
                        top: 8.0,
                        left: 12.0,
                        bottom: 10),
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                Color(0xff056608)),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(9)),
                            foregroundColor:
                            MaterialStateProperty.all<Color>(
                                Color(0xff056608)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(25.0),
                                    side: BorderSide(color: Color(0xff056608))))),
                        child: Text(
                          'View All',
                          style: TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/userallplants');
                        },
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 5,),
              Divider(
                color: Color(0xff056608),
              ),

              //scroll view

              Padding(
                padding: const EdgeInsets.only(left:12.0,right:12),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  height: 240.0,
                  width: MediaQuery.of(context).size.width*80,
                  child: Column(
                    //scrollDirection: Axis.horizontal,
                    children:  [
                      Expanded(
                          child: FirebaseAnimatedList(
                            query: databaseReference,
                            itemBuilder: (context,snapshot,animation,index){
                              plants = snapshot.value as Map;
                              plants!['key'] = snapshot.key;
                              //print(snapshot.key);
                              return Container(
                                height: 90,
                                padding: EdgeInsets.all(8),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(20),
                                //   color: Colors.black26,
                                // ),
                                child: Material(
                                  elevation: 3,
                                  shadowColor: Colors.grey,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),

                                  child: ListTile(
                                    onTap: (){
                                      //Navigator.pushNamed(context, routeName)
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Products(
                                              text: snapshot.key.toString(),
                                              name: snapshot.child('name').value.toString(),
                                              about: snapshot.child('about').value.toString(),
                                              address: snapshot.child('address').value.toString(),
                                              createdAt: snapshot.child('createdAt').value.toString(),
                                              image: snapshot.child('image').value.toString(),
                                              price: snapshot.child('price').value.toString(),
                                              email: snapshot.child('email').value.toString(),
                                              parentid: snapshot.child('parentid').value.toString(),

                                            ),
                                          ));
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    selectedTileColor: Colors.orange[200],
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                     child: Container(
                                       height: 70,
                                       width: 70,
                                       child : Image.network(snapshot.child('image').value.toString(),fit: BoxFit.cover,),
                                     ),
                                    ),
                                    title: Text(
                                          snapshot.child('name').value.toString(),
                                          style: TextStyle(fontSize: 14,color: Colors.black),
                                        ),
                                    subtitle: Text(
                                            snapshot.child('price').value.toString() + "Tk",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme.secondary,
                                                fontWeight:
                                                FontWeight.w700)),
                                    trailing: IconButton(
                                        onPressed: (){
                                           //print(snapshot.child("name").value.toString());
                                          _listItemDeleteDialog(snapshot.child("pid").value.toString());

                                        },
                                        icon: Icon(Icons.delete)
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                      ),
                      // Builder(
                      //   builder: (BuildContext context) {
                      //     return Container(
                      //       width: 140.0,
                      //       child: Card(
                      //         clipBehavior: Clip.antiAlias,
                      //         child: InkWell(
                      //           onTap: () {
                      //             Navigator.pushNamed(
                      //                 context, '/products',
                      //                 arguments: i);
                      //           },
                      //           child: Column(
                      //             crossAxisAlignment:
                      //             CrossAxisAlignment.start,
                      //             children: <Widget>[
                      //               SizedBox(
                      //                 height: 160,
                      //                 child: Hero(
                      //                   tag: '$i',
                      //                   child: CachedNetworkImage(
                      //                     fit: BoxFit.cover,
                      //                     imageUrl: i,
                      //                     placeholder: (context, url) =>
                      //                         Center(
                      //                             child:
                      //                             CircularProgressIndicator()),
                      //                     errorWidget:
                      //                         (context, url, error) =>
                      //                     new Icon(Icons.error),
                      //                   ),
                      //                 ),
                      //               ),
                      //               ListTile(
                      //                 title: Text(
                      //                   'Two Gold Rings',
                      //                   style: TextStyle(fontSize: 14),
                      //                 ),
                      //                 subtitle: Text('\$200',
                      //                     style: TextStyle(
                      //                         color: Theme.of(context)
                      //                             .colorScheme.secondary,
                      //                         fontWeight:
                      //                         FontWeight.w700)),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ]
                  ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
