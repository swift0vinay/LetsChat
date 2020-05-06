import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class ShowImage extends StatefulWidget {
  final String hash;
  final String url;
  final String name;
  ShowImage(  {this.hash,this.url,this.name});
  @override
  _ShowImageState createState() => _ShowImageState(
    url:url,
    hash:hash,
    name: name
  );
}

class _ShowImageState extends State<ShowImage> {
  final String url;
  final String hash;
  final String name;
  _ShowImageState( {this.hash,this.url,this.name}     );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){Navigator.pop(context);},),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(name,style: TextStyle(color: Colors.white),),
      ),
      body:  Hero(
      tag: hash,
     child: Container(
       width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PhotoView(
            backgroundDecoration: BoxDecoration(
              color: Colors.white
            ),
            imageProvider: NetworkImage(url),
                        ),
        ),
      ),
    );
  }
}
