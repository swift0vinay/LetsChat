import 'dart:async';
import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:letschat/databaseService/chatDatabaseService.dart';
import 'package:letschat/screens/fileLoader.dart';
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
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scratcher/scratcher.dart';

class ChatWithFriend extends StatefulWidget {
  final int ts;
  final String myId;
  final String fid;
 final String name;

  final String imageUrl;
  ChatWithFriend({this.ts,this.myId,this.fid,this.name,this.imageUrl});
  @override
  _ChatWithFriendState createState() => _ChatWithFriendState(
    ts:ts,
    myId: myId,
    fid: fid,
    name:name,
    imageUrl:imageUrl,
   );
}

class _ChatWithFriendState extends State<ChatWithFriend>  with SingleTickerProviderStateMixin{
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
//  AndroidInitializationSettings androidInitializationSettings;
//  IOSInitializationSettings iosInitializationSettings;
//  InitializationSettings initializationSettings;
  bool stopUpld=null;
  final int ts;
  final String myId;
  final String fid;
  String fileName='';
  final String name;
  final String imageUrl;
  int type = 0;
  String fileLoc='';
  bool showEmoji=false;
  String link='';
  var val=0.0;
  String uniqueid = '';
  String fileurl = '';
  int seen=0;
  IconData ic = Icons.mic;
  ScrollController scrollController;
  String msg='';
  FocusNode fc=new FocusNode();
  TextEditingController tc = new TextEditingController();
  final List<String> images=[
    "images/item1.jpg",
    "images/item2.jpg",
    "images/item3.jpg",
  ];
  _ChatWithFriendState({this.ts,this.myId, this.fid, this.name, this.imageUrl});
  @override
  void initState() {
    // TODO: implement initState

    getPath();
    super.initState();
//    initializing();
    setState(() {
      seen=ts;
    });
    print('value is $seen');
    if (myId.hashCode <= fid.hashCode) {
      uniqueid = '$myId-$fid';
    }
    else {
      uniqueid = '$fid-$myId';
    }
    ChatDatabaseService(uniqueId: uniqueid).addInitialState(myId, fid);
   scrollController = new ScrollController(initialScrollOffset: 50.0);

  }


    @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 200), () => scrollController.jumpTo(scrollController.position.maxScrollExtent));

    return Scaffold(
        appBar:   chatScreenAppBar(context),
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
                                Color bl=Colors.black;
                                            if(snapshot.data.documents[i]['seen']!=null){
                                        bl=snapshot.data.documents[i]['seen']?Theme.of(context).primaryColor:Colors.black;

                                            }
                                DateTime date = snapshot.data
                                    .documents[i]['date'].toDate();
                                String time = '';
                                if (date.minute >= 10)
                                  time = '${date.hour}:${date.minute}';
                                else
                                  time = '${date.hour}:0${date.minute}';
                                if(seen==1)
                                {
                                  ChatDatabaseService(uniqueId: uniqueid).updateNotify(date.millisecondsSinceEpoch.toString());
                                }
                                if (snapshot.data.documents[i]['type'] == 0) {
                                  return Container(
                                 // padding: EdgeInsets.only(right:10),
                                  margin:EdgeInsets.only(top: 10,bottom: 10,right:10) ,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Bubble(
                                      nipWidth: 10,
                                      nipHeight: 10,
                                      color: Theme.of(context).accentColor,
                                      nip:BubbleNip.rightTop,
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
                                       padding: const EdgeInsets.all(5.0),
                                       child: snapshot.data.documents[i]['userSentmsg'].length<=10?
                                           Wrap(
                                             crossAxisAlignment: WrapCrossAlignment.center,
                                             children: <Widget>[
                                               Text(snapshot.data.documents[i]['userSentmsg'],
                                                 style: TextStyle(
                                                     fontSize: 15.0,color: Colors.white
                                                 ),
                                               ),
                                               SizedBox(width:10),
                                               Wrap(
                                                 spacing: 2,
                                                 children: <Widget>[
                                                   Text(time, style: TextStyle(
                                                     fontSize: 12,
                                                       fontWeight: FontWeight
                                                           .bold,color: Colors.white),
                                                   ),
                                                   Icon(Icons.done_outline,color: bl,size: 15,)
                                                 ],

                                               ),
                                             ],
                                           )
                                           :Column(
                                         crossAxisAlignment: CrossAxisAlignment.end,
                                         children: <Widget>[
                                       Padding(
                                         padding: const EdgeInsets.only(bottom:5.0),
                                         child: Text(snapshot.data.documents[i]['userSentmsg'],
                                                        style: TextStyle(
                                                            fontSize: 15.0,color: Colors.white
                                                        ),
                                                      ),
                                       ),
                                           Wrap(
                                             spacing: 2,
                                             children: <Widget>[
                                               Text(time, style: TextStyle(
                                                 fontSize: 12,
                                                   fontWeight: FontWeight
                                                       .bold,color: Colors.white),
                                               ),
                                               Icon(Icons.done_outline,color: bl,size: 15,)
                                             ],

                                           ),
                                         ],
                                       ),
                                   ),
                                      ),
                                    ),

                                  ),
                                );
                                } else {
                                  return snapshot.data.documents[i]['type'] == 1 ?
                                (snapshot.data.documents[i]['userSentmsg']=='UPLOADING'?
                                  imageUploading(context,time,bl) :
                                    imageUploaded(context,time,snapshot.data.documents[i]['userSentmsg'],snapshot.data.documents[i]['filename'],bl)
                                )
                                    : snapshot.data.documents[i]['type'] == 3 ?
                                (
                                    snapshot.data.documents[i]['userSentmsg']=='PAUSED'?
                                         fileRestartUploading( context,date,
                                            snapshot.data.documents[i]['filename']!=null?snapshot.data.documents[i]['filename']:null,snapshot.data.documents[i]['stop'],snapshot.data.documents[i]['uploadstarted'],snapshot.data.documents[i]['uploadcompleted'],time):
                                    snapshot.data.documents[i]['userSentmsg']=='UPLOADING'?
                                      fileUploading(context,date,
                                    snapshot.data.documents[i]['stop'],
                                    snapshot.data.documents[i]['filename']!=null?snapshot.data.documents[i]['filename']:null,snapshot.data.documents[i]['uploadstarted'],snapshot.data.documents[i]['uploadcompleted'],time,bl):

                                    fileUploaded(context,snapshot.data.documents[i]['filename']!=null?snapshot.data.documents[i]['filename']:null,time,bl)
                                )
                                   :snapshot.data.documents[i]['type'] == 4?
                                sendMyCard(context,snapshot.data.documents[i]['imageIndex'],snapshot.data.documents[i]['content'],time,bl)
                                      :null;
                                }}
                              else {
                                DateTime date = snapshot.data
                                    .documents[i]['date'].toDate();
                                String time = '';
                                if (date.minute >= 10)
                                  time = '${date.hour}:${date.minute}';
                                else
                                  time = '${date.hour}:0${date.minute}';
                                if(seen==1)
                                {
                                  ChatDatabaseService(uniqueId: uniqueid).updateSeen(date.millisecondsSinceEpoch.toString(), true);
                                }
                                if (snapshot.data.documents[i]['type'] == 0) {

                                  return Container(
                                 // padding: EdgeInsets.only(left:10),
                                    margin:EdgeInsets.only(top: 10,bottom: 10,left:10) ,
                                    child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Bubble(
                                      nipWidth: 10,
                                      nipHeight: 10,
                                      nip:BubbleNip.leftTop,
                                      color: Theme.of(context).secondaryHeaderColor,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width*0.65,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).secondaryHeaderColor ,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: snapshot.data.documents[i]['userSentmsg'].length<=10?
                                          Wrap(
                                            spacing: 5,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            children: <Widget>[
                                              Text(snapshot.data.documents[i]['userSentmsg'],
                                                style: TextStyle(
                                                    fontSize: 17.0,color: Colors.white
                                                ),

                                              ),
                                              Text(time, style: TextStyle(
                                                fontSize: 12,
                                                  fontWeight: FontWeight
                                                      .bold,color: Colors.white),
                                              ),
                                            ],
                                          ):Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(bottom:5.0),
                                                child: Text(snapshot.data.documents[i]['userSentmsg'],
                                                  style: TextStyle(
                                                      fontSize: 15.0,color: Colors.white
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom:5.0),
                                                child: Wrap(
                                                  children: <Widget>[
                                                    Text(time, style: TextStyle(
                                                      fontSize: 12,
                                                        fontWeight: FontWeight
                                                            .bold,color: Colors.white),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  ),
                                );
                                }
                                else {
                                  return snapshot.data.documents[i]['type'] == 1 ?
                                  imageDownloading(context,time,snapshot.data.documents[i]['userSentmsg'].toString(),snapshot.data.documents[i]['date'],snapshot.data.documents[i]['filename'].toString())
                                    : snapshot.data.documents[i]['type'] == 4?
                                  receiveMyCard(context,snapshot.data.documents[i]['imageIndex'],snapshot.data.documents[i]['content'],time)
                                  :snapshot.data.documents[i]['type'] == 3 ?
                                (
                                    snapshot.data.documents[i]['downloaded']=='NO'?

                                fileDownlaoding(context,snapshot.data.documents[i]['filename'],snapshot.data.documents[i]['start'],snapshot.data.documents[i]['isdownloading'],
                                            snapshot.data.documents[i]['isdownloaded'],snapshot.data.documents[i]['userSentmsg'],
                                            snapshot.data.documents[i]['date'],time)
                                :
                                 fileDownloaded(context,snapshot.data.documents[i]['filename']==null?
                                 null:snapshot.data.documents[i]['filename'],time)

                                )


                                    : null;
                                }
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
              margin: EdgeInsets.only(bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.black)
                      ),
                      child: Row(
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.insert_emoticon),onPressed: (){
                            if(!showEmoji)
                            {hideKeyboard();
                            showEmojiContainer();
                            }
                            else
                            {
                              showKeyboard();
                              hideEmojiKey();
                            }
                          },),
                          Flexible(
                              child: Container(
                              child: TextField(
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                focusNode: fc,
                                onTap: (){
                                  return  hideEmojiKey();
                                },
                                onChanged: ((val){
                                  setState(() {
                                    msg = val;
                                    if(val.length<=1)
                                    {
                                      ChatDatabaseService(uniqueId: uniqueid).addTypingUser(myId, false);
                                    }
                                    else
                                    {
                                      ChatDatabaseService(uniqueId: uniqueid).addTypingUser(myId, true);
                                    }
                                  });
                                }),
                                controller: tc,
                                
                                decoration: InputDecoration.collapsed(hintText: "Send a msg"),
                              ),
                            ),
                          ),

                          IconButton(icon: Icon(Icons.attach_file),onPressed: (){
                            showAttachmentSheet(context);
                          },),
                          IconButton(icon: Icon(Icons.add_circle),onPressed: (){
                            showScratchCard(context);
                          },),

                        ],
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      mini: true,
                      child: Icon(msg == '' ? Icons.mic : Icons.send,color: Colors.white,),
                      backgroundColor:Theme.of(context).primaryColor,
                      onPressed: (){
                        if (msg != '') {
                          if (fileurl == '') {
                            ChatDatabaseService(uniqueId: uniqueid)
                                .userSendChat(myId, fid, tc.text.toString(),
                                DateTime
                                    .now()
                                    .millisecondsSinceEpoch
                                    .toString(), Timestamp.fromDate(
                                    DateTime.now()), type,false);
                          }
                          tc.clear();
                          ChatDatabaseService(uniqueId: uniqueid).addTypingUser(myId, false);
                          Future.delayed(Duration(milliseconds: 100), () {
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          });
                        }
                        else {

                        }
                      }
                  ),

                ],
              ),
            ),
//
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
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue,Colors.green],begin: Alignment.bottomLeft,
            end: Alignment.topRight)
          ),
          height: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                child: IconButton(
                icon:Icon(Icons.photo,size: 30),
          onPressed: (){
                  showFilePicker(FileType.image);
          Navigator.pop(context);
          },
              ),
              ),
              CircleAvatar(
                radius: 40,
                child: IconButton(
                  icon:Icon(Icons.videocam,size: 30,),
                  onPressed: (){
                    showFilePicker(FileType.video);
                    Navigator.pop(context);
                  },
                ),
              ), CircleAvatar(
                radius: 40,
                child: IconButton(
                  icon:Icon(Icons.attach_file,size: 30),
                  onPressed: (){
                    showFilePicker(FileType.any);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },

    );
  }

  Future<void> showFilePicker(FileType filetype) async {
    File file = await FilePicker.getFile(type: filetype);
    print(file.path);
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
    else if(ft==1)
        ChatDatabaseService(uniqueId: uniqueid).userSendImage(myId, fid, 'UPLOADING',ms, timestamp, type,filename);
        else
    ChatDatabaseService(uniqueId: uniqueid).userSendChat(myId, fid, 'UPLOADING',ms, timestamp, type,false);

    StorageReference storageReference = FirebaseStorage.instance.ref()
        .child(file.path);
    StorageUploadTask uploadTask = storageReference.putFile(file);
    print(' bool is $stopUpld');

     ChatDatabaseService(uniqueId: uniqueid).updateUploadStart(ms);
        uploadTask.events.listen((event){
          if(stopUpld==true)
          {
            try {
              uploadTask.cancel();
              ChatDatabaseService(uniqueId: uniqueid).stopUpload(ms, true);
              setState(() {
                val = 0.0;
                uploadTask = null;
              });
            }
            catch(e)
          {
            ChatDatabaseService(uniqueId: uniqueid).allUploadUpdate(ms);
            setState(() {
              stopUpld=null;

            });
            print('codes coomes here nad stops');
          }
          }
          else
            {
              ChatDatabaseService(uniqueId: uniqueid).stopUpload(ms, false);
              setState(() {
                val=event.snapshot.bytesTransferred/event.snapshot.totalByteCount;
              });
              print('transferred ${event.snapshot.bytesTransferred} of ${event.snapshot.totalByteCount}');
            }
        });
        if(uploadTask!=null) {
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          String link = await taskSnapshot.ref.getDownloadURL();
          if (link != null) {
            ChatDatabaseService(uniqueId: uniqueid).updateUploadEnd(ms);
          }
          setState(() {
            fileurl = link;
            print(fileurl);
          });
          setState(() {
            val = 0.0;
          });
          ChatDatabaseService(uniqueId: uniqueid).userUpdateChat(fileurl, ms);
          setState(() {
            stopUpld = null;
          });
        }
        else{
          ChatDatabaseService(uniqueId: uniqueid).allUploadUpdate(ms);
          setState(() {
            stopUpld=null;

          });
        }

  }

  Future openMyFile(String filename) async {
    var dir=await getExternalStorageDirectory();
    String path=dir.path;
    String cp='$path/$filename';
    var rs=await OpenFile.open(cp);
    print('${rs.type} ${rs.message}');
  }

  Future<void> getPath() async {
    var dir=await getExternalStorageDirectory();
    String path=dir.path;
    setState(() {
      fileLoc=path;
    });
  }

   Future<bool> checkFilePresent(String s) async {
     if(await File(s).exists())
    return Future<bool>.value(true);
    else
      return Future<bool>.value(false);
  }


  Widget chatScreenAppBar(BuildContext context)
  {
    return PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.width*0.80),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width*0.25,
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:30.0),
                child: FlatButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  icon: Icon(Icons.arrow_back,color: Colors.white,),
                  label: Stack(
                    children: <Widget>[
                      StreamBuilder(
                        stream: Firestore.instance.collection('myUsers').document(fid).snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData?ClipOval(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: snapshot.data['profilepic'],
                                placeholder:(context,url)
                                {
                                  return CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.black,
                                    backgroundImage: AssetImage('images/defaultavatar.jpg'),
                                  );
                                },
                                errorWidget: (context,url,error){
                                  return Icon(Icons.error);
                                },

                              ),
                            ),
                          ):
                           CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: AssetImage('images/defaultavatar.jpg'),
                          );
                        }
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
                  )
                  ,onPressed: (){
                  setState(() {
                    seen=0;
                    print('out value $seen');
                  });
                  Navigator.of(context).popUntil((route)=>route.isFirst);
                },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:30.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.25,
                  child: Row(
                    children: <Widget>[
                      StreamBuilder(
                          stream: Firestore.instance.collection('myChats').document(uniqueid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data[fid] == true ?
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return FileLoaders(name:name);
                                      }
                                  ));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(name.length>6?'${name.substring(0,5)}..':name, style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),),
                                    Text('typing.....', style: TextStyle(
                                        color: Colors.white),)
                                  ],
                                ),
                              )
                                  : GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context)
                                      {
                                        return FileLoaders(name:name);
                                      }
                                  ));
                                },
                                    child: Text(name.length>6?'${name.substring(0,5)}..':name, style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),),
                                  );
                            }
                            else
                              return Container();
                          }

                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:30.0),
                child: Wrap(

                  spacing: 10,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.call,color: Colors.white,),onPressed: (){},),
                    IconButton(icon: Icon(Icons.videocam,color: Colors.white,),onPressed: (){},),
                    IconButton(icon: Icon(Icons.more_vert,color: Colors.white,),onPressed: (){},),

                  ],
                ),
              ),
            ],
          ),
        )
    );

  }

  Widget fileUploaded(BuildContext context, String fs, String time, Color bl) {
    return GestureDetector(
      onTap: (){
        openMyFile(fs);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10.0,right: 10,bottom: 10),
        child: Container(
          alignment: Alignment.centerRight,
          child: Bubble(
            nipHeight: 10,
            nipWidth: 10,
            nip: BubbleNip.rightTop,
            color: Theme.of(context).accentColor,
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
                child:  Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Icon(Icons.insert_drive_file,color: Colors.black38,size: 50,),
                            Positioned(left:14,top: 20,child: Text(
                              fs.
                              substring(fs.indexOf('.'),fs.length)
                              ,style: TextStyle(color: Colors.white,fontSize: 10),)
                            ),
                          ],
                        ),
                        Text(
                          fs==null?
                          'please wait':
                          (fs.length>19?
                          '${fs.substring(0,19)}..'
                              :fs
                          ),
                          style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(time, style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight
                                .bold,color: Colors.white),
                        ),
                        Icon(Icons.done_outline,color: bl,size: 15,)
                      ],
                    ),

                  ],
                )
            ),
          ),
        ),
      ),
    );
  }

  fileUploading(BuildContext context,DateTime dt,bool stop, String fs, bool uploadstarted,bool uploadCompleted,String time, Color bl) {
    String ms=dt.millisecondsSinceEpoch.toString();
    return Container(
      margin: const EdgeInsets.only(top: 10.0,right: 10,bottom: 10),
      child: Container(
        alignment: Alignment.centerRight,
        child: Bubble(
          nipHeight: 10,
          nipWidth: 10,
          nip: BubbleNip.rightTop,
          color: Theme.of(context).accentColor,
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
                child:  Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        (uploadstarted?(uploadCompleted?Icon(Icons.check,color: Colors.black,):Container(
                          margin: EdgeInsets.only(left:8),
                          child: Stack(
                            children: <Widget>[
                              CircularPercentIndicator(
                                progressColor: Colors.red[600],
                                percent:val,
                                radius: 40.0,
                                backgroundColor:Colors.black54,
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left:0,
                                right: 0,
                                child: !stop?IconButton(
                                  icon: Icon(Icons.clear,color: Colors.white,),
                                  onPressed:(){
                                    setState(() {
                                      stopUpld=true;
                                    });
                                    print('stop');
                                    ChatDatabaseService(uniqueId: uniqueid).stopUpload(ms,true);
                                  }
                                ):
                                IconButton(
                                    icon: Icon(Icons.file_upload,color: Colors.white,),
                                    onPressed:(){
                                      setState(() {
                                        stopUpld=false;
                                      });
                                      print('upload');
                                      ChatDatabaseService(uniqueId: uniqueid).stopUpload(ms,false);
                                    }
                                ),
                              )
                            ],
                          ),
                        )
                        ):CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.greenAccent),)
                        ),
                        Text(
                          fs.toString()==null?
                          'please wait':
                          (fs.toString().length>19?
                          '${fs.substring(0,19)}..'
                              :fs
                          ),
                          style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(time, style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight
                                .bold,color: Colors.white),
                        ),
                        Icon(Icons.done_outline,color: bl,size: 15,)
                      ],
                    ),

                  ],
                )
            ),
          ),
        ),
      ),
    );
  }

  Widget fileRestartUploading(BuildContext context, DateTime dt, String fs,bool stop,bool uploadstarted,bool uploadCompleted, String time) {
    String ms=dt.millisecondsSinceEpoch.toString();
    return Container(
      margin: const EdgeInsets.only(top: 10.0,right: 10,bottom: 10),
      child: Container(
        alignment: Alignment.centerRight,
        child: Bubble(
          nipHeight: 10,
          nipWidth: 10,
          nip: BubbleNip.rightTop,
          color: Theme.of(context).accentColor,
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
                child:  Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        (uploadstarted?(uploadCompleted?Icon(Icons.check,color: Colors.black,):Container(
                          margin: EdgeInsets.only(left:8),
                          child: Stack(
                            children: <Widget>[
                              CircularPercentIndicator(
                                progressColor: Colors.red[600],
                                percent:val,
                                radius: 40.0,
                                backgroundColor:Colors.black54,
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left:0,
                                right: 0,
                                child: stop?IconButton(
                                    icon: Icon(Icons.file_upload,color: Colors.white,),
                                    onPressed:(){
                                      setState(() {
                                        stopUpld=false;
                                      });
                                      print('uploading start again');
                                      ChatDatabaseService(uniqueId: uniqueid).updateUploadStart(ms);
                                    }
                                ):
                                IconButton(
                                    icon: Icon(Icons.clear,color: Colors.white,),
                                    onPressed:(){
                                      setState(() {
                                        stopUpld=true;
                                      });
                                      print('upload');
                                      ChatDatabaseService(uniqueId: uniqueid).stopUpload(ms,false);
                                    }
                                ),
                              )
                            ],
                          ),
                        )
                        ):CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(Colors.greenAccent),)
                        ),
                        Text(
                          fs.toString()==null?
                          'please wait':
                          (fs.toString().length>19?
                          '${fs.substring(0,19)}..'
                              :fs
                          ),
                          style: TextStyle(color: Colors.white,fontSize: 15),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(time, style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight
                                .bold,color: Colors.white),
                        ),
                        Icon(Icons.access_time,color: Colors.black,size: 15,)
                      ],
                    ),

                  ],
                )
            ),
          ),
        ),
      ),
    );
  }

  Widget fileDownloaded(BuildContext context,String fs,String time) {
    return GestureDetector(
      onTap: (){
        openMyFile(fs);
      },
        child:Container(
      margin: const EdgeInsets.only(top: 10.0,left: 10,bottom: 10),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Bubble(
          nipHeight: 10,
          nipWidth: 10,
          nip: BubbleNip.leftTop,
          color: Theme.of(context).secondaryHeaderColor,
          child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width*0.65
              ),

              decoration: BoxDecoration(
                  color:Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )
              ),
              child:  Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Icon(Icons.insert_drive_file,color: Colors.black38,size: 50,),
                          Positioned(left:14,top: 20,child: Text(
                            fs.
                            substring(fs.indexOf('.'),fs.length)
                            ,style: TextStyle(color: Colors.white,fontSize: 10),)
                          ),
                        ],
                      ),
                      Text(
                        fs==null?
                        'please wait':
                        (fs.length>19?
                        '${fs.substring(0,19)}..'
                            :fs
                        ),
                        style: TextStyle(color: Colors.white,fontSize: 15),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(time, style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight
                              .bold,color: Colors.white),
                      ),
                    ],
                  ),

                ],
              )
          ),
        ),
      ),
    )
    );
  }

  fileDownlaoding(BuildContext context,String fs,bool start,bool isDownloading,bool isDownloaded,String downloadUrl,Timestamp ts,String time) {
    if(seen==1)
    {
      ChatDatabaseService(uniqueId: uniqueid).updateSeen(ts.millisecondsSinceEpoch.toString(), true);
    }

    return Container(
      margin: const EdgeInsets.only(top: 10.0,left: 10,bottom: 10),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Bubble(
          nipHeight: 10,
          nipWidth: 10,
          nip: BubbleNip.leftTop,
          color: Theme.of(context).secondaryHeaderColor,
          child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width*0.65
              ),
              decoration: BoxDecoration(
                  color:Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )
              ),
              child:Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        fs.toString()==null?
                        'please wait':
                        (fs.toString().length>19?
                        '${fs.substring(0,19)}..'
                            :fs
                        ),
                        style: TextStyle(color: Colors.white,fontSize: 15),),
                      start?(isDownloading
                          ?( isDownloaded?Icon(Icons.check,color: Colors.black,):
                      Container(
                        margin: EdgeInsets.only(right:8),
                        child: CircularPercentIndicator(
                          progressColor: Colors.red[600],
                          percent:val/100,
                          radius: 40.0,
                          backgroundColor:Colors.black54,
                        ),
                      )):CircularProgressIndicator()):
                      IconButton(
                        icon: Icon(Icons.file_download),
                        onPressed: (){
                          startDownload( downloadUrl,fs,ts);
                        },
                      )
                      ,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(time, style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight
                              .bold,color: Colors.white),
                      ),
                    ],
                  ),

                ],
              ),
        ),
      ),)
    );
//        start?(isDownloading
//                            ?( isDownloaded?Icon(Icons.check,color: Colors.black,):
//                        CircularPercentIndicator(
//                          percent:val/100,
//                          radius: 30.0,
//                          backgroundColor: Colors.greenAccent,
//                        )):CircularProgressIndicator()):IconButton(
//                          onPressed: (){
//                            startDownload( downloadUrl,fs,ts);
//                          }
//                          ,icon: Icon(Icons.file_download),color: Colors.black,)
  }

  imageUploading(BuildContext context,String time,Color bl) {
    return Container(
      margin: EdgeInsets.only(right:10),
      child: Container(
        alignment: Alignment.centerRight,
        child: Bubble(
          nipHeight: 10,
          nipWidth: 10,
          nip: BubbleNip.rightTop,
          color: Theme.of(context).accentColor,
          child: Container(
            height: MediaQuery.of(context).size.width*0.766,
            width: MediaQuery.of(context).size.width*0.65,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width*0.724,
                  width: MediaQuery.of(context).size.width*0.65,
                  child:Center(
                    child: CircularProgressIndicator(backgroundColor: Colors.greenAccent,),
                  ),

                ),

                Wrap(
                  children: <Widget>[
                    Text(time, style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold),),
                    Icon(Icons.done_outline,color: bl,size: 15,)

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  imageUploaded(BuildContext context, String time,String msg,String fs,Color bl) {
    return Container(
      margin: EdgeInsets.only(right:10),
      child: Container(
        alignment: Alignment.centerRight,
        child: Bubble(
          nipHeight: 10,
          nipWidth: 10,
          nip: BubbleNip.rightTop,
          color: Theme.of(context).accentColor,

          child: Container(
            height: MediaQuery.of(context).size.width*0.766,
            width: MediaQuery.of(context).size.width*0.65,

            child: GestureDetector(
              onTap:(){
                Navigator.push(context, PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 1500),
                    pageBuilder: (_,__,___){
                      return ShowImage(hash:time.hashCode.toString(),url: msg,name:fs);
                    }
                ));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Hero(
                    tag:time.hashCode.toString(),
                    child:Container(
                    height: MediaQuery.of(context).size.width*0.724,
                    width: MediaQuery.of(context).size.width*0.65,
                      child: ClipRect(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: msg,
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

                  ),

                  Wrap(
                    children: <Widget>[
                      Text(time, style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold),),
                      Icon(Icons.done_outline,color: bl,size: 15,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  imageDownloading(BuildContext context, String time,String msg,Timestamp ts,String filename) {
     if(seen==1)
    {
    ChatDatabaseService(uniqueId: uniqueid).updateSeen(ts.millisecondsSinceEpoch.toString(), true);
    }

    return Container(
      margin: EdgeInsets.only(left:10,bottom: 5,top: 5),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Bubble(
          nipHeight: 10,
          nipWidth: 10,
          nip: BubbleNip.leftTop,
          color: Theme.of(context).secondaryHeaderColor,

          child: Container(

            height: MediaQuery.of(context).size.width*0.766,
            width: MediaQuery.of(context).size.width*0.65,
            child: Builder(
                builder:(context) {
                  return GestureDetector(
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return ShowImage(hash:name.hashCode.toString(),url: msg,name: filename,);
                          }
                      ));
                    }, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.width*0.724,
                        width: MediaQuery.of(context).size.width*0.65,
                        child: Hero(
                          tag: name.hashCode.toString(),
                          child: ClipRect(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: msg,
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

                      ),

                      Text(time, style: TextStyle(
                          fontWeight: FontWeight.bold,color: Colors.white),),
                    ],
                  ),
                  );}
            ),
          ),
        ),
      ),
    );
  }

  void showScratchCard(BuildContext context) {
    int t=0;
    TextEditingController tssc=new TextEditingController();
    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    showModalBottomSheet(context: (context), builder: (cc){
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("Choose Scratch Card"),),
        body: Container(
          height: 350,
          child: Column(
            children: <Widget>[
              Flexible(
                child: GestureDetector(
                  onLongPress: (){
                   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(images[t]
                    .substring(images[t].indexOf('/'),images[t].length)),));
                  },
                  child: CarouselSlider(
                    items:  images.map(
                          (url) {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            child: Image.asset(
                                url,
                                fit: BoxFit.cover,
                                width: 500.0
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    options: CarouselOptions(
                      height: 200,
                        aspectRatio: 16/9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (int index,CarouselPageChangedReason cs)
                        {

                          setState(() {
                            t=index;
                          });
                          print(t);
                          print(cs);
                        }
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top:5.0,left: 5.0,right:5.0),
                  child: TextField(
                    controller: tssc,
                    decoration: InputDecoration(
                      labelText: "Enter your msg",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(10.0)
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          mini:true,
          child: Icon(Icons.send,color: Colors.white,),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed:  tssc.text.trim().length!=0?(){
          ChatDatabaseService(uniqueId: uniqueid).sendCard(myId,fid,DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(), Timestamp.fromDate(
              DateTime.now()),4,false,
          tssc.text.trim(),
            t
          );
          Future.delayed(Duration(milliseconds: 100), () {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease);
          });
          Navigator.pop(context);
          }:(){
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("ENTER A MSG")));
            },
        ),
      );
    });
  }

  sendMyCard(BuildContext context, int index, String content,String time,Color bl) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0,left: 10,bottom: 10),
      child: Container(
        alignment: Alignment.centerRight,
        child: Bubble(
          nipHeight: 10,
          nipWidth: 10,
          nip: BubbleNip.rightTop,
          color: Theme.of(context).accentColor,
          child: Container(
            height: MediaQuery.of(context).size.width*0.70,
            width: MediaQuery.of(context).size.width*0.65,

            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width*0.65,
                  width: MediaQuery.of(context).size.width*0.65,
                  child: Scratcher(

                    accuracy: ScratchAccuracy.low,
                    brushSize: 50,
                    image:Image.asset(images[index]),
                    child: Container(
                      height: 300,
                      width: 300,
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 50
                        ),
                      ),
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(time, style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight
                            .bold,color: Colors.white),
                    ),
                    SizedBox(width: 2,),
                    Icon(Icons.done_outline,color: bl,size: 15,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  receiveMyCard(BuildContext context, int index, String content,String time) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0,left: 10,bottom: 10),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Bubble(
          nipHeight: 10,
          nipWidth: 10,
          nip: BubbleNip.leftTop,
          color: Theme.of(context).secondaryHeaderColor,
          child:
          Container(
              height: MediaQuery.of(context).size.width*0.695,
              width: MediaQuery.of(context).size.width*0.65,
              child:Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width*0.65,
                width: MediaQuery.of(context).size.width*0.65,
                child: Scratcher(

                    accuracy: ScratchAccuracy.low,
                    brushSize: 50,
                    image:Image.asset(images[index]),
                    child: Container(
                      height: 300,
                      width: 300,
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 50
                        ),
                      ),
                    )
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(time, style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight
                          .bold,color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),)
    );
  }

  Future<void> showCardDialog(BuildContext context, int index, String content) {
  double opacity=0.0;
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
  title: Align(alignment: Alignment.center,
  child: Text("TAP TO SCRATCH",
  style: TextStyle(color: Colors.black,
  fontSize: 20,fontWeight: FontWeight.bold),),
  ),
        content: Scratcher(
          accuracy: ScratchAccuracy.low,
          brushSize: 50,
          image:Image.asset(images[index]),
          threshold: 25,
          onThreshold: (){
            setState(() {
              opacity=1;

            });
          },
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: opacity,
            child: Container(
              height: 300,
              width: 300,
              alignment: Alignment.center,
              child: Text(
                content,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 50
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
