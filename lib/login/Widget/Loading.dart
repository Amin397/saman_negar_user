import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: SizedBox.expand(
        child: Container(

          child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),child: SpinKitFadingCube(color: Colors.amber,size: 100.0,),),
          color: Color.fromRGBO(0, 0, 0, 0.3),
        ),
      ),
    );
  }
}
