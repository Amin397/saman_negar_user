import 'dart:convert';

import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class CarGroups {
  final String id;
  final String name;

  CarGroups({this.name, this.id});

  factory CarGroups.fromJson(Map<String, dynamic> json) {
    return CarGroups(
      id: json['car_group_id'],
      name: json['title'],
    );
  }

  @override
  String toString() {
    return this.name ;
  }
}

Future<List<CarGroups>> fetchCarGroups() async {
  var data = await makePostRequest(CustomStrings.API_ROOT  + 'BaseTables/carDefine/CarGroups/CarGroups.php', {});
  final items =
  json.decode(data.content()).cast<Map<String, dynamic>>();
  List<CarGroups> listOfGroup = items.map<CarGroups>((json) {
    return CarGroups.fromJson(json);
  }).toList();
  return listOfGroup;
}
