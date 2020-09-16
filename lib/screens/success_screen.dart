import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/dashboard/cars/carsList.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/insurance_list.dart';
import 'package:samannegarusers/funcs.dart';


class SuccessPage extends StatefulWidget {

  String centerTitle;
   String name;
   String lastName;
   int page_manager;

  SuccessPage(this.centerTitle, this.name, this.lastName , this.page_manager){
    this.centerTitle = centerTitle;
    this.name = name;
    this.lastName = lastName;
    this.page_manager = page_manager;

  }

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> with TickerProviderStateMixin {

  AnimationController _controller;

  String _customer_id;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    getPref('customer_id').then((value){
      setState(() {
        _customer_id = value;
      });
    });

    Timer(Duration(seconds: 4), () {

      nav_manager(widget.page_manager);
      // Navigator.of(context).pushReplacement(
      //     PageRouteBuilder(
      //         transitionDuration:
      //         Duration(milliseconds: 600),
      //         pageBuilder: (_, __, ___) =>
      //         carsList()));
    });
  }

  nav_manager(page_handl)
  {
    switch(page_handl){
      case 1:{
        Navigator.of(context).pushReplacement(PageTransition(
            child: carsList(
              title: 'تتیر',
              name: widget.name.toString(),
              lastName: widget.lastName.toString(),
              customerID: _customer_id,
            ), type: null));
        break;
      }
      case 2:{
        Navigator.of(context).pushReplacement(PageTransition(
            child: InsuranceList(
              title: 'تتیر',
              name: widget.name.toString(),
              lastName: widget.lastName.toString(),
              customerID: _customer_id,
            ), type: null));
        break;
      }
    }
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
