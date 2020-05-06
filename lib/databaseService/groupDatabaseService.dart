import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDatabaseService{

  CollectionReference _collectionReference=Firestore.instance.collection('myGroups');

  Future createGroup(String uid,String groupName,String groupPic,String desc) async {
    try {
      return await _collectionReference.document(groupName).setData({
      'groupName':groupName,
      'groupPic':groupPic,
      'groupDesc':desc,
        'p1':uid,
      });
    }
    catch(e){
      print(e.toString());
    }
  }


  Future addFriend(String id,String groupName,String uid)
  async {
    return await _collectionReference.document(groupName).collection('Friends').document(uid)
        .setData({
      'uid':uid,
      'id':id,
      'added':true,
    }
    );
  }

  Future sendUserMsg(String groupNamehashCode,String msg,Timestamp timestamp,String fromId,String ms,int type)
  async {
   return await Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
   .document(ms).setData({
     'userMessage':msg,
     'from':fromId,
     'date':timestamp,
     'type':type
   });
  }
  Future addFriendDoc(String id,String groupName,String uid)
  async {
    return await _collectionReference.document(groupName).updateData({
      id:uid,
     }
    );
  }

  Future deleteDocFromData(String pid,String uid,String groupName)
  async {
   return await  _collectionReference.document(groupName).updateData({
      pid:FieldValue.delete(),
    });
  }

  Future userSendFile(String groupNamehashCode,String senderId,String url,String ms,Timestamp date,int type,String filename)
  async {
    return await Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
        .document(ms).setData({
      'from':senderId,
      'date':date,
      'type':type,
      'userMessage':url,
      'uploadstarted':false,
      'uploadcompleted':false,
      'filename':filename,
      'downloaded':'No',
      'start':false,
      'isdownloading':false,
      'isdownloaded':false

    });

  }
  Future anotherUserUpdateChat(String groupNamehashCode,String state,String ms) async {
    try{
      return await  Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
          .document(ms).updateData(
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
  Future userUpdateChat(String groupNamehashCode,String msg,String ms) async {
    try{
      return await  Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
          .document(ms).updateData(
          {
            'userMessage':msg,
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
  Future updateUploadStart(String groupNamehashCode,String ms)  {
    try{
      return  Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
          .document(ms).updateData(
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

  Future updateUploadEnd(String groupNamehashCode,String ms)  {
    try{
      return  Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
          .document(ms).updateData(
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

  Future updateStart(String groupNamehashCode,String ms)  {
    try{
      return  Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
          .document(ms).updateData(
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

  Future updateIsDownloading(String groupNamehashCode,String ms)  {
    try{
      return  Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
          .document(ms).updateData(
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
  Future updateIsDownloaded(String groupNamehashCode,String ms) {
    try{
      return  Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
          .document(ms).updateData(
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

  deleteField(String groupNamehashCode,String ms) {
    try{
      return  Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
          .document(ms).updateData(
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

  Future userSendImage(String groupNamehashCode,String senderId,String url,String ms,Timestamp date,int type,String filename)
  async {
    return await Firestore.instance.collection('myChats').document(groupNamehashCode).collection('Messages')
        .document(ms).setData({
      'from':senderId,
      'date':date,
      'type':type,
      'userMessage':url,
      'filename':filename,
    });

  }
}