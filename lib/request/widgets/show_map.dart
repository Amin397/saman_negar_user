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

class ShowMap extends StatefulWidget {
  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  GoogleMapController controller;

  GoogleLocation currentLocation;
  bool _serviceEnabled;
  locations.PermissionStatus _permissionGranted;
  locations.LocationData _locationData;
  Set<Marker> markers = Set<Marker>();

//  Position position;

  @override
  Future<void> initState() {
    super.initState();
    fetchCurrentLocation();

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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GoogleMap(
          initialCameraPosition:
          CameraPosition(target: LatLng(36.0, 54.0), zoom: 8.0),
          onMapCreated: (controller) async {
            print("_locationData??"+_locationData.toString());

            this.controller = controller;

            currentLocation = await LocationController.getCurrentLocation();
            print("TaxiMap currentLocation::  " +currentLocation.position.toString());
            controller.animateCamera(
                CameraUpdate.newLatLngZoom(currentLocation.position, 12));
//            getNearExperts(currentLocation.position.latitude , currentLocation.position.longitude);
            Marker startM = await createMarker(Colors.black , currentLocation.position , "here");
            markers.add(startM);
            print("TaxiMap GoogleMap::  " +currentLocation.position.toString());
          },
          myLocationButtonEnabled: true,
          myLocationEnabled: true,

        ),

      );

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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

}
