import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:letschat/databaseService/databaseService.dart';
import 'package:letschat/databaseService/profileDatabaseService.dart';
import 'package:letschat/screens/loadingScreen.dart';
import 'package:letschat/services/authService.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
class ProfileMaker extends StatefulWidget {
  @override
  _ProfileMakerState createState() => _ProfileMakerState();
}

class _ProfileMakerState extends State<ProfileMaker> {

  //METHOD 1

  //DECLARING VARIABLES
  TextEditingController _username=new TextEditingController();
  File _image;
  bool uploaded=true;
  final key=GlobalKey<ScaffoldState>();
  String imageLink='https://firebasestorage.googleapis.com/v0/b/letschat-8a0be.appspot.com/o/defaultavatar.jpg?alt=media&token=2f896d3a-6b33-4bdc-800c-dcd9e993758f';
  showDp(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body: Center(
        child: Container(
            width: 200,
            height: 200,
            child: Hero(
              tag: imageLink.hashCode,
              child: _image==null?Image.network('https://firebasestorage.googleapis.com/v0/b/letschat-8a0be.appspot.com/o/groupavatar.png?alt=media&token=89c3ce63-424b-49a1-81dd-9b9fd3ea1086')
                  :Image.file(_image),
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("UPDATE YOUR PROFILE"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.power_settings_new,color: Colors.white,),onPressed: (){AuthenticationService().signOut();},)
      ],
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body:  Stack(
        children: <Widget>[
          uploaded?Container():Container(
      child: Temp(
        size: 30,
      ),),
          Container(
              child: ListView(

                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:50.0,left: 80.0,right: 80.0,bottom: 50.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              showDp(context);
                              },
                         child: ClipOval(
                           child: Hero(
                             tag: imageLink.hashCode,
                             child: Container(
                                 decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     border: Border.all(color: Colors.black)
                                 ),
                                 height: 160,
                                 width: 160,
                                 child: _image!=null?Image.file(_image,fit: BoxFit.cover,)
                                     :Image.asset('images/defaultavatar.jpg')),
                           ),
                         ),
                          ),
                          Positioned(
                              right: 0,bottom: 0,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).secondaryHeaderColor,
                                radius: 25,
                                child: IconButton(
                                  onPressed: (){
                                        getImage();
                                  },
                                  icon: Icon(Icons.camera_alt,size: 30,color: Colors.white,),
                                ),
                              ),
                              )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Theme.of(context).accentColor,
                      child: Text("UPDATE IMAGE",style: TextStyle(letterSpacing: 1,color: Colors.white
                      ,fontWeight: FontWeight.bold,fontSize: 20),),
                      onPressed: (){
                          uploadPhoto(context);
                          setState(() {
                            uploaded=false;
                          });
                      },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 45.0),
                    child: TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        hintText: "ENTER YOUR USERNAME",
                          suffixIcon: Icon(Icons.edit,color:  Theme.of(context).secondaryHeaderColor,),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0),bottomRight: Radius.circular(15.0))
                          ),
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0),bottomRight: Radius.circular(15.0))
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      )
      ,
         floatingActionButton: Builder(

            builder: (context) {
              return FloatingActionButton.extended(
                  label: Text("NEXT",style: TextStyle(color: Colors.white),),icon: Icon(Icons.arrow_forward
              ,color: Colors.white,),
                  onPressed: uploaded?(){
                    if(_username.text!='')
                    {
                      ProfileDatabase(uid: user.uid).addToDatabase(_username.text.toString(), imageLink);
                      DatabaseService(uid:user.uid).updateName(_username.text.toString(),imageLink);
                    }
                    else
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("PLEASE FILL USERNAME"),));
                  }:(){}
              );
            }
        )
    );
  }

    Future getImage() async{
    var image=await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50);
    print("IMAGE SIZE BEFORE:"+image.lengthSync().toString());
    setState(() {
      _image=image;
      print('Image Path $_image');
    });
    }

  Future uploadPhoto(BuildContext context) async{
  try
   {

     String filename=basename(_image.path);
    StorageReference storageReference=
        FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask=
    storageReference.putFile(_image);
    StorageTaskSnapshot snapshot=await uploadTask.onComplete;
    String link=await snapshot.ref.getDownloadURL();
    setState(()  {
    imageLink= link;
    uploaded=true;
    }
    );}
    catch(e){print(e.toString());}
  }
}
