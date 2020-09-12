import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samannegarusers/dashboard/plugins/zoom_scaffold.dart';
import 'package:samannegarusers/dashboard/ui/menu.dart';
import 'package:samannegarusers/login/Widget/Loading.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_bloc.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_event.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_state.dart';
import 'package:samannegarusers/request/widgets/destination_selection_widget.dart';
import 'package:samannegarusers/request/widgets/home_app_bar.dart';
import 'package:samannegarusers/request/widgets/home_drawer.dart';
import 'package:samannegarusers/request/widgets/taxi_booking_confirmed_widget.dart';
import 'package:samannegarusers/request/widgets/taxi_booking_home_widget.dart';
import 'package:samannegarusers/request/widgets/taxi_booking_state_widget.dart';
import 'package:samannegarusers/request/widgets/taxi_map.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

  }

  MenuController menuController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<TaxiBookingBloc>(context).add(BackPressedEvent());
        return false;
      },
      child: ChangeNotifierProvider.value(
        value: menuController,
        child: ZoomScaffold(
          fullAppBar: false,
          menuScreen: MenuScreen(
            fullName: '',
          ),
          contentScreen: Layout(contentBuilder: (cc) => MapPage()),
        ),
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
//      body: TaxiMap(),
//      body:BlocBuilder<TaxiBookingBloc, TaxiBookingState>(
//          builder: (BuildContext context, TaxiBookingState state) {
//      return TaxiBookingHomeWidget();
//      }),

//      body: TaxiBookingStateWidget(),
      bottomSheet: BlocBuilder<TaxiBookingBloc, TaxiBookingState>(
          builder: (BuildContext context, TaxiBookingState state) {

//        if (state is TaxiBookingNotInitializedState) {
//          print('TaxiBookingNotInitializedState');
//          return SizedBox.expand(
//            child: Center(
//              child: Loading(),
//            ),
//          );
//
////          return TaxiBookingHomeWidget();
//        }
//        if (state is TaxiBookingNotSelectedState) {
//          print('DestinationSelctionWidget');
//          return DestinationSelctionWidget();
//        }
//        if (state is TaxiBookingConfirmedState) {
//          print('jere');
//          return TaxiBookingConfirmedWidget();
//        }
        return TaxiBookingHomeWidget();
      }),
    );
  }
}
