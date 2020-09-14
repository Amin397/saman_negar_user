import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';


class TypeOfInsurance{

   String id;
   String name;

   TypeOfInsurance({this.name, this.id });

  factory TypeOfInsurance.fromJson(Map<String, dynamic> json) {
    return TypeOfInsurance(
        id: json['insurance_type_id'],
        name: json['insurance_name'],
    );
  }

   @override
   String toString() {
     return this.name ;
   }

}

Future<List<TypeOfInsurance>> fetchInsuranceType() async {
  var data = await makePostRequest(CustomStrings.API_ROOT  + 'BaseTables/Colors/Colors.php', {});
  final items =
  json.decode(data.content()).cast<Map<String, dynamic>>();
  List<TypeOfInsurance> listOfInsuranceType = items.map<TypeOfInsurance>((json) {
    return TypeOfInsurance.fromJson(json);
  }).toList();
  print("listOfColors: "+listOfInsuranceType.toString());
  return listOfInsuranceType;
}