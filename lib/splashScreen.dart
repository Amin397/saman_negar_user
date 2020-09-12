import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/dashboard/home.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/welcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> fetchStr() async {
    var data;
//    SharedPreferences.setMockInitialValues({});

    if (await getPref('username') != null &&
        await getPref('password') != null) {
      data = await loginCustomer(
          await getPref('username'), await getPref('password'));
    } else {
      await new Future.delayed(const Duration(seconds: 3), () {
        data = new Map();
        data['result'] = 'login';
      });
    }
    return data;
  }

  GlobalKey scaffoldKey = new GlobalKey();

  @override
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'سامان',
          style: TextStyle(
            fontFamily: 'IRANSans',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xfffbb448),
          ),
          children: [
            TextSpan(
              text: ' نگار',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: ' ایرانیان',
              style: TextStyle(color: Color(0xfff7892b), fontSize: 30),
            ),
          ]),
    );
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      body: FutureBuilder<dynamic>(
        future: fetchStr(),
        builder: (context, snapshot) {
          print("splashscreen" + "data.toString()");
          if (snapshot.hasData) {
            var data = (snapshot.data);
            print("splashscreen" + data.toString());
            if (data['result'] == 'login' || data['result'] == 'failed') {
              return WelcomePage();
            } else if (data['result'] == 'success') {
              return Home();
            }
          } else if (snapshot.hasError) {
            print("${snapshot.error}");
          }
          // By default, show a loading spinner
          return Center(
            child: SizedBox.expand(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                        child: SpinKitFadingCube(
                          color: Colors.amber,
                          size: 100.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 80.0),
                      child: _title(),
                    ),
                  ],
                ),
                color: Color.fromRGBO(255, 240, 179, 0.8),
              ),
            ),
          );

        },
      ),
    );
  }
}
