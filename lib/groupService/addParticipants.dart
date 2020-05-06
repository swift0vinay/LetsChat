import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letschat/databaseService/groupDatabaseService.dart';
import 'package:letschat/groupService/groupChatScreen.dart';
import 'package:letschat/groupService/groupScreen.dart';
import 'package:letschat/screens/loadingScreen.dart';
import 'package:letschat/screens/maintabscreen.dart';
import 'package:letschat/screens/navScreen.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:provider/provider.dart';
class AddParticipants extends StatefulWidget {
  final String groupName;
  AddParticipants({this.groupName});
  @override
  _AddParticipantsState createState() => _AddParticipantsState(
    groupName: groupName,
  );
}

class _AddParticipantsState extends State<AddParticipants> {
  final String groupName;
  _AddParticipantsState({this.groupName});
  int count=0;
  int fc=2;
  bool countTest=true;
  GroupDatabaseService gds=GroupDatabaseService();
  @override
  Widget build(BuildContext context) {
    String id='p$fc';
    final user=Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          Navigator.pop(context);
        },),
        backgroundColor: Theme.of(context).primaryColor,
        title: StreamBuilder(
          stream: Firestore.instance.collection('myGroups').document(groupName).collection('Friends').snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.documents.length==5)
                {
                  return Text("Max Participants added");
                }
              else
            return Text("Add Participants Max 5--->${snapshot.data.documents.length}",style: TextStyle(color: Colors.white),);
          }
            else
              return Text("Add Participants Max 5--->0",style: TextStyle(color: Colors.white),);
          }
        ),
      ),
      body:StreamBuilder(
          stream: Firestore.instance.collection('Friends').
          document(user.uid).collection('myFriends').snapshots(),
          builder: (context, ss) {
            if (!ss.hasData) {
              return Temp(size: 40,);
            }
            else {
              return ListView.builder(
                itemCount: ss.data.documents.length,
                itemBuilder: (context, i) {
                  return user.uid == ss.data.documents[i]['id']
                      ? Container()
                      :
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance.collection('myUsers').document(ss.data.documents[i]['id']).snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData?ClipOval(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot.data['profilepic'],
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
                              ),
                            ):Container();
                          }
                        ),
                        StreamBuilder(
                            stream: Firestore.instance.collection('myUsers').document(ss.data.documents[i]['id']).snapshots(),
                            builder: (context, snapshot) {
                            return snapshot.hasData?Text(snapshot.data['username'],
                              style: TextStyle(fontWeight: FontWeight.bold),):
                            Container();
                          }
                        ),
                        StreamBuilder(
                            stream: Firestore.instance.collection('myGroups')
                                .document(groupName)
                                .collection('Friends').document(
                                ss.data.documents[i]['id'].toString())
                                .snapshots()
                            , builder: (context, cc) {
                          return cc.hasData?(cc.data.exists? IconButton(
                            iconSize: 20.0,
                            icon: Icon(Icons.undo),
                            onPressed: (){
                              String pid=cc.data['id'];
                              gds.deleteDocFromData(pid,ss.data.documents[i]['id'], groupName);
                              Firestore.instance.collection('myGroups').document(groupName).collection('Friends').document(ss.data.documents[i]['id']).delete().catchError((e){print(e.toString());});
                              setState(() {
                                --count;
                                --fc;
                              });
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("USER REMOVED")
                                ,)
                              );},
                            color: Colors.black,
                          )
                              :IconButton(
                              iconSize: 20.0,
                              icon: Icon(Icons.person_add),
                              onPressed: (){
                                String id='p$fc';
                                gds.addFriend(id,groupName, ss.data.documents[i]['id']);
                                gds.addFriendDoc(id,groupName,ss.data.documents[i]['id']);
                                setState(() {
                                  ++count;
                                  ++fc;
                                });
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("USER ADDED AS FRIEND")
                                        ,action: SnackBarAction(
                                          label: "UNDO",
                                          onPressed: ()  {
                                            String pid=cc.data['id'];
                                            gds.deleteDocFromData(pid,ss.data.documents[i]['id'], groupName);
                                            Firestore.instance.collection('myGroups').document(groupName).collection('Friends').document(ss.data.documents[i]['id']).delete().catchError((e){print(e.toString());});
                                            setState(() {
                                              --count;
                                              --fc;
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Next",style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.arrow_forward,color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)
                {
                  return GroupChatScreen(groupName: groupName,uid: user.uid,lp: true,);
                }
          ));
        },
      ),
    );
  }
}
