import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:letschat/databaseService/statusDatabaseService.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:provider/provider.dart';
class ShowStory extends StatefulWidget {

  @override
  _ShowStoryState createState() => _ShowStoryState();
}

class _ShowStoryState extends State<ShowStory> {
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
  
            Navigator.of(context).popUntil((route)=>route.isFirst);
//            Navigator.pushAndRemoveUntil(context,
//                MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
//                    (Route<dynamic> route) => route is MainScreen
//
//            );
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("STATUS"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('userStories').snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData ?
          ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,i){
              String present=Timestamp.fromDate(DateTime.now()).millisecondsSinceEpoch.toString();
              print(present);

              if(snapshot.data.documents[i]['end']==present)
                {
                  StatusDatabaseService().deleteuserStory(snapshot.data.documents[i]['start']);
                }
              return snapshot.data.documents[i]['uid']==user.uid?
                ListTile(
                 leading: GestureDetector(
                     onTap: (){
                     },
                     child: ClipOval(
                       child: CircleAvatar(
                           radius: 25,
                           backgroundColor: Colors.black,
                           child: CachedNetworkImage(
                             fit: BoxFit.cover,
                             imageUrl: snapshot.data.documents[i]['imageUrl'],
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
                  title: StreamBuilder(
                    stream: Firestore.instance.collection('myUsers')
                        .document(user.uid).snapshots(),
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
                  subtitle: Text("TIME"),
                )
                  :Center(
                child: Container(
                ),
              );
            },

          ) :
          Center(
            child: SpinKitChasingDots(color: Colors.black, size: 35,),
          );
        }),
    );
  }
}
