import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/dashboard/fab.dart';
import 'package:samannegarusers/dashboard/home.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/poll.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/sendDocs.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

import 'casepursuite.dart';
import 'complain.dart';
import 'consultantndOnlineToll.dart';

class InsuranceAndValue extends StatefulWidget {
  final int initialPage;

  InsuranceAndValue({Key key, this.initialPage = 1}) : super(key: key);

  _InsuranceAndValueState createState() => _InsuranceAndValueState();
}

class _InsuranceAndValueState extends State<InsuranceAndValue>
    with TickerProviderStateMixin {
  var bottomNavigationBarIndex;
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

  @override
  Widget scaffold(BuildContext context) {
    return Scaffold(
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => Container(
                              margin:
                                  EdgeInsets.only(left: 0, top: 15, bottom: 0),
                            ),
                        childCount: 1),
                  ),
                  SliverGrid.count(
                    crossAxisCount: 3,
                    children: [
                      __smallItem('مشاورهء خسارت آنلاین', 'تنظیمات حساب',
                          Icons.headset_mic, Colors.red, 1,titleFontSize: 11.0,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                PageTransition(
                                    child: ConsultantAndOnlineToll(),
                                    type: PageTransitionType.downToUp));
                          }),
                      __smallItem('نزدیک ترین شعبه بیمه گر', 'قطعات اصلی با بهترین قیمت',
                          Icons.location_on, Colors.green, 3,titleFontSize: 11.0),
                      __smallItem(
                          'درخواست کارشناسی سیار',
                          'بهترین و نزدیک ترین مراکز خدمات',
                          Icons.settings,
                          Colors.deepOrange,
                          2),
                      __smallItem(
                          'ارسال مستندات',
                          'رزرو آنلاین خدمات تعمیرگاهی',
                          Icons.send,
                          Colors.blueAccent,
                          4,onTap: () {
                              Navigator.of(context).pushReplacement(
                              PageTransition(
                              child: SendDocspage(),
                              type: PageTransitionType.downToUp));
                              }),
                      __smallItem(
                          'درخواست جرثقیل',
                          'دریافت و پرداخت آنلاین جرایم رانندگی',
                          Icons.drive_eta,
                          Colors.red,
                          5),
                      __smallItem('نظرسنجی', 'خدمات حمل خودرو',
                          Icons.poll, Colors.deepPurple, 6 ,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                PageTransition(
                                    child: Pollpage(),
                                    type: PageTransitionType.downToUp));
                          }),
                      __smallItem(
                          'رفع نقص و فاکتور تعمیرات',
                          'اجاره ی خودروی با و بدون سرنشین',
                          Icons.restore_page,
                          Colors.amber,
                          7),
                      __smallItem('فیلم برداری و تصویر برداری حادثه', 'خرید و فروش انواع خودرو',
                          Icons.camera_enhance, Colors.deepPurple, 8),
                      __smallItem('اعتراض به برخورد کارشناس', 'رهیاب رهیااببب',
                          Icons.person_pin, Colors.red, 9),
                      __smallItem(
                          'پیگیری پرونده',
                          'اجاره ی خودروی با و بدون سرنشین',
                          Icons.folder_open,
                          Colors.blueGrey, 7 ,
                      onTap: () {
                      Navigator.of(context).pushReplacement(
                      PageTransition(
                      child: Casepursuitepage(),
                      type: PageTransitionType.downToUp));
                      }),
                      __smallItem('شکایات و انتقادات', 'خرید و فروش انواع خودرو',
                          Icons.perm_device_information, Colors.amberAccent, 8 ,
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                        PageTransition(
                        child: Complainpage(),
                        type: PageTransitionType.downToUp));
                      }),
                      __smallItem('عکس بازسازی', 'رهیاب رهیااببب',
                          Icons.picture_in_picture, Colors.grey, 9),
                      __smallItem(
                          'تماس با مرکز پیام',
                          'اجاره ی خودروی با و بدون سرنشین',
                          Icons.folder_open,
                          Colors.green,
                          7),
                      __smallItem('پیام ها', 'خرید و فروش انواع خودرو',
                          Icons.perm_device_information, Colors.black45, 8),
                      __smallItem('پیام به کارشناس', 'رهیاب رهیااببب',
                          Icons.textsms, Colors.lightGreen, 9),
                    ],
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
                      child: Home(), type: PageTransitionType.rightToLeftWithFade));
                } else {
                  Navigator.of(context).pushReplacement(PageTransition(
                      child: Home(),
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
        )
    );
  }

  void onTabTapped(int index) {
    pageViewController.animateToPage(index == 1 ? 0 : 1,
        curve: Curves.easeIn, duration: new Duration(milliseconds: 250));
  }

  Widget __smallItem(
      String title, String subTitle, IconData icon, Color color, int index,
      {Function onTap = null,
      double InsuranceAndValueize = 35.0,
      bool showSub = false,
      double subFontSize = 12,double titleFontSize = 11.0}) {
    return GestureDetector(
      child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(
                    icon,
                    size: InsuranceAndValueize,
                    color: color,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'IRANSans',
                      fontSize: titleFontSize,
                      color: CustomColors.TextHeaderGrey,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                showSub
                    ? Stack(
                        children: <Widget>[
                          Text(
                            subTitle,
                            style: TextStyle(
                                fontFamily: 'IRANSans',
                                fontSize: subFontSize,
                                color: CustomColors.TextSubHeaderGrey),
                          )
                        ],
                      )
                    : SizedBox(height: 0)
              ],
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            boxShadow: [
              BoxShadow(
                color: CustomColors.GreyBorder,
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
            color: Colors.white,
          ),
          margin: EdgeInsets.all(4),
          height: 200.0),
      onTap: onTap != null
          ? onTap
          : () {
              showRichDialog(context);
            },
    );
  }
}
