import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
class UserModel{
  final String email;
  UserModel({this.email});
}
class DatabaseService{
final String uid;
DatabaseService({this.uid});
final CollectionReference _collectionReference
=Firestore.instance.collection('myUsers');

Future userUpdateStatus(int t) async {
  return await _collectionReference.document(uid).updateData({
    'online':t==1?1:t==2?2:0,
  });
}
Future addMyUser(String uid,String email,int online,String last_active) async {
 try {
   return await _collectionReference.document(uid).setData({
     'uid': uid,
     'email': email,
     'username':null,
     'profilepic':null,
     'online':0,
     'last_active':last_active,
   });
 }
 catch(e){
   print(e.toString());
 }
}

Future updateName(String name,String url) async {
  try {
    return await _collectionReference.document(uid).updateData({
      'username':name,
      'profilepic':url
      });
  }
  catch(e){
    print(e.toString());
  }
}

}