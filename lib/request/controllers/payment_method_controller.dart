import 'dart:async';

import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:samannegarusers/request/models/payment_method.dart';

class PaymentMethodController {
  static Future<List<PaymentMethod>> getMethods() async {
    String customer_id = await getPref('customer_id');
    var res = await makePostRequest(CustomStrings.CUSTOMERS, {
      'api_type': 'getCars',
      'customer_id': customer_id != null ? customer_id : '0',
      'request' : 'app'
    });
    print("PaymentMethodController"+res.content());
    var data = res.json();
    List<PaymentMethod> output = [];
    data.forEach((data) {
      output.add(PaymentMethod(
          id: data['customer_car_id'],
          title: data['title'] ,
          icon:
              'https://icon-library.net/images/mastercard-icon-png/mastercard-icon-png-28.jpg',
          description: data['text']));
    });
    Completer completer = new Completer<List<PaymentMethod>>();
    completer.complete(output);
    return completer.future;
  }
}
