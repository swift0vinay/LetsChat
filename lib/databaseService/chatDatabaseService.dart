import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDatabaseService{
  final String uniqueId;
  ChatDatabaseService({this.uniqueId});

  final CollectionReference _chatDatabase=Firestore.instance
                                                      .collection('myChats');

  Future addInitialState(String uid,String fid) async {
    try{
      return await _chatDatabase.document(uniqueId).setData(
          {
            uid:false,
            fid:false,
          }
      );
    }
    catch(e){}
}
  Future addTypingUser(String uid,bool state) async {
    try{
      return await _chatDatabase.document(uniqueId).updateData(
          {
            uid:state,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future sendCard(String myId, String fid, String ms, Timestamp date, int type,bool state,String content,int imageIndex)
  async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).setData(
          {
            'fromId':myId,
            'toId':fid,
            'date':date,
            'content':content,
            'type':type,
            'seen':state,
            'notify':false,
            'imageIndex':imageIndex,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future userSendChat(String uid,String fid,String msg,String ms,Timestamp date,int type,bool state) async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).setData(
          {
            'fromId':uid,
            'toId':fid,
            'date':date,
            'userSentmsg':msg,
            'type':type,
            'seen':state,
            'notify':false,
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
    }

  Future updateSeen(String ms,bool state) async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'seen':state
          }
      );
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future userSendImage(String uid,String fid,String msg,String ms,Timestamp date,int type,String filename) async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).setData(
          {
            'fromId':uid,
            'toId':fid,
            'date':date,
            'userSentmsg':msg,
            'type':type,
            'filename':filename,
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
            'stop':false,
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
            'stop':FieldValue.delete(),
            'seen':false,
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

  Future uploadRestart(String ms) async {
    try{
      return  await _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'downloaded':'NO',
            'start':false,
            'isdownloading':false,
            'isdownloaded':false
          }
      );
    }
    catch(e){
      print(e.toString());
    }
  }
  Future stopUpload(String ms,bool state) async{
  try  {
  return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
  {
  'stop':state,
  }
  );
  }
  catch(e){
  print(e.toString());
  }}
  Future updateNotify(String ms) async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'notify':null,
          }
      );
    }
    catch(e){
      print(e.toString());
    }
  }

  Future allUploadUpdate(String ms) async {
    try{
      return await _chatDatabase.document(uniqueId).collection('Messages').document(ms).updateData(
          {
            'userSentmsg':'PAUSED',
            'uploadstarted':true,
            'uploadcompleted':false,
            'stop':true,
          }
      );
    }
    catch(e){
      print(e.toString());
    }
  }


}