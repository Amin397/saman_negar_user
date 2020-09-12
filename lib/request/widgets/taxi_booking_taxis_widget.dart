import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_bloc.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_event.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_state.dart';
import 'package:samannegarusers/request/models/google_location.dart';
import 'package:samannegarusers/request/models/taxi_booking.dart';
import 'package:samannegarusers/request/models/taxi_type.dart';
import 'package:samannegarusers/request/widgets/rounded_button.dart';

class TaxiBookingTaxisWidget extends StatefulWidget {
  @override
  _TaxiBookingTaxisWidgetState createState() => _TaxiBookingTaxisWidgetState();
}

class _TaxiBookingTaxisWidgetState extends State<TaxiBookingTaxisWidget> {
  TaxiBooking taxiBooking;
  final TextEditingController textEditingController = TextEditingController();

  PersianDatePickerWidget persianDatePicker;
  var _dateTime;
  GoogleLocation source;
  String bookingtime;
  String bookingdate;
  DateTime now = new DateTime.now();
  DateTime date;
  int _radioValue = 0;
  int _result = 2;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _result = 2;//بدنه
          print(_result.toString());
          break;
        case 1:
          _result =1;//ثالث
          print(_result.toString());
          break;
      }
    });
  }
  @override
  void initState() {
    persianDatePicker = PersianDatePicker(
        controller: textEditingController,
    ).init();
    date = new DateTime(now.year, now.month, now.day);
    print("TaxiBookingTaxisWidget : date" + date.toString());
    super.initState();
    taxiBooking = (BlocProvider.of<TaxiBookingBloc>(context).state
            as TaxiNotSelectedState)
        .booking;
    print("TaxiBookingTaxisWidget : taxiBooking" + taxiBooking.adress);
    source = new GoogleLocation("52",LatLng(33.45,59.567),"محل حادثه");
    bookingdate = date.toString();
    bookingtime = now.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Container(
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
                Directionality(
                  textDirection: TextDirection.ltr,
                  child:   Container(
                    height: 200,
                    child: Card(
                      elevation: 4,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child:TimePickerSpinner(
                                is24HourMode: false,
                                normalTextStyle: TextStyle(
                                    fontSize: 24,
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IRANSans'
                                ),
                                highlightedTextStyle: TextStyle(
                                    fontSize: 24,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IRANSans'
                                ),
                                spacing: 50,
                                itemHeight: 70,
                                isForce2Digits: true,
                                onTimeChange: (time) {
                                  setState(() {
                                    _dateTime = time ;
                                    bookingtime = _dateTime.hour.toString().padLeft(2, '0') + ':' +
                                        _dateTime.minute.toString().padLeft(2, '0') + ':' +
                                        _dateTime.second.toString().padLeft(2, '0');
                                    print(bookingtime);
                                  });
                                },
                              )
                          ),
                          Text(
                              "زمان بازدیدد",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IRANSans'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Card(
                    elevation: 2,
                    child: Row(
                      children: <Widget>[
                        Text(
                            " تاریخ بازدید  ",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IRANSans'),
                    ),
                       Expanded(
                         flex: 2,
                         child:  TextField(
                           textAlign: TextAlign.center,
                           decoration: InputDecoration(
                             border: InputBorder.none,
                             labelStyle:  TextStyle(
                                 fontSize: 15,
                                 fontWeight: FontWeight.w600,
                                 fontFamily: 'IRANSans'),
                         ),
                           enableInteractiveSelection: false, // *** this is important to prevent user interactive selection ***
                           onTap: () {
                             FocusScope.of(context).requestFocus(new FocusNode()); // to prevent opening default keyboard
                             showModalBottomSheet(
                                 context: context,
                                 builder: (BuildContext context) {
                                   return persianDatePicker;
                                 });
                             setState(() {
                               textEditingController : textEditingController;
                             });
                           },
                           controller: textEditingController,
                         ),
                       ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Card(
                      elevation: 2,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                           Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Radio(
                                      value: 1,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      'بدنه',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'IRANSans'),
                                    ),
                                  ],
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Radio(
                                      value: 0,
                                      groupValue: _radioValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                    new Text(
                                      'ثالث',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'IRANSans'),
                                    ),
                                  ],
                                )
                              ],
                            ),

                          Text(
                            " نوع بیمه  " ,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IRANSans'),
                         textAlign: TextAlign.right,
                          ) ,
                        ],
                      ) ,
                    ),
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
                  text: "مرحله ی بعد" ,
                  onTap: () {
                    BlocProvider.of<TaxiBookingBloc>(context)
                        .add(TaxiSelectedEvent(
                        source : source ,
                        bookingTime: bookingtime ,
                        bookingDate: textEditingController.text ,
                        accidentType : _result.toString(),
                    ));
                  },
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  Widget buildLocation(String area, String label) {
    return Row(
      children: <Widget>[
        Text(
          "•",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
        ),
        SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$label",
                style: TextStyle(fontSize: 18.0, color: Colors.black38),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                "$area",
                style: Theme.of(context).textTheme.title,
              )
            ],
          ),
        )
      ],
    );
  }
}
