import 'package:flutter/material.dart';
import 'package:letschat/screens/Register.dart';
import 'package:letschat/screens/SignIn.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignedIn=true;
  void toggleValue(){
    setState(() {
      isSignedIn=!isSignedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: isSignedIn?SignIn(toggleValue: toggleValue):Register(toggleValue: toggleValue));
  }
}
