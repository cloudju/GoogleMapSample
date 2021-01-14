import 'dart:async';
import 'dart:collection';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  LocationData currentLocation;

  // StreamSubscription<LocationData> locationSubscription;

  Location _locationService = new Location();
  String error;

  Set<Circle> _circles = HashSet<Circle>();
  Set<Polygon> _polygons = HashSet<Polygon>();

  var pos = LatLng(34.743208, 134.997586);

  @override
  void initState() {
    super.initState();

    initPlatformState();
    _locationService.onLocationChanged().listen((LocationData result) async {
      setState(() {
        currentLocation = result;
      });
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  // Widget build(BuildContext context) {
  //   if (currentLocation == null) {
  //     return Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   } else {
  //     return MaterialApp(
  //       home: Scaffold(
  //         appBar: AppBar(
  //           title: Text('Maps Sample App'),
  //           backgroundColor: Colors.green[700],
  //         ),
  //         body: GoogleMap(
  //           onMapCreated: _onMapCreated,
  //           initialCameraPosition: CameraPosition(
  //             target:
  //                 LatLng(currentLocation.latitude, currentLocation.longitude),
  //             zoom: 17.0,
  //           ),
  //           myLocationEnabled: true,
  //         ),
  //       ),
  //     );
  //   }
  // }
  Widget build(BuildContext context) {
    var poss = [
      LatLng(34.741898553518714, 134.9971568584442),
      LatLng(34.742898553518714, 134.9971568584442),
      LatLng(34.743898553518714, 134.9971568584442),
      LatLng(34.744898553518714, 134.9971568584442),
      LatLng(34.745898553518714, 134.9971568584442),
      LatLng(34.746898553518714, 134.9971568584442),
      LatLng(34.747898553518714, 134.9971568584442),
      LatLng(34.748898553518714, 134.9971568584442),
      LatLng(34.749898553518714, 134.9971568584442),
      LatLng(34.740898553518714, 134.9971568584442),
      LatLng(34.751898553518714, 134.9971568584442),
      LatLng(34.752898553518714, 134.9971568584442),
      LatLng(34.753898553518714, 134.9971568584442),
      LatLng(34.754898553518714, 134.9971568584442),
    ];

    var x = 34.741898553518714;
    var y = 134.9971568584442;
    for (var i = 0; i < 50; i++) {
      for (var j = 0; j < 50; j++) {
        _setCircles(LatLng(x + i * 0.001, y + j * 0.001));
      }
    }

    _setPolygon();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Maps"),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            // 最初のカメラ位置
            target: pos,
            zoom: 18.0,
          ),
          circles: _circles,
          polygons: _polygons,
          onTap: (point) {
            print(point);
          },
        ),
      ),
    );
  }

  void _setPolygon() {
    var polygons = newMethod;
    final String polygonIdVal = 'polygon_id_1';
    _polygons.add(Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: polygons,
      strokeWidth: 2,
      strokeColor: Colors.yellow,
      fillColor: Colors.yellow.withOpacity(0.15),
    ));
  }

  List<LatLng> get newMethod {
    return [
      LatLng(34.74603371005585, 134.9933383986354), //1
      LatLng(34.746661829043845, 135.00046536326408), //2
      LatLng(34.74215001041296, 134.99463021755219), //4
      LatLng(34.74267209032816, 135.00058371573687), //3
    ];
  }

  void _setCircles(LatLng point) {
    final String circleIdVal = 'circle_id_1';
    _circles.add(Circle(
        circleId: CircleId(circleIdVal),
        center: point,
        radius: 30,
        fillColor: Colors.redAccent.withOpacity(0.5),
        strokeWidth: 3,
        strokeColor: Colors.redAccent));
  }

  void initPlatformState() async {
    LocationData myLocation;
    try {
      myLocation = await _locationService.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENITED')
        error = 'Permission denited';
      else if (e.code == 'PERMISSION_DENITED_NEVER_ASK')
        error =
            'Permission denited - please ask the user to enable it from the app settings';
      myLocation = null;
    }
    setState(() {
      currentLocation = myLocation;
    });
  }
}
