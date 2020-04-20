import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDatabase{
  final String uid;
  ProfileDatabase({this.uid});

  final CollectionReference _profiles=Firestore.instance
  .collection('Profiles');

  Future addToDatabase(String userName,String imageUrl) async {
    return await _profiles.document(uid).setData(
      {
      'userName':userName ,
      'imageUrl':imageUrl,
      }
    );
  }
}