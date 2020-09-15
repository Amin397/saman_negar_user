import 'dart:convert';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class TypeOfInsurance{

   String id;
   String name;

   TypeOfInsurance({this.name, this.id });

  factory TypeOfInsurance.fromJson(Map<String, dynamic> json) {
    return TypeOfInsurance(
        id: json['id'],
        name: json['title'],
    );
  }

   @override
   String toString() {
     return this.name ;
   }

}

Future<List<TypeOfInsurance>> fetchInsuranceType() async {
  var data = await makePostRequest(CustomStrings.API_INSURANCE,{
    'api_type': 'GetInsuranceType'
  });
  final items =
  json.decode(data.content()).cast<Map<String, dynamic>>();
  List<TypeOfInsurance> listOfInsuranceType = items.map<TypeOfInsurance>((json) {
    return TypeOfInsurance.fromJson(json);
  }).toList();
  return listOfInsuranceType;
}