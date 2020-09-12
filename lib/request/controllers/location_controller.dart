import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:requests/requests.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:samannegarusers/request/models/google_location.dart';

class LocationController {
  static Future<GoogleLocation> getCurrentLocation(
      {bool doAddress = false}) async {
    var currentLocation = await getLocation();
    print("LocationController currentlocation: " + currentLocation.toString());
    doAddress = true;
    var r;
    if (doAddress) {
      var res = await Requests.get('https://map.ir/reverse?lat=${currentLocation
          .latitude}&lon=${currentLocation
          .longitude}&x-api-key=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjM1MGYxNDc0YjI1MjRkNTQyOGI0OTQ4MTk5ZjQzMDhlOTc2NTQ2OGNmMGFmMTFiNjhmNmQ4Njg2MWZiNmFmZTY5NjM2ODZlODE5MzJhMzYxIn0.eyJhdWQiOiI4NzY4IiwianRpIjoiMzUwZjE0NzRiMjUyNGQ1NDI4YjQ5NDgxOTlmNDMwOGU5NzY1NDY4Y2YwYWYxMWI2OGY2ZDg2ODYxZmI2YWZlNjk2MzY4NmU4MTkzMmEzNjEiLCJpYXQiOjE1ODcyMjg1OTcsIm5iZiI6MTU4NzIyODU5NywiZXhwIjoxNTg5ODIwNTk3LCJzdWIiOiIiLCJzY29wZXMiOlsiYmFzaWMiXX0.rSOnvFM_G9KdlBOAwWT3dIf_XLtwOc6HlgxrpeyuB_msnp7kwAxD56mAzilsMgtmIq4ZZfUp1iupqfseqYb9QFke1kEk4E6aG3-Y1axGNQRKToEacX0X6aGCnH5SQki0fS1fkLrTnZOEgVpaIzb1ztBPCLsIncal9BWoY_RBUNyf0ZvEDL8gS2i9pvhGipjZxOjt4KjHlFkszyWMs0ZDwmr6oVYSgiVpngPY7g1sKeh-5IWZleUqJIhKKUuVvk-hUDjq7I8cDFEXh0hHT64H8p1HsnzXUdO236f1knL8PZ-ilrUp_jpN7mtodRfphFQuR0WEmL_UuhTWUeW6aL9xpQ');
      r = res.json();
    }

    return GoogleLocation("AIzaSyBfAsunUGq0jsgNBM2QilvgZKus3Ax-PXs",
        LatLng(currentLocation.latitude, currentLocation.longitude),
        doAddress ? r['address'].toString() : 'تست');

  }

  static Future<GoogleLocation> getLocationfromId(LatLng position) async {
    return GoogleLocation("AIzaSyBfAsunUGq0jsgNBM2QilvgZKus3Ax-PXs",
        LatLng(40.747092, 53.987013), "20 W 34th St, New York, NY 10001, USA");
  }

  static Future<List<LatLng>> getPolylines(LatLng start, LatLng end) async {
    var data = await makePostRequest('${CustomStrings.Experts}',
        {'api_type': 'getActives'});

    print("getNearExperts:  " + data.json().toString());
    if (data.json() != null) {
      var expertlist = data.json();
      print("getNearExperts indide:  " + expertlist[0]['lat']);

      List<Map> map = [
        {"lat": 40.7835246, "lang": 53.9651392},
        {"lat": 40.74700869999999, "lang": 53.9870749},
        {"lat": 40.7836479, "lang": 53.96495809999999},
        {"lat": 40.78148909999999, "lang": 53.9627453},

      ];
//      map.addAll(expertlist[0]);
      print(map.map((val) => LatLng(val["lat"], val["lang"]))
          .toList()
          .toString());
      return map.map((val) => LatLng(val["lat"], val["lang"])).toList();
    }
  }

}
