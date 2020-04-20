import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:letschat/databaseService/statusDatabaseService.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:letschat/storymode/showStory.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
class StatusUpload extends StatefulWidget {
  final File image;
  final String imagePath;
  StatusUpload(
  {
    this.image,
    this.imagePath
}
      );
  @override
  _StatusUploadState createState() => _StatusUploadState(
    image: image,imagePath: imagePath
  );
}

class _StatusUploadState extends State<StatusUpload> {
  final File image;
  final String imagePath;
  String _imageUrl='';
  _StatusUploadState({
    this.image,
    this.imagePath
  });
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(imagePath);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
      },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Upload"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:20.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height/3,
              width: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/3,
              child: FittedBox(
                child: Image.file(image),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context){
          return FloatingActionButton(
            backgroundColor:Theme.of(context).accentColor,
            child: Icon(Icons.send,color:Colors.white,size: 24,),
            onPressed: (){
              callUpload(context,image,imagePath,user.uid);
              showDialog(context: context,builder: (context){
                return AlertDialog(
                  content: Container(
                    height: 100,
                    width: 100,
                    child: SpinKitChasingDots(color: Colors.black,size: 20,),
                  ),
                );
              });
            },
          );
        },
      )
    );
  }
  Future callUpload(BuildContext context,File image,String path,String uid) async {
   try {
     String filename=basename(path);
     StorageReference storageReference=
     FirebaseStorage.instance.ref().child(filename);
     StorageUploadTask storageUploadTask=
     storageReference.putFile(image);
     StorageTaskSnapshot snapshot= await storageUploadTask.onComplete;
     String link=await snapshot.ref.getDownloadURL();
     setState(() {
       Scaffold.of(context).showSnackBar(SnackBar(
         content: Text("UPLOADED"),
       ));
       _imageUrl=link;
       print(_imageUrl);
     });
     DateTime publishingDate=DateTime.now();
     String published=Timestamp.fromDate(publishingDate).millisecondsSinceEpoch.toString();
     print("PUBLISHED : $publishingDate");
     print("PUBLISHED TIMESTAMP: $published");

     DateTime endDate=publishingDate.add(Duration(minutes: 1));
     String end=Timestamp.fromDate(endDate).millisecondsSinceEpoch.toString();
     print("END : $endDate ");
     print("ENDING TIMESTAMP: $end");
     StatusDatabaseService().userStory(uid,_imageUrl,published,published.toString(), end.toString());
     print("DATA ADDED");
     Navigator.push(context, MaterialPageRoute(
       builder: (context){
         return ShowStory();
       }
     ));
   }
   catch(e)
    {
      print(e.toString());
    }
  }

}
