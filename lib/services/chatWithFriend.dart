import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:letschat/databaseService/chatDatabaseService.dart';
import 'package:letschat/screens/showImage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ChatWithFriend extends StatefulWidget {
  final String myId;
  final String fid;
 final String name;

  final String imageUrl;
  ChatWithFriend({this.myId,this.fid,this.name,this.imageUrl});
  @override
  _ChatWithFriendState createState() => _ChatWithFriendState(
    myId: myId,
    fid: fid,
    name:name,
    imageUrl:imageUrl,
   );
}

class _ChatWithFriendState extends State<ChatWithFriend>  with SingleTickerProviderStateMixin{
  final String myId;
  final String fid;
  String fileName='';
  final String name;
  final String imageUrl;
  int type = 0;
  bool showEmoji=false;
  String link='';
  var val=0.0;
  String uniqueid = '';
  String fileurl = '';
  IconData ic = Icons.mic;
  ScrollController scrollController;
  String msg;
  FocusNode fc=new FocusNode();
  TextEditingController tc = new TextEditingController();

  _ChatWithFriendState({this.myId, this.fid, this.name, this.imageUrl});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   scrollController = new ScrollController(initialScrollOffset: 50.0);
    }
    @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 200), () => scrollController.jumpTo(scrollController.position.maxScrollExtent));
    if (myId.hashCode <= fid.hashCode) {
      uniqueid = '$myId-$fid';
    }
    else {
      uniqueid = '$fid-$myId';
    }
    return Scaffold(
        appBar:PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.width*0.70),
          child: Container(
            alignment: Alignment.bottomCenter,
           height:MediaQuery.of(context).size.width*0.23,
           color: Theme.of(context).primaryColor,
           child: Row(
             children: <Widget>[
                     FlatButton(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(30.0),
                       ),
                       onPressed: (){
                         Navigator.pop(context);
                       },
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Icon(Icons.arrow_back,color: Colors.white,size: 20,),
                           Stack(
                             children: <Widget>[
                               ClipOval(
                                 child: CircleAvatar(
                                   radius: 20,
                                   backgroundColor: Colors.black,
                                   child: CachedNetworkImage(
                                     fit: BoxFit.cover,
                                     imageUrl:imageUrl,
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
                               Positioned(
                                 right: 0,
                                 bottom: 0,
                                 child: StreamBuilder(
                                     stream: Firestore.instance.collection('myUsers').document(fid).snapshots(),
                                     builder: (context, snapshot) {
                                       return snapshot.hasData?CircleAvatar(backgroundColor:
                                       snapshot.data['online']==1?Colors.green:snapshot.data['online']==2
                                           ?Colors.red:Colors.orangeAccent,radius: 8,):
                                        CircleAvatar(backgroundColor: Colors.orangeAccent,radius: 8,);
                                     }
                                 ),
                               ),
                             ],
                           ),
                         ],
                       ),
                       ),
               Text(name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
    ,           SizedBox(width: 5,),
               Wrap(
                 spacing: 10,
                 children: <Widget>[
                   IconButton(icon: Icon(Icons.call,color: Colors.white,),onPressed: (){},),
                   IconButton(icon: Icon(Icons.videocam,color: Colors.white,),onPressed: (){},),
                   IconButton(icon: Icon(Icons.more_vert,color: Colors.white,),onPressed: (){       },),

                 ],
               )

             ] ),
           ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: StreamBuilder(
                    stream: Firestore.instance.collection('myChats').document(
                        uniqueid)
                        .collection('Messages').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            controller: scrollController,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, i) {
                              if (snapshot.data.documents[i]['fromId'] ==
                                  myId) {

                                DateTime date = snapshot.data
                                    .documents[i]['date'].toDate();
                                String time = '';
                                if (date.minute >= 10)
                                  time = '${date.hour}:${date.minute}';
                                else
                                  time = '${date.hour}:0${date.minute}';

                                return snapshot.data.documents[i]['type'] == 0
                                    ?
                                Container(
                                  padding: EdgeInsets.only(right:10),
                                  margin:EdgeInsets.symmetric(vertical: 15) ,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width*0.65,
                                      ),
                                      decoration: BoxDecoration(
                                       color: Theme.of(context).accentColor ,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                   child: Padding(
                                     padding: const EdgeInsets.all(10.0),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                       children: <Widget>[
                                     Padding(
                                       padding: const EdgeInsets.only(bottom:5.0),
                                       child: Text(snapshot.data.documents[i]['userSentmsg'],
                                                      style: TextStyle(
                                                          fontSize: 20.0
                                                      ),
                                                    ),
                                     ),
                                         Padding(
                                                    padding: const EdgeInsets.only(bottom:5.0),
                                                    child: Text(time, style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold),),
                                                  ),
                                       ],
                                     ),
                                   ),
                                    ),

                                  ),
                                ) :
                                snapshot.data.documents[i]['type'] == 1 ?
                                (snapshot.data.documents[i]['userSentmsg']=='UPLOADING'?
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 80, right: 10.0,bottom:10.0),
                                  child:Container(

                                    padding: EdgeInsets.only(
                                        top: 5.0, right: 5.0, left: 5.0),
                                    height: 280,
                                    width: 280,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)
                                          ,
                                          bottomRight: Radius.circular(10),)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          height: 260,
                                          width: 260,
                                          child:Center(
                                            child: CircularProgressIndicator(backgroundColor: Colors.greenAccent,),
                                          ),

                                        ),

                                        Text(time, style: TextStyle(
                                            fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                ) :
                                    Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 80, right: 10.0,bottom:10.0),
                                  child:Container(

                                    padding: EdgeInsets.only(
                                        top: 5.0, right: 5.0, left: 5.0),
                                    height: 280,
                                    width: 280,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)
                                          ,
                                          bottomRight: Radius.circular(10),)
                                    ),
                                    child: GestureDetector(
                                      onTap:(){
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context){
                                            return ShowImage(url: snapshot.data.documents[i]['userSentmsg'],);
                                          }
                                        ));
                                        },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            height: 260,
                                            width: 260,
                                            child: ClipRect(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: snapshot.data
                                                    .documents[i]['userSentmsg'],
                                                placeholder: (context, url) {
                                                  return Container(
                                                      child: Center(
                                                        child: CircularProgressIndicator(backgroundColor: Colors.greenAccent),
                                                      )
                                                  );
                                                },
                                                errorWidget: (context, url,
                                                    error) {
                                                  return Icon(Icons.error);
                                                },
                                              ),
                                            ),

                                          ),

                                          Text(time, style: TextStyle(
                                              fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                                    : snapshot.data.documents[i]['type'] == 3 ?
                                (snapshot.data.documents[i]['userSentmsg']=='UPLOADING'?
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0,
                                      right: 10,
                                      bottom: 10,
                                      left: 80),
                                  child: Container(
                                     constraints: BoxConstraints(
                                         maxWidth: MediaQuery.of(context).size.width*0.65
                                     ),

                                     decoration: BoxDecoration(
                                         color:Theme.of(context).accentColor,
                                         borderRadius: BorderRadius.only(
                                           topLeft: Radius.circular(10),
                                           bottomLeft: Radius.circular(10),
                                           bottomRight: Radius.circular(10),
                                         )
                                     ),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                       children: <Widget>[
                                         Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                             children: <Widget>[
                                               Icon(Icons.insert_drive_file,color: Colors.black,),

                                               (snapshot.data.documents[i]['uploadstarted']?(snapshot.data.documents[i]['uploadcompleted']?Icon(Icons.check,color: Colors.black,):CircularPercentIndicator(
                                                 percent:val,
                                                 radius: 30.0,
                                                 backgroundColor: Colors.greenAccent,
                                               )
                                               ):CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.greenAccent),)
                                               )
                                             ]
                                         ),
                                         Padding(
                                           padding: const EdgeInsets.only(left:10.0),
                                           child: Text(snapshot.data.documents[i]['filename']==null?'NOT AVAILABLE':snapshot.data.documents[i]['filename']),
                                         ),
                                         Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Text(time, style: TextStyle(
                                               fontWeight: FontWeight.bold),),
                                         ),

                                       ],
                                     )),
                                ):GestureDetector(
                                 onLongPress: (){

                                 },
                                  child: Padding(
                                   padding: const EdgeInsets.only(top: 10.0,
                                       right: 10,
                                       bottom: 10,
                                       left: 80),
                                   child: Container(
                                       constraints: BoxConstraints(
                                           maxWidth: MediaQuery.of(context).size.width*0.65
                                       ),

                                       decoration: BoxDecoration(
                                           color:Theme.of(context).accentColor,
                                           borderRadius: BorderRadius.only(
                                             topLeft: Radius.circular(10),
                                             bottomLeft: Radius.circular(10),
                                             bottomRight: Radius.circular(10),
                                           )
                                       ),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.end,
                                         children: <Widget>[
                                           Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                               children: <Widget>[
                                                 Icon(Icons.insert_drive_file,color: Colors.black,),
                                               ]
                                           ),
                                           Padding(
                                             padding: const EdgeInsets.only(left:10.0),
                                             child: Text(snapshot.data.documents[i]['filename']==null?'NOT AVAILABLE':snapshot.data.documents[i]['filename']),
                                           ),
                                           Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Text(time, style: TextStyle(
                                                 fontWeight: FontWeight.bold),),
                                           ),

                                         ],
                                       )),
                               ),
                                ))

                                    : null;
                              }
                              else {
                                DateTime date = snapshot.data
                                    .documents[i]['date'].toDate();
                                String time = '';
                                if (date.minute >= 10)
                                  time = '${date.hour}:${date.minute}';
                                else
                                  time = '${date.hour}:0${date.minute}';

                                return snapshot.data.documents[i]['type'] == 0
                                    ?  Container(
                                  padding: EdgeInsets.only(left:10),
                                  margin:EdgeInsets.symmetric(vertical: 15) ,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width*0.65,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff29B6F6) ,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(bottom:5.0),
                                              child: Text(snapshot.data.documents[i]['userSentmsg'],
                                                style: TextStyle(
                                                    fontSize: 20.0
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom:5.0),
                                              child: Text(time, style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ),
                                )
                                    :
                                snapshot.data.documents[i]['type'] == 1 ?
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, right: 80, left: 10.0,bottom:10.0),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 5.0, right: 5.0, left: 5.0),
                                    height: 280,
                                    width: 280,
                                    decoration: BoxDecoration(
                                        color: Color(0xff29B6F6),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)
                                          ,
                                          bottomRight: Radius.circular(10),)
                                    ),
                                    child: Builder(
                                      builder:(context) {
                                        return GestureDetector(
                                          onTap:(){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context){
                                                  return ShowImage(url: snapshot.data.documents[i]['userSentmsg'],);
                                                }
                                            ));
                                          }, child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              height: 260,
                                              width: 260,
                                              child: ClipRect(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: snapshot.data
                                                      .documents[i]['userSentmsg'],
                                                  placeholder: (context, url) {
                                                    return Container(
                                                        child: Center(
                                                          child: CircularProgressIndicator(backgroundColor: Colors.greenAccent,),
                                                        )
                                                    );
                                                  },
                                                  errorWidget: (context, url,
                                                      error) {
                                                    return Icon(Icons.error);
                                                  },
                                                ),
                                              ),

                                            ),

                                            Text(time, style: TextStyle(
                                                fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      );}
                                    ),
                                  ),
                                )
                                    : snapshot.data.documents[i]['type'] == 3 ?
                                (snapshot.data.documents[i]['downloaded']=='NO'?
                                         Padding(
                                  padding: const EdgeInsets.only(top: 10.0,
                                          left: 10,
                                          bottom: 10,
                                          right: 80),
                                  child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width*0.65
                                        ),

                                        decoration: BoxDecoration(
                                            color:Color(0xff29B6F6),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            )
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                               Icon(Icons.insert_drive_file,color: Colors.black,),
                                                snapshot.data.documents[i]['start']?(snapshot.data.documents[i]['isdownloading']
                                                    ?( snapshot.data.documents[i]['isdownloaded']?Icon(Icons.check,color: Colors.black,):
                                                CircularPercentIndicator(
                                                  percent:val/100,
                                                  radius: 30.0,
                                                  backgroundColor: Colors.greenAccent,
                                                )):CircularProgressIndicator()):IconButton(
                                                  onPressed: (){
                                                    startDownload( snapshot.data.documents[i]['userSentmsg'],snapshot.data.documents[i]['filename'],snapshot.data.documents[i]['date']);
                                                  }
                                                  ,icon: Icon(Icons.file_download),color: Colors.black,)
                             ]
                              ),
                                            Padding(
                                              padding: const EdgeInsets.only(left:10.0),
                                              child: Text(snapshot.data.documents[i]['filename']==null?'NOT AVAILABLE':snapshot.data.documents[i]['filename']),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(time, style: TextStyle(
                                                  fontWeight: FontWeight.bold),),
                                            ),

                                          ],
                                        )
                                  )
                                )
//                                      }
//                                    )
                                :
                                Padding(
                                    padding: const EdgeInsets.only(top: 10.0,
                                        left: 10,
                                        bottom: 10,
                                        right: 80),
                                    child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width*0.65
                                        ),

                                        decoration: BoxDecoration(
                                            color:Color(0xff29B6F6),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            )
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Icon(Icons.insert_drive_file,color: Colors.black,),
                                                  Icon(Icons.check,color: Colors.black,),
                                                ]
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left:10.0),
                                              child: Text(snapshot.data.documents[i]['filename']==null?'NOT AVAILABLE':snapshot.data.documents[i]['filename']),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(time, style: TextStyle(
                                                  fontWeight: FontWeight.bold),),
                                            ),

                                          ],
                                        )
                                    )
                                )
                                )


                                    : null;
                              }
                            }
                        );
                      }
                      else {
                        return Container(
                          child: Center(
                            child: Text("NO MESSAGES"),
                          ),
                        );
                      }
                    }
                ),
              ),
            ),
            Container(

              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left:40.0),
                            child: TextField(
                              onTap: (){
                               return  hideEmojiKey();
                              },
                              focusNode: fc,
                              cursorColor: Colors.redAccent,
                              controller: tc,
                              onChanged: (val) {
                                setState(() {
                                  msg = val;
                                });
                              },
                              decoration: InputDecoration(

                                  suffixIcon: Wrap(
                                    children: <Widget>[

                                      IconButton(icon: Icon(
                                          Icons.camera_alt, color: Colors.black54,
                                          size: 30), onPressed: () {},),
                                    ],
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(80.0)
                                  ),
                                  hintText: "Send a message",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(80.0))
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:6.0),
                            child: IconButton(
                                icon: Icon(Icons.insert_emoticon),
                                iconSize: 30,
                                onPressed:(){
                                  if(!showEmoji)
                                  {hideKeyboard();
                                  showEmojiContainer();
                                  }
                                  else
                                  {
                                    showKeyboard();
                                    hideEmojiKey();
                                  }
                                }
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:200.0,top:3),
                            child: IconButton(icon: Icon(
                                Icons.attach_file, color: Colors.black54,
                                size: 30), onPressed: () {
                              fc.unfocus();
                              showAttachmentSheet(context);
                            },),
                          ),
                        ],
                      ),
                    ),

                    FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(tc.text.trim() == '' ? Icons.mic : Icons.send,
                        size: 28,color: Colors.white,),
                      elevation: 0,
                      onPressed: () {
                        if (tc.text.trim() != '') {
                          if (fileurl == '') {
                            ChatDatabaseService(uniqueId: uniqueid)
                                .userSendChat(myId, fid, tc.text.toString(),
                                DateTime
                                    .now()
                                    .millisecondsSinceEpoch
                                    .toString(), Timestamp.fromDate(
                                    DateTime.now()), type);
                          }
                          tc.clear();

                          Future.delayed(Duration(milliseconds: 100), () {
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          });
                        }
                        else {

                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            showEmoji?Container(child: emojiContainer(context),):Container()
          ],
        )
    );
  }

  Future startDownload(String url,String filename,Timestamp ts) async {
    String ms=ts.millisecondsSinceEpoch.toString();
    ChatDatabaseService(uniqueId: uniqueid).updateStart(ms);
    print(url);
    var dir=await getExternalStorageDirectory();
    String path=dir.path;
    String cp='$path/$filename';
    print(cp);

    Dio dio=new Dio();
    try{
      ChatDatabaseService(uniqueId: uniqueid).updateIsDownloading(ms);
      dio.download(url, cp,onReceiveProgress: (r,t){
     setState(() {
       var totalDownload=((r/t)*100).floorToDouble();
       val=totalDownload;
       print(val);
     });
     if(val==100.0)
        {
          print('completed');
          setState(() {
            val=0.0;
          });
          ChatDatabaseService(uniqueId: uniqueid).updateIsDownloaded(ms);
          ChatDatabaseService(uniqueId: uniqueid).anotherUserUpdateChat('YES', ms);
          ChatDatabaseService(uniqueId: uniqueid).deleteField(ms);
        }

      });

    }
    catch(e){
      print(e.toString());
    }
  }

  showKeyboard()=> fc.requestFocus();
  hideKeyboard()=> fc.unfocus();
  hideEmojiKey(){
    setState(() {
      showEmoji=false;
    });
  }
  showEmojiContainer(){
    setState(() {
      showEmoji=true;
    });
  }
   emojiContainer(BuildContext context){
    return EmojiPicker(
      indicatorColor: Colors.white,
      rows: 3,
      recommendKeywords: ["happy","sad","depressed"],
      bgColor:Theme.of(context).accentColor,
      onEmojiSelected: (e,c){
        tc.text=tc.text+e.emoji;
      },
      columns: 7,
    );
  }
  void showAttachmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.image,size: 50,color: Theme.of(context).primaryColor,),
                title: Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Text("IMAGE",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                ),
                onTap: () {
                  showFilePicker(FileType.image);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 5,),
              Divider(height: 5,),
              ListTile(
                leading: Icon(Icons.videocam,size: 50,color: Theme.of(context).primaryColor,),
                title: Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Text("VIDEO",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                ),
                onTap: () {
                  showFilePicker(FileType.video);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 5,),
              Divider(height: 5,),
              ListTile(
                leading: Icon(Icons.insert_drive_file,size: 50,color: Theme.of(context).primaryColor,),
                title: Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Text("FILE",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                ),
                onTap: () {
                  showFilePicker(FileType.any);
                  Navigator.pop(context);
                },
              )

            ],
          ),
        );
      },

    );
  }

  Future<void> showFilePicker(FileType filetype) async {
    File file = await FilePicker.getFile(type: filetype);
    String filename= basename(file.path);
    print(filename);
    int ft = 0;
    if (filetype == FileType.image) {
      ft = 1;
//      print("BEFORE : "+file.lengthSync().toString());
//      print("AFTER : "+file.lengthSync().toString());
    }
    else if (filetype == FileType.video) {
      ft = 2;
    }
    else if (filetype == FileType.any) {
      ft = 3;
    }
    setState(() {
      type = ft;
    });
    DateTime dt=DateTime.now();
    String ms= dt.millisecondsSinceEpoch.toString();
    Timestamp timestamp=Timestamp.fromDate(dt);
    if(ft==3)
      ChatDatabaseService(uniqueId: uniqueid).userSendFile(myId, fid, 'UPLOADING', ms, timestamp, type, filename,'NO');
    else
    ChatDatabaseService(uniqueId: uniqueid).userSendChat(myId, fid, 'UPLOADING',ms, timestamp, type);
    StorageReference storageReference = FirebaseStorage.instance.ref()
        .child(file.path);
    StorageUploadTask uploadTask = storageReference.putFile(file);
    ChatDatabaseService(uniqueId: uniqueid).updateUploadStart(ms);
    uploadTask.events.listen((event){
        setState(() {
          val=event.snapshot.bytesTransferred/event.snapshot.totalByteCount;
        });
      print('transferred ${event.snapshot.bytesTransferred} of ${event.snapshot.totalByteCount}');
    });
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String link = await taskSnapshot.ref.getDownloadURL();
    if(link!=null)
      {
        ChatDatabaseService(uniqueId: uniqueid).updateUploadEnd(ms);
      }
    setState(() {
      fileurl = link;
      fileName=filename;
      print(fileurl);
    });
    setState(() {
      val=0.0;
    });
      ChatDatabaseService(uniqueId: uniqueid).userUpdateChat(fileurl, ms);


  }
}
