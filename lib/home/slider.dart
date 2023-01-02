import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeSlider extends StatefulWidget {
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {

   List<String> imgList = [
  //   'https://images.unsplash.com/photo-1517848568502-d03fa74e1964?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
  //   'https://images.unsplash.com/photo-1477554193778-9562c28588c0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
  //   'https://images.unsplash.com/photo-1490349368154-73de9c9bc37c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
  //   'https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
  //   'https://images.unsplash.com/photo-1414872785488-7620d2ae7566?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'
   ];

  void imageAdd () async {
    FirebaseDatabase.instance.ref("allplants").onValue.listen((event) {

      final data =
      Map<String, dynamic>.from(event.snapshot.value as Map,);
      List<String> item = [];

      data.forEach((key, value) {
        setState(() {
          item.add(value['image'].toString());
          imgList = item.reversed.toList();
        });
      });
    }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageAdd();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Center(
            child: CarouselSlider(
              options: CarouselOptions(
                  autoPlay: true,
                  height: 350,
                  pauseAutoPlayOnTouch: true,
                  viewportFraction: 1.0

                //for another view
                // height: 200.0,
                // enlargeCenterPage: true,
                // autoPlay: true,
                // aspectRatio: 16 / 9,
                // autoPlayCurve: Curves.fastOutSlowIn,
                // enableInfiniteScroll: true,
                // autoPlayAnimationDuration: Duration(milliseconds: 800),
                // viewportFraction: .8,

              ),
              items: imgList.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: i,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator()
                          ),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                        )
                    );
                  },
                );
              }).toList(),

            ),
          ),
        ],
      ),
    );
  }
}
