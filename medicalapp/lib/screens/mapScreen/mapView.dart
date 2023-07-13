import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../utility/constants.dart';

// class CustomMapNotifier extends ChangeNotifier {
//   List<Marker> markers = [];
//   bool markerPress = false;
//   Future addMarkers({required LatLng latLng}) async {
//     MarkerId markerId = MarkerId(latLng.toString());
//     Marker marker = Marker(
//       position: latLng,
//       markerId: markerId,
//       draggable: false,
//       icon: BitmapDescriptor.defaultMarker,
//       infoWindow: InfoWindow(
//         title: 'Marker Title',
//         snippet: 'Marker Snippet',
//         onTap: () {
//           log('InfoWindow');
//         },
//       ),
//       onTap: () {
//         markerPress = true;
//         log(latLng.toString());
//       },
//     );
//     markers.add(marker);
//     notifyListeners();
//   }

//   void closeBottomSheet() {
//     markerPress = false;
//     notifyListeners();
//   }

//   void clearMarker() {
//     markers = [];
//     notifyListeners();
//   }
// }

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // CustomMapNotifier customMapNotifier({required bool renderUI}) =>
  //     Provider.of<CustomMapNotifier>(context, listen: renderUI);
  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  static const LatLng _center = const LatLng(45.521563, -122.677433);
  late GoogleMapController _mapController;
  final Completer<GoogleMapController> _completer = Completer();
  List<Marker> markers = [];
  bool markerPress = false;

  String mapTheme = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DefaultAssetBundle.of(context).loadString(mapStyle).then((value) {
      mapTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    log(markers.toString());
    Future addMarkers({required LatLng latLng}) async {
      MarkerId markerId = MarkerId(latLng.toString());
      Marker marker = Marker(
        position: latLng,
        markerId: markerId,
        draggable: false,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: 'Marker Title',
          snippet: 'Marker Snippet',
          onTap: () {
            log('InfoWindow');
          },
        ),
        onTap: () {
          setState(() {
            markerPress = true;
            log(latLng.toString());
          });
        },
      );
      setState(() {
        markers.add(marker);
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () => setState(() {
          markerPress = false;
        }),
        child: GoogleMap(
          markers: Set.from(markers),
          initialCameraPosition: CameraPosition(
            target: LatLng(8.5603347, 76.8802452),
            zoom: 12.0,
          ),
          onTap: (latLng) {
            setState(() {
              markerPress = false;
            });
            log(latLng.toString());

            addMarkers(latLng: latLng);
          },
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            controller.setMapStyle(mapTheme);
            _completer.complete(controller);
            _mapController = controller;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation();
        },
        child: Icon(Icons.my_location),
      ),
      bottomSheet: markerPress ? _buildBottomSheet() : SizedBox(),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: Center(
        child: Text(
          'This is a persistent bottom sheet',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latLng = LatLng(position.latitude, position.longitude);
  }
}
