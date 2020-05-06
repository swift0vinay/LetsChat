import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:letschat/databaseService/groupDatabaseService.dart';
import 'package:letschat/groupService/customAppBar.dart';
import 'package:letschat/groupService/sendTextMessages.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:provider/provider.dart';
class GroupChatScreen extends StatefulWidget {
  final String groupName;
  final String uid;
  final bool lp;
  GroupChatScreen({this.groupName,this.uid,this.lp});
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState(
    groupName: groupName,
        uid:uid,
    lp:lp
  );
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  TextEditingController tc = TextEditingController();
  final bool lp;
  final String groupName;
  final String uid;
  String fileurl = '';
  String msg = '';
  int type = 0;
  var val = 0.0;
  ScrollController scrollController;

  _GroupChatScreenState({this.groupName, this.uid,this.lp});

  FocusNode fc = new FocusNode();
  bool st=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = new ScrollController(initialScrollOffset: 50.0);
    if(lp)
      {
        setState(() {
          st=true;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: myAppBar(context, groupName,st),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('myChats').document(
                    groupName.hashCode.toString())
                    .collection('Messages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        controller: scrollController,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, i) {
                          if (snapshot.data.documents[i]['from'] == user.uid) {
                            return senderBox(context,
                                snapshot.data.documents[i]['userMessage'],
                                snapshot.data
                                    .documents[i]['date'].toDate());
                          }
                          else {
                            return receiverBox(context, user.uid,
                                snapshot.data.documents[i]['userMessage'],
                                snapshot.data
                                    .documents[i]['date'].toDate(),
                                snapshot.data.documents[i]['from']);
                          }
                        }
                    );
                  }
                  else {
                    return Container(
                      child: Center(
                        child: Text("SAY HI"),
                      ),
                    );
                  }
                },
              ),
            ),
          ),

          Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black)
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.insert_emoticon), onPressed: () {},),
                        Flexible(
                          child: Container(

                            child: TextField(
                              maxLines: null,
                              onChanged: ((val) {
                                setState(() {
                                  msg = val;
                                });
                              }),
                              controller: tc,
                              decoration: InputDecoration.collapsed(
                                  hintText: "Send a msg"),
                            ),
                          ),
                        ),

                        IconButton(icon: Icon(Icons.attach_file), onPressed: () {
                         showAttachmentSheet(context);
                        },),
                        IconButton(
                          icon: Icon(Icons.camera_alt), onPressed: () {},),

                      ],
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                  mini: true,
                  child: Icon(msg.trim() == '' ? Icons.mic : Icons.send,
                    color: Colors.white,),
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  onPressed: () {
                    if (tc.text.trim() != '') {
                      if (fileurl == '') {
                        GroupDatabaseService()
                            .sendUserMsg(
                            groupName.hashCode.toString(), tc.text.toString()
                            , Timestamp.fromDate(DateTime.now()),
                            user.uid,
                            DateTime
                                .now()
                                .millisecondsSinceEpoch
                                .toString(),
                            type
                        );
                      }
                      tc.clear();
//                        ChatDatabaseService(uniqueId: uniqueid).addTypingUser(myId, false);
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
        ],
      ),
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

  Future<void> showFilePicker(FileType fileType) async {
    File file = await FilePicker.getFile(type: fileType);
    String filename = basename(file.path);
    print(filename);
    int ft = 0;
    if (fileType == FileType.image)
      ft = 1;
    else if (fileType == FileType.video)
      ft = 2;
    else if (fileType == FileType.any)
      ft = 3;
    setState(() {
      type = ft;
    });

    DateTime dt = DateTime.now();
    String ms = dt.millisecondsSinceEpoch.toString();
    Timestamp timestamp = Timestamp.fromDate(dt);
    if (ft == 3)
      GroupDatabaseService().userSendFile(
          groupName.hashCode.toString(),
          uid,
          'UPLOADING',
          ms,
          timestamp,
          type,
          filename);
    else if (ft == 1)
      GroupDatabaseService().userSendImage(
          groupName.hashCode.toString(),
          uid,
          'UPLOADING',
          ms,
          timestamp,
          type,
          filename);
    else
      GroupDatabaseService().sendUserMsg(
          groupName.hashCode.toString(), 'UPLOADING', timestamp, uid, ms, type);

    StorageReference storageReference = FirebaseStorage.instance.ref()
        .child(file.path);
    StorageUploadTask uploadTask = storageReference.putFile(file);
    GroupDatabaseService().updateUploadStart(groupName.hashCode.toString(), ms);
    uploadTask.events.listen((event) {
      setState(() {
        val = event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
      });
      print('transferred ${event.snapshot.bytesTransferred} of ${event.snapshot
          .totalByteCount}');
    });
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String link = await taskSnapshot.ref.getDownloadURL();
    if (link != null) {
      GroupDatabaseService().updateUploadEnd(groupName.hashCode.toString(), ms);
    }
    setState(() {
      fileurl = link;
      print(fileurl);
    });
    setState(() {
      val = 0.0;
    });
    GroupDatabaseService().userUpdateChat(
        groupName.hashCode.toString(), fileurl, ms);
  }

}
