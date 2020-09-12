import 'dart:convert';

import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class TypeOfCar {
  final String id;
  final String name;

  TypeOfCar({this.name, this.id});

  factory TypeOfCar.fromJson(Map<String, dynamic> json) {
    return TypeOfCar(
      id: json['type_of_car_id'],
      name: json['title'],
    );
  }

  @override
  String toString() {
    return this.name;
  }
}

Future<List<TypeOfCar>> fetchTypeOfCar(brand_id, car_group_id) async {
  var data = await makePostRequest(
      CustomStrings.API_ROOT + 'BaseTables/carDefine/CarModel/CarModel.php', {
    'api_type': 'getTypeOfCar',
    'brand_id': brand_id,
    'car_group_id': car_group_id
  });
  print(data.content());
  final items = json.decode(data.content()).cast<Map<String, dynamic>>();
  List<TypeOfCar> listOfGroup = items.map<TypeOfCar>((json) {
    return TypeOfCar.fromJson(json);
  }).toList();
  return listOfGroup;
}
