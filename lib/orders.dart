import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Orders> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final dataRef = FirebaseDatabase.instance.ref().child('orders').child(FirebaseAuth.instance.currentUser!.uid);
  final dataRef2 = FirebaseDatabase.instance.ref().child('allOrders');

  String str = " ";
  Map? order;

  Future<void> _listItemDeleteDialog(String oid) async {
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
                              dataRef.child(oid).remove();
                              dataRef2.child(oid).remove();
                              const snackBar = SnackBar(
                                content: Text('Order was deleted!'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              Navigator.pop(context);
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
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Color(0xFF056608),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF056608),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: 40,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text('Your orders')
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:12.0,right:12),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    height: 600.0,
                    width: MediaQuery.of(context).size.width*80,
                    child: Column(
                      //scrollDirection: Axis.horizontal,
                        children:  [
                          Expanded(
                            child: FirebaseAnimatedList(
                                query: dataRef,
                                itemBuilder: (context,snapshot,animation,index){
                                  order = snapshot.value as Map;
                                  order!['key'] = snapshot.key;
                                  // final DocumentSnapshot variable = FirebaseFirestore.instance.collection('userdetails').doc(snapshot.child('ownerId').toString()).get();
                                  // setState(() {
                                  //   str = variable.get('name');
                                  // });
                                  //print(snapshot.key);
                                  return Container(
                                    padding: EdgeInsets.all(8),
                                    child: Material(
                                      elevation: 3,
                                      shadowColor: Colors.grey,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),

                                      child: ListTile(
                                        onTap: (){
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
                                            'Total plants: '+snapshot.child('plantNum').value.toString()+'\n'
                                                +'Cost: '+snapshot.child('price').value.toString() + "Tk",
                                            //+'\n'+FirebaseFirestore.instance.collection('userdetails').doc(snapshot.child('ownerId').toString()).get().toString(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme.secondary,
                                                fontWeight:
                                                FontWeight.w700)
                                        ),
                                        trailing: IconButton(
                                            onPressed: (){
                                              //print(snapshot.child("name").value.toString());
                                              _listItemDeleteDialog(snapshot.child("orderId").value.toString());

                                            },
                                            icon: Icon(Icons.delete)
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
