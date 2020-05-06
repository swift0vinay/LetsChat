import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:letschat/screens/chatscreen.dart';
import 'package:letschat/groupService/groupScreen.dart';
class NavScreen extends StatefulWidget {
  final int ts;
  NavScreen({this.ts});
  @override
  _NavScreenState createState() => _NavScreenState(
    ts: ts
  );
}

class _NavScreenState extends State<NavScreen> {
  final int ts;
  _NavScreenState({this.ts});
  int _page=0;
  Widget PageChoser(int page)
  {
    switch (page)
    {
      case 0:
        return ChatScreen(ts:ts);
        break;
        case 1:
          return GroupScreen();
          break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height:50,
        backgroundColor: Theme.of(context).primaryColor,
        items: <Widget>[
          Icon(Icons.chat, size: 30),
          Icon(Icons.people, size: 30),
        ],
        animationCurve: Curves.easeInOut,
        onTap: (index){
        setState(() {
          _page=index;
        });
        },
      ),
      body: PageChoser(_page),
    );
  }
}
