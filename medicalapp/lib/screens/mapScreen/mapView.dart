import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  void _onMapCreated(GoogleMapController controller) {
    Completer<GoogleMapController> _controller = Completer();
  }

  static const LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng? _pickedLocation;
  GoogleMapController? _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(8.5603347, 76.8802452),
          zoom: 13.0,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: _handleTap, // Register the onTap function to handle map taps
        markers: Set<Marker>.from([
          if (_pickedLocation != null)
            Marker(
              markerId: MarkerId('picked_location'),
              position: _pickedLocation!,
            ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.my_location),
      ),
    );
    // return GoogleMap(
    //   onMapCreated: _onMapCreated,
    //   initialCameraPosition: CameraPosition(
    //     target: _center,
    //     zoom: 11.0,
    //   ),
    // );
  }

  void _handleTap(LatLng latLng) {
    setState(() {
      _pickedLocation = latLng;
    });
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _pickedLocation = latLng;
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 13.0));
    });
  }
}
