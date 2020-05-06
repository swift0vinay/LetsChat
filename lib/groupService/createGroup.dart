import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:letschat/databaseService/groupDatabaseService.dart';
import 'package:letschat/groupService/addParticipants.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  File _image;
  String imageLink='https://firebasestorage.googleapis.com/v0/b/letschat-8a0be.appspot.com/o/groupavatar.png?alt=media&token=89c3ce63-424b-49a1-81dd-9b9fd3ea1086';
  TextEditingController tc1=new TextEditingController();
  TextEditingController tc2=new TextEditingController();
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
            leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
              Navigator.pop(context);
            },),
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("CREATE GROUP",style: TextStyle(color: Colors.white),),

          ),
           body: Builder(
             builder: (context) {
               return ListView(
                 children: <Widget>[
                   Center(
                     child: Padding(
                       padding: const EdgeInsets.only(top:50.0,left: 80.0,right: 80.0,bottom: 50.0),
                       child: Stack(
                         children: <Widget>[
                           GestureDetector(
                             onTap: (){
                               Navigator.push(context, PageRouteBuilder(
                                 pageBuilder: (_,__,___){
                                  return showDp(context);
                                 }
                               ));
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
                                         :Image.asset('images/groupavatar.png')),
                               ),
                             ),
                           ),
                           Positioned(
                             right: 0,bottom: 0,
                             child: CircleAvatar(
                               backgroundColor: Color(0xffFFB74D),
                               radius: 25,
                               child: IconButton(
                                 onPressed: (){
                                   getImage(context);
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
                     padding: const EdgeInsets.all(10.0),
                     child: TextField(
                       controller: tc1,
                       decoration: InputDecoration(
                         labelText: "Enter Group Name",
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5.0),
                           borderSide: BorderSide(
                             color: Colors.black
                           )
                         )
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: TextField(
                       controller: tc2,
                       decoration: InputDecoration(
                           labelText: "Enter Group Description",
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(5.0),
                               borderSide: BorderSide(
                                   color: Colors.black
                               )
                           )
                       ),
                     ),
                   ),
                 ],
               );
             }
           ),
          floatingActionButton: Builder(

            builder: (context) {
              return FloatingActionButton.extended(
                label: Text("NEXT"),icon: Icon(Icons.arrow_forward),
                  onPressed: (){
                    if(tc1.text=='')
                    {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Name Required"),));
                    }
                    else
                    {
                      showDialog(context: context,builder: (context){
                        return AlertDialog(
                          content: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      });
                      print(imageLink);
                      GroupDatabaseService().createGroup(user.uid,tc1.text.toString(),imageLink,tc2.text.isEmpty?null:tc2.text.toString());
                      print(tc1.text.hashCode);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return AddParticipants(groupName:tc1.text.toString());
                          }
                      ));
                    }

                  }
              );
            }
          ),
        );

  }
  Future getImage(BuildContext context) async{
    var image=await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50);
    print("IMAGE SIZE BEFORE:"+image.lengthSync().toString());
    setState(() {
      _image=image;
      print('Image Path $_image');
    });
    if(_image!=null)
      {
        uploadPhoto(context);
      }
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
