import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/Helper/ViewHelper.dart';
import 'package:samannegarusers/dashboard/cars/carsList.dart';
import 'package:samannegarusers/dashboard/cars/models/carBrands.dart';
import 'package:samannegarusers/dashboard/cars/models/carColors.dart';
import 'package:samannegarusers/dashboard/cars/models/carGroups.dart';
import 'package:samannegarusers/dashboard/cars/models/carModel.dart';
import 'package:samannegarusers/dashboard/cars/models/typeOfCar.dart';
import 'package:samannegarusers/dashboard/home.dart';
import 'package:samannegarusers/dashboard/plugins/mask_text_input_formatter.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:samannegarusers/screens/success_screen.dart';

var COLORS = [
  Colors.amber,
  CustomColors.BellYellow,
  CustomColors.HeaderYellowLight,
  CustomColors.YellowAccent,
  Colors.redAccent
];

class AddCar extends StatefulWidget {
  AddCar({Key key, this.title, this.name, this.lastName, this.customerID})
      : super(key: key);

  final String title;
  final String name;
  final String lastName;
  final String customerID;

  @override
  _AddCarState createState() => new _AddCarState();
}

class _AddCarState extends State<AddCar> with TickerProviderStateMixin {
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
  static String _customer_id = '0';

  Future<void> setData() async {
    showLoadingDialog(tapDismiss: false);
    var res = await makePostRequest(CustomStrings.CUSTOMERS, {
      'customer_id': await getPref('customer_id'),
      'api_type': 'get',
      'request': 'app'
    });
    res = res.json();
    print("_AddCarState setdata: " + res.toString());
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

    print('##################################%%%%%%%%%%%%%%%%%%%% ${_customer_id}');

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

  TextEditingController production_year = new TextEditingController();
  TextEditingController vinnumber = new TextEditingController();
  TextEditingController platenumber1 = new TextEditingController();
  TextEditingController platenumber2 = new TextEditingController();
  TextEditingController platenumber3 = new TextEditingController();
  TextEditingController platenumber4 = new TextEditingController();

  MaskTextInputFormatter production_year_formatter =
      new MaskTextInputFormatter(mask: '13a#', filter: {
    '1': new RegExp(r'1'),
    '3': new RegExp(r'3'),
    'a': new RegExp(r'[4-9]'),
    '#': new RegExp(r'[0-9]'),
  });

  String carGroupId = '0';
  String _carGroupHint = 'لطفا گروه خودرو را انتخاب نمایید';
  String carBrandId = '0';
  String _carBrandHint = 'لطفا برند خودرو را انتخاب نمایید';
  String typeOfCarId = '0';
  String _typeOfCarHint = 'لطفا نام خودرو را انتخاب نمایید';
  String carModelId = '0';
  String _carModelHint = 'لطفا مدل خودرو را انتخاب نمایید';
  String carColorId = '0';
  String _carColorHint = 'لطفا رنگ خودرو را انتخاب نمایید';
  Future __typeOfCarFuture = fetchTypeOfCar('0', '0');
  Future __carModelFuture = fetchCarModel('0', '0', '0');

  @override
  Widget page(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Expanded(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            flex: 1,
                                            child: _textFormField(
                                                size,
                                                production_year,
                                                'سال تولید خودرو',
                                                1,
                                                .075,
                                                true,
                                                1,
                                                true,
                                                production_year_formatter,
                                                true),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: _textFormField(
                                                size,
                                                vinnumber,
                                                'شماره VIN',
                                                1,
                                                .075,
                                                true,
                                                1,
                                                true,
                                                production_year_formatter,
                                                false),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: FutureBuilder<
                                                      List<CarGroups>>(
                                                  future: fetchCarGroups(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              List<CarGroups>>
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
                                                              style: BorderStyle
                                                                  .solid,
                                                              width: 0.80),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                                child: DropdownButton<
                                                                        CarGroups>(
                                                                    icon:
                                                                        Padding(
                                                                      child: Icon(
                                                                          Icons
                                                                              .drive_eta),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                    ),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'IRANSans',
                                                                        color: Colors
                                                                            .black54),
                                                                    items: snapshot
                                                                        .data
                                                                        .map((carGroup) =>
                                                                            DropdownMenuItem<
                                                                                CarGroups>(
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
                                                                    onChanged:
                                                                        (CarGroups
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        print(carBrandId);
                                                                        __typeOfCarFuture = fetchTypeOfCar(carBrandId,carGroupId);
                                                                        __carModelFuture = fetchCarModel(carBrandId,carGroupId,"0");
                                                                        _carGroupHint = value.name;
                                                                        carGroupId = value.id;
                                                                      });
                                                                    },
                                                                    isExpanded:
                                                                        true,
                                                                    hint:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10.0),
                                                                      child:
                                                                          Text(
                                                                        _carGroupHint,
                                                                      ),
                                                                    ))));
                                                  }),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Flexible(
                                            child: FutureBuilder<
                                                    List<CarBrands>>(
                                                future: fetchCarBrands(),
                                                builder: (BuildContext
                                                        context,
                                                    AsyncSnapshot<
                                                            List<CarBrands>>
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
                                                            style: BorderStyle
                                                                .solid,
                                                            width: 0.80),
                                                      ),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                              child: DropdownButton<
                                                                      CarBrands>(
                                                                  icon:
                                                                      Padding(
                                                                    child: Icon(
                                                                        Icons
                                                                            .branding_watermark),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'IRANSans',
                                                                      color: Colors
                                                                          .black54),
                                                                  items: snapshot
                                                                      .data
                                                                      .map((carBrand) =>
                                                                          DropdownMenuItem<
                                                                              CarBrands>(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: <Widget>[
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(right: 30.0),
                                                                                  child: new Text(
                                                                                    carBrand.name,
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'IRANSans',
                                                                                      fontSize: 12.0,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            value: carBrand,
                                                                          ))
                                                                      .toList(),
                                                                  onChanged:
                                                                      (CarBrands value) {
                                                                    setState(
                                                                        () {
                                                                      _carBrandHint =
                                                                          value.name;
                                                                      carBrandId =
                                                                          value.id;
                                                                      __typeOfCarFuture = fetchTypeOfCar(
                                                                          carBrandId,
                                                                          carGroupId);
                                                                      print("addcar:" +
                                                                          carBrandId +
                                                                          "  " +
                                                                          carGroupId);

                                                                      print(
                                                                          carBrandId);
                                                                      print(
                                                                          carGroupId);
                                                                    });
                                                                  },
                                                                  isExpanded:
                                                                      true,
                                                                  hint:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    child:
                                                                        Text(
                                                                      _carBrandHint,
                                                                    ),
                                                                  ))
                                                          )
                                                  );
                                                }),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: FutureBuilder<List<TypeOfCar>>(
                                            future: __typeOfCarFuture,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<TypeOfCar>>
                                                    snapshot) {
                                              if (!snapshot.hasData)
                                                return LinearProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                              Color>(
                                                          CustomColors
                                                              .BlueDark),
                                                );
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                        color: Colors.blueGrey,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 0.80),
                                                  ),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                                  TypeOfCar>(
                                                              icon: Padding(
                                                                child: Icon(Icons
                                                                    .branding_watermark),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                              ),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'IRANSans',
                                                                  color: Colors
                                                                      .black54),
                                                              items: snapshot
                                                                  .data
                                                                  .map((typeOfCar) =>
                                                                      DropdownMenuItem<
                                                                          TypeOfCar>(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: 30.0),
                                                                              child: new Text(
                                                                                typeOfCar.name,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'IRANSans',
                                                                                  fontSize: 12.0,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        value:
                                                                            typeOfCar,
                                                                      ))
                                                                  .toList(),
                                                              onChanged:
                                                                  (TypeOfCar
                                                                      value) {
                                                                setState(() {
                                                                  _typeOfCarHint =
                                                                      value
                                                                          .name;
                                                                  print(
                                                                      _typeOfCarHint);
                                                                  typeOfCarId =
                                                                      value.id;
                                                                  __carModelFuture = fetchCarModel(
                                                                      carBrandId,
                                                                      carGroupId,
                                                                      typeOfCarId);
                                                                });
                                                              },
                                                              isExpanded: true,
                                                              hint: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child: Text(
                                                                  _typeOfCarHint,
                                                                ),
                                                              )
                                                          )
                                                      )
                                              );
                                            }),
                                      ),
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: FutureBuilder<List<CarModel>>(
                                            future: __carModelFuture,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<CarModel>>
                                                    snapshot) {
                                              if (!snapshot.hasData)
                                                return LinearProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                              Color>(
                                                          CustomColors
                                                              .BlueDark),
                                                );
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                        color: Colors.blueGrey,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 0.80),
                                                  ),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                                  CarModel>(
                                                              icon: Padding(
                                                                child: Icon(Icons
                                                                    .branding_watermark),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                              ),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'IRANSans',
                                                                  color: Colors
                                                                      .black54),
                                                              items: snapshot
                                                                  .data
                                                                  .map((carModel) =>
                                                                      DropdownMenuItem<
                                                                          CarModel>(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: 30.0),
                                                                              child: new Text(
                                                                                carModel.name,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'IRANSans',
                                                                                  fontSize: 12.0,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        value:
                                                                            carModel,
                                                                      ))
                                                                  .toList(),
                                                              onChanged:
                                                                  (CarModel
                                                                      value) {
                                                                setState(() {
                                                                  _carModelHint =
                                                                      value
                                                                          .name;
                                                                  print(
                                                                      _carModelHint);
                                                                  carModelId =
                                                                      value.id;
                                                                });
                                                              },
                                                              isExpanded: true,
                                                              hint: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child: Text(
                                                                  _carModelHint,
                                                                ),
                                                              ))));
                                            }),
                                      ),
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: FutureBuilder<List<CarColors>>(
                                            future: fetchCarColors(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<CarColors>>
                                                    snapshot) {
                                              print("colors : " +
                                                  snapshot.data.toString());
                                              if (!snapshot.hasData)
                                                return LinearProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                              Color>(
                                                          CustomColors
                                                              .BlueDark),
                                                );
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                        color: Colors.blueGrey,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 0.80),
                                                  ),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                                  CarColors>(
                                                              icon: Padding(
                                                                child: Icon(Icons
                                                                    .branding_watermark),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                              ),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'IRANSans',
                                                                  color: Colors
                                                                      .black54),
                                                              items: snapshot
                                                                  .data
                                                                  .map((carcolor) =>
                                                                      DropdownMenuItem<
                                                                          CarColors>(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding: EdgeInsets.only(right: 30.0),
                                                                              child: new Text(
                                                                                carcolor.name,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'IRANSans',
                                                                                  fontSize: 12.0,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        value:
                                                                            carcolor,
                                                                      ))
                                                                  .toList(),
                                                              onChanged:
                                                                  (CarColors value) {
                                                                setState(() {
                                                                  _carColorHint =
                                                                      value
                                                                          .name;
                                                                  carColorId =
                                                                      value.id;
                                                                  print(
                                                                      _carColorHint);
                                                                  print(
                                                                      carColorId);
                                                                });
                                                              },
                                                              isExpanded: true,
                                                              hint: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                child: Text(
                                                                  _carColorHint,
                                                                ),
                                                              )
                                                          )
                                                      )
                                              );
                                            }),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      ViewHelper.pelak(
                                          context,
                                          platenumber1,
                                          platenumber2,
                                          platenumber3,
                                          platenumber4),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      _submitButton(size),
                                    ],
                                  ),
                                ))),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
                          title: 'qwq',
                          name: _name,
                          lastName: _lastName,
                          customerID: _customer_id,
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

  Widget _submitButton(Size size){
    return GestureDetector(
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.all(
            Radius.circular(5.0)),
        child: Container(
          width: size.width,
          height: size.height * .08,
          padding: EdgeInsets.symmetric(
              vertical: size.height * .01),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green,
              borderRadius: BorderRadius.all(
                  Radius.circular(5))),
          child: Text(
            'ثبت خودرو',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'IRANSans'),
          ),
        ),
      ),
      onTap: () {
        List<String> plate = [];
        plate.add(platenumber1.text);
        plate.add(platenumber2.text);
        plate.add(platenumber3.text);
        plate.add(platenumber4.text);
        print(platenumber1.text);
        print(platenumber2.text);
        print(platenumber3.text);
        print(platenumber4.text);
        print(plate.toString());
        addMyCar(
            context,
            _customer_id,
            carModelId,
            carBrandId,
            carGroupId,
            typeOfCarId,
            plate.toString(),
            carColorId,
            production_year.text.toString(),
            vinnumber.text.toString());
      },
    );
  }

  Widget _textFormField(Size size, TextEditingController controller, lable,
      double w, double h, bool numeric, int maxLines, bool enable,
      [mask, maskEnable]) {
    return Container(
      height: size.height * h,
      width: size.width * w,
      color: Colors.white,
      child: TextField(
        textInputAction: TextInputAction.done,
        inputFormatters: (maskEnable) ? [mask] : null,
        enabled: enable,
        textAlign: TextAlign.center,
        keyboardType: (numeric) ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.grey[50],
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(6.0),
            borderSide: new BorderSide(
              color: Colors.black45,
            ),
          ),
          disabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
              color: Color(0xff290d66),
            ),
          ),
          filled: true,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.deepOrangeAccent)),
          labelText: lable,
          labelStyle: TextStyle(
              fontFamily: 'IRANSans', color: Colors.black, fontSize: 14.0),
        ),
      ),
    );
  }

  Future<void> addMyCar(
      BuildContext context,
      _customer_id,
      carModelId,
      carBrandId,
      carGroupId,
      typeOfCarId,
      platenumber,
      carColorId,
      production_year,
      vinnumber) async {
    showLoadingDialog();
    makePostRequestAmin(
        CustomStrings.API_ROOT + 'Customers/Cars/CustomerCars.php', {
      'api_type': 'add',
      'customer_id': _customer_id,
      'car_model_id': carModelId,
      'car_brand_id': carBrandId,
      'car_group_id': carGroupId,
      'car_name_id': typeOfCarId,
      'plaque': platenumber,
      'color_id': carColorId,
      'production_date': production_year,
      'vin_number': vinnumber
    }).then((value) {
      if (value['result'] == 'success') {
        hideLoadingDialog();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.downToUp,
                child: SuccessPage('خودرو جدید با موفقیت اضافه شد !' , widget.name , widget.lastName , 1)));
        print('amin');
      }
    });
  }

}

