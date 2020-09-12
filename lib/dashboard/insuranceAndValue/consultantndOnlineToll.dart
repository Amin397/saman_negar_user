import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/login/Widget/bezierContainer.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:provider/provider.dart';

import 'package:samannegarusers/login/loginPage.dart';
import 'package:samannegarusers/login/welcomePage.dart';

import '../../funcs.dart';
import '../fab.dart';
import '../home.dart';
import '../util.dart';
import 'insuranceAndValue.dart';

class ConsultantAndOnlineToll extends StatefulWidget {

  final int initialPage;

  ConsultantAndOnlineToll({Key key, this.initialPage = 1, this.title}) : super(key: key);
//  ConsultantAndOnlineToll({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ConsultantAndOnlineTollState createState() =>
      _ConsultantAndOnlineTollState();
}

class _ConsultantAndOnlineTollState extends State<ConsultantAndOnlineToll>
    with TickerProviderStateMixin {

  MenuController menuController;
  var customerData;
  String _name = 'کاربر';
  String _lastName = 'گرامی';
  String _customer_id = '0';


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

  void initState() {
    setData();
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
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
                    colors: [Colors.green, Colors.lightGreen])),
            child: Text(
              'تایید',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'IRANSans'),
            ),
          ),
          onTap: () {
            print('register');
          },
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
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
                    colors: [Colors.red, Colors.redAccent])),
            child: Text(
              'لغو',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'IRANSans'),
            ),
          ),
          onTap: () {
            print('register');
          },
        )
      ],
    );
  }

  Widget _title() {
    return Column(

      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'مشاوره آنلاین',
              style: TextStyle(
                fontFamily: 'IRANSans',
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            )),
        SizedBox(
          height: 15,
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'لطفا اطلاعات خود را وارد نمایید',
              style: TextStyle(
                fontFamily: 'IRANSans',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ))
      ],
    );
  }

  Widget _emailPasswordWidget() {

    return Column(
      children: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child:
                  _entryField("شماره بیمه نامه", inputType: TextInputType.number),
            ),
            SizedBox(
              height: 10,
              width: 10,
            ),
            new Directionality(
              textDirection: TextDirection.rtl,
              child: Flexible(
                child:
                _entryField("شرکت صادر کننده", inputType: TextInputType.text),
              )
            ),

          ],
        ),

      ],
    );
  }
  int index;
  var msgreciever = <String>[
    'سامان نگار',
    'بیمه گر',
  ];
  @override
  Widget build(BuildContext context) {
    print("_ConsultantAndOnlineTollState++++++"+_name +",," +_lastName);
    return ChangeNotifierProvider.value(

      value: menuController,
//      builder: (context) => menuController,
      child: ZoomScaffold(
        menuScreen: MenuScreen(
          fullName: _name + ' , ' + _lastName,
        ),
        contentScreen: Layout(contentBuilder: (cc) => scaffold(context)),
      ),
    );

  }
  @override
  Widget scaffold(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(

                      children: <Widget>[
                        _title(),
                        SizedBox(
                          height: 50,
                        ),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "انتخاب پذبرنده پیام",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: 'IRANSans'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                            child:new DropdownButton<String>(
                              value: index == null ? null : msgreciever[index],
                              isExpanded: true,
                              style: TextStyle(fontSize: 14 , fontFamily: 'IRANSans' , fontWeight: FontWeight.bold , color: Colors.black45),
                              items: msgreciever.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child:   Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                    value),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  index = msgreciever.indexOf(value);
                                  print(index);
                                });
                              },
                            )),
                          ],
                        ),
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
