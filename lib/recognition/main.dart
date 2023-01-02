import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Brikkhayon/recognition/home_page.dart';

import 'home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyRecApp());
}

class MyRecApp extends StatelessWidget {
  static final String title = 'Speech to Text';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.purple),
    home: HomePage(),
  );
}