import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letschat/databaseService/addFriendDatabaseService.dart';
import 'package:letschat/screens/loadingScreen.dart';
import 'package:letschat/screens/maintabscreen.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:provider/provider.dart';
class FriendService extends StatefulWidget {

  @override
  _FriendServiceState createState() => _FriendServiceState();
}

class _FriendServiceState extends State<FriendService> {
  int count = 0;
  AddFriendDatabaseService add = new AddFriendDatabaseService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("ADD FRIENDS"),
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          actions: <Widget>[
            count == 0 ?
            FlatButton.icon(onPressed: () {
              move(user.uid);
            }, icon: Icon(Icons.arrow_forward,color: Colors.white,), label: Text("SKIP",style: TextStyle(color: Colors.white),))
                : FlatButton.icon(onPressed: () {
              move(user.uid);
            }, icon: Icon(Icons.arrow_forward,color: Colors.white,), label: Text("NEXT",style: TextStyle(color: Colors.white),))
          ],
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('myUsers').snapshots(),
            builder: (context, ss) {
              if (!ss.hasData) {
                return Temp(size: 40,);
              }
              else {
                return ListView.builder(
                  itemCount: ss.data.documents.length,
                  itemBuilder: (context, i) {
                    return user.uid == ss.data.documents[i]['uid']
                        ? Container()
                        :
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                      ClipOval(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: ss.data.documents[i]['profilepic'],
                          placeholder: (context, url) {
                            return CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage: AssetImage(
                                  'images/defaultavatar.jpg'),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Icon(Icons.error);
                          },

                        ),
                      ),),
                          Text(ss.data.documents[i]['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),),
                          StreamBuilder(
                              stream: Firestore.instance.collection('Friends')
                                  .document(user.uid)
                                  .collection('myFriends').document(ss.data.documents[i]['uid'].toString()).snapshots(),
                              builder: (context,cc)
                              {

                                return cc.hasData?(cc.data.exists?
                                IconButton(
                                  iconSize: 20.0,
                                  icon: Icon(Icons.undo),
                                  onPressed: (){

                                    Firestore.instance.collection('Friends').document(user.uid).collection('myFriends').document(ss.data.documents[i]['uid']).delete().catchError((e){print(e.toString());});
                                    setState(() {
                                      --count;
                                    });
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("USER REMOVED")
                                      ,)
                                    );},
                                  color: Colors.black,
                                )
                                    :
                                IconButton(
                                    iconSize: 20.0,
                                    icon: Icon(Icons.person_add),
                                    onPressed: (){

                                      add.addFriend(user.uid,ss.data.documents[i]['uid']);
                                      setState(() {
                                        ++count;
                                      });
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(content: Text("USER ADDED AS FRIEND")
                                              ,action: SnackBarAction(
                                                label: "UNDO",
                                                onPressed: ()  {
                                                  Firestore.instance.collection('Friends').document(user.uid).collection('myFriends').document(ss.data.documents[i]['uid']).delete().catchError((e){print(e.toString());});
                                                  setState(() {
                                                    --count;
                                                  });

                                                },

                                              )
                                          )
                                      );

                                    }
                                )):CircularProgressIndicator(strokeWidth: 2,);
                              }
                          )
                        ],
                      )
                    );
                  },
                );
              }
            }
        )


    );
  }
  move(String uid) {
    AddFriendDatabaseService(uid: uid).updateStatus('Done');
    return MainScreen();
//    await   Navigator.push(context, MaterialPageRoute(
//        builder: (context){
//          return MainScreen();
//        }
//    ));
  }
}