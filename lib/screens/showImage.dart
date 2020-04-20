import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class ShowImage extends StatefulWidget {
  final String url;
  ShowImage(  {this.url});
  @override
  _ShowImageState createState() => _ShowImageState(
    url:url,
  );
}

class _ShowImageState extends State<ShowImage> {
  final String url;
  var regexExp=new RegExp('%2FI(.*?)\?alt');
  String filename='';
  _ShowImageState( {this.url}     );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(url);
    String ss;
    Iterable matches = regexExp.allMatches(url);
    matches.forEach((match) {
      ss=url.substring(match.start, match.end);
      print(url.substring(match.start, match.end));
    });
    String z=ss.substring(3,ss.length-4);
    print(z);
    setState(() {
      filename=z;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(filename,style: TextStyle(color: Colors.white),),
      ),
      body: Container(
       width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PhotoView(
          loadingBuilder: (context,event){
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueGrey,
                  strokeWidth: 3,
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            );
          },
          imageProvider: NetworkImage(url),
                      ),
      ),
    );
  }
}
