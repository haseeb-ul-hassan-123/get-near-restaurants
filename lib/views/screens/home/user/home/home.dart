import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';
import 'package:hoyzee_app_map_feature/models/restaurants_model.dart';
import 'package:hoyzee_app_map_feature/provider/user/restaurants_provider.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/home/all_resturents.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/home/restaurants_menu.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_card_restaurant.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  List<Marker> _markers = [];
  double? _currentUserLatitude;
  double? _currentUserLongitude;
  GoogleMapController? _controller;
  GoogleMapController? _mapcontroller;
  String? _darkMapStyle;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Geoflutterfire? geoFlutterFire;
  String? deviceToken;
  Future<void> getUserLocation() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => {
              setState(() {
                _currentUserLatitude = value.get('latitude');
                _currentUserLongitude = value.get('longitude');
                deviceToken = value.get('deviceToken');
              })
            });
    final getRestaurants =
        Provider.of<RestaurantProvider>(context, listen: false);
    getRestaurants.getNearbyRestaurants(
      LatLng(_currentUserLatitude!, _currentUserLongitude!),
    );
    getRestaurants.addMarkers(
        LatLng(_currentUserLatitude!, _currentUserLongitude!),
        _customInfoWindowController,
        context,
        _selectedCategories.value);
  }

  bool showInfoWindowInitially = true;
  bool like1 = false;
  bool like2 = false;
  bool isLiked = false;
  final double minZoom = 14.4746;
  final double maxZoom = 20.77;
  final List<String> _categories = [
    'American cuisine',
    'Italian cuisine',
    'Mexican cuisine',
    'Chinese cuisine',
    'Japanese cuisine',
    'Mediterranean cuisine',
    'Vegetarian/vegan',
    'Comfort Food',
  ];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _selectedCategories = BehaviorSubject<List<String>>.seeded([]);

  void _toggleCategory(String category) {
    final selectedCategories = _selectedCategories.value;
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    _selectedCategories.add(selectedCategories);
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

  void _applyFilter() {
    final getRestaurants =
        Provider.of<RestaurantProvider>(context, listen: false);
    getRestaurants.getNearbyRestaurants(
      LatLng(_currentUserLatitude!, _currentUserLongitude!),
    );
    Navigator.pop(context);
  }

  void initState() {
    super.initState();
    getUserLocation();
    _controller?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(_currentUserLatitude!, _currentUserLongitude!), 14));
  }

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final restaurantNotifier = Provider.of<RestaurantProvider>(context);
    // addCustomInfoWindow();

    print("Categgdfhj${_selectedCategories.value}");

    print(
        "Categgdfhjdsd32${restaurantNotifier.filterRestaurantsListModel.length}");
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: CustomText(
            text: 'Home',
            size: 16,
            weight: FontWeight.bold,
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  _showFilterSheet();
                },
                child: ImageIcon(
                  AssetImage(Assets.sortImage),
                  size: 20,
                  color: kblackColor,
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            // MyMarker(globalKey),
            if (restaurantNotifier.restaurantsListModel.length != 0)
              if (_currentUserLatitude == null)
                Center(
                  child: CupertinoActivityIndicator(
                    color: kPrimaryColor,
                    radius: 30,
                  ),
                )
              else
                CustomGoogleMapMarkerBuilder(
                  //screenshotDelay: const Duration(seconds: 4),
                  customMarkers: restaurantNotifier.filtermarkers.isEmpty &&
                          _selectedCategories.value.isEmpty
                      ? restaurantNotifier.markers
                      : restaurantNotifier.filtermarkers,
                  builder: (BuildContext context, Set<Marker>? markers) {
                    if (markers == null) {
                      return const Center(
                          child: CupertinoActivityIndicator(
                        radius: 10,
                        color: Colors.black,
                      ));
                    }
                    return GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_currentUserLatitude ?? 0.0,
                            _currentUserLongitude ?? 0.0),
                        zoom: 14.4746,
                      ),
                      markers: {
                        ...markers,
                        Marker(
                            markerId: MarkerId('Your Location'),
                            position: LatLng(_currentUserLatitude ?? 0.0,
                                _currentUserLongitude ?? 0.0),
                            icon: BitmapDescriptor.defaultMarker,
                            infoWindow: InfoWindow(
                                title:
                                    "Your Location") // Customize the marker icon as needed
                            ),
                      },
                      onCameraMove: (CameraPosition position) {
                        // print('on camer move: ${position.zoom}');
                        // if (position.zoom <= 13) {
                        //   restaurantNotifier.setSignUpLoading(false);
                        // } else {
                        //   restaurantNotifier.setSignUpLoading(true);
                        // }
                      },
                      onMapCreated: (GoogleMapController controller) async {
                        _mapcontroller = controller;
                        _controller?.animateCamera(CameraUpdate.newLatLngZoom(
                            LatLng(_currentUserLatitude ?? 0.0,
                                _currentUserLongitude ?? 0.0),
                            14));
                        controller.setMapStyle(await rootBundle
                            .loadString('assets/map_style/dark.json'));
                      },
                    );
                  },
                )
            else
              // _currentUserLatitude == null && _currentUserLongitude == null
              //     ? CupertinoActivityIndicator()
              //     :
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(_currentUserLatitude!, _currentUserLongitude!),
                  zoom: 12,
                ),
                onMapCreated: (controller) async {
                  _controller = controller;
                  _controller?.animateCamera(CameraUpdate.newLatLngZoom(
                      LatLng(_currentUserLatitude!, _currentUserLongitude!),
                      14));
                  controller.setMapStyle(await rootBundle
                      .loadString('assets/map_style/dark.json'));
                },
                markers: {
                  Marker(
                    markerId: MarkerId('Your Location'),
                    position:
                        LatLng(_currentUserLatitude!, _currentUserLongitude!),
                    icon: BitmapDescriptor.defaultMarker,
                    infoWindow: InfoWindow(title: "Your Location"),
                  ),
                },
              ),
            Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: CustomButton(
                            width: getSizeWidth(context) * 0.3,
                            radius: 40,
                            height: 40,
                            bordercolor: Colors.transparent,
                            buttonText: 'View all',
                            // onTap: () async {
                            //   await NotificationHandler.sendPushNotification(
                            //     title: 'Send notification',
                            //     body: "This is Simple notification of hoyzee",
                            //     token: deviceToken,
                            //   );
                            // },
                            onTap: () => Get.to(() => AllResturents(
                                  currentUserLatitude: _currentUserLatitude!,
                                  currentUserLongitude: _currentUserLongitude!,
                                ))),
                      ),
                    ),
                    SizedBox(
                      height: getSizeHeight(context) * 0.02,
                    ),
                    restaurantNotifier.restaurantsListModel.length != 0
                        ? _selectedCategories.value.isNotEmpty &&
                                restaurantNotifier
                                    .filterRestaurantsListModel.isEmpty
                            ? Container(
                                height: getSizeHeight(context) * 0.12,
                                child: Center(
                                  child: CustomText(
                                    text: 'No nearby restaurants available',
                                    color: kPrimaryColor,
                                  ),
                                ),
                              )
                            : Container(
                                height: getSizeHeight(context) * 0.12,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: restaurantNotifier
                                            .filterRestaurantsListModel
                                            .isNotEmpty
                                        ? restaurantNotifier
                                            .filterRestaurantsListModel.length
                                        : restaurantNotifier
                                            .restaurantsListModel.length,
                                    itemBuilder: (context, index) {
                                      print(
                                          "Nearbydhfhsdf${restaurantNotifier.restaurantsListModel.length}");
                                      print(
                                          "Nearbydhfhsdf2222${restaurantNotifier.filterRestaurantsListModel.length}");

                                      RestaurantsModel restaurantsModel =
                                          restaurantNotifier
                                                  .filterRestaurantsListModel
                                                  .isNotEmpty
                                              ? restaurantNotifier
                                                      .filterRestaurantsListModel[
                                                  index]
                                              : restaurantNotifier
                                                  .restaurantsListModel[index];
                                      print(
                                          'rest ======= ${restaurantsModel.rName}');
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: CustomCardRestaurant(
                                            Iconpressd: () {
                                              if (restaurantsModel.rLikes
                                                  .contains(FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid)) {
                                                FirebaseFirestore.instance
                                                    .collection('restaurants')
                                                    .doc(restaurantsModel.rId)
                                                    .update({
                                                  'rLikes':
                                                      FieldValue.arrayRemove([
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid
                                                  ])
                                                });
                                              } else {
                                                FirebaseFirestore.instance
                                                    .collection('restaurants')
                                                    .doc(restaurantsModel.rId)
                                                    .update({
                                                  'rLikes':
                                                      FieldValue.arrayUnion([
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid
                                                  ])
                                                });
                                              }
                                            },
                                            tap: () =>
                                                Get.to(() => RestaurantsMenu(
                                                      restaurantsModel:
                                                          restaurantsModel,
                                                    )),
                                            icon: restaurantsModel.rLikes
                                                    .contains(FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        ?.uid)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            likes: restaurantsModel
                                                .rLikes.length
                                                .toString(),
                                            height:
                                                getSizeHeight(context) * 0.12,
                                            width: getSizeWidth(context) * 0.8,
                                            rName: restaurantsModel.rName,
                                            rImage: restaurantsModel.rImage,
                                            rAddress: restaurantsModel.rAddress,
                                            rDistance:
                                                '${restaurantsModel.distanceInMiles.toStringAsFixed(2)} Miles',
                                          ),
                                        ),
                                      );
                                    }),
                              )
                        : Container(
                            height: getSizeHeight(context) * 0.12,
                            child: Center(
                              child: CustomText(
                                text: 'No nearby restaurants available',
                                color: kPrimaryColor,
                              ),
                            ),
                          )
                  ],
                )),
          ],
        ));
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(minHeight: getSizeHeight(context) * 0.07),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: context,
      builder: (BuildContext context) {
        return _BottomSheet();
      },
    );
  }

  Widget _BottomSheet() {
    final getRestaurants = Provider.of<RestaurantProvider>(
      context,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: getSizeWidth(context) * 0.15,
            child: Divider(
              height: 5,
              thickness: 2,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: CustomText(
              text: 'Search Filter',
              size: 16,
              weight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CustomText(
                text: 'Category',
                size: 16,
                weight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Column(
            children: [
              Row(
                children: [
                  _buildCategoryChip(
                    'American cuisine',
                  ),
                  _buildCategoryChip(
                    'Italian cuisine',
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCategoryChip(
                    'Mexican cuisine',
                  ),
                  _buildCategoryChip(
                    'Chinese cuisine',
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCategoryChip(
                    'Japanese cuisine',
                  ),
                  _buildCategoryChip(
                    'Mediterranean cuisine',
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCategoryChip(
                    'Vegetarian/vegan',
                  ),
                  _buildCategoryChip(
                    'Comfort Food',
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          CustomButton(
              bgColor: kPrimaryColor,
              radius: 40,
              bordercolor: Colors.transparent,
              buttonText: 'Apply',
              onTap: () {
                print("Selected Categories:${_selectedCategories.value}");
                Provider.of<RestaurantProvider>(context, listen: false)
                    .clearFilterRestaurantsList();
                Provider.of<RestaurantProvider>(context, listen: false)
                    .clearFilterMarkers();
                if (_selectedCategories.value.isEmpty) {
                  getRestaurants.getNearbyRestaurants(
                    LatLng(_currentUserLatitude!, _currentUserLongitude!),
                  );
                  getRestaurants.addMarkers(
                      LatLng(_currentUserLatitude!, _currentUserLongitude!),
                      _customInfoWindowController,
                      context,
                      _selectedCategories.value);
                  Navigator.pop(context);
                } else {
                  getRestaurants
                      .getFilterRestaurants(_selectedCategories.value);
                  getRestaurants.filterAddMarkers(
                      LatLng(_currentUserLatitude!, _currentUserLongitude!),
                      _customInfoWindowController,
                      context,
                      _selectedCategories.value);
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    String category,
  ) {
    return StreamBuilder<List<String>>(
      stream: _selectedCategories.stream,
      builder: (context, snapshot) {
        final bool isSelected = snapshot.data?.contains(category) ?? false;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _toggleCategory(
                  category,
                );
              },
              child: Container(
                height: getSizeHeight(context) * 0.07,
                width: getSizeWidth(context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected ? kPrimaryColor : Colors.grey,
                    )),
                child: Center(
                  child: CustomText(
                    text: category,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyMarker extends StatelessWidget {
  // declare a global key and get it trough Constructor
  MyMarker(this.globalKeyMyWidget);
  final GlobalKey globalKeyMyWidget;
  @override
  Widget build(BuildContext context) {
    // wrap your widget with RepaintBoundary and
    // pass your global key to RepaintBoundary
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 180,
            decoration:
                BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          ),
          Container(
              width: 220,
              height: 150,
              decoration:
                  BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.accessibility,
                    color: Colors.white,
                    size: 35,
                  ),
                  Text(
                    'Widget',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
