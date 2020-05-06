
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:letschat/databaseService/chatDatabaseService.dart';
import 'package:letschat/screens/loadingScreen.dart';
import 'package:letschat/services/authService.dart';
import 'package:letschat/services/chatWithFriend.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:provider/provider.dart';
class ChatScreen extends StatefulWidget {
  final int ts;
  ChatScreen({this.ts});
  @override
  _ChatScreenState createState() => _ChatScreenState(
    ts:ts
  );
}

class _ChatScreenState extends State<ChatScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  final int ts;
  _ChatScreenState({this.ts});
  final AuthenticationService _auth=AuthenticationService();
  ScrollController sc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializing();
    sc=new ScrollController();
  }

  initializing()
  async {
    androidInitializationSettings=AndroidInitializationSettings('ic_launcher');
    iosInitializationSettings=IOSInitializationSettings(onDidReceiveLocalNotification:
    onDidReceiveLocalNotification);
    initializationSettings=InitializationSettings(androidInitializationSettings,iosInitializationSettings);
    await   flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);

  }

  void _showNotification(String username,String last_msg) async {
    await notification(username,last_msg);
  }
  Future<void> notification(String username,String last_msg) async {
    AndroidNotificationDetails androidNotificationDetails
    =AndroidNotificationDetails('Channel Id'
        ,'Channerl title'
        ,'Channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');
    IOSNotificationDetails iosNotificationDetails=
    IOSNotificationDetails();

    NotificationDetails notificationDetails=
    NotificationDetails(androidNotificationDetails,iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0,username,last_msg, notificationDetails,);

  }
  Future onDidReceiveLocalNotification(int id,String title,String body
      ,String payload) async{
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("OKAY"),
          isDefaultAction: true,
          onPressed: (){print(" ");},
        ),

      ],
    );
  }
  Future onSelectNotification(String payload)
  {
    if(payload!=null)
    {
      print(payload);
    }
  }
  @override
  Widget build(BuildContext context) {

    final user=Provider.of<User>(context);
   // getStatus(dbref,user.uid);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
           child: StreamBuilder(
             stream: Firestore.instance.collection('Friends').document(user.uid).collection('myFriends')
              .snapshots(),
              builder: (context,ss){
               if(!ss.hasData){
                 return Center(child: Temp(size:40));
               }
               else{
                 return ListView.builder(
                   shrinkWrap: true,
                     itemCount: ss.data.documents.length,
                     itemBuilder: (context,i){

                       return user.uid==ss.data.documents[i]['uid']?Container():Padding(
                         padding: const EdgeInsets.all(5.0),
                         child: StreamBuilder(
                           stream: Firestore.instance.collection('myUsers').document(ss.data.documents[i]['id']).snapshots(),
                           builder: (context, snapshot) {
                            if(snapshot.hasData)
                              {
                                String uniqueid='';
                                String myid=user.uid;
                                String fid=ss.data.documents[i]['id'];
                                String name=snapshot.data['username'];
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
                                      int count=0;
                                      int lastIndex=snapshot.data.documents.length>0?snapshot.data.documents.length-1:null;
                                      while(lastIndex!=null && (snapshot.data.documents[lastIndex]['fromId']==fid && snapshot.data.documents[lastIndex]['seen']!=true))
                                        {
                                          ++count;
                                          --lastIndex;
                                        }
                                       if(snapshot.data.documents.length>1 &&(snapshot.data.documents[snapshot.data.documents.length-1]['toId']==myid && snapshot.data.documents[snapshot.data.documents.length-1]['notify']==false))
                                         {
                                           Timestamp dt=snapshot.data.documents[snapshot.data.documents.length-1]['date'];
                                           String ms=dt.millisecondsSinceEpoch.toString();
                                           _showNotification(name, snapshot.data.documents[snapshot.data.documents.length-1]['userSentmsg']);
                                           print('in chat screen updating notify for $myid');
                                           ChatDatabaseService(uniqueId: uniqueid).updateNotify(ms);
                                         }
                                      String text=snapshot.data.documents.length>0?
                                      (snapshot.data.documents[snapshot.data.documents.length-1]['type']==0?
                                          snapshot.data.documents[snapshot.data.documents.length-1]['userSentmsg']:
                                          snapshot.data.documents[snapshot.data.documents.length-1]['type']==4?
                                              'Scratch Card'
                                              :snapshot.data.documents[snapshot.data.documents.length-1]['filename']):null;

                                      return Column(
                                        children: <Widget>[
                                          StreamBuilder(
                                            stream: Firestore.instance.collection('myChats').document(uniqueid)
                                          .snapshots(),
                                            builder: (context, ss) {
                                           if(ss.hasData){
                                              if(ss.data.exists) {
                                                return ss.data.data[fid] ?
                                                Row(
                                                  children: <Widget>[
                                                    Text("typing..."),
                                                  ],
                                                ) : Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: <Widget>[
                                                    Text(text == null
                                                        ? ''
                                                        : (text.length < 17
                                                        ? text
                                                        : ('${text.substring(
                                                        0, 17)}...'))),
                                                    CircleAvatar(radius: 10,
                                                        child: Text(count == 0
                                                            ? ''
                                                            : '$count',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white),)
                                                        ,
                                                        backgroundColor: count ==
                                                            0
                                                            ? Colors.white24
                                                            : Theme
                                                            .of(context)
                                                            .primaryColor)
//
                                                  ],
                                                );
                                              }
                                              else
                                                {
                                                  return Text("");
                                                }
                                                                                            }
                                              else
                                                {
                                                  return CircularProgressIndicator();
                                                }
                                            }
                                          ),
                                          Divider(height: 30,color: Colors.black,thickness: 1,)
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
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context){
                                      return DpPage(name:snapshot.data['username'],hash:snapshot.data['username'].hashCode.toString(),url:snapshot.data['profilepic']);
                                    }
                                  ));
                                 },
                                 child: Hero(
                                   tag: snapshot.data['username'].hashCode.toString(),
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
                               ),
                                title: Padding(
                                  padding: const EdgeInsets.only(top:10.0,bottom:8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(snapshot.data['username'],style: TextStyle(fontWeight: FontWeight.bold),),
                                      StreamBuilder(
                                        stream: Firestore.instance.collection('myChats').document(uniqueid).collection('Messages').snapshots(),
                                        builder: (context, snapshot) {

                                                if(snapshot.hasData) {
                                                  Timestamp ts = snapshot.data
                                                      .documents.length > 0
                                                      ? snapshot.data
                                                      .documents[snapshot.data
                                                      .documents.length -
                                                      1]['date']
                                                      : null;
                                                  DateTime dt;
                                                  if (ts != null)
                                                    dt = ts.toDate();
                                                  else
                                                    dt = null;
                                                  String time = '';
                                                  if (dt != null) {
                                                    if (dt.minute >= 10)
                                                      time =
                                                      '${dt.hour}:${dt.minute}';
                                                    else
                                                      time =
                                                      '${dt.hour}:0${dt.minute}';

                                                  }
                                                  return Text(time,style: TextStyle(fontSize: 13),);
                                                }
                                                  else {
                                                    return CircularProgressIndicator();
                                                  }
                                        }
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: (){
                                 Navigator.push(context, PageRouteBuilder(
                                   transitionDuration: Duration(milliseconds: 400),
                                   transitionsBuilder: (context,animation,secondaryAnimation,child){
                                     return SlideTransition(
                                       position: Tween<Offset>(
                                         begin: const Offset(1.0,0.0),
                                         end: Offset.zero
                                       ).animate(animation),
                                       child: SlideTransition(
                                     position: Tween<Offset>(
                                     begin:Offset.zero,
                                     end:  const Offset(1.0,0.0)
                                     ).animate(secondaryAnimation),
                                       child: child,
                                       ));
                                   },
                                   pageBuilder: (context,animation,secondaryAnimation)
                                     {
                                       return ChatWithFriend(ts:ts,myId:user.uid,fid:fid,name: snapshot.data['username'],imageUrl:snapshot.data['profilepic']);
                                       },


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
                       );

                     });
               }
              },
            ),

      ),
    );
  }
}

class DpPage extends StatelessWidget {
  final String name;
  final String hash;
  final String url;
  DpPage({this.name,this.hash,this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),color: Colors.white,onPressed: (){Navigator.pop(context);},),
        title: Text(name,style: TextStyle(color: Colors.white),),),
      body: Center(
        child: Hero(
          tag: hash,
          child: CachedNetworkImage(
            fit: BoxFit.fitWidth,
            imageUrl: url,
            placeholder: (context,url){
              return CircularProgressIndicator();
            },
            errorWidget: (context,url,err){
              return Icon(Icons.error);
            },
          ),
        ),
      ),
    );
  }
}

class GroupDp extends StatelessWidget {
  final String name;
  final String hash;
  final String url;
  GroupDp({this.name,this.hash,this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),color: Colors.white,onPressed: (){Navigator.pop(context);},),
        title: Text(name,style: TextStyle(color: Colors.white),),),
      body: Center(
        child: Hero(
          tag: hash,
          child: Container(
            height: 200,
            child: CachedNetworkImage(
              fit: BoxFit.fitWidth,
              imageUrl: url,
              placeholder: (context,url){
                return CircularProgressIndicator();
              },
              errorWidget: (context,url,err){
                return Icon(Icons.error);
              },
            ),
          ),
        ),
      ),
    );
  }
}

