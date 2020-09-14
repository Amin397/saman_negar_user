import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:samannegarusers/login/constants.dart';

import '../../../funcs.dart';

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
    return Container();
  }
}
