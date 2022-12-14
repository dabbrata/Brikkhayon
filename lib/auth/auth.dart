import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Brikkhayon/blocks/auth_block.dart';
import 'signin.dart';
import 'signup.dart';

bool isAdmin = false;

class Auth extends StatelessWidget {
  final List<Widget> tabs = [
    SignUp(),
    SignIn()
  ];
  @override
  Widget build(BuildContext context) {
    final AuthBlock authBlock = Provider.of<AuthBlock>(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(authBlock.currentIndex == 0 ? 'Sign In' : 'Create Account'),
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.lock_open),
      //       label: 'Sign In',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.people_outline),
      //       label: 'Create Account',
      //     ),
      //   ],
      //   currentIndex: authBlock.currentIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: (num){
      //      authBlock.currentIndex = num;
      //   },
      // ),
      body: tabs[authBlock.currentIndex],
    );
  }
}