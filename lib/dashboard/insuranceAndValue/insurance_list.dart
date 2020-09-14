import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/dashboard/addresses/addressesList.dart';
import 'package:samannegarusers/dashboard/fab.dart';
import 'package:samannegarusers/dashboard/home.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/forms/add_insurance.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:shimmer/shimmer.dart';

import '../../funcs.dart';
import '../fab.dart';
import '../home.dart';

var COLORS = [
  Colors.amber,
  CustomColors.BellYellow,
  CustomColors.HeaderYellowLight,
  CustomColors.YellowAccent,
  Colors.redAccent
];

class InsuranceList extends StatefulWidget {
  String title;
  String name;
  String lastName;
  String customerID;

  InsuranceList(
      {Key key, this.title, this.name, this.lastName, this.customerID})
      : super(key: key);

  @override
  _InsuranceListState createState() => _InsuranceListState();
}

class _InsuranceListState extends State<InsuranceList>
    with TickerProviderStateMixin {
  MenuController menuController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  var insurance;
  final List dismissControllers = [];

  @override
  void initState() {
    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
    insurance = fetchInsurance();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: menuController,
      child: ZoomScaffold(
        menuScreen: MenuScreen(
          fullName: widget.name.toString() + ' ' + widget.lastName.toString(),
        ),
        contentScreen: Layout(contentBuilder: (cc) => page(context)),
      ),
    );
  }

  @override
  Widget page(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: new Scaffold(
            resizeToAvoidBottomPadding: true,
            key: _scaffoldKey,
            body: new Stack(
              children: <Widget>[
                new Transform.translate(
                    offset: new Offset(0.0, size.height * 0.0001),
                    child: LiquidPullToRefresh(
                        key: _refreshIndicatorKey,
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverFillRemaining(
                              child: FutureBuilder<dynamic>(
                                future: insurance,
                                builder: (ctx, snapShot) {
                                  if (snapShot.hasData) {
                                    dismissControllers.clear();
                                    if (snapShot.data.toString() == '[]') {
                                      return Center(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'شما بیمه ای ثبت نکرده اید!',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          SizedBox(height: 20),
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  PageTransition(
                                                      child: AddInsurance(),
                                                      type: PageTransitionType
                                                          .downToUp));
                                            },
                                            textColor: Colors.white,
                                            padding: const EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              height: 60,
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: <Color>[
                                                    CustomColors
                                                        .HeaderYellowLight,
                                                    CustomColors.BlueDark,
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        CustomColors.BlueShadow,
                                                    blurRadius: 2.0,
                                                    spreadRadius: 1.0,
                                                    offset: Offset(0.0, 0.0),
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 10, 20, 10),
                                              child: Center(
                                                child: const Text(
                                                  'ثبت بیمه جدید!',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                    }
                                    return ListView.builder(
                                      itemCount: snapShot.data.length,
                                      itemBuilder: (context, index) {
                                        dismissControllers
                                            .add(SlidableController());
                                        final dismiss = SlidableController();
                                        final key = new GlobalKey();
                                        return Slidable(
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          key: key,
                                          controller: dismissControllers[index],
                                          actionExtentRatio: 0.25,
                                          child: AwesomeListItem(
                                              title: snapShot.data[index][
                                                          'insurance_number'] ==
                                                      null
                                                  ? "بدون اسم "
                                                  : 'شماره بیمه نامه: ${snapShot.data[index]['insurance_number']} ',
                                              content:
                                                  'تاریخ شروع بیمه نامه: ${snapShot.data[index]['start_date']} \n'
                                                  'تاریخ اتمام بیمه نامه: ${snapShot.data[index]['end_date']}\n'
                                                  'سقف میزان پراخت خسارت: ${snapShot.data[index]['max_payment']}ريال\n'
                                                  'سقف میزان پراخت خسارت جانی: ${snapShot.data[index]['max_jani']}ريال\n'
                                                  'شماره پلاک: ${snapShot.data[index]['plaque']}\n'
                                                      'شرکت بیمه: ${snapShot.data[index]['companyName']}'),
                                          actions: <Widget>[],
                                          secondaryActions: <Widget>[
                                            IconSlideAction(
                                              caption: 'ویرایش',
                                              color: Colors.green,
                                              icon: Icons.edit,
                                              onTap: () {
                                                // Navigator.of(context)
                                                //     .pushReplacement(PageTransition(
                                                //     child: EditInsurance(
                                                //         name: widget.name,
                                                //         lastName: widget.lastName,
                                                //         customerID: widget.customerID,
                                                //         carId:snapShot.data[index]['customer_car_id'],
                                                //         vin_number:snapShot.data[index]['vin_number'],
                                                //         pdate : snapShot.data[index]['production_date'],
                                                //         plaque : snapShot.data[index]['plaque'],
                                                //         carcolorid : snapShot.data[index]['color_id'],
                                                //         carspecs : snapShot.data[index]['text'],
                                                //         carGroupId : snapShot.data[index]['car_group_id'],
                                                //         carBrandId : snapShot.data[index]['car_brand_id'],
                                                //         carModelId : snapShot.data[index]['car_model_id'],
                                                //         carNameId : snapShot.data[index]['car_name_id']
                                                //     ),
                                                //     type: PageTransitionType.fade));
                                              },
                                            ),
                                            IconSlideAction(
                                              caption: 'حذف بیمه',
                                              color: Colors.red,
                                              icon: Icons.delete,
                                              onTap: () async {
                                                showLoadingDialog();
                                                var res = await makePostRequest(
                                                    '${CustomStrings.API_INSURANCE}',
                                                    {
                                                      'customer_id': snapShot
                                                              .data[index][
                                                          'customer_insurance_id'],
                                                      'api_type': 'delete_app'
                                                    }).then((value) {
                                                  if (value['result'] ==
                                                      'done') {
                                                    setState(() {
                                                      insurance =
                                                          fetchInsurance();
                                                    });
                                                    hideLoadingDialog();
                                                  } else {
                                                    hideLoadingDialog();
                                                    showRichDialog(context,
                                                        title: 'کاربر گرامی!',
                                                        text:
                                                            'با عرض پوزش عملیات مورد نظر شما تکمیل نشد ٬ لطفا دوباره تلاش کنید و در صورت تکرار این خطا با پشتیبانی تماس حاصل فرمایید',
                                                        type: 0);
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (snapShot.hasError) {
                                    print('${snapShot.error}');
                                  }
                                  return ListView.builder(
                                    itemCount: 4,
                                    // Important code
                                    itemBuilder: (context, index) =>
                                        Shimmer.fromColors(
                                            baseColor:
                                                CustomColors.HeaderYellowLight,
                                            highlightColor: Colors.white,
                                            child: AwesomeListItem(
                                                title: 'نام آدرس',
                                                content: 'موقعیت مکانی',
                                                blend: true)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        onRefresh: _handleRefresh))
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: addInsuranceFab(context),
            bottomNavigationBar: BottomNavigationBar(
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
                        child: Home(), type: PageTransitionType.upToDown));
                  } else {
                    Navigator.of(context).pushReplacement(PageTransition(
                        child: Home(
                          initialPage: 0,
                        ),
                        type: PageTransitionType.upToDown));
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
                ])));
  }

  Future<void> _handleRefresh() {
    return fetchInsurance();
  }

  Future<dynamic> fetchInsurance() async {
    var data = await makePostRequest('${CustomStrings.API_INSURANCE}', {
      'customer_id': widget.customerID,
      'api_type': 'customerInsurances',
    });
    return data.json();
  }
}
