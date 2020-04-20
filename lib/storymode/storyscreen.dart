import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:letschat/storymode/showStory.dart';
import 'package:letschat/storymode/statusUplaod.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';
class StoryScreen extends StatefulWidget {
  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  bool isStatusPresent = false;
  File _image;
  String imageUrl = '';
  String timeStamp = '';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20),
              child: ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.black,),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ShowStory();
                        }
                    ));
                  },
                ),
                leading: GestureDetector(
                  onTap: () {
                    isStatusPresent ? openStory(context,imageUrl) : getImage(
                        user.uid, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Stack(
                      children: <Widget>[
                        ClipOval(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset('images/defaultavatar.jpg'),
                          ),
                        )
                        ,
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Theme
                                    .of(context)
                                    .accentColor,
                                shape: BoxShape.circle
                            ),
                            child: Icon(Icons.add, size: 15,),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                title: StreamBuilder(
                  stream: Firestore.instance.collection('myUsers')
                      .document(user.uid).snapshots(),
                  builder: (context,cs){
                    if(cs.hasData){
                      return Text(cs.data['username']);
                    }
                    else
                    {
                      return Text("");
                    }
                  },
                ),
                subtitle: Text("TIMING COMES"),
              ),
            ),
            Divider(height: 20,thickness:2),
            StreamBuilder(
              stream: Firestore.instance.collection('userStories').snapshots(),
              builder: (context,ss)
              {
                if(!ss.hasData)
                  {
                    return Center(child: Text("NO STATUS"),);
                  }
                else
                  {
                    return ListView.builder(
                      shrinkWrap: true,
                        itemCount: ss.data.documents.length,
                        itemBuilder:(context,i)
                        {
                          return ss.data.documents[i]['uid']!=user.uid?Padding(
                            padding: const EdgeInsets.only(left:20.0,top:10.0,bottom:10.0),
                            child: ListTile(
                              title: StreamBuilder(
                                 stream: Firestore.instance.collection('myUsers')
                                  .document(ss.data.documents[i]['uid']).snapshots(),
                                  builder: (context,cs){
                                   if(cs.hasData){
                                     return Padding(
                                       padding: const EdgeInsets.only(left:30.0),
                                       child: Text(cs.data['username']),
                                     );
                                   }
                                   else
                                     {
                                       return Text("");
                                     }
                                  },
                                ),
                              leading:  GestureDetector(
                                  onTap: (){
                                    openStory(context,ss.data.documents[i]['imageUrl']);
                                  },
                                  child: ClipOval(
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: ss.data.documents[i]['imageUrl'],
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
                                      )
                                  )
                              ),
                            ),
                          ): Center(child: Container());
                        }
                    );
                  }
              },
            )
          ],
        )

    );
  }

  Future getImage(String uid, BuildContext context) async {
    try {
      var file = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      setState(() {
        _image = file;
        if (_image != null) {
          print(_image.path);
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return StatusUpload(image: _image, imagePath: _image.path,);
              }
          ));
        } else
          print("no file selected");
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("UPLOADING>>>"),));
      });
    }
    catch (e) {
      print(e.toString());
    }
  }

 void openStory(BuildContext context,String url) {
   Navigator.push(context, MaterialPageRoute(
       builder: (context){
         return StoryMode(url:url);
       }
   ));
 }
}

class StoryMode extends StatefulWidget {
  final String url;
  StoryMode({this.url});

  @override
  _StoryModeState createState() => _StoryModeState(
    url:url
  );
}

class _StoryModeState extends State<StoryMode> {
  final controller=StoryController();

  final String url;
  _StoryModeState({this.url});

  @override
  Widget build(BuildContext context) {
    List<StoryItem> mylist=[
      StoryItem.pageImage(NetworkImage(url)),
       ];
    return StoryView(
      mylist,
      controller: controller,
      onComplete: (){
        Navigator.pop(context);
      },
      repeat: false,
      onStoryShow: (s){
        print('item traversed');
      },
    );
  }
}
