import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letschat/groupService/groupChatScreen.dart';
import 'package:letschat/screens/loadingScreen.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:provider/provider.dart';
class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('myGroups').snapshots(),
          builder: (context,ss){
            if(ss.hasData){
              return ListView.builder(
                  itemCount: ss.data.documents.length,
                  itemBuilder: (context,i)
                  {
                    if(ss.data.documents[i]['p1']==user.uid||ss.data.documents[i]['p2']==user.uid
                        ||ss.data.documents[i]['p3']==user.uid||ss.data.documents[i]['p4']==user.uid||
                        ss.data.documents[i]['p5']==user.uid)
                    {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          subtitle:
                             StreamBuilder(
                                 stream: Firestore.instance.collection('myChats').document(ss.data.documents[i]['groupName'].hashCode.toString()).collection('Messages').snapshots(),
                                 builder: (context, snapshot) {

                                   if(snapshot.hasData) {
                                     String text=snapshot.data.documents.length>0?
                                     (snapshot.data.documents[snapshot.data.documents.length-1]['type']==0?
                                     snapshot.data.documents[snapshot.data.documents.length-1]['userMessage']
                                         :snapshot.data.documents[snapshot.data.documents.length-1]['filename']):null;
                                     Timestamp ts=snapshot.data.documents.length>0?snapshot.data.documents[snapshot.data.documents.length-1]['date']:null;

                                     DateTime dt;
                                     if(ts!=null)
                                       dt =ts.toDate();
                                     else
                                       dt=null;
                                     String time='';
                                     if(dt!=null) {
                                       if (dt.minute >= 10)
                                         time = '${dt.hour}:${dt.minute}';
                                       else
                                         time = '${dt.hour}:0${dt.minute}';
                                     }

                                     return Column(
                                       children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(text==null?'':(text.length<17?text:('${text.substring(0,19)}...'))),
                                            Text(time)
                                          ],
                                        ),
                                         Divider(height: 30,color: Colors.black,thickness: 1,)
                                       ],
                                     );
                                   }
                                   else
                                   {
                                     return Container();
                                   }
                                 }
                             ),
                          leading: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context){
                                    return GroupDp(name:ss.data.documents[i]['groupName'],hash:ss.data.documents[i]['groupName'].hashCode.toString(),url:ss.data.documents[i]['groupPic']);
                                  }
                              ));
                            },
                            child: Hero(
                              tag:ss.data.documents[i]['groupName'].hashCode.toString(),
                              child: ClipOval(
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: ss.data.documents[i]['groupPic'],
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
                                ),
                              ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(top:10.0,bottom:8.0),
                            child: Text(ss.data.documents[i]['groupName'],style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context){
                              return GroupChatScreen(groupName: ss.data.documents[i]['groupName'],uid:user.uid,lp: false,);
                            }
                          ));
                          },
                        ),
                      ) ;
                    }
                    else
                    {
                      return Container();
                    }
                  }
              );
            }
            else
            {
              return Temp(size:40);
            }
          },
        ),
      ),
    );
  }
}


class GroupDp extends StatelessWidget {
  final String name;
  final String hash;
  final String url;
  GroupDp({this.name,this.hash,this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),color: Colors.white,onPressed: (){Navigator.pop(context);},),
        title: Text(name,style: TextStyle(color: Colors.white),),),
      body: Center(
        child: Hero(
          tag: hash,
          child: CachedNetworkImage(
            fit: BoxFit.fitWidth,
            imageUrl: url,
            placeholder: (context,url){
              return CircularProgressIndicator();
            },
            errorWidget: (context,url,err){
              return Icon(Icons.error);
            },
          ),
        ),
      ),
    );
  }
}