import 'package:Brikkhayon/recognition/speech_api.dart';
import 'package:Brikkhayon/recognition/substring_highlighted.dart';
import 'package:Brikkhayon/recognition/utils.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../aftersearched.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = ' ';
  bool isListening = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Voice Recognition Search",style: TextStyle(fontSize: 16),),
      centerTitle: true,
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () async {
              await FlutterClipboard.copy(text);

              // Scaffold.of(context).showSnackBar(
              //   SnackBar(content: Text('✓   Copied to Clipboard')),
              // );
              var snackBar = SnackBar(content: Text('✓   Copied to Clipboard'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 220,
            margin: EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width*9,
            decoration: BoxDecoration(
              border: Border.all(width: 2,color: Colors.black54,),
              borderRadius: BorderRadius.circular(14),
            ),
            child: SingleChildScrollView(
              reverse: true,
              padding: const EdgeInsets.all(30).copyWith(bottom: 150),
              child: SubstringHighlight(
                text: text,
                terms: Command.all,
                textStyle: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                textStyleHighlight: TextStyle(
                  fontSize: 32.0,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          ),
          Container(
            margin: EdgeInsets.all(12),
            child: SizedBox(
              width: MediaQuery.of(context).size.width*9,
              height: 50.0,
              child: ElevatedButton(
                child: Text('Search'),
                onPressed: (){
                 // Navigator.push(context, '/aftersearched');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPlant()));
                  if(text == " "){
                    void getMessage(String string) async {
                      final ref =await SharedPreferences.getInstance();
                      await ref.setString('searchMsg', string);
                    }
                    setState(() {
                      getMessage("");
                    });
                  }

                },
              ),
            ),
          ),

          Container(
            height: 140,
            margin: EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width*9,
            decoration: BoxDecoration(
              //border: Border.all(width: 0,color: Colors.black54,),
              //borderRadius: BorderRadius.circular(2),
            ),

            child: Text(
                "\n"
                "Press the mic and start speaking.\n\nHere according to your speaking the voice is recognized and searching happened after clicking search button",
                style: TextStyle(
                  fontSize: 15,

                ),
            ),

          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            height: 2,
            color: Colors.black54,
          ),
        ],
      ),
    ),

    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: AvatarGlow(
      animate: isListening,
      endRadius: 65,
      glowColor: Theme.of(context).primaryColor,
      child: FloatingActionButton(
        child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
        onPressed: toggleRecording,
      ),
    ),
  );

  Future toggleRecording() => SpeechApi.toggleRecording(
    onResult: (text) => setState(() {
      this.text = text;
      getMessage(text);

    }),
    onListening: (isListening) {
      setState(() => this.isListening = isListening);

      if (!isListening) {
        Future.delayed(Duration(seconds: 1), () {
          Utils.scanText(text);
        });
      }
    },
  );

  void getMessage(String string) async {
    final ref =await SharedPreferences.getInstance();
    await ref.setString('searchMsg', string);
  }
}