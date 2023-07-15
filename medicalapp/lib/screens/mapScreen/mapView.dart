import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../helper/helper.dart';
import '../../providers/auth_provider.dart';
import '../../utility/constants.dart';
import 'package:http/http.dart' as http;
import 'models/autocomplate_prediction.dart';
import 'models/location_list_tile.dart';
import 'models/mapLocationMarkerModeal.dart';
import 'models/place_auto_complate_response.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  AuthProvider auth({required bool renderUI}) =>
      Provider.of<AuthProvider>(context, listen: renderUI);
  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  static const LatLng _center = const LatLng(45.521563, -122.677433);
  late GoogleMapController _mapController;
  final Completer<GoogleMapController> _completer = Completer();
  List<Marker> markers = [];
  TextEditingController search_bar_Controller = TextEditingController();
  String mapTheme = '';
  String currentLongitude = '';
  bool _isExpanded = false;
  String currentLatitude = '';
  List<AutocompletePrediction> placePredications = [];
  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context).loadString(mapStyle).then((value) {
      mapTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (_isExpanded) {
              setState(() {
                _isExpanded = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: searchBar(),
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_isExpanded) {
            setState(() {
              _isExpanded = false;
            });
          }
        },
        child: Stack(
          children: [
            FutureBuilder<UserLocationList>(
              future: userLocationList(
                  auth(renderUI: false).u_id,
                  auth(renderUI: false).access_token,
                  currentLatitude,
                  currentLongitude),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  for (var i = 0; i < snapshot.data!.data.length; i++) {
                    //LatLng latlng = LatLng(snapshot.data!.data[i].);
                    // addMarkers(
                    //   context: context,
                    //   latLng: latLng,
                    // );
                  }
                  return GoogleMap(
                    markers: Set.from(markers),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          Helpers.convertIntoDouble(snapshot.data!.latitude),
                          Helpers.convertIntoDouble(snapshot.data!.longitude)),
                      zoom: 12.0,
                    ),
                    onTap: (latLng) {
                      log(latLng.toString());
                    },
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      controller.setMapStyle(mapTheme);
                      _completer.complete(controller);
                      _mapController = controller;
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              },
            ),
            Positioned(
                top: 65,
                child: _isExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(left: 72),
                        child: Container(
                          width: 320.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Divider(
                                height: 4,
                                thickness: 4,
                                color: Color(0xFFF8F8F8),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton.icon(
                                  onPressed: updateAndFetchLocation,
                                  icon: SvgPicture.asset(
                                    location,
                                    height: 16,
                                  ),
                                  label: const Text("Use my Current Location"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFEEEEEE),
                                    foregroundColor: Color(0xFF0D0D0E),
                                    elevation: 0,
                                    fixedSize: const Size(double.infinity, 40),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 4,
                                thickness: 4,
                                color: Color(0xFFF8F8F8),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: placePredications.length,
                                itemBuilder: (context, index) =>
                                    LocationListTile(
                                  press: () {
                                    setState(() {
                                      _isExpanded = false;
                                    });
                                  },
                                  location:
                                      placePredications[index].description!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateAndFetchLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }

  GestureDetector searchBar() {
    return GestureDetector(
      onTap: () => setState(() {
        if (_isExpanded) {
          _isExpanded = false;
        } else {
          _isExpanded = true;
        }
      }),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: _isExpanded ? 320.0 : 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(Icons.search),
            ),
            _isExpanded
                ? Expanded(
                    child: TextField(
                      controller: search_bar_Controller,
                      onChanged: placeAutoComplete,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<String> placeAutoComplete(String query) async {
    Uri url = Uri.https(
      "maps.googleapis.com",
      '/maps/api/place/autocomplete/json',
      {"input": query, "key": googlePlacesApi},
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response.body);
      if (result.predictions != null) {
        setState(() {
          placePredications = result.predictions!;
          log(placePredications[0].description.toString());
        });
      }

      return response.body;
    } else {
      throw Exception('Failed to load Data');
    }
  }

  //LatLng a = LatLng(latitude, longitude);
  Future<void> addMarkers({
    required BuildContext context,
    required LatLng latLng,
    required String markerName,
    required String markerIds,
  }) async {
    MarkerId markerId = MarkerId(markerIds);
    Marker marker = Marker(
      position: latLng,
      markerId: markerId,
      draggable: false,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: markerName,
        onTap: () {},
      ),
      onTap: () {
        _showAnimatedBottomSheet(context);
      },
    );
    setState(() {
      markers.add(marker);
    });
  }

  updateAndFetchLocation() {
    _getCurrentLocation().then((value) {
      setState(() {
        currentLatitude = value.latitude.toString();
        currentLongitude = value.longitude.toString();
        _isExpanded = false;
        update_user_location(
            auth(renderUI: false).u_id,
            auth(renderUI: false).access_token,
            currentLatitude,
            currentLongitude);
        _mapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(Helpers.convertIntoDouble(currentLongitude),
              Helpers.convertIntoDouble(currentLatitude)),
        ));
      });
    });
  }

  Future<String> update_user_location(String user_id, String access_token,
      String latitude, String longitude) async {
    String url = '${baseUrl}update_user_location';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
      "latitude": latitude,
      "longitude": longitude
    };
    var response = await http.post(Uri.parse(url), body: obj);
    if (response.statusCode == 200) {
      log(response.body);
      return response.body;
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<UserLocationList> userLocationList(
    String userId,
    String accessToken,
    String latitude,
    String longitude,
  ) async {
    String url = '${baseUrl}user_location_list';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
      "latitude": latitude,
      "longitude": longitude
    };

    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(obj),
    );

    if (response.statusCode == 200) {
      log(response.body);
      final data = UserLocationList.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<void> _showAnimatedBottomSheet(BuildContext context) async {
    showModalBottomSheet<void>(
      context: context,
      builder: _buildBottomSheetContent,
    );
  }

  Widget _buildBottomSheetContent(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              alignment: Alignment.center,
              child: Text(
                'This is a beautiful animated bottom sheet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<LatLng> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }
}
