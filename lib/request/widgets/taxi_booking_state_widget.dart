import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_bloc.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_state.dart';
import 'package:samannegarusers/request/widgets/dashed_line.dart';
import 'package:samannegarusers/request/widgets/destination_selection_widget.dart';
import 'package:samannegarusers/request/widgets/taxi_booking_cancellation_dialog.dart';

class TaxiBookingStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<TaxiBookingBloc>(context),
      builder: (context, state) {
        int selectedTab = 1;
        TaxiBookingState currentState = state;
        print("TaxiBookingStateWidget: "+currentState.toString());
        String title = "";
        if (state is TaxiBookingLoadingState) {
          currentState = state.state;
        }
        switch (currentState.runtimeType) {
          case DetailsNotFilledState:
            selectedTab = 1;
            title = "وارد کردن آدرس";
            break;
          case TaxiNotSelectedState:
            selectedTab = 2;
            title = "تایید محل حادثه";
            break;
          case PaymentNotInitializedState:
            selectedTab = 3;
            title = "خودروی " ;
            break;
          case TaxiNotConfirmedState:
            selectedTab = 4;
            title = "اطلاعات ";
            break;
        }
        return Directionality(
          child: Container(

            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [CustomColors.HeaderOrange,CustomColors.HeaderYellowLight])
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.title.copyWith(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  TaxiBookingCancellationDialog());
                        },
                        color: Colors.white),
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(children: [
                  buildTab(context, "1", selectedTab >= 1),
                  Expanded(
                    child: DashedLine(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  buildTab(context, "2", selectedTab >= 2),
                  Expanded(
                    child: DashedLine(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  buildTab(context, "3", selectedTab >= 3),
                  Expanded(
                    child: DashedLine(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  buildTab(context, "4", selectedTab >= 4),
                ]),
                SizedBox(
                  height: 12.0,
                )
              ],
            ),
          ),
          textDirection: TextDirection.rtl,
        );
      },
    );
  }

  Widget buildTab(BuildContext context, String val, bool enabled) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.0)),
        child: Text(
          "$val",
          style: Theme.of(context).textTheme.headline.copyWith(
              color: enabled ? Colors.black : Colors.white, fontSize: 15),
        ));
  }
}
