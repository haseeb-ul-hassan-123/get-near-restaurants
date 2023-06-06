import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/models/products_model.dart';
import 'package:hoyzee_app_map_feature/models/restaurants_model.dart';
import 'package:hoyzee_app_map_feature/provider/user/restaurants_provider.dart';
import 'package:hoyzee_app_map_feature/services/user/user_api.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/home/order_now.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/home/restaurants_menu.dart';
import 'package:hoyzee_app_map_feature/views/widgets/customLoading.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_card_restaurant.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_container.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class Like extends StatefulWidget {
  const Like({Key? key}) : super(key: key);

  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> with SingleTickerProviderStateMixin {
  @override
  TabController? _tabController;
  List<Marker> _markers = [];
  double? _currentUserLatitude;
  double? _currentUserLongitude;
  GoogleMapController? _controller;
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getRestaurants();
    }
  }

  Future<void> _getRestaurants() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => {
              setState(() {
                print("fhdsdhjfk${value.get('latitude')}");
                _currentUserLatitude = value.get('latitude');
                _currentUserLongitude = value.get('longitude');
              })
            });
    final getRestaurants =
        Provider.of<RestaurantProvider>(context, listen: false);
    getRestaurants.getNearbyRestaurants(
      LatLng(_currentUserLatitude ?? 0.0, _currentUserLongitude ?? 0.0),
    );
  }

  bool like1 = false;
  bool like2 = false;
  List<RestaurantsModel> _nearbyRestaurants = [];
  bool isLiked = false;
  @override
  void initState() {
    super.initState();

    _getRestaurants();
    _tabController = TabController(vsync: this, length: 2);
    // length represents the number of tabs in the TabBar
  }

  Widget build(BuildContext context) {
    final restaurantNotifier = Provider.of<RestaurantProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Column(
            children: [
              Container(
                height: 0.2,
                color: Colors.black,
                width: getSizeWidth(context),
              ),
              Container(
                height: getSizeHeight(context) * 0.06,
                child: TabBar(
                  controller: _tabController,
                  labelColor:
                      Colors.black, // set the color of the selected tab's label
                  unselectedLabelColor: Colors
                      .black, // set the color of the unselected tab's label
                  indicatorColor: kblackColor,
                  indicatorWeight: 2,
                  unselectedLabelStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w400, fontSize: 12),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          12), // set the color of the active tab indicator line
                  tabs: [
                    Tab(
                      text: 'Products',
                    ),
                    Tab(text: 'Restaurants'),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: kPrimaryColor,
        title: CustomText(
          text: 'Favorites',
          size: 16,
          weight: FontWeight.bold,
        ),
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
              itemCount: restaurantNotifier.restaurantsListModel.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('restaurants')
                      .doc(restaurantNotifier.restaurantsListModel[index].rId)
                      .collection('products')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CustomActivityIndicator(
                          radius: 20,
                        ),
                      );
                    }

                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs
                          .map((document) {
                            ProductsModel productsModel =
                                ProductsModel.fromJson(document.data());

                            return productsModel.pLikes.contains(
                                    FirebaseAuth.instance.currentUser?.uid)
                                ? InkWell(
                                    onTap: () => Get.to(() => OrderNow(
                                          restaurantsModel: restaurantNotifier
                                              .restaurantsListModel[index],
                                          productsModel: productsModel,
                                        )),
                                    child: CustomContainer(
                                      onpressed: () {
                                        if (productsModel.pLikes.contains(
                                            FirebaseAuth
                                                .instance.currentUser?.uid)) {
                                          FirebaseFirestore.instance
                                              .collection('restaurants')
                                              .doc(restaurantNotifier
                                                  .restaurantsListModel[index]
                                                  .rId)
                                              .collection('products')
                                              .doc(document.id)
                                              .update({
                                            'pLikes': FieldValue.arrayRemove([
                                              FirebaseAuth
                                                  .instance.currentUser?.uid
                                            ])
                                          });
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection('restaurants')
                                              .doc(restaurantNotifier
                                                  .restaurantsListModel[index]
                                                  .rId)
                                              .collection('products')
                                              .doc(document.id)
                                              .update({
                                            'pLikes': FieldValue.arrayUnion([
                                              FirebaseAuth
                                                  .instance.currentUser?.uid
                                            ])
                                          });
                                        }
                                      },
                                      color: productsModel.pLikes.contains(
                                              FirebaseAuth
                                                  .instance.currentUser?.uid)
                                          ? Colors.red
                                          : Colors.black,
                                      icon: productsModel.pLikes.contains(
                                              FirebaseAuth
                                                  .instance.currentUser?.uid)
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      height: getSizeHeight(context) * 0.12,
                                      width: getSizeWidth(context),
                                      rName: productsModel.pName,
                                      rImage: productsModel.pImages,
                                      price: "\$${productsModel.pPrice}",
                                    ),
                                  )
                                : SizedBox();
                          })
                          .toList()
                          .cast(),
                    );
                  },
                );
              }),
          ListView.builder(
              itemCount: restaurantNotifier.restaurantsListModel.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                RestaurantsModel data =
                    restaurantNotifier.restaurantsListModel[index];
                return restaurantNotifier.restaurantsListModel[index].rLikes
                            .contains(UserApi.currentUser) ==
                        true
                    ? Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 3),
                          child: CustomCardRestaurant(
                            Iconpressd: () {
                              if (data.rLikes.contains(UserApi.currentUser)) {
                                FirebaseFirestore.instance
                                    .collection('restaurants')
                                    .doc(data.rId)
                                    .update({
                                  'rLikes': FieldValue.arrayRemove(
                                      [UserApi.currentUser])
                                });
                              } else {
                                FirebaseFirestore.instance
                                    .collection('restaurants')
                                    .doc(data.rId)
                                    .update({
                                  'rLikes': FieldValue.arrayUnion(
                                      [UserApi.currentUser])
                                });
                              }
                            },
                            tap: () => Get.to(() => RestaurantsMenu(
                                  restaurantsModel: restaurantNotifier
                                      .restaurantsListModel[index],
                                )),
                            icon: data.rLikes.contains(UserApi.currentUser)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            likes: data.rLikes.length.toString(),
                            height: getSizeHeight(context) * 0.12,
                            width: getSizeWidth(context),
                            rName: data.rName,
                            rImage: data.rImage,
                            rAddress: data.rAddress,
                            rDistance: data.distanceInMiles.toStringAsFixed(2),
                          ),
                        ),
                      )
                    : SizedBox();
              })
        ],
      ),
    );
  }
}
