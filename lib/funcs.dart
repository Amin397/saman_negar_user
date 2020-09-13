import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:requests/requests.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:permission_handler/permission_handler.dart';

Future<Map> loginCustomer(username, password) async {
  var res = await makePostRequest(CustomStrings.CUSTOMERS,
      {'username': username, 'password': password, 'api_type': 'login'});
  return res.json();
}

Future<Map> signupCustomer(mobile) async {
  var res = await makePostRequest(CustomStrings.CUSTOMERS,
      {'mobile': mobile,  'api_type': 'signup'});
  return res.json();
}

Future<Map> checkedCode(mobile, password) async {
  var res = await makePostRequest(CustomStrings.CUSTOMERS,
      {'mobile': mobile,  'password': password, 'api_type': 'addCustomer'});
  return res.json();
}

// ignore: non_constant_identifier_names
Future<Map> GetCustomer(customerId) async {
  var res = await makePostRequest(CustomStrings.CUSTOMERS,
      {'customer_id': customerId, 'api_type': 'get'});
  return res.json();
}

Future<void> setPref(name, pref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(name, pref);
}

Future<String> getPref(name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(name);
}

Future<dynamic> makePostRequest(String API, Map params) async {
  params['token'] = '199d2addf2da5116b1accafcf4685f128df2ca69';
  return await Requests.post(API, body: params);
}

Future<dynamic> makePostRequestAmin(String API,Map params) async {
  params['token'] = '199d2addf2da5116b1accafcf4685f128df2ca69';
  var res = await Requests.post(API, body: params);
  print(res.content());
  return res.json();
}

Future<dynamic> makenewPostRequest(String API, Map params) async {
  params['api-key'] = '199d2addf2da5116b1accafcf4685f128df2ca69';
  return await Requests.post(API, body: params);
}

Future<PermissionStatus> _getLocationPermission() async {
  final PermissionStatus permission = await LocationPermissions()
      .checkPermissionStatus(level: LocationPermissionLevel.location);

  if (permission != PermissionStatus.granted) {
    final PermissionStatus permissionStatus = await LocationPermissions()
        .requestPermissions(
        permissionLevel: LocationPermissionLevel.location);

    return permissionStatus;
  } else {
    return permission;
  }
}
Future<dynamic> getLocation() async {
  final PermissionStatus permission = await _getLocationPermission();
  if (permission == PermissionStatus.granted) {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  print(position);
    return position;
  }


//  print(await Geolocator().checkGeolocationPermissionStatus());
//  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//  return position;
}

void showInSnackBar(
    BuildContext context, String value, Color color, int secs, _scaffoldKey) {
  FocusScope.of(context).requestFocus(new FocusNode());
  _scaffoldKey.currentState?.removeCurrentSnackBar();
  _scaffoldKey.currentState.showSnackBar(new SnackBar(
    content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontSize: 16.0, fontFamily: "IRANSans"),
    ),
    backgroundColor: color,
    duration: Duration(seconds: secs),
  ));
}
