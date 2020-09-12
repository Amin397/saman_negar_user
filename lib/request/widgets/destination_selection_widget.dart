import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:samannegarusers/dashboard/util.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_bloc.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_event.dart';
import 'package:samannegarusers/request/controllers/location_controller.dart';
import 'package:samannegarusers/request/controllers/user_location_controller.dart';
import 'package:samannegarusers/request/models/google_location.dart';
import 'package:samannegarusers/request/models/user_location.dart';
import 'package:samannegarusers/request/widgets/ease_in_widget.dart';
import 'package:location/location.dart' as locations;


class DestinationSelctionWidget extends StatefulWidget {
  @override
  _DestinationSelctionWidgetState createState() =>
      _DestinationSelctionWidgetState();
}

class _DestinationSelctionWidgetState extends State<DestinationSelctionWidget>
    with TickerProviderStateMixin<DestinationSelctionWidget> {
  bool isLoading;
  List<UserLocation> savedLocations;
  AnimationController animationController;
  Animation animation;
  GoogleLocation currentLocation;
  bool _serviceEnabled;
  locations.PermissionStatus _permissionGranted;
  locations.LocationData _locationData;
  GoogleLocation _reqloc;
  String _reqtype;
  @override
  void initState() {
    super.initState();
    fetchCurrentLocation();

//    _reqtype =( BlocProvider.of<TaxiBookingBloc>(context).state as DestinationSelectedEvent ).destination;
//    _reqloc =( BlocProvider.of<TaxiBookingBloc>(context).state as DestinationSelectedEvent ).location;
//    print("_reqtype : " + _reqtype + _reqloc.areaDetails) ;

    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      loadDestinations();
    });
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      curve: Curves.easeInExpo,
      parent: animationController,
    );
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      animationController.forward();
    });
  }
  fetchCurrentLocation() async {


    currentLocation = await LocationController.getCurrentLocation();
    print("currentLocation in DestinationSelctionWidgetState" + currentLocation.areaDetails);
    setState(() {
      currentLocation =currentLocation;
    });

    return;

    }


  Future<void> loadDestinations() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                height: 150 * animation.value,
                child: child,
              );
            },
            child: Container(
              height: 150.0,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: ListView(
                children: [
                  SingleChildScrollView(
                    child: new Row(
                      children: [
                        buildDestinationWidget(Icons.drive_eta, 'مقصر هستم!',
                            Colors.red, Colors.white, '0'),
                        buildDestinationWidget(Icons.style, 'زیان دیده هستم!',
                            Colors.yellow, Colors.black87, '1'),
                      ],
                    ),
                  ),
                ],
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
          );
  }

  Widget buildDestinationWidget(
      IconData icon, String txt, Color clr, Color txtColors, value) {
    return EaseInWidget(
        onTap: () {
          print("DestinationSelctionWidget buildDestinationWidget : " + value.toString());
          print("DestinationSelctionWidget buildDestinationWidget : " + currentLocation.areaDetails);
          selectDestination(value , currentLocation);
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(12.0),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.01),
              boxShadow: [
                BoxShadow(
                    color: clr,
//                    blurRadius: 15.0,
                    spreadRadius: 0.05),
              ],
              borderRadius: BorderRadius.circular(12.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  size: 22.0,
                  color: txtColors,
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                txt,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: txtColors),
              ),
              SizedBox(
                height: 4.0,
              ),
            ],
          ),
        ));
  }

  void selectDestination(String type , GoogleLocation location) async {
    print("current location in select distanation : " +location.areaDetails);
    await animationController.reverse(from: 1.0);
    BlocProvider.of<TaxiBookingBloc>(context)
        .add(DestinationSelectedEvent(requesttype: type , location : currentLocation));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
