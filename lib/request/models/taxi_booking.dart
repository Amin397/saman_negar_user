import 'package:samannegarusers/request/models/payment_method.dart';

import 'google_location.dart';
import 'taxi_type.dart';

class TaxiBooking {
  final String id;
  final GoogleLocation source;
  final String bookingtime;
  final String bookingdate;
  final String adress;
  final String accidentType;
//  final GoogleLocation destination;
  final GoogleLocation location;
//  final int noOfPersons;
//  final DateTime bookingTime;
  final String requesttype;
//  final double estimatedPrice;
  final PaymentMethod paymentMethod;
//  final String promoApplied;

  TaxiBooking(
      this.id,
      this.source,
      this.bookingtime,
      this.bookingdate,
//      this.destination,
      this.requesttype,
      this.location,
      this.adress,
      this.accidentType,
//      this.noOfPersons,
//      this.bookingTime,
//      this.taxiType,
//      this.estimatedPrice,
      this.paymentMethod,
//      this.promoApplied
      );

  TaxiBooking.named({
    this.id,
    this.source,
    this.bookingdate,
    this.bookingtime,
    this.accidentType,
//    this.destination,
    this.requesttype,
    this.location,
    this.adress,
//    this.noOfPersons,
//    this.bookingTime,
//    this.taxiType,
//    this.estimatedPrice,
    this.paymentMethod,
//    this.promoApplied,
  });

  TaxiBooking copyWith(TaxiBooking booking) {
    return TaxiBooking.named(
        id: booking.id ?? id,
        source: booking.source ?? source,
//        destination: booking.destination ?? destination,
      adress: booking.adress ?? adress,
      location: booking.location ?? location,
//        noOfPersons: booking.noOfPersons ?? noOfPersons,
        bookingtime: booking.bookingtime ?? bookingtime,
      accidentType: booking.accidentType ?? accidentType,
      bookingdate: booking.bookingdate ?? bookingdate,
      requesttype: booking.requesttype ?? requesttype,
        paymentMethod: booking.paymentMethod ?? paymentMethod,
//        promoApplied: booking.promoApplied ?? promoApplied,
//        estimatedPrice: booking.estimatedPrice ?? estimatedPrice,
        );
  }
}
