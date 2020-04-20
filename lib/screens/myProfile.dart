import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:provider/provider.dart';
class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  void showDp(BuildContext context,String link){
    var alert=AlertDialog(
      content: FittedBox(
          child: Image.network(link),
      ),

    );
    showDialog(context: context,builder: (context){return alert;});
  }
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
       leading: IconButton(icon:Icon(Icons.arrow_back),color: Colors.white,iconSize: 30,onPressed: (){
         Navigator.pop(context);
       },),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Profiles').document(user.uid).snapshots(),
        builder: (context, snapshot) {
          return Builder(
            builder: (context)=>
            Container(
              child: ListView(

                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:80.0,left: 80.0,right: 80.0,bottom: 50.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            
                            onTap: (){showDp(context,snapshot.data['imageUrl'].toString());},
                            child: ClipOval(
                              
                              child: CircleAvatar(
                               backgroundColor: Colors.black,
                                radius: 80,
                                child: SizedBox(
                                
                                    height: 160,
                                    width: 160,
                                child: Image.network(snapshot.data['imageUrl']),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,bottom: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 25,
                              child: IconButton(
                                onPressed: (){
                                },
                                icon: Icon(Icons.camera_alt,size: 30,color: Colors.black,),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 45.0),
                      child: Text(
                        snapshot.data['userName'],
                        style: TextStyle(fontSize:30,fontWeight: FontWeight.bold),
                      )
                    ),
                  ),
                ],
              ),
            ),
    );
        }
      ),
    );
  }



}
