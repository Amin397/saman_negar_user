import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/login/Widget/bezierContainer.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:samannegarusers/login/loginPage.dart';
import 'package:samannegarusers/login/welcomePage.dart';
import 'package:provider/provider.dart';

import '../../funcs.dart';
import '../fab.dart';
import '../util.dart';
import 'insuranceAndValue.dart';

class Pollpage extends StatefulWidget {
  Pollpage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PollpageState createState() => _PollpageState();
}

class _PollpageState extends State<Pollpage>
    with TickerProviderStateMixin {

  MenuController menuController;
  var customerData;
  String _name = 'کاربر';
  String _lastName = 'گرامی';
  String _customer_id = '0';
  List data = List();
  List expert = List();
  List requestExpertise = List();
  String RequestExpertise,Expert,Complain;

  Future<void> setData() async {
    showLoadingDialog(tapDismiss: false);
    var res = await makePostRequest(CustomStrings.CUSTOMERS, {
      'customer_id': await getPref('customer_id'),
      'api_type': 'get'
    });
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

    return "Sucess";
  }
  Future<String> getExperts() async {
    var res = await makePostRequest(CustomStrings.Experts,
        {});
    var resBody =res.json();

    setState(() {
      expert = resBody;
    });

    print(resBody);

    return "Sucess";
  }
  Future<String> getRequestExpertise() async {
    var res = await makePostRequest(CustomStrings.RequestExpertise,
        {});
    var resBody =res.json();

    setState(() {
      requestExpertise = resBody;
    });

    print(resBody);

    return "Sucess";
  }
  void initState() {
    setData();
    getTypesOfcomplaints();
    getExperts();
    getRequestExpertise();
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
                  filled: true),
          )
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
                padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 8),
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
                        colors: [Colors.redAccent, Colors.red])),
                child: Text(
                  'توضیحات',
                  style: TextStyle(
                      fontSize: 14, color: Colors.white, fontFamily: 'IRANSans'),
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
                padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 5),
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
                        colors: [Colors.orangeAccent, Colors.orange])),
                child: Text(
                  'ارسال به نمایندگی',
                  style: TextStyle(
                      fontSize: 14, color: Colors.black, fontFamily: 'IRANSans'),
                ),
              ),
              onTap: () {
                Fluttertoast.showToast(
                    msg: "شکایت شما به نمایندگی ارسال شد",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 8),
                margin: EdgeInsets.only(bottom: 25),
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
                  'ثبت نظر',
                  style: TextStyle(
                      fontSize: 14, color: Colors.white, fontFamily: 'IRANSans'),
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
                padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 5),
                margin: EdgeInsets.only(bottom: 25),
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
                        colors: [Colors.green, Colors.lightGreen])),
                child: Text(
                  'پاسخ شکایت بیمه گذار',
                  style: TextStyle(
                      fontSize: 14, color: Colors.white, fontFamily: 'IRANSans'),
                ),
              ),
              onTap: () {
                print('register');
              },
            ),
          ],
        ),
      ],
    );
  }
  int index1 , index2 , index3;

  int _radioValue1 = 0;
  int _result ;

  int _radioValue2 = 0;
  int _result2 ;

  int _radioValue3 = 0;
  int _result3 ;

  int _radioValue4 = 0;
  int _result4 ;

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
      switch (_radioValue1) {
        case 0:
          _result = 0;
          print(_result.toString());
          break;
        case 1:
          _result =1;
          print(_result.toString());
          break;
      }
    });
  }
  void _handleRadioValueChange2(int value) {
    setState(() {
      _radioValue2 = value;
      switch (_radioValue2) {
        case 0:
          _result2 = 0;
          print(_result2.toString());
          break;
        case 1:
          _result2 =1;
          print(_result2.toString());
          break;
      }
    });
  }
  void _handleRadioValueChange3(int value) {
    setState(() {
      _radioValue3 = value;
      switch (_radioValue3) {
        case 0:
          _result3 = 0;
          print(_result3.toString());
          break;
        case 1:
          _result3 =1;
          print(_result3.toString());
          break;
      }
    });
  }
  void _handleRadioValueChange4(int value) {
    setState(() {
      _radioValue4 = value;
      switch (_radioValue4) {
        case 0:
          _result4 = 0;
          print(_result4.toString());
          break;
        case 1:
          _result4 =1;
          print(_result4.toString());
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider.value(
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
                        SizedBox(
                          height: 20,
                        ),
                        new Column(

                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "کد رهگیری",
                                        style: TextStyle(fontSize: 16 , fontFamily: 'IRANSans' , color: Colors.black , fontWeight: FontWeight.bold),),
                                      SizedBox(
                                        height: 10,
                                      ),
                                  Container(
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                      child:Center(
                                        child: new DropdownButton(
                                          items: requestExpertise.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item['request_id']),
                                              value: item['request_id'].toString(),
                                            );
                                          }).toList(),
                                          onChanged: (newVal) {
                                            setState(() {
                                              RequestExpertise = newVal;
                                            });
                                          },
                                          value: RequestExpertise,
                                        ),
                                      )
                                  )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  "انتخاب کارشناس" ,
                                  style: TextStyle(fontSize: 16 , fontFamily: 'IRANSans' , color: Colors.black , fontWeight: FontWeight.bold),),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    child:new Center(
                                      child: DropdownButton(
                                        items: expert.map((item) {
                                          return new DropdownMenuItem(
                                            child: new Text(item['fname']+" "+item['lname']),
                                            value: item['expert_id'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            Expert = newVal;
                                          });
                                        },
                                        value: Expert,
                                      ),
                                    )
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  "نوع شکایت" ,
                                  style: TextStyle(fontSize: 16 , fontFamily: 'IRANSans' , color: Colors.black , fontWeight: FontWeight.bold),),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                  ),
                                  child: new Center(
                                    child:  DropdownButton(
                                      items: data.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(item['complaints_name']),
                                          value: item['typesofcomplaint_id'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          Complain = newVal;
                                        });
                                      },
                                      value: Complain,
                                    ),
                                  ),
                                )
                              ],
                            ),

                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        new Directionality(
                          child: _entryField("توضیحات نوع شکایت", inputType: TextInputType.text),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Radio(
                                  value: 1,
                                  groupValue: _radioValue1,
                                  onChanged: _handleRadioValueChange1,
                                ),
                                new Text(
                                  'بله',
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Radio(
                                  value: 0,
                                  groupValue: _radioValue1,
                                  onChanged: _handleRadioValueChange1,
                                ),
                                new Text(
                                  'خیر',
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "آیا کارشناس با شما تماس گرفت؟" ,
                              style: TextStyle (color: Colors.black , fontSize: 14),
                              textAlign: TextAlign.right,
                            ) ,
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Radio(
                                  value: 1,
                                  groupValue: _radioValue2,
                                  onChanged: _handleRadioValueChange2,
                                ),
                                new Text(
                                  'بله',
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Radio(
                                  value: 0,
                                  groupValue: _radioValue2,
                                  onChanged: _handleRadioValueChange2,
                                ),
                                new Text(
                                  'خیر',
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "آیا بازدید توسط کارشناس انجام شد؟" ,
                              style: TextStyle (color: Colors.black , fontSize: 14 ),
                              textAlign: TextAlign.right,
                            ) ,
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Radio(
                                  value: 1,
                                  groupValue: _radioValue3,
                                  onChanged: _handleRadioValueChange3,
                                ),
                                new Text(
                                  'بله',
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Radio(
                                  value: 0,
                                  groupValue: _radioValue3,
                                  onChanged: _handleRadioValueChange3,
                                ),
                                new Text(
                                  'خیر',
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "آیا از رفتار کارشناس راضی بودید؟" ,
                              style: TextStyle (color: Colors.black , fontSize: 14),
                              textAlign: TextAlign.right,
                            ) ,
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Radio(
                                  value: 1,
                                  groupValue: _radioValue4,
                                  onChanged: _handleRadioValueChange4,
                                ),
                                new Text(
                                  'بله',
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Radio(
                                  value: 0,
                                  groupValue: _radioValue4,
                                  onChanged: _handleRadioValueChange4,
                                ),
                                new Text(
                                  'خیر',
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "ایا از میزان برآورد خسارت راضی بودید؟" ,
                              style: TextStyle (color: Colors.black , fontSize: 14),
                              textAlign: TextAlign.right,
                            ) ,
                          ],
                        ),
                        _entryField("هرگونه شکایت و انتقادی از سامان نگار دارید اعلام بفرمایید"),
                        _submitButton(),

                      ],
                    ),
                  ),


                ],
              ),
            )
        ),
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
                      child: InsuranceAndValue(), type: PageTransitionType.rightToLeftWithFade));
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
                    style: TextStyle(fontFamily: 'IRANSans', color: Colors.grey),
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
