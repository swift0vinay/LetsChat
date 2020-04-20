import 'package:cloud_firestore/cloud_firestore.dart';

class AddFriendDatabaseService{
  final String uid;
  AddFriendDatabaseService({this.uid});
  CollectionReference _collectionReference=Firestore.instance.collection('Friends');

  Future addStatus(String uid,String status) async {
    return await _collectionReference.document(uid).setData({
      'id':uid,
      'status':status
    });
  }
  Future updateStatus(String status) async {
    return await _collectionReference.document(uid).updateData({
      'status':status
    });
  }
  Future addFriend(String uid,String fid)
  async {
    return await _collectionReference.document(uid).collection('myFriends').document(fid).setData({
      'id':fid,
      'added':true,
    });
  }

}