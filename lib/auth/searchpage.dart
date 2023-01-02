
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../product_detail.dart';



class SearchPageWidget extends StatefulWidget {
  const SearchPageWidget({Key? key}) : super(key: key);

  @override
  _SearchPageWidgetState createState() => _SearchPageWidgetState();
}

class _SearchPageWidgetState extends State<SearchPageWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1528183429752-a97d0bf99b5a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8dHJlZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60''https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  final controller = TextEditingController();

  Map? plants;
  DatabaseReference dbGenReference = FirebaseDatabase.instance.ref().child("allplants");

  @override
  void initState() {
    super.initState();
    getData();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          color: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF056608),
            size: 30,
          ),
        ),
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
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        'Search by plant\'s name',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          height: 3,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.only(left: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child:TypeAheadField<Data?>(
                              debounceDuration: Duration(microseconds: 500),
                              textFieldConfiguration: TextFieldConfiguration(
                                  autofocus: true,
                                  controller: controller,
                                  style: DefaultTextStyle.of(context).style.copyWith(
                                      fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                    color: Colors.black87
                                  ),
                                  decoration: InputDecoration(
                                      hintText: 'Search',
                                      hintStyle: TextStyle(fontSize: 15,fontFamily: 'Lobster'),
                                      border: OutlineInputBorder(

                                      ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.green)),

                                  )
                              ),
                              suggestionsCallback: (pattern) async {
                                return await getSuggestions(pattern);
                                //return await City.getList(pattern);
                              },
                              itemBuilder: (context, Data? suggestion) {
                                return ListTile(
                                  leading:ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      child : Image.network(suggestion!.imgUrl.toString(),fit: BoxFit.cover,),
                                    ),
                                  ),
                                  title: Text('${suggestion!.name}'),
                                  subtitle: Text('${suggestion!.price}' + 'TK'),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                //controller.text = '${suggestion!.name}';
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Products(
                                      text: " ",
                                      name: suggestion!.name.toString(),
                                      about: suggestion!.about.toString(),
                                      address: suggestion!.address.toString(),
                                      createdAt: suggestion!.createdAt.toString(),
                                      image: suggestion!.imgUrl.toString(),
                                      price: suggestion!.price.toString(),
                                      email: suggestion!.email.toString(),
                                      parentid: suggestion!.parentId.toString(),
                                    ),
                                ));
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 2),
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF0D3E0F),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(5),
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(5),
                              ),
                              shape: BoxShape.rectangle,
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: IconButton(
                                color: Colors.transparent,
                                // borderRadius: 30,
                                // borderWidth: 1,
                                // buttonSize: 60,
                                icon: Icon(
                                  Icons.search_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  print('IconButton pressed.');

                                  searchText(controller.text.toLowerCase().toString());
                                  Navigator.pushNamed(context, '/aftersearched');
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           Names(
                                  //             name: controller.text.toString(),
                                  //           ),
                                  //     ));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(-1, 0.3),
                        child: Text(
                          'Categorised searched',
                          //style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(-1, 0.8),
                        child: Text(
                          'Voice Recognition',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/recognition');
                      },
                      child: Material(
                        color: Colors.transparent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.asset(
                                      'assets/images/voicerecognition.jpg',
                                    ).image,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(0),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.64,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(-1, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 5, 5, 0),
                                        child: Text(
                                          'The searching depending on your voice recognition',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            //height: 1.3,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(-1, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 7, 5, 0),
                                        child: Text(
                                          'The  trees which are shown according to your voice message.',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
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
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(-1, 0.8),
                          child: Text(
                            'Location',
                            style:
                            TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/nearbyPlants');
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              color:
                              Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: Image.asset(
                                        'assets/images/map.png',
                                      ).image,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(0),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(0),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.64,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(-1, 0),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              5, 5, 5, 0),
                                          child: Text(
                                            'The range of your current location of available plants',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(-1, 0),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              5, 7, 5, 0),
                                          child: Text(
                                            'The plants which are available to your current location.',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
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
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(15, 25, 0, 0),
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(-1, 0.8),
                          child: Text(
                            'All Plants',
                            style:
                            TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(),
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        height: 200.0,
                        width: MediaQuery.of(context).size.width * 80,
                        child: Column(
                          //scrollDirection: Axis.horizontal,
                            children: [
                              Expanded(
                                  child: StreamBuilder(
                                    stream: dbGenReference.onValue,
                                    builder: (context,
                                        AsyncSnapshot<DatabaseEvent>
                                        snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container(
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                              new BorderRadius.all(const Radius.circular(20.0))),
                                          child: LinearProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD3D3D3)),
                                            backgroundColor: Color(0xffe5e5e5),
                                          ),
                                        );
                                      } else {
                                        Map<dynamic, dynamic> map = snapshot
                                            .data!.snapshot.value as dynamic;
                                        List<dynamic> list = [];
                                        list.clear();
                                        list = map.values.toList();
                                        //imgList.addAll(list[index]['image']);
                                        return ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: snapshot.data!.snapshot
                                                .children.length,
                                            itemBuilder: (context, index) {
                                              //imgList.insert(0,list[index]['image']);
                                              //someMap["${list[index]['name']}"] = "${list[index]['image']}";
                                              //print(list[index]['name']);
                                              //print(list[index]['image']);
                                              return InkWell(
                                                onTap: () {
                                                  //Navigator.pushNamed(context, routeName)
                                                  String str = list[index]['pid'].toString();

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Products(
                                                              text: list[index]['text'].toString(),
                                                              name: list[index]['name'].toString(),
                                                              about: list[index]['about'].toString(),
                                                              address: list[index]['address'].toString(),
                                                              createdAt: list[index]['createdAt'].toString(),
                                                              image: list[index]['image'].toString(),
                                                              price: list[index]['price'].toString(),
                                                              email: list[index]['email'].toString(),
                                                              parentid: list[index]['pid'].toString(),
                                                            ),
                                                      ));
                                                  //setPlantName(str);
                                                },
                                                child: Card(
                                                  elevation: 10,
                                                  shadowColor: Colors.black,
                                                  color: Colors.white,
                                                  child: SizedBox(
                                                    width: 150,
                                                    height: 300,
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(0.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // SizedBox(
                                                          //   height: 5,
                                                          // ),
                                                          // CircleAvatar(
                                                          //   backgroundColor:
                                                          //       Colors.green[
                                                          //           500],
                                                          //   radius: 50,
                                                          //   child:
                                                          //       CircleAvatar(
                                                          //     backgroundImage:
                                                          //         NetworkImage(
                                                          //             list[index]['image']), //NetworkImage
                                                          //     radius: 50,
                                                          //   ), //CircleAvatar
                                                          // ),
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(5.0),//or 15.0
                                                            child: Container(
                                                              height: 130.0,
                                                              width: 150.0,
                                                              //color: Color(0xffFF0E58),
                                                              child: CachedNetworkImage(imageUrl:list[index]["image"],fit: BoxFit.cover,
                                                                placeholder: (context, url) => new Icon(Icons.image),
                                                                errorWidget: (context, url, error) => new Icon(Icons.error),

                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            //color:Colors.redAccent,
                                                            padding: EdgeInsets.only(left: 8),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  list[index]
                                                                  ['name'],
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .black87,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ), //Textstyle
                                                                ), //Text
                                                                // SizedBox(
                                                                //   height: 10,
                                                                // ), //SizedBox
                                                                Text(
                                                                  list[index][
                                                                  'price'] + " Tk",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .black87,
                                                                    fontWeight: FontWeight.w300,
                                                                  ), //Textstyle
                                                                ), //Text
                                                                SizedBox(
                                                                  height: 8,
                                                                ), //SizedBox
                                                                //SizedBox
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ), //Column
                                                    ), //Padding
                                                  ), //SizedBox
                                                ),
                                              );
                                            });
                                      }
                                    },
                                  )
                              ),
                              // Expanded(
                              //   child: FirebaseAnimatedList(
                              //       query: dbGenReference,
                              //       itemBuilder: (context,snapshot,animation,index){
                              //         plants = snapshot.value as Map;
                              //         plants!['key'] = snapshot.key;
                              //         return Container(
                              //           height: 90,
                              //           padding: EdgeInsets.all(8),
                              //           // decoration: BoxDecoration(
                              //           //   borderRadius: BorderRadius.circular(20),
                              //           //   color: Colors.black26,
                              //           // ),
                              //           child: Material(
                              //             elevation: 3,
                              //             shadowColor: Colors.grey,
                              //             color: Colors.white,
                              //             borderRadius: BorderRadius.circular(10),
                              //
                              //             child: ListTile(
                              //               onTap: (){
                              //                 //Navigator.pushNamed(context, routeName)
                              //                 Navigator.push(
                              //                     context,
                              //                     MaterialPageRoute(
                              //                       builder: (context) => Products(
                              //                         text: snapshot.key.toString(),
                              //                         name: snapshot.child('name').value.toString(),
                              //                         about: snapshot.child('about').value.toString(),
                              //                         address: snapshot.child('address').value.toString(),
                              //                         createdAt: snapshot.child('createdAt').value.toString(),
                              //                         image: snapshot.child('image').value.toString(),
                              //                         price: snapshot.child('price').value.toString(),
                              //                         email: snapshot.child('email').value.toString(),
                              //
                              //                       ),
                              //                     ));
                              //               },
                              //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              //               selectedTileColor: Colors.orange[200],
                              //               leading: ClipRRect(
                              //                 borderRadius: BorderRadius.circular(10),
                              //                 child : Image.network(snapshot.child('image').value.toString()),
                              //               ),
                              //               title: Text(
                              //                 snapshot.child('name').value.toString(),
                              //                 style: TextStyle(fontSize: 14,color: Colors.black),
                              //               ),
                              //               subtitle: Text(
                              //                   snapshot.child('price').value.toString() + "Tk",
                              //                   style: TextStyle(
                              //                       color: Theme.of(context)
                              //                           .colorScheme.secondary,
                              //                       fontWeight:
                              //                       FontWeight.w700)),
                              //               // trailing: IconButton(
                              //               //     onPressed: (){
                              //               //       _listItemDeleteDialog();
                              //               //     },
                              //               //     icon: Icon(Icons.delete)
                              //               // ),
                              //             ),
                              //           ),
                              //         );
                              //       }
                              //   ),
                              // ),
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
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  List<Data> list = [];
  void getData()  {
    DatabaseReference searchRef = FirebaseDatabase.instance.ref().child("allplants");
    FirebaseDatabase.instance.ref("allplants").onValue.listen((event) {

      final data =
      Map<String, dynamic>.from(event.snapshot.value as Map,);

      //print(text);
      data.forEach((key, value) {

          Data data = new Data(name: value['name'], price: value['price'], imgUrl: value['image'], about: value['about'], address: value['address'], createdAt: value['createdAt'], parentId: value['pid'], email: value['email']);
          list.add(data);


       // print('${value['email']}'.toString().trim());
        //print(userId);
        // if(value['curUid'].toString().trim() == userId.toString().trim()){
        //   dbGenRefrence.child(value['pid']).remove();
        //   Fluttertoast.showToast(msg: 'Removed the plant');
        //   Fluttertoast.showToast(msg: " if");
        //   return;
        //
        // }
        // else{
        //   Fluttertoast.showToast(msg: "not in if");
        // }
      });
      //print(list[1].name);
    }

    );

  }

  List<Data> plantList = [];
  Future getSuggestions(String txt) async{
    //print(list[1].name);
    plantList.clear();
    for(int i=0;i<list.length;i++){
      if(list[i].name.toLowerCase().contains(txt.toLowerCase())){
        Data data = new Data(name: list[i].name, price: list[i].price, imgUrl: list[i].imgUrl, about: list[i].about, address: list[i].address, createdAt: list[i].createdAt, parentId: list[i].parentId, email: list[i].email);
        plantList.add(data);
        //print(txt + " " + list[i].name);
      }
    }
    return await plantList;
  }

  void searchText(String string) async {
    final ref =await SharedPreferences.getInstance();
    await ref.setString('searchMsg', string);
    print(string);
  }

}

class Data{  //modal class
  String name,price,imgUrl,about,address,createdAt,parentId,email;

  Data({
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.about,
    required this.address,
    required this.createdAt,
    required this.parentId,
    required this.email,
  });
}



// class City {
//   List<String> citylist = ["a","b","dc","de","ef"];
//   Future getList(String text) async {
//     return citylist;
//   }
// }
