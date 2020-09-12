import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/login/Widget/bezierContainer.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:samannegarusers/login/loginPage.dart';
import 'package:samannegarusers/login/welcomePage.dart';

import '../funcs.dart';
import 'CodeConfirming.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController mobileController = new TextEditingController();

  GlobalKey _scaffoldKey1 = new GlobalKey();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(context, PageTransition(
            type: PageTransitionType.leftToRight,
            duration: new Duration(milliseconds: 250),
            child: WelcomePage()
        ));
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
          '!ثبت نام',
          style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: 'IRANSans'),
        ),
      ),
      onTap: () async {

        String mobile = mobileController.text.toString();

        if (!CustomStrings.MOBILE_REGEX.hasMatch(mobile)) {
          Fluttertoast.showToast(
              msg: "لطفا شماره موبایل را با فرمت درست وارد کنید",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          return;
        }
        print(mobile);
        var result = await signupCustomer(mobile);
        print(result);
        if (result['status'] == 'success') {
          setPref('username', mobile);
          getPref('username').then((value) => print(value));
          Navigator.pushReplacement(context,
              PageTransition(child: CodeConfirming(result['code']),
                  type: PageTransitionType.downToUp));
        }else if(result['status'] == 'user registered'){
          Fluttertoast.showToast(
              msg: "این شماره قبلا ثبت شده است!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      }
    );

  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'ورود',
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
            'اکانت دارید؟',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,fontFamily: 'IRANSans'),
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

  Widget _emailPasswordWidget() {

    return Column(
      children: <Widget>[
        _entryField("شماره موبایل", mobileController,
            isPassword: false, inputType: TextInputType.number),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child:Container(
          height: MediaQuery.of(context).size.height,
          child:Stack(
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
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _loginAccountLabel(),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
              Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer())
            ],
          ),
        )
      )
    );
  }
}
