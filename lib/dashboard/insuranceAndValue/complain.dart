import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/login/Widget/bezierContainer.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:samannegarusers/login/loginPage.dart';
import 'package:samannegarusers/login/welcomePage.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/request/models/Complaint.dart';
import 'package:http/http.dart' as http;

import '../../funcs.dart';
import '../fab.dart';
import '../util.dart';
import 'insuranceAndValue.dart';

class Complainpage extends StatefulWidget {
  Complainpage({Key key1, this.title}) : super(key: key1);

  final String title;

  @override
  _ComplainpageState createState() => _ComplainpageState();
}

class _ComplainpageState extends State<Complainpage>
    with TickerProviderStateMixin {
  MenuController menuController;
  var customerData;
  String _name = 'کاربر';
  String _lastName = 'گرامی';
  String typesofcomplaint_id,complaints_name;
  var complainData;
  String _customer_id = '0';
  List data = List();

  Future<void> setData() async {
    showLoadingDialog(tapDismiss: false);
    var res = await makePostRequest(CustomStrings.CUSTOMERS,
        {'customer_id': await getPref('customer_id'), 'api_type': 'get'});
    res = res.json();

    _name = await res['data']['name'];
    _lastName = await res['data']['lname'];
    _customer_id = await res['data']['customer_id'];
    customerData = await res;
    hideLoadingDialog();

  }
  Future<String> getTypesOfcomplaints() async {
    var res = await makePostRequest(CustomStrings.TypesOfcomplaints,
        {});
    var resBody =res.json();

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Success";
  }

  void initState() {
    setData();
    getTypesOfcomplaints();
    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  PageController pageViewController;

  @override
  void dispose() {
    super.dispose();
  }

  Widget _entryField(String title,
      {TextInputType inputType = TextInputType.text}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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
                        colors: [Colors.blueAccent, Colors.blue])),
                child: Text(
                  'بارگزاری مستندات',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'IRANSans'),
                ),
              ),
              onTap: () {
                print('register');
              },
            ),
            SizedBox(
              width: 2,
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
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
                        colors: [Colors.black54, Colors.black45])),
                child: Text(
                  'تاریخ تنظیم',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'IRANSans'),
                ),
              ),
              onTap: () {
                print('register');
              },
            ),
            SizedBox(
              width: 2,
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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
                        colors: [Colors.green, Colors.green[500]])),
                child: Text(
                  ' ثبت',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'IRANSans'),
                ),
              ),
              onTap: () {
                print('register');
              },
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            margin: EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Text(
              'پیگیری شکایت',
              style: TextStyle(
                  fontSize: 14, color: Colors.red, fontFamily: 'IRANSans'),
            ),
          ),
          onTap: () {
            print('register');
          },
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
      value: menuController,
//      builder: (context) => menuController,
      child: ZoomScaffold(
        menuScreen: MenuScreen(
          fullName: _name + ' ' + _lastName,
        ),
        contentScreen: Layout(contentBuilder: (cc) => scaffold(context)),
      ),
    );
  }

  Widget scaffold(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "نوع شکایت",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'IRANSans'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0, style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                          child: Center(
                            child: new DropdownButton(
                              items: data.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(item['complaints_name']),
                                  value: item['typesofcomplaint_id'].toString(),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  complaints_name = newVal;
                                });
                              },
                              value: complaints_name,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new Directionality(
                        textDirection: TextDirection.rtl,
                        child: _entryField("توضیحات و علت شکایت",
                            inputType: TextInputType.text)),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                  ],
                ),
              ),
            ],
          ),
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: customFab(context),
        bottomNavigationBar: Directionality(
          child: BottomNavigationBar(
              currentIndex: 0,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 10,
              selectedLabelStyle: TextStyle(color: CustomColors.BlueDark),
              selectedItemColor: CustomColors.BlueDark,
              unselectedFontSize: 10,
              onTap: (index) {
                print(index);
                if (index == 0) {
                  Navigator.of(context).pushReplacement(PageTransition(
                      child: InsuranceAndValue(),
                      type: PageTransitionType.rightToLeftWithFade));
                } else {
                  Navigator.of(context).pushReplacement(PageTransition(
                      child: InsuranceAndValue(),
                      type: PageTransitionType.leftToRight));
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Image.asset('assets/images/task.png'),
                  ),
                  title: Text(
                    'خدمات',
                    style:
                        TextStyle(fontFamily: 'IRANSans', color: Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Icon(Icons.arrow_back))),
                  title: Text(
                    'بازگشت',
                    style: TextStyle(fontFamily: 'IRANSans'),
                  ),
                ),
              ]),
          textDirection: TextDirection.rtl,
        ));
  }

  void onTabTapped(int index) {
    pageViewController.animateToPage(index == 1 ? 0 : 1,
        curve: Curves.easeIn, duration: new Duration(milliseconds: 250));
  }
}
