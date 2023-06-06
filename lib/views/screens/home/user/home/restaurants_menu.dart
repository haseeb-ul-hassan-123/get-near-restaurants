import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/models/products_model.dart';
import 'package:hoyzee_app_map_feature/models/restaurants_model.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/home/order_now.dart';
import 'package:hoyzee_app_map_feature/views/widgets/customLoading.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

import '../../../../widgets/custom_container.dart';

class RestaurantsMenu extends StatefulWidget {
  final RestaurantsModel restaurantsModel;
  const RestaurantsMenu({Key? key, required this.restaurantsModel})
      : super(key: key);

  @override
  State<RestaurantsMenu> createState() => _RestaurantsMenuState();
}

class _RestaurantsMenuState extends State<RestaurantsMenu> {
  @override
  bool showSearchField = false;
  String searchQuery = '';
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          title: showSearchField
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    key: Key('searchField'),
                    width: getSizeHeight(context) * 1,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              : CustomText(
                  text: widget.restaurantsModel.rName,
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: showSearchField
                    ? IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            showSearchField = false;
                          });
                        },
                      )
                    : IconButton(
                        key: Key('searchIcon'),
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            showSearchField = true;
                          });
                        },
                      ),
              ),
            ),
          ],
        ),
        body: searchQuery.isEmpty
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(widget.restaurantsModel.rId)
                    .collection('products')
                    .where('status', isEqualTo: 0)
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
                    children: snapshot.data!.docs
                        .map((document) {
                          ProductsModel productsModel =
                              ProductsModel.fromJson(document.data());
                          return InkWell(
                            onTap: () => Get.to(() => OrderNow(
                                  restaurantsModel: widget.restaurantsModel,
                                  productsModel: productsModel,
                                )),
                            child: CustomContainer(
                              color: Colors.white,
                              height: getSizeHeight(context) * 0.12,
                              width: getSizeWidth(context),
                              rName: productsModel.pName,
                              rImage: productsModel.pImages,
                              price: "\$${productsModel.pPrice}",
                            ),
                          );
                        })
                        .toList()
                        .cast(),
                  );
                },
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(widget.restaurantsModel.rId)
                    .collection('products')
                    .where('status', isEqualTo: 0)
                    .where('pName', isGreaterThanOrEqualTo: searchQuery)
                    .where('pName', isLessThan: searchQuery + 'z')
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
                    children: snapshot.data!.docs
                        .map((document) {
                          ProductsModel productsModel =
                              ProductsModel.fromJson(document.data());
                          return InkWell(
                            onTap: () => Get.to(() => OrderNow(
                                  restaurantsModel: widget.restaurantsModel,
                                  productsModel: productsModel,
                                )),
                            child: CustomContainer(
                              color: Colors.white,
                              height: getSizeHeight(context) * 0.12,
                              width: getSizeWidth(context),
                              rName: productsModel.pName,
                              rImage: productsModel.pImages,
                              price: "\$${productsModel.pPrice}",
                            ),
                          );
                        })
                        .toList()
                        .cast(),
                  );
                },
              ));
  }
}
