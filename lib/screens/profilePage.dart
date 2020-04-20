import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   String mylink;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  getdata();
  }
  Future getdata() async{

    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
        setState(() {
         String _link= sharedPreferences.getString('mylink');
         print('PROFILE PAGE LINK $_link');
        mylink=_link;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PROFILE"),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: ClipOval(
            child: mylink!=null?Image.network(mylink,
            fit: BoxFit.fill,):Image.network('https://firebasestorage.googleapis.com/v0/b/letschat-8a0be.appspot.com/o/defaultavatar.jpg?alt=media&token=2f896d3a-6b33-4bdc-800c-dcd9e993758f'),

          ),
        ),
      ),
    );
  }
}
