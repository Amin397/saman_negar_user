import 'dart:async';
import 'dart:convert';
//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/dashboard/cars/carsList.dart';
import 'package:samannegarusers/dashboard/cars/models/Cities.dart';
import 'package:samannegarusers/dashboard/cars/models/carGroups.dart';
import 'package:samannegarusers/dashboard/home.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:location/location.dart';

import 'package:shimmer/shimmer.dart';

var COLORS = [
  Colors.amber,
  CustomColors.BellYellow,
  CustomColors.HeaderYellowLight,
  CustomColors.YellowAccent,
  Colors.redAccent
];

class AddAddress extends StatefulWidget {
  AddAddress({Key key, this.title, this.name, this.lastName, this.customerID})
      : super(key: key);

  final String title;
  final String name;
  final String lastName;
  final String customerID;

  @override
  _AddAddressState createState() => new _AddAddressState();
}

class _AddAddressState extends State<AddAddress> with TickerProviderStateMixin {
  MenuController menuController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

//  final circularController = FabCircularMenuController();

  var cars;
  final List dismissControllers = [];
  String _name = 'کاربر';
  String _lastName = 'گرامی';
  var complainData;
  String _customer_id = '0';

  Future<void> setData() async {
    showLoadingDialog(tapDismiss: false);
    var res = await makePostRequest(CustomStrings.CUSTOMERS,
        {'customer_id': await getPref('customer_id'), 'api_type': 'get'});
    res = res.json();

    _name = await res['data']['name'];
    _lastName = await res['data']['lname'];
    _customer_id = await res['data']['customer_id'];
    hideLoadingDialog();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();

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

  TextEditingController addresstext = new TextEditingController();
  TextEditingController addresstitletext = new TextEditingController();

  String stateId = '0';
  String _stateIdHint = 'استان';
  String cityId = '0';
  String _cityIdHint = 'شهر';
  Future __cityfuture = fetchcities('0');

  @override
  Widget page(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: new Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body: new Stack(
              children: <Widget>[
                new Transform.translate(
                  offset: new Offset(
                      0.0, MediaQuery.of(context).size.height * 0.0001),
                  key: _refreshIndicatorKey,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverFillRemaining(
                        child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Expanded(
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          TextField(
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'عنوان آدرس',
                                                labelText: 'نام آدرس'),
                                            controller: addresstitletext,
                                          ),
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Flexible(
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: FutureBuilder<
                                                          List<CarGroups>>(
                                                      future: fetchCarGroups(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  List<
                                                                      CarGroups>>
                                                              snapshot) {
                                                        if (!snapshot.hasData)
                                                          return LinearProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                            valueColor:
                                                                new AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    CustomColors
                                                                        .BlueDark),
                                                          );
                                                        return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  width: 0.80),
                                                            ),
                                                            child: DropdownButtonHideUnderline(
                                                                child: DropdownButton<CarGroups>(
                                                                    icon: Padding(
                                                                      child: Icon(
                                                                          Icons
                                                                              .drive_eta),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                    ),
                                                                    style: TextStyle(fontFamily: 'IRANSans', color: Colors.black54),
                                                                    items: snapshot.data
                                                                        .map((carGroup) => DropdownMenuItem<CarGroups>(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: <Widget>[
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(right: 30.0),
                                                                                    child: new Text(
                                                                                      carGroup.name,
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'IRANSans',
                                                                                        fontSize: 12.0,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              value: carGroup,
                                                                            ))
                                                                        .toList(),
                                                                    onChanged: (CarGroups value) {
                                                                      setState(
                                                                          () {
                                                                        print(
                                                                            stateId);
                                                                        _stateIdHint =
                                                                            value.name;
                                                                        stateId =
                                                                            value.id;
                                                                        __cityfuture =
                                                                            fetchcities(stateId);
                                                                      });
                                                                    },
                                                                    isExpanded: true,
                                                                    hint: Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                      child:
                                                                          Text(
                                                                        _stateIdHint,
                                                                      ),
                                                                    ))));
                                                      }),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Flexible(
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: FutureBuilder<
                                                          List<Cities>>(
                                                      future: __cityfuture,
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  List<Cities>>
                                                              snapshot) {
                                                        if (!snapshot.hasData)
                                                          return LinearProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                            valueColor:
                                                                new AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    CustomColors
                                                                        .BlueDark),
                                                          );
                                                        return Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  width: 0.80),
                                                            ),
                                                            child: DropdownButtonHideUnderline(
                                                                child: DropdownButton<Cities>(
                                                                    icon: Padding(
                                                                      child: Icon(
                                                                          Icons
                                                                              .branding_watermark),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                    ),
                                                                    style: TextStyle(fontFamily: 'IRANSans', color: Colors.black54),
                                                                    items: snapshot.data
                                                                        .map((cities) => DropdownMenuItem<Cities>(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: <Widget>[
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(right: 30.0),
                                                                                    child: new Text(
                                                                                      cities.name,
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'IRANSans',
                                                                                        fontSize: 12.0,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              value: cities,
                                                                            ))
                                                                        .toList(),
                                                                    onChanged: (Cities value) {
                                                                      setState(
                                                                          () {
                                                                        _cityIdHint =
                                                                            value.name;
                                                                        print(
                                                                            _cityIdHint);
                                                                        cityId =
                                                                            value.id;
                                                                      });
                                                                    },
                                                                    isExpanded: true,
                                                                    hint: Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                      child:
                                                                          Text(
                                                                        _cityIdHint,
                                                                      ),
                                                                    ))));
                                                      }),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          TextField(
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: ' آدرس',
                                                labelText: ' آدرس'),
                                            controller: addresstext,
                                          ),
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          GestureDetector(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 8),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade200,
                                                        offset: Offset(2, 4),
                                                        blurRadius: 5,
                                                        spreadRadius: 2)
                                                  ],
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                      colors: [
                                                        Colors.green,
                                                        Colors.green[500]
                                                      ])),
                                              child: Text(
                                                ' انتخاب از روی نقشه',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontFamily: 'IRANSans'),
                                              ),
                                            ),
                                            onTap: () {
//                                              _getLocation();
                                              final CameraPosition
                                                  _kGooglePlex = CameraPosition(
                                                target: LatLng(
                                                    37.42796133580664,
                                                    -122.085749655962),
                                                zoom: 14.4746,
                                              );
                                              Completer<GoogleMapController>
                                                  _controller = Completer();

                                              Dialog errorDialog = Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0)),
                                                //this right here
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15.0),
                                                          child: Container(
                                                            width: 300,
                                                            height: 300,
                                                            child: GoogleMap(
                                                              mapType: MapType.hybrid,
                                                              initialCameraPosition: _kGooglePlex,
                                                              onMapCreated:(GoogleMapController
                                                                      controller) {
                                                                _controller.complete(controller);
                                                              },
                                                            ),
                                                          )),
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'Got It!',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .purple,
                                                                fontSize: 18.0),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          errorDialog);
                                            },
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
//            ),
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
                        child: carsList(
                          title: '',
                          name: widget.name,
                          lastName: widget.lastName,
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
//  _getLocation() async {
//    var location = new Location();
//    var currentLocation;
//    try {
//      currentLocation = await location.getLocation();
//
//      print("locationLatitude: ${currentLocation["latitude"]}");
//      print("locationLongitude: ${currentLocation["longitude"]}");
//      setState(
//              () {}); //rebuild the widget after getting the current location of the user
//    } on Exception {
//      currentLocation = null;
//    }
//  }
}
