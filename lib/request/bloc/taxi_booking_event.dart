import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:samannegarusers/request/models/google_location.dart';
import 'package:samannegarusers/request/models/payment_method.dart';
import 'package:samannegarusers/request/models/taxi_type.dart';

abstract class TaxiBookingEvent extends Equatable {
  TaxiBookingEvent();
}

class TaxiBookingStartEvent extends TaxiBookingEvent {


  @override
  List<Object> get props => null;

}

class DestinationSelectedEvent extends TaxiBookingEvent {
  final String requesttype;
  final GoogleLocation location;

  DestinationSelectedEvent({
    @required this.requesttype,
    @required this.location
  });

  @override
  List<Object> get props => [requesttype,location];
}

class DetailsSubmittedEvent extends TaxiBookingEvent {
//  final GoogleLocation source;
  final String adress;
//  final int noOfPersons;
//  final DateTime bookingTime;

  DetailsSubmittedEvent(
      {
//      @required this.source,
      @required this.adress,
//      @required this.noOfPersons,
//      @required this.bookingTime
      });

  @override
  List<Object> get props => [
//    source,
    adress
//    noOfPersons, bookingTime
    ];
}

class TaxiSelectedEvent extends TaxiBookingEvent {
  final GoogleLocation source;
  final String bookingTime;
  final String bookingDate;
  final String accidentType;

  TaxiSelectedEvent({
    @required this.source,
    @required this.bookingTime,
    @required this.bookingDate,
    @required this.accidentType,
  });

  @override
  List<Object> get props => [
    source,
    bookingTime,
    bookingDate,
    accidentType
  ];
}

class PaymentMadeEvent extends TaxiBookingEvent {
  final PaymentMethod paymentMethod;

  PaymentMadeEvent({@required this.paymentMethod});

  @override
  List<Object> get props => [paymentMethod];
}

class BackPressedEvent extends TaxiBookingEvent {
  @override
  List<Object> get props => null;
}

class TaxiBookingCancelEvent extends TaxiBookingEvent {
  @override
  List<Object> get props => null;
}
