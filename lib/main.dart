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
          primaryColor: Color(0xffDA291C),
            accentColor: Color(0xff56A8CB),
          secondaryHeaderColor: Color(0xff53A567),
        ),
        home: Wrapper(),
      ),
    );
  }
}