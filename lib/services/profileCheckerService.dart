import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:letschat/databaseService/addFriendDatabaseService.dart';
import 'package:letschat/friendService/addFriendServiced.dart';
import 'package:letschat/screens/creatingProfile.dart';
import 'package:letschat/screens/loadingScreen.dart';
import 'package:letschat/screens/maintabscreen.dart';
import 'package:letschat/services/usermodel.dart';

import 'package:provider/provider.dart';
class ProfileCheckerService extends StatefulWidget {
  @override
  _ProfileCheckerServiceState createState() => _ProfileCheckerServiceState();
}

class _ProfileCheckerServiceState extends State<ProfileCheckerService> {

  var firebaseDatabaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder(
      stream: Firestore.instance.collection('Profiles')
          .document(user.uid)
          .snapshots(),
      builder: (context, ss) {
        if (ss.hasData) {
          var doc = ss.data;
          if (doc.data['userName'] == 'abc') {
            AddFriendDatabaseService(uid:user.uid).addStatus(user.uid,'firstTime');
            return ProfileMaker();
          }
          else {
            return StreamBuilder(
              stream: Firestore.instance.collection('Friends').document(user.uid).snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  print(snapshot.data['status']);
                  if(snapshot.data['status']=='firstTime')
                  return FriendService();
                  else if(snapshot.data['status']=='Done')
                    return MainScreen();
                  else
                    return null;
                }
                else
                {
                  return Temp(size: 40,);
                }
              }

            );
          }
        }
        else {
          return Temp(size: 40,);
        }
      },
    );
  }

}