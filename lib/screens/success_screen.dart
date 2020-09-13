import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:samannegarusers/dashboard/cars/carsList.dart';


class SuccessPage extends StatefulWidget {

  String centerTitle;
  SuccessPage(this.centerTitle){
    this.centerTitle = centerTitle;
  }

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> with TickerProviderStateMixin {

  AnimationController _controller;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pop(0);
      // Navigator.of(context).pushReplacement(
      //     PageRouteBuilder(
      //         transitionDuration:
      //         Duration(milliseconds: 600),
      //         pageBuilder: (_, __, ___) =>
      //         carsList()));
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: Container(
            height: size.height * .5,
            child: Column(
              children: [
                Lottie.asset('assets/anim/success_animation.json',
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration
                        ..forward();
                    }),
                SizedBox(height: size.height * .1,),
                Text(widget.centerTitle , style: TextStyle(
                  color: Colors.black ,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600
                ),)
              ],
            )
          ),
        ),
      ),
    );
  }
}
