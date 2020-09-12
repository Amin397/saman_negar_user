import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locations;
import 'package:samannegarusers/login/constants.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_bloc.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_event.dart';
import 'package:samannegarusers/request/bloc/taxi_booking_state.dart';
import 'package:samannegarusers/request/controllers/location_controller.dart';
import 'package:samannegarusers/request/models/google_location.dart';
import 'package:samannegarusers/request/models/taxi.dart';
import 'package:samannegarusers/request/models/taxi_booking.dart';
import 'dart:ui' as ui;

import '../../funcs.dart';

class TaxiMap extends StatefulWidget {
  @override
  _TaxiMapState createState() => _TaxiMapState();
}

class _TaxiMapState extends State<TaxiMap> {
  GoogleMapController controller;
  Set<Marker> markers = Set<Marker>();
  Set<Polyline> polylines = Set<Polyline>();
  Set<Circle> circles = Set<Circle>();
  ArgumentCallback<LatLng> onTap;
  GoogleLocation currentLocation;
  bool _serviceEnabled;
  locations.PermissionStatus _permissionGranted;
  locations.LocationData _locationData;
//  Position position;

  @override
  Future<void> initState() {
    super.initState();
    fetchCurrentLocation();
//    getNearExperts("33","59");

    print("_locationData"+_locationData.toString());
  }
  fetchCurrentLocation() async {
    print("STARTING LOCATION SERVICE");
    locations.Location location = new locations.Location();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    print("_locationData::51"+_locationData.toString());
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == locations.PermissionStatus.DENIED)
      _permissionGranted = await location.requestPermission();
    if (_permissionGranted == locations.PermissionStatus.GRANTED) {
      _locationData = await location.getLocation();
     print("_locationData::"+_locationData.toString());

     return;

    }

//    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
//    print("TaxiMap GoogleMap :: ${geolocationStatus.toString()}" );
//
//
//    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
//
//    geolocator
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//        .then(( position) {
//      print("geolocator TaxiMap GoogleMap::  " +position.toString());
//    }).catchError((e) {
//      print(e);
//    });
    Fluttertoast.showToast(
        msg:  LocationController.getCurrentLocation().toString() ,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void clearData() {
    markers.clear();
    polylines.clear();
    circles.clear();
  }

  Circle createCircle(Color color, LatLng position) {
    return Circle(
        circleId: CircleId(position.toString()),
        fillColor: color,
        strokeColor: color.withOpacity(0.4),
        center: position,
        strokeWidth: 75,
        radius: 32.0,
        visible: true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocListener<TaxiBookingBloc, TaxiBookingState>(
        listener: (context, state) {

          print("TaxiMap BlocListener" + state.toString());
          if (state is TaxiBookingNotSelectedState) {
            List<Taxi> taxis = state.taxisAvailable;
            clearData();
//            addTaxis(taxis);

          }
          if (state is TaxiBookingConfirmedState) {
//            clearData();

            TaxiBooking booking = (state).booking;
            addPolylines(booking.location.position, booking.source.position);
          }
          if (state is TaxiNotConfirmedState) {
            clearData();

            TaxiBooking booking = (state).booking;
            addPolylines(booking.location.position, booking.source.position);
          }
        },
        child:
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(36.0, 54.0), zoom: 8.0),
          onMapCreated: (controller) async {
            print("_locationData??"+_locationData.toString());

            this.controller = controller;
            BlocProvider.of<TaxiBookingBloc>(context)
                .add(TaxiBookingStartEvent());

            currentLocation = await LocationController.getCurrentLocation();
            print("TaxiMap currentLocation::  " +currentLocation.position.toString());
            controller.animateCamera(
                CameraUpdate.newLatLngZoom(LatLng(currentLocation.position.latitude , currentLocation.position.longitude), 12));
//            getNearExperts(currentLocation.position.latitude , currentLocation.position.longitude);
            BlocProvider.of<TaxiBookingBloc>(context)
                .add(TaxiBookingStartEvent());
            Fluttertoast.showToast(
                msg: "line153::"+currentLocation.position.toString() ,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
            print("TaxiMap GoogleMap::  " +currentLocation.position.toString());
          },
          onTap: _handleTap,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: markers,
          polylines: polylines,
          circles: circles,
        ),

      ),
    );
  }
  _handleTap(LatLng point) {
    Fluttertoast.showToast(
        msg: "line180::"+point.longitude.toString() ,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'مکان من',
        ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });
  }
  Future addTaxis(List<Taxi> taxis) async {
    GoogleLocation currentPositon =
        await LocationController.getCurrentLocation();
    print('TaxicurrentPositon ${currentPositon.toString()}');
    circles.add(createCircle(Colors.blueAccent, currentPositon.position));
    if (this.controller == null) {
      return;
    }
    controller.moveCamera(CameraUpdate.newLatLng(currentPositon.position));
    markers.clear();
    await Future.wait(taxis.map((taxi) async {
      final Uint8List markerIcon =
          await getBytesFromAsset("images/taxi_marker.png", 100);
      BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);
      print('Taxi ${taxi.id}');
      markers.add(Marker(
        markerId: MarkerId("${taxi.id}"),
        position: LatLng(taxi.position.latitude, taxi.position.longitude),
        infoWindow: InfoWindow(
          title: taxi.title,
        ),
        icon: descriptor,
      ));
    }));
    setState(() {});
  }

  Future<Marker> createMarker(
      Color color, LatLng position, String title) async {
    final Uint8List markerIcon =
        await getBytesFromAsset("images/location.png", 100);
    BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);
    return Marker(
      markerId: MarkerId("${position.toString()}"),
      position: position,
      infoWindow: InfoWindow(
        title: title,
      ),
      icon: descriptor,
    );
  }

  Future<void> addPolylines(LatLng start, LatLng end) async {
    List<LatLng> result = await LocationController.getPolylines(start, end);

    setState(() {});
    Marker startM = await createMarker(Colors.black, start, "Start");
    Marker endM = await createMarker(Colors.black, end, "End");
    markers.add(startM);
    markers.add(endM);
    for (int i = 1; i < result.length; i++) {
      polylines.add(
        Polyline(
            polylineId: PolylineId("${result[i].toString()}"),
            color: Colors.black,
            points: [result[i - 1], result[i]],
            width: 3,
            visible: true,
            startCap: Cap.roundCap,
            jointType: JointType.mitered,
            endCap: Cap.roundCap,
            geodesic: true,
            patterns: [PatternItem.dash(12)],
            zIndex: 1),
      );
    }
    result.forEach((val) {});

    setState(() {});
    controller.animateCamera(CameraUpdate.newLatLngZoom(result[0], 14));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
  Future<dynamic> getNearExperts(lat , long) async {
    var data = await makePostRequest('${CustomStrings.Experts}',
        {'api_type': 'getActives'});

    print( "getNearExperts:  "+data.json().toString());
    if(data.json()!= null){
      var expertlist = data.json();
//
//      if(expertlist['lat'] ==null || expertlist['lang'] == null){
//        expertlist['lat'] = "36.34";
//        expertlist['lang'] =" 59.58";
//      }
      print( "getNearExperts:  "+ expertlist[0]['ActiveExpert_id']);
      print( "getNearExperts:  "+ expertlist[0]['expert']['fname']);

//     if(expertlist[0]['lat'] != null)
//        {
          print( "getNearExperts indide:  "+ expertlist[0]['lat']);
          expertlist[0]['lat'] ="33.4";
        expertlist[0]['lang'] = "59.8";
//        }else
          print( "getNearExperts:  "+ expertlist[0]['lat']);

//      Marker resultMarker = Marker(
//        markerId: MarkerId(expertlist[0]['ActiveExpert_id']),
//        infoWindow: InfoWindow(
//            title: "${expertlist[0]['expert']['fname']}",
//            ),
//        position: LatLng((expertlist[0]['lat'])!= null ? double.parse(expertlist[0]['lat']): "33.4" ,
//            double.parse(expertlist[0]['lang'])),
//      );
// Add it to Set
//      markers.add(resultMarker);
//      print( "getNearExperts lat :  "+expertlist['lat']);
          final Uint8List markerIcon =
          await getBytesFromAsset("images/taxi_marker.png", 100);
          BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);
//          print('Taxi ${expertlist['expert_id']}');
          markers.add(Marker(
            markerId: MarkerId("${expertlist[0]['ActiveExpert_id']}"),
            position: LatLng( double.parse(expertlist[0]['lat']),  double.parse(expertlist[0]['lang'])),
            infoWindow: InfoWindow(
              title: expertlist[0]['expert']['fname'],
            ),
            icon: descriptor,
          ));

    }
    return data.json();
  }
}
