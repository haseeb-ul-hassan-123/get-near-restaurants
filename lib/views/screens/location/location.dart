import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoyzee_app_map_feature/constant/Utils/flashbar.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;

class CustomLocation extends StatefulWidget {
  final int type;
  const CustomLocation({Key? key, required this.type}) : super(key: key);

  @override
  State<CustomLocation> createState() => _CustomLocationState();
}

class _CustomLocationState extends State<CustomLocation> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _locations = [];
  GoogleMapController? _mapController;
  String apiKey = 'YOUR API';
  final _geoFlutterFire = Geoflutterfire();
  Future<void> _searchLocations(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Data::    ${data}");
      setState(() {
        _locations = List<Map<String, dynamic>>.from(data['results']);
      });
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 15),
    ));
    _addMarker(
        LatLng(position.latitude, position.longitude), 'Current Location');
  }

  double? _lat;
  double? _lng;
  void _moveCameraA(Map<String, dynamic> location) async {
    final lat = location['geometry']['location']['lat'];
    final lng = location['geometry']['location']['lng'];
    final name = location['name'];

    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 15),
    ));
    print("latlong${lat}");
    print("latlong${lng}");
    if (lat != null) {
      print("latlong${lat}");
      print("latlong${lng}");
      setState(() {
        _lat = lat;
        _lng = lng;
        _addMarker(LatLng(lat, lng), name ?? '');
        _addressController.text = location['formatted_address'];
        _locations = [];
      });
    }
  }

  TextEditingController _addressController = TextEditingController();
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15),
      ));

      setState(() {
        _addressController.text = '${placemark.name},${placemark.country}';
        _lat = position.latitude;
        _lng = position.longitude;
      });
    }
  }

  void _addMarker(LatLng position, String title) {
    Marker marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: title),
    );
    setState(() {
      _markers.add(marker);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    super.initState();
  }

  GeoFirePoint? geopint;
  @override
  Widget build(BuildContext context) {
    print("ADDress:  ${_addressController.text}");
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 2,
            ),
            onMapCreated: _onMapCreated,
            markers: _markers,
          ),
          ListView.builder(
              itemCount: _locations.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      _moveCameraA(_locations[index]);
                    },
                    child: Card(
                      surfaceTintColor: Colors.white,
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: CustomText(
                          text: "${_locations[index]['name']}",
                          color: kblackColor,
                          size: 16,
                          weight: FontWeight.w700,
                        ),
                        subtitle: CustomText(
                          text: "${_locations[index]["formatted_address"]}",
                          color: kblackColor,
                          size: 12,
                          weight: FontWeight.normal,
                          onTap: () {
                            _moveCameraA(_locations[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
          Positioned(
            bottom: 0,
            child: Container(
              height: getSizeHeight(context) * 0.35,
              width: getSizeWidth(context),
              decoration: BoxDecoration(
                  color: kwhiteColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.only(top: 14, left: 18, right: 18),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: 'Enter Location',
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: getSizeHeight(context) * 0.02,
                    ),
                    CustomTextField(
                      controller: _addressController,
                      hintText: 'Search',
                      icon: Assets.search,
                      onchanged: (value) => _searchLocations(value),
                    ),
                    GestureDetector(
                      onTap: _getCurrentLocation,
                      child: Row(
                        children: [
                          Icon(
                            Icons.my_location,
                            size: 18,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: getSizeWidth(context) * 0.03,
                          ),
                          CustomText(
                            text: 'Use my current location',
                            size: 14,
                            weight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getSizeHeight(context) * 0.03,
                    ),
                    CustomButton(
                      buttonText: 'Save',
                      bordercolor: Colors.transparent,
                      radius: 40,
                      onTap: () async {
                        if (_locations != null &&
                            _addressController.text != null) {
                          if (FirebaseAuth.instance.currentUser != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .get()
                                .then((value) async => ({
                                      if (value['accountType'] == 0)
                                        {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.uid)
                                              .update({
                                            'address': _addressController.text,
                                            'latitude': _lat,
                                            'longitude': _lng,
                                          }).then((value) => ({
                                                    FlushBar.topFlushBarMessage(
                                                        'Location updated',
                                                        context,
                                                        kGreenColor,
                                                        Icon(Icons.check)),
                                                  }))
                                        }
                                      else
                                        {
                                          geopint = _geoFlutterFire.point(
                                              latitude: _lat ?? 0.0,
                                              longitude: _lng ?? 0.0),
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.uid)
                                              .update({
                                            'address': _addressController.text,
                                            'location': geopint?.data,
                                          }),
                                          await FirebaseFirestore.instance
                                              .collection('restaurants')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.uid)
                                              .update({
                                            'address': _addressController.text,
                                            'location': geopint?.data,
                                          }).then((value) => ({}))
                                        }
                                    }));
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
