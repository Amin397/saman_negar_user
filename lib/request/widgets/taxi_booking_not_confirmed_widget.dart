import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:load/load.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samannegarusers/funcs.dart';
import 'package:samannegarusers/login/constants.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_bloc.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_state.dart';
import 'package:samannegarusers/request/models/payment_method.dart';
import 'package:samannegarusers/request/models/taxi_booking.dart';
import 'package:samannegarusers/request/models/taxi_driver.dart';
import 'package:samannegarusers/request/screens/request_waiting.dart';
import 'package:samannegarusers/request/widgets/rounded_button.dart';
import 'package:samannegarusers/request/widgets/taxi_booking_cancellation_dialog.dart';

class TaxiBookingNotConfirmedWidget extends StatefulWidget {
  @override
  _TaxiBookingNotConfirmedWidgetState createState() =>
      _TaxiBookingNotConfirmedWidgetState();
}

class _TaxiBookingNotConfirmedWidgetState
    extends State<TaxiBookingNotConfirmedWidget> {
  TaxiBooking booking;
  TaxiDriver driver;
  String Address , carname , time , date , carId;
  @override
  void initState() {
    super.initState();
    booking = (BlocProvider.of<TaxiBookingBloc>(context).state
            as TaxiNotConfirmedState)
        .booking;

    Address = booking.adress ;
    carname = booking.paymentMethod.title ;
    carId = booking.paymentMethod.id ;
    time = booking.bookingtime ;
    date = booking.bookingdate ;
    driver = (BlocProvider.of<TaxiBookingBloc>(context).state
            as TaxiNotConfirmedState)
        .driver;
    print("TaxiBookingNotConfirmedWidget driver" + booking.paymentMethod.id);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
//                buildDriver(),
                  buildPriceDetails(),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 22.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Expanded(
                          child: Text(
                            Address,
                            style: Theme.of(context).textTheme.subhead,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    booking.accidentType == "1" ? "بدنه" : "ثالث",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IRANSans'),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                RoundedButton(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => TaxiBookingCancellationDialog());
                  },
                  iconData: Icons.cancel,
                ),
                SizedBox(
                  width: 24.0,
                ),
                Expanded(
                  flex: 2,
                  child: RoundedButton(
                    text: "تایید",
                    onTap: () {
                      sendDataReq();

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
//
//  Widget buildDriver() {
//    return Row(
//      children: <Widget>[
//        ClipRRect(
//          borderRadius: BorderRadius.circular(12.0),
//          child: Image.network(
//            "${driver.driverPic}",
//            width: 48.0,
//            height: 48.0,
//            fit: BoxFit.cover,
//          ),
//        ),
//        SizedBox(
//          width: 16.0,
//        ),
//        Expanded(
//            child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: <Widget>[
//            Text(
//              "${driver.driverName}",
//              style: Theme.of(context).textTheme.title,
//            ),
//            SizedBox(
//              height: 4.0,
//            ),
//            Text(
//              "${driver.taxiDetails}",
//              style: Theme.of(context).textTheme.subtitle,
//            )
//          ],
//        )),
//        SizedBox(
//          width: 8.0,
//        ),
//        Container(
//          decoration: BoxDecoration(
//              color: Color(0xffeeeeee).withOpacity(0.5),
//              borderRadius: BorderRadius.circular(12.0)),
//          padding: EdgeInsets.all(6.0),
//          child: Row(
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              Icon(
//                Icons.star,
//                color: Colors.yellow,
//                size: 20.0,
//              ),
//              Text(
//                "${driver.driverRating}",
//                style: Theme.of(context).textTheme.title,
//              ),
//            ],
//          ),
//        )
//      ],
//    );
//  }

  Widget buildPriceDetails() {
    return Column(
      children: <Widget>[
        Divider(),
        SizedBox(
          height: 14.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildIconText(date, Icons.date_range),
            buildIconText(time, Icons.access_time),
            buildIconText(carname, Icons.directions_car),
          ],
        ),
        SizedBox(
          height: 14.0,
        ),
        Divider()
      ],
    );
  }

  Widget buildIconText(String text, IconData iconData) {
    return Row(
      children: <Widget>[
        Icon(
          iconData,
          size: 22.0,
          color: Colors.black,
        ),
        Text(
          " $text",
          style: Theme.of(context).textTheme.title,
        )
      ],
    );
  }
  Future<void> sendDataReq() async {
    showLoadingDialog(tapDismiss: false);
    print(booking.location.position.latitude);
    var res = await makenewPostRequest(CustomStrings.New_API_ROOT, {
      'user_Id': await getPref('customer_id'),
      'car_Id': carId,
      'user_Type': booking.requesttype ,
      'lat' : booking.location.position.latitude ,
      'lon': booking.location.position.longitude,
      'accident_Date': booking.bookingdate,
      'accident_Time': booking.bookingtime ,
      'accident_Type': booking.accidentType ,
      'user_Address': booking.adress,
      'target' : 'request'
    });
    res = res.json();
    print("result with new api : "+res['ok'].toString());
    print("result with new api : "+res['data']['accident_Type'].toString());
    print("result with new api : "+res['data'].toString());
    print("result with new api : "+res['data']['customer']['mobile'].toString());
    print("result with new api : "+res['data']['customerCar']['plaque'].toString());
//    _name = await res['data']['name'];
//    _lastName = await res['data']['lname'];
//    _customer_id = await res['data']['customer_id'];
//    customerData = await res;
    hideLoadingDialog();
    Navigator.of(context).pushReplacement(PageTransition(
        child: RequestWaiting(), type: PageTransitionType.rightToLeftWithFade));
  }
}
