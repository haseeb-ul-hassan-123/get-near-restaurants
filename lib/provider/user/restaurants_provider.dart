import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoyzee_app_map_feature/constant/distance.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/models/restaurants_model.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/home/restaurants_menu.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_card_restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  List<RestaurantsModel> _restaurantsListModel = [];
  List<RestaurantsModel> get restaurantsListModel => _restaurantsListModel;
  List<RestaurantsModel> _filterResturantsListModel = [];
  List<RestaurantsModel> get filterRestaurantsListModel =>
      _filterResturantsListModel;
  setRestaurantsListModel(RestaurantsModel value) {
    _restaurantsListModel.add(value);
    notifyListeners();
  }

  setFilterRestaurantsListModel(RestaurantsModel value) {
    _filterResturantsListModel.add(value);
    notifyListeners();
  }

  clearFilterRestaurantsList() {
    _filterResturantsListModel.clear();
    notifyListeners();
  }

  List<MarkerData> _markers = [];
  List<MarkerData> get markers => _markers;
  setMarkers(MarkerData value) {
    _markers.add(value);
    notifyListeners();
  }

  List<MarkerData> _filterMarkers = [];
  List<MarkerData> get filtermarkers => _filterMarkers;
  setFilterMarkers(MarkerData value) {
    _filterMarkers.add(value);
    notifyListeners();
  }

  clearFilterMarkers() {
    _filterMarkers.clear();
    notifyListeners();
  }

  bool showWindow = true;

  bool get isShowWindow => showWindow;
  setSignUpLoading(bool loading) {
    showWindow = loading;
    notifyListeners();
  }

  bool isOpen(Map<String, dynamic> hours) {
    final now = DateTime.now();
    final currentDay = now.weekday;
    final currentTime = now.hour * 60 + now.minute;

    final dayName = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][currentDay - 1];

    final daySlots = hours[dayName];

    if (daySlots == null) {
      return false;
    }

    for (final slot in daySlots) {
      final openTime = slot['open'];
      final closeTime = slot['close'];
      if (currentTime >= openTime && currentTime <= closeTime) {
        return true;
      }
    }

    return false;
  }

  List<MarkerData> addMarkers(
    LatLng userPosition,
    CustomInfoWindowController customInfoWindowController,
    BuildContext context,
    List<String> categories,
  ) {
    final markers = <MarkerData>[];
    final geo = Geoflutterfire();
    final GeoFirePoint center = geo.point(
      latitude: userPosition.latitude,
      longitude: userPosition.longitude,
    );
    final radius = 16.0934; // Radius in miles
    final collectionReference =
        FirebaseFirestore.instance.collection('restaurants');
    Stream<List<DocumentSnapshot>> stream =
        geo.collection(collectionRef: collectionReference).within(
              center: center,
              radius: radius,
              field: 'location',
              strictMode: true,
            );

    stream.listen((List<DocumentSnapshot> documentList) {
      print("Data in Marker ${documentList.length}");
      _markers = [];
      documentList.forEach((DocumentSnapshot document) {
        RestaurantsModel restaurant = RestaurantsModel.fromFirestore(document);
        final distance = distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          restaurant.location['geopoint'].latitude,
          restaurant.location['geopoint'].longitude,
        );
        print("jsfdj${restaurant.rName}");

        if (restaurant.rApproved == 1 &&
            restaurant.isOpen == true &&
            restaurant.isblocked == false) {
          if (isOpen(restaurant.hours)) {
            restaurant.distanceInMiles = distance;
            setMarkers(
              MarkerData(
                marker: Marker(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestaurantsMenu(
                                    restaurantsModel: restaurant,
                                  )));
                    },
                    markerId: MarkerId(restaurant.rId),
                    position: LatLng(restaurant.location['geopoint'].latitude,
                        restaurant.location['geopoint'].longitude)),
                child: CustomCardRestaurant(
                  Iconpressd: () {
                    if (restaurant.rLikes
                        .contains(FirebaseAuth.instance.currentUser?.uid)) {
                      FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(restaurant.rId)
                          .update({
                        'rLikes': FieldValue.arrayRemove(
                            [FirebaseAuth.instance.currentUser?.uid])
                      });
                    } else {
                      FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(restaurant.rId)
                          .update({
                        'rLikes': FieldValue.arrayUnion(
                            [FirebaseAuth.instance.currentUser?.uid])
                      });
                    }
                  },
                  tap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantsMenu(
                                  restaurantsModel: restaurant,
                                )));
                  },
                  icon: restaurant.rLikes
                          .contains(FirebaseAuth.instance.currentUser?.uid)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  likes: restaurant.rLikes.length.toString(),
                  height: getSizeHeight(context) * 0.10,
                  width: getSizeWidth(context) * 0.6,
                  rName: restaurant.rName,
                  rImage: restaurant.rImage,
                  rAddress: restaurant.rAddress,
                  rDistance:
                      '${restaurant.distanceInMiles.toStringAsFixed(2)} Miles',
                ),
              ),
            );

            notifyListeners();
          }
        }
        notifyListeners();
      });
    });

    return markers;
  }

  List<MarkerData> filterAddMarkers(
    LatLng userPosition,
    CustomInfoWindowController customInfoWindowController,
    BuildContext context,
    List<String> categories,
  ) {
    final markers = <MarkerData>[];
    final geo = Geoflutterfire();
    final GeoFirePoint center = geo.point(
      latitude: userPosition.latitude,
      longitude: userPosition.longitude,
    );
    final radius = 16.0934; // Radius in miles
    final collectionReference =
        FirebaseFirestore.instance.collection('restaurants');
    Stream<List<DocumentSnapshot>> stream =
        geo.collection(collectionRef: collectionReference).within(
              center: center,
              radius: radius,
              field: 'location',
              strictMode: true,
            );

    stream.listen((List<DocumentSnapshot> documentList) {
      print("Data in Marker ${documentList.length}");
      _filterMarkers = [];
      documentList.forEach((DocumentSnapshot document) {
        RestaurantsModel restaurant = RestaurantsModel.fromFirestore(document);
        final distance = distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          restaurant.location['geopoint'].latitude,
          restaurant.location['geopoint'].longitude,
        );
        print("jsfdj${restaurant.rName}");

        if (restaurant.rApproved == 1 &&
            isOpen(restaurant.hours) &&
            restaurant.isOpen == true &&
            restaurant.isblocked == false) {
          restaurant.distanceInMiles = distance;

          // Filter restaurants based on categories
          if (restaurant.categories
              .any((category) => categories.contains(category))) {
            setFilterMarkers(
              MarkerData(
                marker: Marker(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantsMenu(
                          restaurantsModel: restaurant,
                        ),
                      ),
                    );
                  },
                  markerId: MarkerId(restaurant.rId),
                  position: LatLng(
                    restaurant.location['geopoint'].latitude,
                    restaurant.location['geopoint'].longitude,
                  ),
                ),
                child: CustomCardRestaurant(
                  Iconpressd: () {
                    if (restaurant.rLikes
                        .contains(FirebaseAuth.instance.currentUser?.uid)) {
                      FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(restaurant.rId)
                          .update({
                        'rLikes': FieldValue.arrayRemove(
                            [FirebaseAuth.instance.currentUser?.uid])
                      });
                    } else {
                      FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(restaurant.rId)
                          .update({
                        'rLikes': FieldValue.arrayUnion(
                            [FirebaseAuth.instance.currentUser?.uid])
                      });
                    }
                  },
                  tap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantsMenu(
                          restaurantsModel: restaurant,
                        ),
                      ),
                    );
                  },
                  icon: restaurant.rLikes
                          .contains(FirebaseAuth.instance.currentUser?.uid)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  likes: restaurant.rLikes.length.toString(),
                  height: getSizeHeight(context) * 0.10,
                  width: getSizeWidth(context) * 0.6,
                  rName: restaurant.rName,
                  rImage: restaurant.rImage,
                  rAddress: restaurant.rAddress,
                  rDistance:
                      '${restaurant.distanceInMiles.toStringAsFixed(2)} Miles',
                ),
              ),
            );
          }
        }
      });
      notifyListeners();
    });

    return markers;
  }

  getFilterRestaurants(List<String> categories) {
    List<RestaurantsModel> filteredList = _restaurantsListModel.where((res) {
      return res.categories.any((category) => categories.contains(category));
    }).toList();
    // _restaurantsListModel = filteredList;
    if (filteredList.isNotEmpty) {
      _filterResturantsListModel.clear();
      filteredList.forEach((element) {
        setFilterRestaurantsListModel(element);
      });
    }
    print("Filter${filteredList.length}");
    // notifyListeners();
  }

  List<RestaurantsModel> getNearbyRestaurants(
    LatLng userPosition,
  ) {
    final geo = Geoflutterfire();
    final center = geo.point(
      latitude: userPosition.latitude,
      longitude: userPosition.longitude,
    );
    final collectionReference =
        FirebaseFirestore.instance.collection('restaurants');
    final radius = 16.0934;
    final field = 'location';
    final stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field, strictMode: true);

    stream.listen((List<DocumentSnapshot> documentList) {
      print("Data in Nearby ${documentList.length}");
      _restaurantsListModel.clear();
      documentList.forEach((DocumentSnapshot document) {
        RestaurantsModel restaurant = RestaurantsModel.fromFirestore(document);
        final distance = distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          restaurant.location['geopoint'].latitude,
          restaurant.location['geopoint'].longitude,
        );
        print("Resturent Name: ${restaurant.rName}");
        if (restaurant.rApproved == 1 &&
            isOpen(restaurant.hours) &&
            restaurant.isOpen == true &&
            restaurant.isblocked == false) {
          restaurant.distanceInMiles = distance;

          setRestaurantsListModel(restaurant);
        }
      });
    });
    return _restaurantsListModel;
  }
}
