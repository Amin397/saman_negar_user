
import 'dart:convert';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class CarInsurance{

  String car_name;
  String car_id;

  CarInsurance({this.car_name, this.car_id});

  factory CarInsurance.fromJson(Map<String, dynamic> json) {
    return CarInsurance(
      car_id: json['customer_car_id'],
      car_name: json['title'],
    );
  }

  @override
  String toString() {
    return this.car_name ;
  }
}

// Future<List<CarInsurance>> fetchCars(customerID) async {
//   var data = await makePostRequest('${CustomStrings.CUSTOMERS}', {
//     'customer_id': customerID,
//     'api_type': 'getCars',
//     'request': 'app'
//   });
//   final items =
//   json.decode(data.content()).cast<Map<String, dynamic>>();
//   List<CarInsurance> listOfInsuranceType = items.map<CarInsurance>((json) {
//     return CarInsurance.fromJson(json);
//   }).toList();
//   return listOfInsuranceType;
// }

Future<List<CarInsurance>> fetchInsuranceCar(customerID) async {
  var data = await makePostRequest(CustomStrings.CUSTOMERS,{
    'customer_id': customerID,
    'api_type': 'getCars',
    'request': 'app'
  });
  final items =
  json.decode(data.content()).cast<Map<String, dynamic>>();
  List<CarInsurance> listOfInsuranceType = items.map<CarInsurance>((json) {
    return CarInsurance.fromJson(json);
  }).toList();
  return listOfInsuranceType;
}
