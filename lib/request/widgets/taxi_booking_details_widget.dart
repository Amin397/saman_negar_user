import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_bloc.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_event.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_state.dart';
import 'package:samannegarusers/request/controllers/location_controller.dart';
import 'package:samannegarusers/request/models/google_location.dart';
import 'package:samannegarusers/request/models/taxi_booking.dart';
import 'package:samannegarusers/request/widgets/rounded_button.dart';

class TaxiBookingDetailsWidget extends StatefulWidget {
  @override
  _TaxiBookingDetailsWidgetState createState() =>
      _TaxiBookingDetailsWidgetState();
}

class _TaxiBookingDetailsWidgetState extends State<TaxiBookingDetailsWidget> {
  GoogleLocation source, destination;
  int noOfPersons;
  DateTime bookingTime;
  GoogleLocation currentLocation;
  var myaddress;
  String addresstext;

  @override
  Future<void> initState()  {

//
//    fetchCurrentLocation();
    super.initState();

    TaxiBooking taxiBooking = (BlocProvider.of<TaxiBookingBloc>(context).state
            as DetailsNotFilledState)
        .booking;
//    noOfPersons = taxiBooking.noOfPersons;
//    bookingTime = taxiBooking.bookingTime;
//    source = taxiBooking.source;
//    addressController.text = source.areaDetails.toString();
    print("TaxiBookingDetailsWidget  requesttype : " +  taxiBooking.requesttype );
    print("TaxiBookingDetailsWidget source: " + taxiBooking.location.areaDetails!= null ?  taxiBooking.location.areaDetails : "null" );
    destination = taxiBooking.location.areaDetails != null ? taxiBooking.location :  GoogleLocation("52",LatLng(33.45,59.567),"مبدا");
    setState(() {
      source = destination;
      addresstext = destination == null ? "hnvs" : destination.areaDetails.toString() ;
    });
  }
//  fetchCurrentLocation() async {
//    currentLocation = await LocationController.getCurrentLocation();
//    source = currentLocation!= null ? currentLocation: GoogleLocation("52",LatLng(33.45,59.567),"مبدا") ;
//    print("my adress:"  + currentLocation.areaDetails.toString());
//    print("TaxiBookingDetailsWidget fetchCurrentLocation:"  + source.areaDetails.toString());
//    setState(() {
//      addresstext = currentLocation == null ? "hnvs" : currentLocation.areaDetails.toString() ;
//    });
//      return;
//
//    }

  TextEditingController addressController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

//    setState(() {
//      source = destination;
//    });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                        addresstext == null ? "address" : addresstext,
//                      currentLocation.toString()== null ? currentLocation.areaDetails.toString():"ادرس من",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    SizedBox(
                      height:12.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'آدرس دقیق خود را وارد کنید'
                      ),
                      controller: addressController,
                      maxLines: 2,

                    ),
                    SizedBox(
                      height: 24.0,
                    ),


                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                RoundedButton(
                  onTap: () {
                    BlocProvider.of<TaxiBookingBloc>(context)
                        .add(BackPressedEvent());
                  },
                  iconData: Icons.keyboard_backspace,
                ),
                SizedBox(
                  width: 18.0,
                ),
                Expanded(
                  flex: 2,
                  child: RoundedButton(
                    text: "مرحله ی بعد",
                    onTap: () {
//                      destination = new GoogleLocation("52",LatLng(33.45,59.567), addressController.text.toString());
                      print(destination.position.toString());
                      print(destination.placeId.toString());
                      print(source.areaDetails.toString());
                      BlocProvider.of<TaxiBookingBloc>(context).add(
                          DetailsSubmittedEvent(
//                              bookingTime: bookingTime,
                            adress: addresstext + "- " + addressController.text,
//                              source: source,
//                              noOfPersons: noOfPersons
                          )
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }




  Widget buildContainer(String val, bool enabled) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 6.0),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
            color: enabled ? Colors.amber : Color(0xffeeeeee),
            borderRadius: BorderRadius.circular(12.0)),
        child: Text(
          "$val",
          style: Theme.of(context).textTheme.headline.copyWith(
              color: enabled ? Colors.white : Colors.black, fontSize: 15.0),
        ));
  }

  Widget buildTimeContainer(
      {String text,
      IconData iconData,
      bool enabled = false,
      Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              color: enabled ? Colors.black : Color(0xffeeeeee),
              borderRadius: BorderRadius.circular(12.0)),
          child: text != null
              ? Text(
                  "$text",
                  style: Theme.of(context).textTheme.headline.copyWith(
                      color: enabled ? Colors.white : Colors.black,
                      fontSize: 15.0),
                )
              : Icon(
                  iconData,
                  color: enabled ? Colors.white : Colors.black,
                  size: 18.0,
                )),
    );
  }

  Widget buildInputWidget(String text, String hint, Function() onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xffeeeeee).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text ?? hint,
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(color: text == null ? Colors.black45 : Colors.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
