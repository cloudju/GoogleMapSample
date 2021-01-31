import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  Completer<GoogleMapController> _controller = Completer();
  Location _locationService = Location();

  // 現在位置
  LatLng _currLocation; // = LatLng(34.743208, 134.997586);

  var pos = LatLng(34.743208, 134.997586);

  @override
  void initState() {
    super.initState();
  }

  void _getLocation() async {
    print('getting:$_currLocation');
    LocationData pos = await _locationService.getLocation();
    _currLocation = LatLng(pos.latitude, pos.longitude);
    print('get:$_currLocation');
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    print('build:$_currLocation');
    if (_currLocation == null) {
      // 現在位置の取得
      _getLocation();
      // 現在位置の変化を監視
      _locationService.onLocationChanged.listen((LocationData result) async {
        setState(() {
          _currLocation = LatLng(result.latitude, result.longitude);
          print('setState:$_currLocation');
        });
      });
      return Scaffold();
    } else {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Flutter Maps"),
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              // 最初のカメラ位置
              target: LatLng(_currLocation.latitude, _currLocation.longitude),
              zoom: 18.0,
            ),
            myLocationEnabled: true,
            onTap: (point) {
              print(point);
            },
          ),
        ),
      );
    }
  }
}
