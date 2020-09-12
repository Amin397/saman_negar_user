import 'dart:convert';

import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class Cities {
  final String id;
  final String name;

  Cities({this.name, this.id});

  factory Cities.fromJson(Map<String, dynamic> json) {
    return Cities(
      id: json['type_of_car_id'],
      name: json['title'],
    );
  }

  @override
  String toString() {
    return this.name;
  }
}

Future<List<Cities>> fetchcities(brand_id) async {
  var data = await makePostRequest(
      CustomStrings.API_ROOT + 'BaseTables/carDefine/CarModel/CarModel.php', {
    'api_type': 'getTypeOfCar',
    'brand_id': brand_id,
    'car_group_id': '3'
  });
  print(data.content());
  final items = json.decode(data.content()).cast<Map<String, dynamic>>();
  List<Cities> listOfGroup = items.map<Cities>((json) {
    return Cities.fromJson(json);
  }).toList();
  return listOfGroup;
}
