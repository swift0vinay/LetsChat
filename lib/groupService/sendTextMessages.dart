import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letschat/screens/loadingScreen.dart';
import 'package:letschat/services/chatWithFriend.dart';
class ChatBubbleTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.blue;

    var path = Path();
    path.lineTo(-10, 0);
    path.lineTo(0, 10);
    path.lineTo(10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
Widget senderBox(BuildContext context,String userMsg,DateTime date){

  String time = '';
  if (date.minute >= 10)
    time = '${date.hour}:${date.minute}';
  else
    time = '${date.hour}:0${date.minute}';
  return

      Container(
        margin:EdgeInsets.only(top: 10,bottom:10,right:10) ,
        child: Container(
          alignment: Alignment.centerRight,
          child: Bubble(
            nipWidth: 10,
            nipHeight: 10,
            nip:BubbleNip.rightTop,
            color: Theme.of(context).accentColor,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width*0.65,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child:
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("You",style: TextStyle(
                        color: Colors.white,
                    ),),
                    SizedBox(height: 2,),
                    userMsg.length<=10?
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(userMsg,
                          style: TextStyle(
                              fontSize: 20.0,color: Colors.white
                          ),
                        ),
                        SizedBox(width:10),
                        Wrap(
                          spacing: 2,
                          children: <Widget>[
                            Text(time, style: TextStyle(
                                fontWeight: FontWeight
                                    .bold,color: Colors.white),
                            ),
                            ],

                        ),
                      ],
                    )
                        :Wrap(
                      alignment: WrapAlignment.end,
                      children: <Widget>[
                        Text(userMsg,
                          style: TextStyle(
                              fontSize: 20.0,color: Colors.white
                          ),
                        ),
                Text(time, style: TextStyle(
                    fontWeight: FontWeight
                        .bold,color: Colors.white),
                      ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        ),


  );

//    Container(
//    padding: EdgeInsets.only(right:10),
//    margin:EdgeInsets.symmetric(vertical: 15) ,
//    child: Container(
//      alignment: Alignment.centerRight,
//      child: Container(
//        constraints: BoxConstraints(
//          maxWidth: MediaQuery.of(context).size.width*0.65,
//        ),
//        decoration: BoxDecoration(
//          color: Theme.of(context).accentColor,
//          borderRadius: BorderRadius.only(
//            topLeft: Radius.circular(10),
//            bottomRight: Radius.circular(10),
//            bottomLeft: Radius.circular(10),
//          ),
//        ),
//        child: Padding(
//          padding: const EdgeInsets.all(10.0),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.end,
//            children: <Widget>[
//              Text("You",style: TextStyle(
//                  color: Colors.black
//              ),),
//              Padding(
//                padding: const EdgeInsets.only(bottom:5.0),
//                child: Text(userMsg,
//                  style: TextStyle(
//                      fontSize: 20.0
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom:5.0),
//                child: Text(time, style: TextStyle(
//                    fontWeight: FontWeight
//                        .bold),),
//              ),
//            ],
//          ),
//        ),
//      ),
//
//    ),
//  );
}

Widget receiverBox(BuildContext context,String uid,String userMsg,DateTime date,String fid){

  String time = '';
  if (date.minute >= 10)
    time = '${date.hour}:${date.minute}';
  else
    time = '${date.hour}:0${date.minute}';

  return Container(
    padding: EdgeInsets.only(left:10),
    margin:EdgeInsets.symmetric(vertical: 15) ,
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
             color: Theme.of(context).secondaryHeaderColor,
             borderRadius: BorderRadius.only(
               topRight: Radius.circular(10),
               bottomRight: Radius.circular(10),
               bottomLeft: Radius.circular(10),
             ),
           ),
           child: Padding(
             padding: const EdgeInsets.all(5.0),
             child:Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 StreamBuilder(
                     stream: Firestore.instance.collection('myUsers').document(fid).snapshots(),
                     builder: (context, snapshot) {
                       if(snapshot.hasData)
                       {
                         return GestureDetector(
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(
                                 builder: (context){
                                   return ChatWithFriend(myId:uid,fid:fid,imageUrl:snapshot.data['profilepic'],name: snapshot.data['username'],);
                                 }
                             ));
                           },
                           child: Text(snapshot.data['username'],
                             style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                             ),),
                         );
                       }
                       else{
                         return Loading();
                       }
                     }  ),
                 SizedBox(height: 2,),
                 userMsg.length<=10?
                 Wrap(
                   crossAxisAlignment: WrapCrossAlignment.center,
                   children: <Widget>[
                     Text(userMsg,
                       style: TextStyle(
                           fontSize: 20.0,color: Colors.white
                       ),
                     ),
                     SizedBox(width:10),
                     Wrap(
                       spacing: 2,
                       children: <Widget>[
                         Text(time, style: TextStyle(
                             fontWeight: FontWeight
                                 .bold,color: Colors.white),
                         ),
                       ],

                     ),
                   ],
                 )
                     :Wrap(
                   children: <Widget>[
                     Text(userMsg,
                       style: TextStyle(
                           fontSize: 20.0,color: Colors.white
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(bottom:5.0),
                       child: Wrap(
                         spacing: 2,
                         children: <Widget>[
                           Text(time, style: TextStyle(
                               fontWeight: FontWeight
                                   .bold,color: Colors.white),
                           ),
                         ],

                       ),
                     ),
                   ],
                 ),
               ],
             )
           )
         ),
       ),

     ),

  );
}