import 'dart:convert';

import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class InsuranceCompany{

  String insuranceCompanyId;
  String groupOfInsuranceId;
  String companyName;

  InsuranceCompany(
      {this.insuranceCompanyId, this.groupOfInsuranceId, this.companyName});


  factory InsuranceCompany.fromJson(Map<String, dynamic> json) {
    return InsuranceCompany(
      insuranceCompanyId: json['insurance_company_id'],
      groupOfInsuranceId: json['groupOfInsurance_id'],
      companyName:json['companyName']
    );
  }

  @override
  String toString() {
    return this.companyName ;
  }
}

Future<List<InsuranceCompany>> fetchInsuranceCompany() async {
  var data = await makePostRequest(CustomStrings.API_INSURANCE , {
    'api_type' : 'GetCompany'
  });
  final items =
  json.decode(data.content()).cast<Map<String, dynamic>>();
  List<InsuranceCompany> listOfInsuranceType = items.map<InsuranceCompany>((json) {
    return InsuranceCompany.fromJson(json);
  }).toList();
  return listOfInsuranceType;
}