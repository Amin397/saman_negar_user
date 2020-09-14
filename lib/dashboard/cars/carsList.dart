import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/dashboard/cars/forms/addCar.dart';
import 'package:samannegarusers/dashboard/cars/forms/editCar.dart';
import 'package:samannegarusers/dashboard/home.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:shimmer/shimmer.dart';

import '../fab.dart';

var COLORS = [
  Colors.amber,
  CustomColors.BellYellow,
  CustomColors.HeaderYellowLight,
  CustomColors.YellowAccent,
  Colors.redAccent
];

class carsList extends StatefulWidget {
  carsList({Key key, this.title, this.name, this.lastName, this.customerID})
      : super(key: key);

  final String title;
  final String name;
  final String lastName;
  final String customerID;

  @override
  _carsListState createState() => new _carsListState();
}

class _carsListState extends State<carsList> with TickerProviderStateMixin {
  MenuController menuController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

//  final circularController = FabCircularMenuController();

  var cars;
  final List dismissControllers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("carlist name : " + widget.name);
    cars = fetchCars();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
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
    return Directionality(
        textDirection: TextDirection.rtl,
        child: new Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body:   new Stack(
              children: <Widget>[
                new Transform.translate(
                    offset: new Offset(
                        0.0, MediaQuery.of(context).size.height * 0.0001),
                    child: LiquidPullToRefresh(
                        key: _refreshIndicatorKey,
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverFillRemaining(
                              child: FutureBuilder<dynamic>(
                                future: cars,
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
                                            'شما خودرویی ثبت نکرده اید!',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          SizedBox(height: 20),
                                          RaisedButton(
                                            onPressed: () {
                                             Navigator.of(context).push(PageTransition(child: AddCar(), type: PageTransitionType.downToUp));
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
                                                  'ثبت خودرو جدید!',
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
                                              title: snapShot.data[index]
                                                  ['title'] == null ? "بدون اسم ": snapShot.data[index]['title'],
                                              content: snapShot.data[index]
                                                  ['text']),
                                          actions: <Widget>[],
                                          secondaryActions: <Widget>[
                                            new IconSlideAction(
                                              caption: 'ویرایش',
                                              color: Colors.green,
                                              icon: Icons.edit,
                                              onTap: () {
                                                print( snapShot.data[index]['plaque'] );
                                                print( snapShot.data[index]['customer_car_id'] );
                                                print( snapShot.data[index]['color_id'] );
                                                Navigator.of(context)
                                                    .pushReplacement(PageTransition(
                                                    child: EditCar(
                                                      name: widget.name,
                                                      lastName: widget.lastName,
                                                      customerID: widget.customerID,
                                                      carId:snapShot.data[index]['customer_car_id'],
                                                      vin_number:snapShot.data[index]['vin_number'],
                                                      pdate : snapShot.data[index]['production_date'],
                                                      plaque : snapShot.data[index]['plaque'],
                                                      carcolorid : snapShot.data[index]['color_id'],
                                                      carspecs : snapShot.data[index]['text'],
                                                      carGroupId : snapShot.data[index]['car_group_id'],
                                                      carBrandId : snapShot.data[index]['car_brand_id'],
                                                      carModelId : snapShot.data[index]['car_model_id'],
                                                      carNameId : snapShot.data[index]['car_name_id']
                                                    ),
                                                    type: PageTransitionType.fade));
                                              },
                                            ),
                                            new IconSlideAction(
                                              caption: 'حذف ماشین',
                                              color: Colors.red,
                                              icon: Icons.delete,
                                              onTap: () async {
                                                showLoadingDialog();
                                                var res = await makePostRequestAmin(
                                                    '${CustomStrings.API_ROOT}Customers/Cars/CustomerCars.php',
                                                    {
                                                      'customer_car_id': snapShot
                                                              .data[index]
                                                          ['customer_car_id'],
                                                      'api_type': 'delete_app'
                                                    }).then((value) {
                                                  if (value['result'] == 'done') {
                                                    setState(() {
                                                      cars = fetchCars();
                                                    });
                                                    hideLoadingDialog();
                                                  } else {
                                                    hideLoadingDialog();
                                                    showRichDialog(context,
                                                        title: 'کاربر گرامی!',
                                                        text:
                                                        'با عرض پوزش عملیات مورد نظر شما تکمیل نشد٬ لطفا دوباره تلاش کنید و در صورت تکرار این خطا با پشتیبانی تماس حاصل فرمایید',
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
//            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
    return fetchCars();
  }

  Future<dynamic> fetchCars() async {
    var data = await makePostRequest('${CustomStrings.CUSTOMERS}', {
      'customer_id': widget.customerID,
      'api_type': 'getCars',
      'request': 'app'
    });
    print(data.json().toString());
    print(data.json()[0]["car_group_id"]);
    return data.json();
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height / 4.75);
    p.lineTo(0.0, size.height / 3.75);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class AwesomeListItem extends StatefulWidget {
  String title;
  String content;
  bool blend = false;

  AwesomeListItem({this.title, this.content, this.blend = false});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.blend) {
      return new Row(
        children: <Widget>[
          new Container(
            width: 10.0,
            height: 190.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  CustomColors.HeaderOrange,
                  CustomColors.HeaderYellowLight
                ],
              ),
            ),
          ),
          new Expanded(
            child: new Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: new Container(
                      width: 500,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: new Container(
              height: 120.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: CustomColors.HeaderOrange),
              width: 130.0,
            ),
          )
        ],
      );
    } else {
      return new Row(
        children: <Widget>[
          new Container(
            width: 10.0,
            height: 190.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  CustomColors.HeaderOrange,
                  CustomColors.HeaderYellowLight
                ],
              ),
            ),
          ),
          new Expanded(
            child: new Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    widget.title,
                    style: TextStyle(
                        fontFamily: 'IRANSans',
                        color: Colors.grey.shade800,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: new Text(
                      widget.content,
                      style: TextStyle(
                          fontFamily: 'IRANSans',
                          color: Colors.grey.shade500,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(80.0)),
            height: 150.0,
            width: 150.0,
//            color: Colors.white,
            child: Stack(
              children: <Widget>[
                new Transform.translate(
                  offset: new Offset(-10.0, 0.0),
                  child: new Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          CustomColors.HeaderYellowLight,
                          CustomColors.PurpleLight
                        ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft)),
                  ),
                ),
                new Transform.translate(
                  offset: Offset(-20.0, 20.0),
                  child: new Card(
                    elevation: 20.0,
                    child: new Container(
                      height: 120.0,
                      width: 120.0,
                      child: new SizedBox.expand(
                        child: new FittedBox(
                          fit: BoxFit.cover,
                          child: new Icon(
                            Icons.drive_eta,
                            color: CustomColors.BellYellow,
                          ),
                        ),
                      ),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                              width: 10.0,
                              color: Colors.white,
                              style: BorderStyle.solid)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}

class ListItem extends StatelessWidget {
  final int index;

  const ListItem({Key key, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(right: 15.0),
            color: Colors.redAccent,
          ),
          index != -1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'This is title $index',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('This is more details'),
                    Text('One more detail'),
                  ],
                )
              : Expanded(
                  child: Container(
                    color: Colors.amber,
                  ),
                )
        ],
      ),
    );
  }
}
