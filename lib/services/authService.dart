
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letschat/services/usermodel.dart';

class AuthenticationService{

 final  FirebaseAuth _auth=FirebaseAuth.instance;

  Stream<User> get user{
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  User _userFromFirebase(FirebaseUser user){
    return user!=null?User(uid: user.uid):null;
  }
  Future signOut() async{
  try{
   return await _auth.signOut();
  }catch(e){
    print(e.toString());
  }
  }
  Future registerEmailAndPassword(String email,String password) async {
    try{
      AuthResult result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
    }
    catch(e){
      print(e.toString());
    }
  }
  Future signInEmailAndPassword(String email,String password) async{
    try{
      AuthResult result=await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
    }catch(e){
      print(e.toString());
    }
  }
}