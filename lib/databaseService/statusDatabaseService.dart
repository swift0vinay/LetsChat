import 'package:cloud_firestore/cloud_firestore.dart';

class StatusDatabaseService{

  CollectionReference statusService=Firestore.instance.collection('userStories');

  Future userStory(String uid,String imageUrl,String timestamp,String published,String end) async {

    try{
     return await statusService.document(timestamp).setData(
       {
         'uid':uid,
         'imageUrl':imageUrl,
         'start':published,
         'end':end
       }
     );
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  Future deleteuserStory(String timestamp) async {

    try{
      return await statusService.document(timestamp).delete();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}