import 'package:flutter/material.dart';
import 'package:letschat/databaseService/databaseService.dart';
import 'package:letschat/databaseService/profileDatabaseService.dart';
import 'package:letschat/services/authService.dart';

import 'loadingScreen.dart';

class Register extends StatefulWidget {
  final Function toggleValue;
  Register({this.toggleValue});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool show=true;
  Icon showIcon=new Icon(Icons.visibility);
  Icon dontShow=new Icon(Icons.visibility_off);
  final AuthenticationService _auth=AuthenticationService();

  final fk=GlobalKey<FormState>();
  bool loading=false;
  String email="";
  String password="";
  @override
  Widget build(BuildContext context) {

    return  loading?Loading():SafeArea(
      child: Scaffold(
          backgroundColor:Theme.of(context).accentColor,
          body: Form(
            key: fk,
            child: ListView(
              children: <Widget>[
                ClipPath(
                  clipper: ClipperPath(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    color:Theme.of(context).primaryColor
                    ,child: Center(child: Text("REGISTER",style: TextStyle(fontSize: 50,color: Colors.white
                      ,fontWeight: FontWeight.bold),)),
                  ),
                ),

                SizedBox(height: 30.0,),
                TextFormField(
                  onChanged: (val){
                    setState(() {
                      email=val;
                    });
                  },
                  validator: (val){
                    if(val.isEmpty)
                      return "EMPTY EMAIL FIELD";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person,color: Colors.black,size: 25,),

                      labelText: "EMAIL",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.black),
                      )

                  ),
                ),SizedBox(height: 30.0,),
                TextFormField(
                  onChanged: (val){
                    setState(() {
                      password=val;
                    });
                  },
                  validator: (val){
                    if(val.isEmpty)
                      return "EMPTY PASSWORD FIELD";
                    else
                      return null;
                  },obscureText: show,
                  decoration: InputDecoration(

                      suffixIcon: IconButton(icon:showIcon,onPressed: (){
                        setState(() {
                          show=!show;
                          if(show==false)
                            showIcon=dontShow;
                          else
                            showIcon=Icon(Icons.visibility);

                        });
                      },),
                      prefixIcon: Icon(Icons.lock,color: Colors.black,size: 25,),
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.black),
                      )
                  ),
                ),SizedBox(height: 30.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:100.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Register",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    color: Color(0xff29B6F6),
                    onPressed: () async{

                      if(fk.currentState.validate()){
                        setState(() {
                          loading=true;
                        });

                        dynamic rs=await _auth.registerEmailAndPassword(email, password);
                        print(rs.uid);
                        if(rs==null)
                        {
                          setState(() {
                            print("error registering in");
                            loading=false;
                          });
                        }
                        else
                        {
//                          await  Firestore.instance.collection('myUsers').document(rs.uid)
//                              .setData({
//                            'user':rs.uid,
//                            'email':email,
//                          });
                          DatabaseService(uid:rs.uid).addMyUser(rs.uid, email,null,null);
                          print('user added');
                          ProfileDatabase(uid: rs.uid).addToDatabase('abc', 'https://firebasestorage.googleapis.com/v0/b/chatdemo-c7b90.appspot.com/o/defaultavatar.jpg?alt=media&token=1c7abe2f-739f-48ed-bf73-b91850a0b9bf');

                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 50,),
                FlatButton(
                  child: Text("ALREADY AN USER?",style: TextStyle(color: Color(0xff29B6F6)),),
                  onPressed: (){
                    widget.toggleValue();
                  },
                )
              ],
            ),
          )
      ),
    );
  }
}

class ClipperPath extends CustomClipper<Path>{
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height,
        size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

