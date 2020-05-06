import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:letschat/screens/loadingScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class FileLoaders extends StatefulWidget {
  final String name;
  FileLoaders({this.name});
  @override
  _FileLoadersState createState() => _FileLoadersState(
    name: name
  );
}

class _FileLoadersState extends State<FileLoaders> with SingleTickerProviderStateMixin{
  TabController _tc;
  int _val=0;
  var _imageList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
    _tc=TabController(vsync: this,length: 3,initialIndex: 1);

  }
  @override
  void dispose() {

    _tc.dispose();
    super.dispose();
  }
  final String name;
  _FileLoadersState({this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name),
        bottom: TabBar(
          controller: _tc,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 30),
          tabs: <Widget>[
            Tab(text: ("IMAGES"),),
            Tab(text: "VIDEOS",),
            Tab(text:"DOCUMENTS")
          ],

          indicatorColor: Colors.white,
          indicatorWeight: 2.0,
        ),

      ),
        body: TabBarView(
          controller: _tc,
          children: <Widget>[
          _imageList!=null? GridView.builder(
              itemCount: _imageList.length,
             shrinkWrap: true,
             padding: EdgeInsets.symmetric(vertical: 10.0),
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 4.0 / 4.0),
               itemBuilder: (context,i){
                 return GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(
                         builder: (context){
                           return DpPage(name:_imageList[i],hash:_imageList[i].hashCode.toString(),);
                         }
                     ));
                   },
                   child: Hero(
                     tag: _imageList[i].hashCode.toString(),
                     child: Image.file(
                       File(_imageList[i]),
                     fit: BoxFit.cover,),
                   ),
                 );
               }
           ):
            Temp(size: 20,),
            Temp(size: 20,),
            Temp(size: 20,),
          ],
        ),
    );
  }

  void getImages() async{
    var dir=await getExternalStorageDirectory();
    String path=dir.path;
    print(path);
    var imageList=dir.listSync()
    .map((item)=>item.path).where(
        ((item)=>
        item.endsWith(".jpg"))).toList(
      growable: false);

    setState(() {
      _imageList=imageList;
    });
  }
}

class DpPage extends StatelessWidget {
  final String name;
  final String hash;

  DpPage({this.name,this.hash});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),color: Colors.white,onPressed: (){Navigator.pop(context);},),
        title: Text(name,style: TextStyle(color: Colors.white),),),
      body: Center(
        child: Hero(
          tag: hash,
          child: Image.file(File(name))
        ),
      ),
    );
  }
}
