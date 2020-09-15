import 'dart:convert';

import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';

class InsuranceBranch{

  String cBranchId;
  String cBranchName;

  InsuranceBranch({this.cBranchId, this.cBranchName});

  factory InsuranceBranch.fromJson(Map<String, dynamic> json) {
    return InsuranceBranch(
      cBranchId: json['cbranch_id'],
      cBranchName: json['cbranchName'],
    );
  }

  @override
  String toString() {
    return this.cBranchName ;
  }
}

Future<List<InsuranceBranch>> fetchInsuranceBranch(String insuranceCompanyId) async {
  var data = await makePostRequest(CustomStrings.API_INSURANCE , {
    'api_type': 'GetInsurancebranch',
    'InsuranceCompanyid': insuranceCompanyId
  });
  final items =
  json.decode(data.content()).cast<Map<String, dynamic>>();
  List<InsuranceBranch> listOfInsuranceType = items.map<InsuranceBranch>((json) {
    return InsuranceBranch.fromJson(json);
  }).toList();
  return listOfInsuranceType;
}