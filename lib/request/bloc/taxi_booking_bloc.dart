import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_event.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_state.dart';
import 'package:samannegarusers/request/controllers/location_controller.dart';
import 'package:samannegarusers/request/controllers/payment_method_controller.dart';
import 'package:samannegarusers/request/controllers/taxi_booking_controller.dart';
import 'package:samannegarusers/request/models/google_location.dart';
import 'package:samannegarusers/request/models/payment_method.dart';
import 'package:samannegarusers/request/models/taxi.dart';
import 'package:samannegarusers/request/models/taxi_booking.dart';
import 'package:samannegarusers/request/models/taxi_driver.dart';
import 'package:samannegarusers/request/storage/taxi_booking_storage.dart';

class TaxiBookingBloc extends Bloc<TaxiBookingEvent, TaxiBookingState> {
  @override
  TaxiBookingState get initialState => TaxiBookingNotInitializedState();

  @override
  Stream<TaxiBookingState> mapEventToState(TaxiBookingEvent event) async* {
    if (event is TaxiBookingStartEvent) {
      List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();
      yield TaxiBookingNotSelectedState(taxisAvailable: taxis);
    }
    if (event is DestinationSelectedEvent) {
      TaxiBookingStorage.open();
      yield TaxiBookingLoadingState(
          state: DetailsNotFilledState(booking: null));

      GoogleLocation source = await LocationController.getCurrentLocation();

      await TaxiBookingStorage.addDetails(TaxiBooking.named(
          source: source,
          location: event.location,
          requesttype: event.requesttype
          )
      );
      TaxiBooking taxiBooking = await TaxiBookingStorage.getTaxiBooking();
      yield DetailsNotFilledState(booking: taxiBooking);
    }
    if (event is DetailsSubmittedEvent) {
      yield TaxiBookingLoadingState(state: TaxiNotSelectedState(booking: null));
      await Future.delayed(Duration(seconds: 1));
      await TaxiBookingStorage.addDetails(TaxiBooking.named(
        adress: event.adress,
//        destination: event.destination,
//        noOfPersons: event.noOfPersons,
//        bookingtime: event.bookingtime,
      ));
      TaxiBooking booking = await TaxiBookingStorage.getTaxiBooking();
      yield TaxiNotSelectedState(
        booking: booking,
      );
    }
    if (event is TaxiSelectedEvent) {
      yield TaxiBookingLoadingState(
          state:
              PaymentNotInitializedState(booking: null, methodsAvaiable: []));
      TaxiBooking prevBooking = await TaxiBookingStorage.getTaxiBooking();
      double price = await TaxiBookingController.getPrice(prevBooking);
      await TaxiBookingStorage.addDetails(
          TaxiBooking.named(
              bookingdate : event.bookingDate ,
              bookingtime: event.bookingTime ,
              accidentType: event.accidentType,

          ));
      TaxiBooking booking = await TaxiBookingStorage.getTaxiBooking();
      List<PaymentMethod> methods = await PaymentMethodController.getMethods();
      yield PaymentNotInitializedState(
          booking: booking, methodsAvaiable: methods);
    }
    if (event is PaymentMadeEvent) {
      yield TaxiBookingLoadingState(
          state:
              PaymentNotInitializedState(booking: null, methodsAvaiable: null));
      TaxiBooking booking = await TaxiBookingStorage.addDetails(
          TaxiBooking.named(paymentMethod: event.paymentMethod));
      TaxiDriver taxiDriver =
          await TaxiBookingController.getTaxiDriver(booking);
      yield TaxiNotConfirmedState(booking: booking, driver: taxiDriver);
//      await Future.delayed(Duration(seconds: 1));
//      yield TaxiBookingConfirmedState(booking: booking, driver: taxiDriver);
    }
    if (event is TaxiBookingCancelEvent) {
      yield TaxiBookingCancelledState();
      await Future.delayed(Duration(milliseconds: 500));
      List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();
      yield TaxiBookingNotSelectedState(taxisAvailable: taxis);
    }
    if (event is BackPressedEvent) {
      switch (state.runtimeType) {
        case DetailsNotFilledState:
          List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();

          yield TaxiBookingNotSelectedState(taxisAvailable: taxis);
          break;
        case PaymentNotInitializedState:
          yield TaxiNotSelectedState(
              booking: (state as PaymentNotInitializedState).booking);
          break;
        case TaxiNotSelectedState:
          yield DetailsNotFilledState(
              booking: (state as TaxiNotSelectedState).booking);
          break;
      }
    }
  }
}
