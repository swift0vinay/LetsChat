import 'package:flutter/material.dart';
import 'package:letschat/services/profileCheckerService.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:letschat/signupServices/userAuthService.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    print('USER ENTERED $user');
    if(user==null)
      return AuthScreen();
    else {
      //RealtimeDatabase().addUsers(user.uid, 'online', DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString());
      return ProfileCheckerService();
    }}
}
