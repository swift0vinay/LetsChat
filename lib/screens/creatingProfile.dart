import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:letschat/databaseService/databaseService.dart';
import 'package:letschat/databaseService/profileDatabaseService.dart';
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
  void showDp(BuildContext context){
    var alert=AlertDialog(
      content: AnimatedContainer(
        duration: Duration(seconds: 1),
        width: 200,
        height: 200,
        child: _image==null?Image.network('https://firebasestorage.googleapis.com/v0/b/letschat-8a0be.appspot.com/o/defaultavatar.jpg?alt=media&token=2f896d3a-6b33-4bdc-800c-dcd9e993758f')
            :Image.file(_image)
      ),

    );
    showDialog(context: context,builder: (context){return alert;});
  }

  //DECLARING VARIABLES
  TextEditingController _username=new TextEditingController();
  File _image;
  final key=GlobalKey<ScaffoldState>();
  String imageLink='https://firebasestorage.googleapis.com/v0/b/letschat-8a0be.appspot.com/o/defaultavatar.jpg?alt=media&token=2f896d3a-6b33-4bdc-800c-dcd9e993758f';
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("UPDATE YOUR PROFILE"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.power_settings_new,color: Colors.black,),onPressed: (){AuthenticationService().signOut();},)
      ],
      backgroundColor: Color(0xffFF9800),
      ),
      body: Builder(
        builder: (context)=>
         Container(
          child: ListView(

            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:50.0,left: 80.0,right: 80.0,bottom: 50.0),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){showDp(context);},
                     child: ClipOval(
                       child: SizedBox(
                         height: 160,
                           width: 160,
                           child: _image!=null?Image.file(_image,fit: BoxFit.cover,)
                           :Image.asset('images/defaultavatar.jpg')),
                     ),
                      ),
                      Positioned(
                          right: 0,bottom: 0,
                          child: CircleAvatar(
                            backgroundColor: Color(0xffFFB74D),
                            radius: 25,
                            child: IconButton(
                              onPressed: (){
                                    getImage();
                              },
                              icon: Icon(Icons.camera_alt,size: 30,color: Colors.black,),
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
                    color: Color(0xff29B6F6),
                  child: Text("UPDATE IMAGE",style: TextStyle(letterSpacing: 1,color: Colors.white
                  ,fontWeight: FontWeight.bold,fontSize: 20),),
                  onPressed: (){
                      uploadPhoto(context);
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
                      suffixIcon: Icon(Icons.edit,color:  Color(0xffFFB74D),),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffFFB74D)),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0),bottomRight: Radius.circular(15.0))
                      ),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0),bottomRight: Radius.circular(15.0))
                    )
                  ),
                ),
              ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 45,top:120),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    color: Color(0xffFFB74D),
    child: Text("NEXT",style: TextStyle(letterSpacing: 1,color: Colors.white
        ,fontWeight: FontWeight.bold,fontSize: 20),),
    onPressed: (){
                      if(_username.text!='')
                      {
                        ProfileDatabase(uid: user.uid).addToDatabase(_username.text.toString(), imageLink);
                        DatabaseService(uid:user.uid).updateName(_username.text.toString(),imageLink);
                      }
                      else
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("PLEASE FILL USERNAME"),));


    },),
                  ),
            ],
          ),
        ),
      ),
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
     Scaffold.of(context).showSnackBar(SnackBar(content: Text("UPDATING PLEASE WAIT..."),));

     String filename=basename(_image.path);
    StorageReference storageReference=
        FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask=
    storageReference.putFile(_image);
    StorageTaskSnapshot snapshot=await uploadTask.onComplete;
    String link=await snapshot.ref.getDownloadURL();
    setState(()  {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("UPDATED"),));
    imageLink= link;
    }
    );}
    catch(e){print(e.toString());}
  }
}
