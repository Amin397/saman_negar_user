import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/dashboard/home.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/loginPage.dart';
import 'package:samannegarusers/login/signup.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        getPref('username').then((value) =>  print("_WelcomePageState: "+value));
        if (await getPref('username') != null &&
            await getPref('password') != null) {
          showLoadingDialog();
          print("WelcomePage" + "data.toString()");
          var result = await loginCustomer(
              await getPref('username'), await getPref('password'));
          if (result['result'] == 'success') {
            hideLoadingDialog();
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Home(), type: PageTransitionType.downToUp));
          } else {
            hideLoadingDialog();
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: LoginPage(), type: PageTransitionType.fade));
          }
        } else {
          hideLoadingDialog();
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: LoginPage(), type: PageTransitionType.fade));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'ورود',
          style: TextStyle(
              fontSize: 20, color: Color(0xfff7892b), fontFamily: 'IRANSans'),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'همین حالا ثبت نام کتید!',
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'IRANSans'),
        ),
      ),
    );
  }

  Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              'ورود سریع با اثر انگشت',
              style: TextStyle(
                  color: Colors.white, fontSize: 17, fontFamily: 'IRANSans'),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(Icons.fingerprint, size: 90, color: Colors.white),
            SizedBox(
              height: 20,
            ),
            Text(
              'ورود با اثر انگشت',
              style: TextStyle(
                fontFamily: 'IRANSans',
                color: Colors.white,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ));
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'سامان',
          style: TextStyle(
            fontFamily: 'IRANSans',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: ' نگار',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: ' ایرانیان',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xfffbb448), Color(0xffe46b10)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title(),
              SizedBox(
                height: 80,
              ),
              _submitButton(),
              SizedBox(
                height: 20,
              ),
              _signUpButton(),
              SizedBox(
                height: 20,
              ),
              _label()
            ],
          ),
        ),
      ),
    );
  }
}
