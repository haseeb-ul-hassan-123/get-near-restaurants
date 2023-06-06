import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';
import 'package:hoyzee_app_map_feature/models/restaurants_model.dart';
import 'package:hoyzee_app_map_feature/provider/user/restaurants_provider.dart';
import 'package:hoyzee_app_map_feature/views/widgets/customLoading.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_card_restaurant.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'restaurants_menu.dart';

class AllResturents extends StatefulWidget {
  final double currentUserLatitude;
  final double currentUserLongitude;
  const AllResturents({
    Key? key,
    required this.currentUserLatitude,
    required this.currentUserLongitude,
  }) : super(key: key);

  @override
  State<AllResturents> createState() => _AllResturentsState();
}

class _AllResturentsState extends State<AllResturents> {
  @override
  void initState() {
    // TODO: implement initState
    final restaurantNotifier =
        Provider.of<RestaurantProvider>(context, listen: false);
    restaurantNotifier.getNearbyRestaurants(
        LatLng(widget.currentUserLatitude, widget.currentUserLongitude));
    super.initState();
  }

  final _selectedCategories = BehaviorSubject<List<String>>.seeded([]);
  Widget build(BuildContext context) {
    final restaurantNotifier = Provider.of<RestaurantProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: CustomText(
          text: 'All Restaurants',
          size: 16,
          weight: FontWeight.bold,
        ),
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () => Get.back()),
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
      body: _selectedCategories.value.isNotEmpty &&
              restaurantNotifier.filterRestaurantsListModel.isEmpty
          ? Container(
              height: getSizeHeight(context) * 0.12,
              child: Center(
                child: CustomText(
                  text: 'No nearby restaurants available',
                  color: kPrimaryColor,
                ),
              ),
            )
          : ListView.builder(
              itemCount:
                  restaurantNotifier.filterRestaurantsListModel.isNotEmpty
                      ? restaurantNotifier.filterRestaurantsListModel.length
                      : restaurantNotifier.restaurantsListModel.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('restaurants')
                      .where('rId',
                          isEqualTo: restaurantNotifier
                              .restaurantsListModel[index].rId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    final distance = restaurantNotifier
                        .restaurantsListModel[index].distanceInMiles;
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
                            RestaurantsModel restaurantsModel =
                                restaurantNotifier
                                        .filterRestaurantsListModel.isNotEmpty
                                    ? restaurantNotifier
                                        .filterRestaurantsListModel[index]
                                    : restaurantNotifier
                                        .restaurantsListModel[index];
                            return Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15, bottom: 3),
                                child: CustomCardRestaurant(
                                  Iconpressd: () {
                                    if (restaurantsModel.rLikes.contains(
                                        FirebaseAuth.instance.currentUser
                                            ?.phoneNumber)) {
                                      FirebaseFirestore.instance
                                          .collection('restaurants')
                                          .doc(document.id)
                                          .update({
                                        'rLikes': FieldValue.arrayRemove([
                                          FirebaseAuth
                                              .instance.currentUser?.phoneNumber
                                        ])
                                      });
                                    } else {
                                      FirebaseFirestore.instance
                                          .collection('restaurants')
                                          .doc(document.id)
                                          .update({
                                        'rLikes': FieldValue.arrayUnion([
                                          FirebaseAuth
                                              .instance.currentUser?.phoneNumber
                                        ])
                                      });
                                    }
                                  },
                                  tap: () => Get.to(() => RestaurantsMenu(
                                        restaurantsModel: restaurantsModel,
                                      )),
                                  icon: restaurantsModel.rLikes.contains(
                                          FirebaseAuth.instance.currentUser
                                              ?.phoneNumber)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  likes:
                                      restaurantsModel.rLikes.length.toString(),
                                  height: getSizeHeight(context) * 0.12,
                                  width: getSizeWidth(context),
                                  rName: restaurantsModel.rName,
                                  rImage: restaurantsModel.rImage,
                                  rAddress: restaurantsModel.rAddress,
                                  rDistance:
                                      '${distance.toStringAsFixed(2)} Miles',
                                ),
                              ),
                            );
                          })
                          .toList()
                          .cast(),
                    );
                  },
                );
              }),
    );
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
                if (_selectedCategories.value.isEmpty) {
                  getRestaurants.getNearbyRestaurants(
                    LatLng(widget.currentUserLatitude,
                        widget.currentUserLongitude),
                  );

                  Navigator.pop(context);
                } else {
                  getRestaurants
                      .getFilterRestaurants(_selectedCategories.value);
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

  void _toggleCategory(String category) {
    final selectedCategories = _selectedCategories.value;
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    _selectedCategories.add(selectedCategories);
  }

  @override
  void dispose() {
    _selectedCategories.close();
    super.dispose();
  }
}
