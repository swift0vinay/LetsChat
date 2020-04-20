import 'package:flutter/material.dart';

import 'package:letschat/services/authService.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:letschat/signupServices/Wrapper.dart';
import 'package:provider/provider.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value: AuthenticationService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xffFF9800),
            accentColor: Color(0xffFFB74D)
        ),
        home: Wrapper(),
      ),
    );
  }
}