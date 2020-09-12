import 'dart:convert';

import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class CarColors {
  final String id;
  final String name;
  final String colorcode;

  CarColors({this.name, this.id ,this.colorcode});

  factory CarColors.fromJson(Map<String, dynamic> json) {
    return CarColors(
      id: json['color_id'],
      name: json['color_name'],
      colorcode : json['color_code']
    );
  }

  @override
  String toString() {
    return this.name ;
  }
}

Future<List<CarColors>> fetchCarColors() async {
  var data = await makePostRequest(CustomStrings.API_ROOT  + 'BaseTables/Colors/Colors.php', {});
  final items =
  json.decode(data.content()).cast<Map<String, dynamic>>();
  List<CarColors> listOfColors = items.map<CarColors>((json) {
    return CarColors.fromJson(json);
  }).toList();
  print("listOfColors: "+listOfColors.toString());
  return listOfColors;
}
