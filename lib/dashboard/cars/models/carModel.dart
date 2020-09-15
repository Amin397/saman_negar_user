import 'dart:convert';

import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class CarModel {

  final String id;
  final String name;

  CarModel({this.name, this.id});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['cid'],
      name: json['title'],
    );
  }

  @override
  String toString() {
    return this.name;
  }
}

Future<List<CarModel>> fetchCarModel(brand_id, car_group_id, typeOfCar_id) async {
  var data = await makePostRequest(
      CustomStrings.API_ROOT + 'BaseTables/carDefine/CarModel/CarModel.php', {
    'api_type': 'getCarModel',
    'brand_id': brand_id,
    'car_group_id': car_group_id,
    'car_name_id': typeOfCar_id
  });
  final items = json.decode(data.content()).cast<Map<String, dynamic>>();
  List<CarModel> listOfGroup = items.map<CarModel>((json) {
    return CarModel.fromJson(json);
  }).toList();
  return listOfGroup;
}
