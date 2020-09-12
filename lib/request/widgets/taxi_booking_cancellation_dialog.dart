import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_bloc.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_event.dart';

class TaxiBookingCancellationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text("لغو درخواست"),
          content: Text("ایا میخواهید درخواست خود را لغو کنید؟"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "خیر",
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "تایید",
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                BlocProvider.of<TaxiBookingBloc>(context)
                    .add(TaxiBookingCancelEvent());
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
}

