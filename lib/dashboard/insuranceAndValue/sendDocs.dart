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

import '../../funcs.dart';
import '../fab.dart';
import '../home.dart';
import '../util.dart';
import 'insuranceAndValue.dart';

class SendDocspage extends StatefulWidget {
  SendDocspage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SendDocspageState createState() => _SendDocspageState();
}

class _SendDocspageState extends State<SendDocspage>
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

  Widget _title() {
    return Column(
      children: <Widget>[

        SizedBox(
          height: 15,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
          text: 'انتخاب اعلان',
          style: TextStyle(
          fontFamily: 'IRANSans',
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          ),
          ))
        ],
    );
  }
  Widget _entryField(String title,
      {TextInputType inputType = TextInputType.text}) {
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
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return   ChangeNotifierProvider.value(
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
    return  Scaffold(
        body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _title(),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child:  Text("کد اعلان" , style: TextStyle(color: Colors.black , fontSize: 20 , fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Container(
                                height: 50,
                                child: VerticalDivider(color : Colors.grey),
                              ),
                              Expanded(
                                flex: 2,
                                child:Container(
                                  alignment: Alignment.center,
                                  child:  Text("تیتر اعلان" , style: TextStyle(color: Colors.black , fontSize: 20 , fontWeight: FontWeight.bold),) ,
                                ),
                              ),
                              Container(
                                height: 50,
                                child: VerticalDivider(color : Colors.grey),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("ردیف" , style: TextStyle(color: Colors.black , fontSize: 20 , fontWeight: FontWeight.bold),),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            )) ,
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
