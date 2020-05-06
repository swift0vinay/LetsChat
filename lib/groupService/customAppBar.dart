import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
Widget myAppBar(BuildContext context,String groupName,bool lp){
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.width*0.25),
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
              label: CircleAvatar(backgroundColor:Colors.white,backgroundImage: AssetImage('images/groupavatar.png'),)
              ,onPressed: lp?(){
              Navigator.of(context).popUntil((route)=>route.isFirst);
            }:(){
              Navigator.pop(context);
            },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: Container(
                width: MediaQuery.of(context).size.width*0.20,
                child: GestureDetector(
                    onTap:(){}
                    ,child: groupName.length<=7?Text(groupName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)
                    :Text('${groupName.substring(0,5)}...',style: TextStyle(color: Colors.white),)
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: Wrap(

              spacing: 10,
              children: <Widget>[
                IconButton(icon: Icon(Icons.call,color: Colors.white,),onPressed: (){},),
                IconButton(icon: Icon(Icons.videocam,color: Colors.white,),onPressed: (){},),
                IconButton(icon: Icon(Icons.more_vert,color: Colors.white,),onPressed: (){       },),

              ],
            ),
          ),
        ],
      ),
    ),
  );

}


