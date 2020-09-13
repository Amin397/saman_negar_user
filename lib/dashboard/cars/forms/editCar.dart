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

class EditCar extends StatefulWidget {
  EditCar({
    Key key,
    this.name,
    this.lastName,
    this.customerID,
    @required this.carId,
    @required this.vin_number,
    @required this.pdate,
    @required this.plaque,
    @required this.carcolorid,
    @required this.carspecs,
    @required this.carGroupId,
    @required this.carBrandId,
    @required this.carModelId,
    @required this.carNameId,
  }) : super(key: key);

  final String name;
  final String lastName;
  final String customerID;
  final String carId;
  final String vin_number;
  final String pdate;
  final String plaque;
  final String carcolorid;
  final String carspecs;
  final String carGroupId;
  final String carBrandId;
  final String carModelId;
  final String carNameId;

  @override
  _EditCarState createState() => new _EditCarState();
}

class _EditCarState extends State<EditCar> with TickerProviderStateMixin {
  MenuController menuController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  _EditCarState();

//  final circularController = FabCircularMenuController();
  var cars;
  final List dismissControllers = [];
  String _name = 'کاربر';
  String _lastName = 'گرامی';
  String carId;
  var complainData;
  String _customer_id ;

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
  void initState() {

    print('${widget.plaque}');


    super.initState();
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
    setState(() {
      _customer_id = widget.customerID;
      vinnumber.text = widget.vin_number;
      production_year.text = widget.pdate;
      platenumber1.text = widget.plaque.substring(1 , 3);
      platenumber2.text = widget.plaque.substring(5 , 6);
      platenumber3.text = widget.plaque.substring(8 , 11);
      platenumber4.text = widget.plaque.substring(13 , 15);
      carModelId = widget.carModelId;
      carBrandId = widget.carBrandId;
      carGroupId = widget.carGroupId;
      typeOfCarId = widget.carNameId;
      carColorId = (widget.carcolorid == null) ? 1 : widget.carcolorid;
    });
    print("editcar plaque :" + widget.plaque.substring(1 , 3));
    print("editcar plaque :" + widget.plaque.substring(5 , 6));
    print("editcar plaque :" +  widget.plaque.substring(8 , 11));
    print("editcar plaque :" + widget.plaque.substring(13 , 15));
    // print("editcar plaque :" + widget.carspecs);
    // print("editcar plaque :" + widget.carspecs.split('-')[2]);
  }

  @override
  Widget build(BuildContext context) {
//    print(":editcar car id :"+ carId);

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
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body: Container(
              width: size.width,
              height: size.height,
              child: Transform.translate(
                offset: new Offset(
                    0.0, size.height * 0.0001),
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
                                      height: 25.0,
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
                                      height: 25.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: ViewHelper.carGroupeFutureId((CarGroups value){
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
                                          }, _carGroupHint) ,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Flexible(
                                          child: ViewHelper.carBrandFutureId((CarBrands value){
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
                                          }, _carBrandHint),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    ViewHelper.typeOfCarFutureId((TypeOfCar value){
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
                                    }, _typeOfCarHint , __typeOfCarFuture),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    _buildCarModelId(),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    ViewHelper.colorFutureId((CarColors value){
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
                                    } , _carColorHint),
                                    // _buildCarColorId(),
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
                                    _acceptContainer(),
                                    SizedBox(
                                      height: 55.0,
                                    ),
                                  ],
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
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
                    print(widget.name);
                    Navigator.of(context).pushReplacement(PageTransition(
                        child: carsList(
                            title: 'qwq',
                            name: widget.name,
                            lastName: widget.lastName,
                            customerID: widget.customerID),
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


  Widget _buildCarModelId(){
    return FutureBuilder<List<CarModel>>(
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
        });
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

  Widget _acceptContainer() {
    return GestureDetector(
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
              fontSize: 14, color: Colors.white, fontFamily: 'IRANSans'),
        ),
      ),
      onTap: () {
        List<String> plate = [];
        plate.add(platenumber1.text);
        plate.add(platenumber2.text);
        plate.add(platenumber3.text);
        plate.add(platenumber4.text);
        addMyCar(
            widget.carId,
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

  Future<void> addMyCar(carId, _customer_id, carModelId, carBrandId, carGroupId,
      typeOfCarId, platenumber, carColorId, production_year, vinnumber) async {
    print("_customer_id" + _customer_id);
    print(carModelId);
    print("carBrandId" + carBrandId);
    print(typeOfCarId);
    print(carGroupId);
    print(platenumber);
    print(carColorId);
    print(production_year);
    print(vinnumber);
    showLoadingDialog();
    var addcar = await makePostRequestAmin(
        CustomStrings.API_ROOT + 'Customers/Cars/CustomerCars.php', {
      'api_type': 'quickEdit',
      'customer_id': _customer_id,
      'customer_car_id': carId,
      'car_model_id': carModelId,
      'car_brand_id': carBrandId,
      'car_group_id': carGroupId,
      'car_name_id': typeOfCarId,
      'plaque': platenumber,
      'color_id': carColorId,
      'production_date': production_year,
      'vin_number': vinnumber
    }).then((value) {
      // print(value.toString());
      if(value['status'] == 'done'){
        hideLoadingDialog();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.downToUp,
                child: SuccessPage('خودرو با موفقیت ویرایش شد !' , widget.name , widget.lastName , widget.customerID)));
      }else{
        print('amin0');
      }
    });
    print(addcar.content().toString());
  }

}

