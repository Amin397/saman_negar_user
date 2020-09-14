class CustomStrings {
  static const API_ROOT = 'https://samannegar.negarine.com/Administrator/APIV1/';
  static const API_INSURANCE = 'https://samannegar.negaapps.ir/Administrator/APIV1/Customers/Insurances/CustomerInsurances.php';
  static const New_API_ROOT = 'https://api.samannegar.negarine.com/v1/user';
  static const CUSTOMERS = '${CustomStrings.API_ROOT}Customers/Customers.php';
  static const GETExperts = '${CustomStrings.API_ROOT}Customers/BaseInfo/Experts/Experts.php';
  static const TypesOfcomplaints = '${CustomStrings.API_ROOT}BaseTables/TypesOfcomplaints/TypesOfcomplaints.php';
  static const RequestExpertise = '${CustomStrings.API_ROOT}RequestExpertise/RequestExpertise/RequestExpertise.php';
  static const Experts = '${CustomStrings.API_ROOT}BaseInfo/Experts/Experts.php';
  static RegExp MOBILE_REGEX = new RegExp(r"^09[0-9]{9,9}$");
}