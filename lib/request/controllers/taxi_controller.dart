import 'package:samannegarusers/request/models/taxi.dart';
import 'package:samannegarusers/request/models/taxi_type.dart';

class TaxiController {
  static Future<List<Taxi>> getTaxis() async {
    return [
      Taxi.named(
          plateNo: "",
          isAvailable: true,
          id: "1",
          title: "Standard"),
      Taxi.named(
          plateNo: "",
          isAvailable: true,
          id: "2",
          title: "Premium"),
      Taxi.named(
          plateNo: "",
          isAvailable: true,
          id: "3",
          title: "Standard"),
    ];
  }
}
