import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:samannegarusers/Helper/ViewHelper.dart';
import 'package:samannegarusers/dashboard/cars/carsList.dart';
import 'package:samannegarusers/dashboard/cars/models/carBrands.dart';
import 'package:samannegarusers/dashboard/cars/models/carColors.dart';
import 'package:samannegarusers/dashboard/cars/models/carGroups.dart';
import 'package:samannegarusers/dashboard/cars/models/carModel.dart';
import 'package:samannegarusers/dashboard/cars/models/typeOfCar.dart';
import 'package:samannegarusers/dashboard/home.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/insurance_list.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/models/insurance_branch.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/models/insurance_companey.dart';
import 'package:samannegarusers/dashboard/insuranceAndValue/models/type_of_insurance.dart';
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

class AddInsurance extends StatefulWidget {

  AddInsurance({Key key, this.title, this.name, this.lastName, this.customerID})
      : super(key: key);

  String title;
  String name;
  String lastName;
  String customerID;

  @override
  _AddInsuranceState createState() => _AddInsuranceState();
}

class _AddInsuranceState extends State<AddInsurance> with TickerProviderStateMixin {


  MenuController menuController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  var insurance;
  final List dismissControllers = [];
  String _name = 'کاربر';
  String _lastName = 'گرامی';
  var complainData;
  String _customer_id = '0';

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

  MaskTextInputFormatter max_khesarat_formatter =
  new MaskTextInputFormatter(mask: '###,###,###,###,###,###,###,###', filter: {"#": RegExp(r'[0-9]')});

  String insuranceTypeId = '0';
  String _insuranceTypeHint = 'گروه بیمه نامه';
  String insuranceCompanyId = '0';
  String _insuranceCompanyHint = 'نام شرکت بیمه نامه';
  String _insuranceCompanyBranchId = '0';
  String _insuranceCompanyBranchHint = 'لطفا شعبه بیمه را انتخاب نمایید';
  Future _insuranceType = fetchInsuranceType();
  Future _insuranceCompany = fetchInsuranceCompany();
  Future __insuranceCompanyBranch = fetchInsuranceBranch('0');

  String startDateInsurance = '';
  String endDateInsurance = '';

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
                CustomScrollView(
                  slivers: <Widget>[
                    SliverFillRemaining(
                      child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                SizedBox(
                                  height: 20.0,
                                ),
                                _textFormField(
                                    size,
                                    vinnumber,
                                    'سقف میزان پرداخت خسارت جانی (ريال)',
                                    1,
                                    .075,
                                    true,
                                    1,
                                    true,
                                    max_khesarat_formatter,
                                    false),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _textFormField(
                                    size,
                                    production_year,
                                    'سقف میزان پرداخت خسارت (ريال)',
                                    1,
                                    .075,
                                    true,
                                    1,
                                    true,
                                    max_khesarat_formatter,
                                    true),
                                SizedBox(
                                  height: 20.0,
                                ),
                                ViewHelper.insuranceDatePicker(context, startDateInsurance, (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext _) {
                                      return  PersianDateTimePicker(
                                        initial: '1398/03/20 19:50',
                                        type: 'datetime',
                                        onSelect: (date) {
                                          setState(() {
                                            startDateInsurance = date;
                                          });
                                        },
                                      );
                                    },
                                  );
                                } , 'تاریخ شروع بیمه نامه' , Colors.greenAccent , true),
                                SizedBox(
                                  height: 20.0,
                                ),
                                ViewHelper.insuranceDatePicker(context, endDateInsurance, (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext _) {
                                      return  PersianDateTimePicker(
                                        initial: '1398/03/20 19:50',
                                        type: 'datetime',
                                        onSelect: (date) {
                                          setState(() {
                                            endDateInsurance = date;
                                          });
                                        },
                                      );
                                    },
                                  );
                                } , 'تاریخ اتمام بیمه نامه' , Colors.redAccent , false),
                                SizedBox(
                                  height: 25.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: FutureBuilder<List<TypeOfInsurance>>(
                                          future: _insuranceType,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<TypeOfInsurance>>
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
                                                        TypeOfInsurance>(
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
                                                            .map((insuranceType) =>
                                                            DropdownMenuItem<
                                                                TypeOfInsurance>(
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
                                                                      insuranceType.name,
                                                                      style: TextStyle(
                                                                        fontFamily: 'IRANSans',
                                                                        fontSize: 12.0,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              value: insuranceType,
                                                            ))
                                                            .toList(),
                                                        onChanged:
                                                            (TypeOfInsurance value) {
                                                          setState(() {
                                                            _insuranceTypeHint =
                                                                value
                                                                    .name;
                                                            print(
                                                                _insuranceTypeHint);
                                                            insuranceTypeId =
                                                                value.id;
                                                            // __insuranceCompanyBranch = fetchInsuranceBranch(
                                                            //     insuranceCompany,
                                                            //     insuranceTypeId,
                                                            //     insuranceCompanyBranch);
                                                          });
                                                        },
                                                        isExpanded: true,
                                                        hint: Padding(
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                              10.0),
                                                          child: Text(
                                                            _insuranceTypeHint,
                                                          ),
                                                        )
                                                    )
                                                )
                                            );
                                          }),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Flexible(
                                      child: FutureBuilder<List<InsuranceCompany>>(
                                          future: _insuranceCompany,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<InsuranceCompany>>
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
                                                        InsuranceCompany>(
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
                                                            .map((insuranceCompany) =>
                                                            DropdownMenuItem<
                                                                InsuranceCompany>(
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
                                                                    child: new Text(insuranceCompany.companyName ,
                                                                      style: TextStyle(
                                                                        fontFamily: 'IRANSans',
                                                                        fontSize: 12.0,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              value:
                                                              insuranceCompany,
                                                            ))
                                                            .toList(),
                                                        onChanged:
                                                            (InsuranceCompany
                                                        value) {
                                                          setState(() {
                                                            _insuranceCompanyHint =
                                                                value
                                                                    .companyName;

                                                            insuranceCompanyId =
                                                                value.insuranceCompanyId;

                                                            __insuranceCompanyBranch = fetchInsuranceBranch(insuranceCompanyId);
                                                          });
                                                        },
                                                        isExpanded: true,
                                                        hint: Padding(
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                              10.0),
                                                          child: Text(
                                                            _insuranceCompanyHint,
                                                          ),
                                                        )
                                                    )
                                                )
                                            );
                                          }),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),
                                FutureBuilder<List<InsuranceBranch>>(
                                    future: __insuranceCompanyBranch,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<InsuranceBranch>>
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
                                                  InsuranceBranch>(
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
                                                      .map((insuranceBranch) =>
                                                      DropdownMenuItem<
                                                          InsuranceBranch>(
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
                                                                (insuranceBranch.cBranchName == null) ? 'amin' : insuranceBranch.cBranchName,
                                                                style: TextStyle(
                                                                  fontFamily: 'IRANSans',
                                                                  fontSize: 12.0,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        value:
                                                        insuranceBranch,
                                                      ))
                                                      .toList(),
                                                  onChanged:
                                                      (InsuranceBranch
                                                  value) {
                                                    setState(() {
                                                      _insuranceCompanyBranchHint =
                                                          value
                                                              .cBranchName;
                                                      _insuranceCompanyBranchId =
                                                          value.cBranchId;
                                                    });
                                                  },
                                                  isExpanded: true,
                                                  hint: Padding(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        10.0),
                                                    child: Text(
                                                      _insuranceCompanyBranchHint,
                                                    ),
                                                  ))));
                                    }),
                                SizedBox(
                                  height: size.height * .04,
                                ),
                                _submitButton(size),
                              ],
                            ),
                          )
                      ),
                    ),
                  ],
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
                        child: InsuranceList(
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
                ]))
    );
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
            'ثبت بیمه نامه',
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
        print(plate.toString());
        addMyInsurance();
      },
    );
  }

  Future<void> addMyInsurance() async {
    showLoadingDialog();
    makePostRequestAmin(
        CustomStrings.API_ROOT + 'Customers/Cars/CustomerCars.php', {
      'api_type': 'add',
      'customer_id': _customer_id,
    }).then((value) {
      if (value['result'] == 'success') {
        hideLoadingDialog();
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.downToUp,
                child: SuccessPage('بیمه نامه جدید با موفقیت اضافه شد !' , widget.name , widget.lastName , widget.customerID)));
      }
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
}
