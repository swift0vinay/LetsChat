
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:letschat/screens/loadingScreen.dart';
import 'package:letschat/services/authService.dart';
import 'package:letschat/services/chatWithFriend.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:provider/provider.dart';
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthenticationService _auth=AuthenticationService();
  //final dbref=FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<User>(context);
   // getStatus(dbref,user.uid);
    return Scaffold(
      body: StreamBuilder(
       stream: Firestore.instance.collection('Friends').document(user.uid).collection('myFriends')
        .snapshots(),
        builder: (context,ss){
         if(!ss.hasData){
           return Loading();
         }
         else{
           return ListView.builder(
               itemCount: ss.data.documents.length,
               itemBuilder: (context,i){

                 return user.uid==ss.data.documents[i]['uid']?Container():Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Card(
                     color: Color(0xffFFB74D),
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
                        stream: Firestore.instance.collection('myUsers').document(ss.data.documents[i]['id']).snapshots(),
                        builder: (context, snapshot) {
                         if(snapshot.hasData)
                           {
                             String uniqueid='';
                             String myid=user.uid;
                             String fid=ss.data.documents[i]['id'];
                             if (myid.hashCode <= fid.hashCode) {
                               uniqueid = '$myid-$fid';
                             }
                             else {
                               uniqueid = '$fid-$myid';
                             }
                             return ListTile(
                               subtitle: StreamBuilder(
                                 stream: Firestore.instance.collection('myChats').document(uniqueid).collection('Messages').snapshots(),
                                 builder: (context, snapshot) {

                                   if(snapshot.hasData) {
                                     String text=snapshot.data.documents.length>0?
                                     (snapshot.data.documents[snapshot.data.documents.length-1]['type']==0?
                                         snapshot.data.documents[snapshot.data.documents.length-1]['userSentmsg']
                                             :snapshot.data.documents[snapshot.data.documents.length-1]['filename']):null;
                                     Timestamp ts=snapshot.data.documents.length>0?snapshot.data.documents[snapshot.data.documents.length-1]['date']:null;

                                      DateTime dt;
                                      if(ts!=null)
                                     dt =ts.toDate();
                                      else
                                        dt=null;
                                      String time='';
                                    if(dt!=null) {
                                      if (dt.minute >= 10)
                                        time = '${dt.hour}:${dt.minute}';
                                      else
                                        time = '${dt.hour}:0${dt.minute}';
                                    }

                                     return Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: <Widget>[
                                         Text(text==null?'':(text.length<17?text:('${text.substring(0,19)}...'))),
                                         Text(time==''?'':time),
                                       ],
                                     );
                                   }
                                   else
                                     {
                                       return Container();
                                     }
                                 }
                               ),
                            leading: GestureDetector(
                              onTap: (){
                                showDialog(context: context,builder: (context){
                                  return AlertDialog(
                                    content: Container(
                                      height: 200,
                                      width: 200,
                                      constraints: BoxConstraints(
                                        maxHeight: 200,
                                        maxWidth: 200,
                                      ),
                                      child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: CachedNetworkImage(
                                          imageUrl: snapshot.data['profilepic'],
                                            placeholder: (context,url){
                                            return Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage('images/defaultavatar.jpg')
                                                )
                                              ),
                                            );
                                            },
                                          ),
                                          ),
                                    ),
                                  );
                                });
                              },
                              child: ClipOval(
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.black,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: snapshot.data['profilepic'],
                                      placeholder:(context,url)
                                      {
                                        return CircleAvatar(
                                          backgroundColor: Colors.black,
                                          backgroundImage: AssetImage('images/defaultavatar.jpg'),
                                        );
                                      },
                                      errorWidget: (context,url,error){
                                        return Icon(Icons.error);
                                      },

                                    ),
                                  ),
                                     ),
                            ),
                             title: Text(snapshot.data['username'],style: TextStyle(fontWeight: FontWeight.bold),),
                             onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context){
                                  return ChatWithFriend(myId:user.uid,fid:fid,name: snapshot.data['username'],imageUrl:snapshot.data['profilepic']
                               );
                                }
                              ));
                             },
                          );}
                         else
                           {
                             return Center(
                               child: CircularProgressIndicator(),
                             );
                           }
                        }
                      ),
                     ),
                   ),
                 );

               });
         }
        },
      )
    );
  }

}
