import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 200,
      height: 200,
      child:Center(
        child: SpinKitCircle(
          color: Colors.black,
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }
}
