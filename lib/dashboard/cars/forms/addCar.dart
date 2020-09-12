import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/dashboard/cars/carsList.dart';
import 'package:samannegarusers/dashboard/cars/forms/addCar.dart';
import 'package:samannegarusers/dashboard/cars/models/carBrands.dart';
import 'package:samannegarusers/dashboard/cars/models/carColors.dart';
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
import 'package:shimmer/shimmer.dart';

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
  String _customer_id = '0';

  Future<void> setData() async {
    showLoadingDialog(tapDismiss: false);
    var res = await makePostRequest(CustomStrings.CUSTOMERS,
        {'customer_id': await getPref('customer_id'),
          'api_type': 'get' ,
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
                    slivers: <Widget>[SliverFillRemaining(
                      child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child:  Directionality(
                              textDirection: TextDirection.rtl,
                              child: Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: TextField(
                                            inputFormatters: [
                                              production_year_formatter
                                            ],
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'تاریخ تولید',
                                                labelText: 'سال تولید خودرو'),
                                            controller: production_year,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Flexible(
                                          child: TextField(
                                            textDirection: TextDirection.rtl,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: ' vin',
                                                labelText: ' شماره vin'),
                                            controller: vinnumber,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    new Row(

                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child:Directionality(
                                            textDirection: TextDirection.rtl,
                                            child:
                                            FutureBuilder<List<CarGroups>>(
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
                                                            style:
                                                            BorderStyle
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
                                                                  Icons.drive_eta),
                                                              padding:
                                                              EdgeInsets.all(10.0),
                                                            ),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'IRANSans',
                                                                color: Colors
                                                                    .black54),
                                                            items: snapshot

                                                              .data
                                                              .map((carGroup) => DropdownMenuItem<
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
                                                                    print(
                                                                        carBrandId);
                                                                    __typeOfCarFuture = fetchTypeOfCar(
                                                                        carBrandId,
                                                                        carGroupId);
                                                                    __carModelFuture = fetchCarModel(
                                                                        carBrandId,
                                                                        carGroupId,
                                                                        "0");
                                                                    _carGroupHint =
                                                                        value.name;
                                                                    carGroupId =
                                                                        value.id;
                                                                  });
                                                            },
                                                            isExpanded:
                                                            true,
                                                            hint:
                                                            Padding(
                                                              padding:
                                                              EdgeInsets.all(10.0),

                                                              child:
                                                              Text(
                                                              _carGroupHint,
                                                            ),
                                                          ))));
                                                }),
                                          ) ,
                                        )
                                        ,
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Flexible(
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child:
                                            FutureBuilder<List<CarBrands>>(
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
                                                            style:
                                                            BorderStyle
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
                                                                      Icons.branding_watermark),
                                                                  padding:
                                                                  EdgeInsets.all(10.0),

                                                              ),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  'IRANSans',
                                                                  color: Colors
                                                                      .black54),
                                                              items: snapshot
                                                                  .data
                                                                  .map((carBrand) => DropdownMenuItem<
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
                                                                  (CarBrands
                                                              value) {
                                                                setState(
                                                                        () {
                                                                      _carBrandHint =
                                                                          value.name;
                                                                      carBrandId =
                                                                          value.id;
                                                                      __typeOfCarFuture = fetchTypeOfCar(
                                                                          carBrandId,
                                                                          carGroupId);
                                                                      print("addcar:"  +carBrandId+"  "+carGroupId );

                                                                      print(carBrandId);
                                                                      print(carGroupId);

                                                                    });
                                                              },
                                                              isExpanded:
                                                              true,
                                                              hint:
                                                              Padding(
                                                                padding:
                                                                EdgeInsets.all(10.0),
                                                                child:
                                                                Text(
                                                                  _carBrandHint,
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
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child:
                                      FutureBuilder<List<TypeOfCar>>(
                                          future: __typeOfCarFuture,
                                          builder: (BuildContext
                                          context,
                                              AsyncSnapshot<
                                                  List<TypeOfCar>>
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
                                              child:
                                              DropdownButtonHideUnderline(
                                                  child: DropdownButton<
                                                      TypeOfCar>(
                                                    icon:
                                                    Padding(

                                                        child: Icon(
                                                        Icons.branding_watermark),
                                                    padding:
                                                    EdgeInsets.all(10.0),
                                                  ),
                                                  style: TextStyle(
                                                      fontFamily:
                                                      'IRANSans',
                                                      color: Colors
                                                          .black54),
                                                  items: snapshot
                                                      .data
                                                      .map((typeOfCar) => DropdownMenuItem<
                                                      TypeOfCar>(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: <Widget>[
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
                                                    value: typeOfCar,
                                                  ))
                                                      .toList(),
                                                  onChanged:
                                                      (TypeOfCar
                                                  value) {
                                                    setState(
                                                            () {
                                                          _typeOfCarHint =
                                                              value.name;
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
                                                  isExpanded:
                                                  true,

                                                  hint:
                                              Padding(
                                              padding:
                                              EdgeInsets.all(10.0),
                                              child:
                                              Text(
                                                _typeOfCarHint,
                                              ),
                                            ))));
                                          }),
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child:
                                      FutureBuilder<List<CarModel>>(
                                          future: __carModelFuture,
                                          builder: (BuildContext
                                          context,
                                              AsyncSnapshot<
                                                  List<CarModel>>
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
                                                child:
                                                DropdownButtonHideUnderline(
                                                    child: DropdownButton<
                                                        CarModel>(
                                                        icon:
                                                        Padding(
                                                          child: Icon(
                                                              Icons.branding_watermark),
                                                          padding:
                                                          EdgeInsets.all(10.0),
                                                        ),
                                                        style: TextStyle(
                                                            fontFamily:

                                                            'IRANSans',
                                                            color: Colors
                                                                .black54),
                                                        items: snapshot
                                                            .data
                                                            .map((carModel) => DropdownMenuItem<
                                                            CarModel>(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: <Widget>[
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
                                                          value: carModel,
                                                        ))
                                                            .toList(),
                                                        onChanged:
                                                            (CarModel
                                                        value) {
                                                          setState(
                                                                  () {
                                                                _carModelHint =
                                                                    value.name;
                                                                print(
                                                                    _carModelHint);
                                                                carModelId =
                                                                    value.id;
                                                              });
                                                        },
                                                        isExpanded:
                                                        true,
                                                        hint:
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.all(10.0),
                                                          child:
                                                          Text(
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
                                      child:
                                      FutureBuilder<List<CarColors>>(
                                          future: fetchCarColors(),
                                          builder: (BuildContext
                                          context,
                                              AsyncSnapshot<
                                                  List<CarColors>>
                                              snapshot) {
                                            print("colors : "+snapshot.data.toString());
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
                                                child:
                                                DropdownButtonHideUnderline(
                                                    child: DropdownButton<
                                                        CarColors>(
                                                      icon:
                                                      Padding(
                                                        child: Icon(
                                                            Icons.branding_watermark),
                                                        padding:
                                                        EdgeInsets.all(10.0),
                                                      ),
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'IRANSans',
                                                          color: Colors
                                                              .black54),
                                                      items: snapshot
                                                          .data
                                                          .map((carcolor) => DropdownMenuItem<
                                                          CarColors>(
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            crossAxisAlignment: CrossAxisAlignment.end,

                                                            children: <Widget>[
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
                                                      value: carcolor,
                                                    ))
                                                    .toList(),
                                                onChanged:
                                                    (CarColors
                                                value) {
                                                  setState(
                                                          () {
                                                        _carColorHint =
                                                            value.name;
                                                        carColorId =
                                                            value.id;
                                                        print(_carColorHint);
                                                        print(carColorId);

                                                      });
                                                },
                                                isExpanded:
                                                true,
                                                hint:
                                                Padding(
                                                  padding:
                                                  EdgeInsets.all(10.0),
                                                  child:
                                                  Text(
                                                    _carColorHint,
                                                  ),
                                                ))));
                                          }),
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                    ),
//                                    TextField(
//                                      textAlign: TextAlign.right,
//                                      textDirection: TextDirection.rtl,
//                                      decoration: InputDecoration(
//                                          border: OutlineInputBorder(),
//                                          hintText: ' پلاک',
//                                          labelText: ' شماره پلاک خودرو'),
//                                      controller: platenumber,
//                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 50 ,left: 50),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blueAccent)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width/6,
                                              height:87,
                                              margin: EdgeInsets.only(top: 10,bottom: 10,right: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blueAccent)
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Text("ایران",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'IRANSans'),
                                                  ),
                                                  TextField(
                                                    textAlign: TextAlign.center,
                                                    style:TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'IRANSans'),
                                                    textDirection: TextDirection.rtl,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      hintText: ' 11',
                                                    ),
                                                    controller: platenumber4,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width/6,
                                              height:87,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blueAccent)
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(""
                                                  ),
                                                  TextField(
                                                    textAlign: TextAlign.center,
                                                    style:TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'IRANSans'),
                                                    textDirection: TextDirection.rtl,
                                                    decoration: InputDecoration(
                                                      hintText: ' 111',
                                                    ),
                                                    controller: platenumber3,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                           flex: 3,
                                           child:  Container(
                                             width: MediaQuery.of(context).size.width/6,
                                             height:87,
                                             decoration: BoxDecoration(
                                                 border: Border.all(color: Colors.blueAccent)
                                             ),
                                             child: Column(
                                               children: <Widget>[
                                                 Text(""
                                                 ),
                                                 TextField(
                                                   textAlign: TextAlign.center,
                                                   style:TextStyle(
                                                       fontSize: 22,
                                                       fontWeight: FontWeight.w600,
                                                       fontFamily: 'IRANSans'),
                                                   textDirection: TextDirection.rtl,
                                                   decoration: InputDecoration(
                                                     hintText: ' الف',
                                                   ),
                                                   controller: platenumber2,
                                                 )
                                               ],
                                             ),
                                           ),
                                         ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width/6,
                                              height:87,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blueAccent)
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(""
                                                  ),
                                                  TextField(
                                                    textAlign: TextAlign.center,
                                                    style:TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'IRANSans'),
                                                    textDirection: TextDirection.rtl,
                                                    decoration: InputDecoration(
                                                      hintText: ' 11',
                                                    ),
                                                    controller: platenumber1,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                                height: 86,
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.blueAccent)
                                                ),
                                                child: Image.asset("images/carplate.jpeg" ,)
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25.0,
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
                                      onTap: (){
                                        List<String> plate = [];
                                        plate.add( platenumber1.text );
                                        plate.add( platenumber2.text );
                                        plate.add( platenumber3.text );
                                        plate.add( platenumber4.text );
                                        print( platenumber1.text );
                                        print( platenumber2.text );
                                        print( platenumber3.text );
                                        print( platenumber4.text );
                                        print(plate.toString());
                                        addMyCar(
                                            _customer_id,
                                            carModelId,
                                            carBrandId,
                                            carGroupId,
                                            typeOfCarId,
                                            plate.toString(),
                                            carColorId,

                                            production_year.text.toString(),
                                        vinnumber.text.toString()
                                        );
                                        },
                                    )
                                  ],
                                ),
                              ))),
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
}

Future<void> addMyCar(_customer_id,carModelId,carBrandId,carGroupId,typeOfCarId,platenumber,
    carColorId,production_year,vinnumber) async {
  var addcar = await makePostRequest(
      CustomStrings.API_ROOT + 'Customers/Cars/CustomerCars.php', {
    'api_type': 'add',
    'customer_id': _customer_id,
    'car_model_id': carModelId,
    'car_brand_id': carBrandId,
    'car_group_id': carGroupId,
    'car_name_id': typeOfCarId,
    'plaque' : platenumber,
    'color_id' : carColorId,
    'production_date' : production_year,
    'vin_number': vinnumber
  });
  print(addcar.content().toString());
}