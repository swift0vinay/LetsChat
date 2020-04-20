import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDatabaseService{
  final String uniqueId;
  ChatDatabaseService({this.uniqueId});

  final CollectionReference _chatDatabase=Firestore.instance
                                                      .collection('myChats');


  Future userSendChat(String uid,String fid,String msg,String ms,Timestamp date,int type) async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).setData(
          {
            'fromId':uid,
            'toId':fid,
            'date':date,
            'userSentmsg':msg,
            'type':type,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
    }
  Future userSendFile(String uid,String fid,String msg,String ms,Timestamp date,int type,String filename,String state) async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).setData(
          {
            'fromId':uid,
            'toId':fid,
            'date':date,
            'userSentmsg':msg,
            'type':type,
            'uploadstarted':false,
            'uploadcompleted':false,
            'filename':filename,
            'downloaded':state,
            'start':false,
            'isdownloading':false,
            'isdownloaded':false

          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  Future userUpdateChat(String msg,String ms) async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'userSentmsg':msg,
            'uploadstarted':FieldValue.delete(),
            'uploadcompleted':FieldValue.delete(),
           }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  Future anotherUserUpdateChat(String state,String ms) async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'downloaded':state,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future updateUploadStart(String ms)  {
    try{
      return  _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'uploadstarted':true,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future updateUploadEnd(String ms)  {
    try{
      return  _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'uploadcompleted':true,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future updateStart(String ms)  {
    try{
      return  _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'start':true,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future updateIsDownloading(String ms)  {
    try{
      return  _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'isdownloading':true,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  Future updateIsDownloaded(String ms) {
    try{
      return  _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'isdownloaded':true,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

   deleteField(String ms) {
    try{
      return  _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'start':FieldValue.delete(),
            'isdownloading':FieldValue.delete(),
            'isdownloaded':FieldValue.delete(),
          }
      );
    }
    catch(e){
      print(e.toString());
    }
  }

}