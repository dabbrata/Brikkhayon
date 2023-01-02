import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget{
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPassword createState() => _ResetPassword();
}
class _ResetPassword extends State<ResetPassword>{

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
//                    color: Colors.red,
                    alignment: Alignment.topCenter,
                    height: 105,
                    margin: EdgeInsets.only(top: 0.0),
                    child: Image.asset(
                        'assets/images/splash.png'
                    ),
                  ),
                  Container(
//                    color: Colors.amber,
                    margin: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xff056608),

                      ),
                    ),
                  ),
                  Container(
//                    color: Colors.amber,
                    margin: EdgeInsets.only(top: 40.0,left: 20.0, right: 20.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1,color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.green)
                        ),
                        labelText: 'New Password',
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
                      ),

                    ),
                  ),
                  Container(
//                    color: Colors.amber,
                    margin: EdgeInsets.only(top: 20.0,left: 20.0, right: 20.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1,color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2,color: Colors.green)
                        ),
                        labelText: 'Confirm New Password',
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
                          child: Text('Save'),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            //padding: EdgeInsets.only(left:205.0,right: 205.0,top:25.0,bottom: 25.0),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            print('changed');
                          },
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
}