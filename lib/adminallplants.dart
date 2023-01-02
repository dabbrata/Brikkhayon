import 'package:Brikkhayon/product_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//String identity=" ";
class AdminAllPlants extends StatefulWidget {
  //String userId,userName;
  AdminAllPlants({Key? key}) : super(key: key);

  @override
  State<AdminAllPlants> createState() => _AdminAllPlants();
}

class _AdminAllPlants extends State<AdminAllPlants> {


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
//                              FirebaseDatabase.instance.ref().child("plantdetails").child(widget.userId).child(pid).remove();
                              //FirebaseDatabase.instance.ref().child("allplants").child(pid).remove();
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xff056608)),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
//          '${widget.userName}'+"'s"+' plants',
        'All Plants',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),

        actions: <Widget>[

        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseDatabase.instance.ref().child("allplants").onValue,
          builder: (context,
              AsyncSnapshot<DatabaseEvent>
              snapshot) {
            try{
              if (!snapshot.hasData) {
                // print("no dataaaaaaaaaaaaaaaaaaaaa");
                return Container(

                  child: Center(child: Text("Loading...")),
                  // decoration: new BoxDecoration(
                  //     borderRadius:
                  //     new BorderRadius.all(const Radius.circular(20.0))),
                  // child: LinearProgressIndicator(
                  //   valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD3D3D3)),
                  //   backgroundColor: Color(0xffe5e5e5),
                  // ),
                );

              } else {
                Map<dynamic, dynamic> map = snapshot
                    .data!.snapshot.value as dynamic;
                List<dynamic> list = [];
                list.clear();
                list = map.values.toList();


                return new GridView.builder(
                    itemCount: snapshot.data!.snapshot
                        .children.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisExtent: 155.0,),
                    itemBuilder: (BuildContext context, int index) {

                      return new GestureDetector(
                        child: new Card(
                          elevation: 5,
                          shadowColor: Colors.black,
                          color: Colors.white,
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
                                    height: 90.0,
                                    width: MediaQuery.of(context).size.width*100,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            list[index]
                                            ['name'],
                                            style: TextStyle(
                                              fontSize: 13,
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
                                              fontSize: 15,
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
                                      // Expanded(
                                      //   child: Container(
                                      //     child: IconButton(
                                      //       icon: Icon(Icons.delete,color: Colors.black45,),
                                      //       onPressed: (){
                                      //         _listItemDeleteDialog(list[index]['pid'].toString());
                                      //         //Fluttertoast.showToast(msg: "Deleted");
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ), //Column
                          ), //SizedBox
                        ),
                        onTap: () {
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
                        },
                      );
                    });
              };
            }catch(e){
              return Container(

                child: Center(child: Text("No Plants Available!")),
                // decoration: new BoxDecoration(
                //     borderRadius:
                //     new BorderRadius.all(const Radius.circular(20.0))),
                // child: LinearProgressIndicator(
                //   valueColor: AlwaysStoppedAnimation<Color>(Color(0xffD3D3D3)),
                //   backgroundColor: Color(0xffe5e5e5),
                // ),
              );
            }
          },
        ),
      ),

    );
  }
}
