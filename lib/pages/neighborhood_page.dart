import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NeighborhoodPage extends StatefulWidget {
  @override
  _NeighborhoodPageState createState() => _NeighborhoodPageState();
}

class _NeighborhoodPageState extends State<NeighborhoodPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = Position(
      latitude: 42.004896,
      longitude: 21.409701,
      timestamp: DateTime.now(),
      accuracy: 10,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);

      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
    });

    print("Location Set: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Neighborhood"),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition ?? LatLng(0, 0),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          if (_currentPosition != null) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(_currentPosition!),
            );
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set<Marker>(),
      ),
    );
  }
}

class Position {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double accuracy;
  final double altitude;
  final double heading;
  final double speed;
  final double speedAccuracy;

  Position({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.accuracy,
    required this.altitude,
    required this.heading,
    required this.speed,
    required this.speedAccuracy,
  });
}
