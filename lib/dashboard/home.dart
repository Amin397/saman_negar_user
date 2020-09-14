import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/dashboard/addresses/addressesList.dart';
import 'package:samannegarusers/dashboard/cars/carsList.dart';
import 'package:samannegarusers/dashboard/fab.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/insuranceAndValue.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/insurance_list.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class Home extends StatefulWidget {
  final int initialPage;

  Home({Key key, this.initialPage = 1}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  var bottomNavigationBarIndex;
  MenuController menuController;
  var customerData;
  String _name = 'کاربر';
  String _lastName = 'گرامی';
  String _customer_id = '0';

  Future<void> setData() async {
    showLoadingDialog(tapDismiss: false);
    var res = await makePostRequest(CustomStrings.CUSTOMERS,
        {'customer_id': await getPref('customer_id'), 
          'api_type': 'get',
          'request': 'app',
        });
    print("_HomeState ; "+res.content());
    res = res.json();
    res = res['data'];
    _name = res['name'];
    _lastName = res['lname'];
    _customer_id = res['customer_id'];
    setPref('customer_id', _customer_id);
    customerData = res;
    hideLoadingDialog();
  }

  void initState() {
    pageViewController = new PageController(initialPage: widget.initialPage);
    bottomNavigationBarIndex = widget.initialPage == 1 ? 0 : 1;
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
    return FutureBuilder(
        future: getPref('customer_id'),
        // ignore: missing_return, missing_return
        builder: (BuildContext cntext, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
                future: makePostRequest(
                    '${CustomStrings.API_ROOT}chatBox/MessageToCustomer/MessageToCustomer.php',
                    {'api_type': 'getMessagesForCustomer', 'customer_id': '1'}),
                builder: (BuildContext cntext, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ChangeNotifierProvider.value(
                      value: menuController,
                      child: ZoomScaffold(
                        data: snapshot.data.json()[0]['message_title'],
                        menuScreen: MenuScreen(
                          fullName:
                              _name.toString() + ' ' + _lastName.toString(),
                        ),
                        contentScreen:
                            Layout(contentBuilder: (cc) => scaffold(context)),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          } else {
            return Container();
          }
        });
    return Container();
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('خروج از برنامه',
          style: TextStyle(
              fontFamily: 'IRANSans',
              fontSize: 15,
              color: CustomColors.TextHeaderGrey,
              fontWeight: FontWeight.w600),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        content: new Text('آیا میخواهید از برنامه خارج شوید؟',
          style: TextStyle(
              fontFamily: 'IRANSans',
              fontSize: 15,
              color: CustomColors.TextHeaderGrey,
              fontWeight: FontWeight.w600),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,),
        actions: <Widget>[
        FlatButton(
        child: Text("خیر"),
        onPressed:  () {
          Navigator.of(context).pop(false);
        },
      ),
          FlatButton(
            child: Text("بله"),
            onPressed:  () {
              Navigator.of(context).pop(true);
            },
          ),
          new GestureDetector(
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
                'خیر',
                style: TextStyle(
                    fontSize: 14, color: Colors.white, fontFamily: 'IRANSans'),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(false);
            },
          ),
          new GestureDetector(
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
                      colors: [Colors.red, Colors.red[200]])),
              child: Text(
                'بله',
                style: TextStyle(
                    fontSize: 14, color: Colors.white, fontFamily: 'IRANSans'),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    )) ?? false;
  }
  @override
  Widget scaffold(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child:Scaffold(
          body: PageView(
//        allowImplicitScrolling: true,
        controller: pageViewController,
        onPageChanged: (page) {
          setState(() {
            bottomNavigationBarIndex = page == 1 ? 0 : 1;
          });
        },
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) => Container(
                                  margin: EdgeInsets.only(
                                      left: 0, top: 15, bottom: 0),
                                ),
                            childCount: 1),
                      ),
                      SliverGrid.count(
                        crossAxisCount: 2,
                        children: [
                          __item('خودرو های من', 'تنظیمات حساب',
                              Icons.drive_eta, Colors.redAccent, onTap: () {
                            Navigator.of(context)
                                .pushReplacement(PageTransition(
                                    child: carsList(
                                      title: 'تتیر',
                                      name: _name,
                                      lastName: _lastName,
                                      customerID: _customer_id,
                                    ),
                                    type: PageTransitionType.fade));
                          }),
                          __item(
                              'بیمه های من',
                              'بهترین و نزدیک ترین مراکز خدمات',
                              Icons.verified_user,
                              Colors.green,onTap: (){
                            Navigator.of(context)
                                .pushReplacement(PageTransition(
                                child: InsuranceList(
                                  title: 'تتیر',
                                  name: _name,
                                  lastName: _lastName,
                                  customerID: _customer_id,
                                ),
                                type: PageTransitionType.fade));
                          }),
                          __item('آدرس های من', 'قطعات اصلی با بهترین قیمت',
                              Icons.local_post_office, Colors.blue, onTap: () {
                            Navigator.of(context)
                                .pushReplacement(PageTransition(
                                    child: addressList(
                                      title: 'تتیر',
                                      name: _name,
                                      lastName: _lastName,
                                      customerID: _customer_id,
                                    ),
                                    type: PageTransitionType.fade));
                          }),
                          __item('املاک من', 'رزرو آنلاین خدمات تعمیرگاهی',
                              Icons.home, Colors.deepPurple),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) => Container(
                                margin: EdgeInsets.only(
                                    left: 0, top: 15, bottom: 0),
                                child: __item(
                                    'بیمه و ارزیابی خسارت خودرو',
                                    'subTitle',
                                    Icons.verified_user,
                                    Colors.green, onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      PageTransition(
                                          child: InsuranceAndValue(),
                                          type: PageTransitionType.downToUp));
                                }),
                              ),
                          childCount: 1),
                    ),
                    SliverGrid.count(
                      crossAxisCount: 3,
                      children: [
                        __smallItem('حساب کاربری', 'تنظیمات حساب',
                            Icons.supervised_user_circle, Colors.orange, 1),
                        __smallItem(
                            'امداد و تعمیرات',
                            'بهترین و نزدیک ترین مراکز خدمات',
                            Icons.settings,
                            Colors.brown,
                            2),
                        __smallItem('قطعات یدکی', 'قطعات اصلی با بهترین قیمت',
                            Icons.whatshot, Colors.lightBlueAccent, 3),
                        __smallItem(
                            'پذیرش تعمیرگاه',
                            'رزرو آنلاین خدمات تعمیرگاهی',
                            Icons.toys,
                            Colors.yellow,
                            4),
                        __smallItem(
                            'پرداخت جرایم',
                            'دریافت و پرداخت آنلاین جرایم رانندگی',
                            Icons.receipt,
                            Colors.red,
                            5),
                        __smallItem('جرثقیل ایمن', 'خدمات حمل خودرو',
                            Icons.view_headline, Colors.blue, 6),
                        __smallItem(
                            'اجاره ی خودرو',
                            'اجاره ی خودروی با و بدون سرنشین',
                            Icons.refresh,
                            Colors.amber,
                            7),
                        __smallItem('خرید و فروش', 'خرید و فروش انواع خودرو',
                            Icons.airport_shuttle, Colors.deepPurple, 8),
                        __smallItem('تنظیمات', 'رهیاب رهیااببب',
                            Icons.settings_applications, Colors.black87, 9),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) => Container(
                                margin: EdgeInsets.only(
                                    left: 0, top: 15, bottom: 0),
                                child: __item(
                                    'باشگاه مشتریان رهیاب',
                                    'دنیایی از خدمات و کالا های تخفیف دار و اعتباری',
                                    Icons.shop,
                                    Colors.purple,
                                    iconSize: 50,
                                    showSub: true, onTap: () {
                                  showRichDialog(context);
                                }),
                              ),
                          childCount: 1),
                    ),
                  ],
                ),
              ))
        ],
      ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: customFab(context),
          bottomNavigationBar: Directionality(
          textDirection: TextDirection.rtl,
          child: BottomNavigationBar(
            currentIndex: bottomNavigationBarIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 10,
            selectedLabelStyle: TextStyle(color: CustomColors.BlueDark),
            selectedItemColor: CustomColors.BlueDark,
            unselectedFontSize: 10,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Image.asset(
                    'assets/images/task.png',
                    color: (bottomNavigationBarIndex == 0)
                        ? CustomColors.BlueDark
                        : CustomColors.TextGrey,
                  ),
                ),
                title: Text(
                  'خدمات',
                  style: TextStyle(fontFamily: 'IRANSans'),
                ),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Image.asset(
                    'assets/images/home.png',
                    color: (bottomNavigationBarIndex == 1)
                        ? CustomColors.BlueDark
                        : CustomColors.TextGrey,
                  ),
                ),
                title: Text(
                  'خانه',
                  style: TextStyle(fontFamily: 'IRANSans'),
                ),
              ),
            ],
            onTap: onTabTapped,
          )),
    ));
  }

  void onTabTapped(int index) {
    pageViewController.animateToPage(index == 1 ? 0 : 1,
        curve: Curves.easeIn, duration: new Duration(milliseconds: 250));
  }

  Widget __smallItem(
      String title, String subTitle, IconData icon, Color color, int index,
      {Function onTap = null,
      double iconSize = 35.0,
      bool showSub = false,
      double subFontSize = 12}) {
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
                    size: iconSize,
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
                  style: TextStyle(
                      fontFamily: 'IRANSans',
                      fontSize: 13,
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
          margin: EdgeInsets.all(10),
          height: 150.0),
      onTap: onTap != null
          ? onTap
          : () {
              showRichDialog(context);
            },
    );
  }

  Widget __item(String title, String subTitle, IconData icon, Color color,
      {Function onTap = null,
      double iconSize = 65.0,
      bool showSub = false,
      double subFontSize = 12}) {
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
                    size: iconSize,
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
                  style: TextStyle(
                      fontFamily: 'IRANSans',
                      fontSize: 15,
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
          margin: EdgeInsets.all(10),
          height: 150.0),
      onTap: onTap != null
          ? onTap
          : () {
              print(onTap);
              showRichDialog(context);
            },
    );
  }
}
