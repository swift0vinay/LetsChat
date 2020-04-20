import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letschat/services/authService.dart';
import 'loadingScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggleValue;
  SignIn({this.toggleValue});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var val=0.00;
  bool show=true;
  Icon showIcon=new Icon(Icons.visibility);
  Icon dontShow=new Icon(Icons.visibility_off);

  final AuthenticationService _auth=AuthenticationService();
  bool loading=false;
  String email="";
  String password="";
  final fk=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return loading?Loading():SafeArea(
      child: Scaffold(
          backgroundColor:Color(0xffFFB74D),
          body: Form(
            key: fk,
            child: ListView(
              children: <Widget>[
                ClipPath(
                  clipper: ClipperPath(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    color:Color(0xffFF9800)
                    ,child: Center(child: Text("Login",style: TextStyle(fontSize: 50,color: Colors.white
                      ,fontWeight: FontWeight.bold),)),
                  ),
                ),

                SizedBox(height: 30.0,),
                               TextFormField(
                  onChanged: (val){
                    setState(() {
                      email=val;
                    });
                  },
                  validator: (val){
                    if(val.isEmpty)
                      return "EMPTY EMAIL FIELD";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person,color: Colors.black,size: 25,),

                      labelText: "EMAIL",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.black),
                      )

                  ),
                ),SizedBox(height: 30.0,),
                TextFormField(
                  onChanged: (val){
                    setState(() {
                      password=val;
                    });
                  },
                  validator: (val){
                    if(val.isEmpty)
                      return "EMPTY PASSWORD FIELD";
                    else
                      return null;
                  },obscureText: show,
                  decoration: InputDecoration(

                      suffixIcon: IconButton(icon:showIcon,onPressed: (){
                        setState(() {
                          show=!show;
                          if(show==false)
                            showIcon=dontShow;
                          else
                            showIcon=Icon(Icons.visibility);

                        });
                      },),
                      prefixIcon: Icon(Icons.lock,color: Colors.black,size: 25,),
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.black),
                      )
                  ),
                ),SizedBox(height: 30.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:100.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Log In",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    color: Color(0xff29B6F6),
                    onPressed: () async{

                       if (fk.currentState.validate()) {
                         setState(() {
                           loading = true;
                         });
                         dynamic rs = await _auth.signInEmailAndPassword(email,
                             password);
                         if (rs == null) {
                           setState(() {
                             print("error signing in");
                             loading = false;
                           });
                         }
                       }

                    },
                  ),
                ),
                SizedBox(height: 50,),
                FlatButton(
                  child: Text("DON'T HAVE AN ACCOUNT?",style: TextStyle(color: Color(0xff29B6F6)),),
                  onPressed: (){
                    widget.toggleValue();
                  },
                ),

              ],
            ),
          )
      ),
    );
  }

}

class ClipperPath extends CustomClipper<Path>{
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height,
        size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
