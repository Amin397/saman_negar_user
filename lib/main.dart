import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:load/load.dart';
import 'package:samannegarusers/login/Widget/Loading.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_bloc.dart';
import 'package:samannegarusers/splashScreen.dart';

import 'login/welcomePage.dart';
//void main() => runApp(
//    LoadingProvider(child: WillPopScope(child: MyApp(), onWillPop: () {print('close'); return;}),loadingWidgetBuilder: (ctx, data) {
//      return Loading();
//    },)
//);

void main() => runApp(MultiBlocProvider(

    providers: [
      BlocProvider<TaxiBookingBloc>(create: (context) => TaxiBookingBloc())
    ],
    child: LoadingProvider(
      child: WillPopScope(
          child: MyApp(),
          onWillPop: () {
            print('close');
            return;
          }),
      loadingWidgetBuilder: (ctx, data) {
        return Loading();
      },
    )));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'سامان نگار ایرانیان',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(fontFamily: 'IRANSans'),
    );
  }
}
