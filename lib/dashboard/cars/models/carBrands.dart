import 'dart:convert';

import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class CarBrands {
  final String id;
  final String name;

  CarBrands({this.name, this.id});

  factory CarBrands.fromJson(Map<String, dynamic> json) {
    return CarBrands(
      id: json['car_brand_id'],
      name: json['title'],
    );
  }

  @override
  String toString() {
    return this.name;
  }
}

Future<List<CarBrands>> fetchCarBrands() async {
  var data = await makePostRequest(CustomStrings.API_ROOT  + 'BaseTables/carDefine/CarBrands/CarBrands.php', {});
  final items =
  json.decode(data.content()).cast<Map<String, dynamic>>();
  List<CarBrands> listOfGroup = items.map<CarBrands>((json) {
    return CarBrands.fromJson(json);
  }).toList();
  return listOfGroup;
}
