import 'package:flutter/material.dart';
import 'package:letschat/databaseService/databaseService.dart';
import 'package:letschat/friendService/addFriendServiced.dart';
import 'package:letschat/groupService/createGroup.dart';
import 'package:letschat/screens/myProfile.dart';
import 'package:letschat/screens/navScreen.dart';
import 'package:letschat/screens/openCamera.dart';
import 'package:letschat/services/authService.dart';
import 'package:letschat/services/usermodel.dart';
import 'package:letschat/storymode/storyscreen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver,SingleTickerProviderStateMixin {
  TabController _tc;
  int ts=1;
  AuthenticationService _auth=new AuthenticationService();
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tc=TabController(vsync: this,length: 3,initialIndex: 1);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _tc.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    switch(state)
    {
      case AppLifecycleState.paused:
       { print('paused');
      setState(() {
        ts=0;
      });
      break;
        }
      case AppLifecycleState.resumed:
        { print('resumed');
        setState(() {
          ts=1;
        });
        break;
        }
      case AppLifecycleState.inactive:
        { print('inactive');
        setState(() {
          ts=2;
        });
        break;
        }
      case AppLifecycleState.detached:
        { print('detached');
        setState(() {
          ts=3;
        });
        break;
        }
    }
  }
  Widget dropdownWidget(BuildContext context) {
    return  PopupMenuButton<int>(
      onSelected: (x){
        switch(x){
          case 0:{
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return FriendService();
                }
            ));
          }
          break;
          case 1:{
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return CreateGroup();
                }
            ));
          }
            break;
          case 2:{
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return MyProfile();
                }
            ));
          }
          break;
          case 3:{
            var rs=_auth.signOut();
             }
        break;

        }
      },
      offset: Offset(0,100),
      itemBuilder:(context)=>[
        PopupMenuItem(
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Add Friends"),
              Icon(Icons.person_add,color: Colors.black),
            ],
          )
        ),
        PopupMenuItem(
          value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Create Group"),
                Icon(Icons.people,color: Colors.black),
              ],
            )
        ),
        PopupMenuItem(
          value: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Check Profile"),
                Icon(Icons.account_circle,color: Colors.black),
              ],
            )
        ),
        PopupMenuItem(
          value: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Log Out"),
                Icon(Icons.power_settings_new,color: Colors.black),
              ],
            )

        )
      ] ,
      icon: Icon(Icons.more_vert,color: Colors.white,),
    );
  }
  @override
  Widget build(BuildContext context) {
    print(ts);
    final user=Provider.of<User>(context);
    DatabaseService(uid:user.uid).userUpdateStatus(ts);
    return Scaffold(
       appBar:

       AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          dropdownWidget(context),
        ],
        title: Text("LETS CHAT"),
        bottom: TabBar(
          controller: _tc,
          isScrollable: true,
           tabs: <Widget>[
            Container(width:30,child: Tab(icon:Icon(Icons.camera_alt))),
            Container(width:100,child: Tab(text: "CHATS",)),
            Container(width:100,child: Tab(text: "STORY",)),
          ],

            indicatorColor: Colors.white,
          indicatorWeight: 2.0,
        ),

      ),
        body: TabBarView(
          controller: _tc,
          children: <Widget>[
            OpenCamera(),
            NavScreen(ts:ts),
            StoryScreen(),
          ],
        ),
    );
  }

}
