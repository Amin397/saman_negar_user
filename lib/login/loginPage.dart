import 'dart:io';

import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:samannegarusers/dashboard/home.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:samannegarusers/login/signup.dart';
import 'package:samannegarusers/login/welcomePage.dart';

import 'Widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController mobileController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  GlobalKey _scaffoldKey = new GlobalKey();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                duration: new Duration(milliseconds: 250),
                child: WelcomePage()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('بازگشت',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'IRANSans'))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false, TextInputType inputType = TextInputType.text}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'IRANSans'),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: inputType,
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'ورود',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontFamily: 'IRANSans'),
        ),
      ),
      onTap: () async {
        String mobile = mobileController.text.toString();
        if (!CustomStrings.MOBILE_REGEX.hasMatch(mobile)) {
          showInSnackBar(context, 'لطفا شماره موبایل را با فرمت درست وارد کنید',
              Colors.red, 5, _scaffoldKey);
          return;
        }
        String password = passwordController.text.toString();
        if (!(password.length > 5)) {
          showInSnackBar(context, 'لطفا رمز عبور خود را وارد کنید', Colors.red,
              5, _scaffoldKey);
          return;
        }
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            showLoadingDialog();
            var result = await loginCustomer(mobile, password);
            print(result);
            if (result['result'] == 'success') {
              setPref('username', mobile);
              setPref('password', password);
              setPref('customer_id', result['data']['customer_id']);
              getPref('username').then((value) =>  print(value));
              Navigator.pushReplacement(context,
                  PageTransition(child: Home(), type: PageTransitionType.downToUp));
              hideLoadingDialog();
            } else {
              showRichDialog(context,
                  title: 'اطلاعات نادرست!',
                  text:
                  'شماره موبایل وارد شده با رمز عبور مطابقت ندارد! لطفا دوباره امتحان کنید و در صورت فراموش کردن رمز عبور از طریق "بازیابی کلمه ی عبور" افدام نمایید.',
                  type: 0);
              hideLoadingDialog();
            }
          }
        } on SocketException catch (_) {
          print('not connected');
          showRichDialog(context,
              title: 'اینترنت!',
              text:
              'اتصال اینترنت خود را چک کنید',
              type: 0);
          hideLoadingDialog();

        }

      },
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(
            'یا',
            style: TextStyle(fontFamily: 'IRANSans'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('با جیمیل خود وارد شوید',
                  style: TextStyle(
                      fontFamily: 'IRANSans',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('G',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text(
              'ثبت نام',
              style: TextStyle(
                  fontFamily: 'IRANSans',
                  color: Color(0xfff79c4f),
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'ثبت نام نکرده اید؟',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'IRANSans',
            ),
          ),
        ],
      ),
    );
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

  Widget _mobilePasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("شماره موبایل", mobileController,
            isPassword: false, inputType: TextInputType.number),
        _entryField("رمز عبور", passwordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: SizedBox(),
                    ),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _mobilePasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text('رمز عبور خود را فراموش کرده اید؟',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'IRANSans')),
                    ),
                    _divider(),
                    _facebookButton(),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _createAccountLabel(),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
              Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer())
            ],
          ),
        )));
  }
}
