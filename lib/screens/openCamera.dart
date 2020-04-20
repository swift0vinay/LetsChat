import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
class OpenCamera extends StatefulWidget {
  @override
  _OpenCameraState createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> {
  File _image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCameraOpen();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
    child: _image!=null?ListView(children: <Widget>[Image.file(_image)
    ,
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(color:Colors.amber,icon: Icon(Icons.save),label: Text("SAVE"),onPressed: (){},),
            FlatButton.icon(color:Colors.amber,icon: Icon(Icons.refresh),label: Text("RETRY"),onPressed: (){getCameraOpen();},),
          ],
        ),
      )
    ]):SpinKitFadingCircle(duration: Duration(milliseconds: 500),color: Colors.amber,)
      ,
    );
  }

  Future getCameraOpen() async{
    var image=await ImagePicker.pickImage(source: ImageSource.camera,);
    setState(() {
      _image=image;
    });
  }
}
