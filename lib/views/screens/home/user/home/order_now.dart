import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';
import 'package:hoyzee_app_map_feature/models/products_model.dart';
import 'package:hoyzee_app_map_feature/models/restaurants_model.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderNow extends StatefulWidget {
  final RestaurantsModel restaurantsModel;
  final ProductsModel productsModel;
  const OrderNow(
      {Key? key, required this.productsModel, required this.restaurantsModel})
      : super(key: key);

  @override
  State<OrderNow> createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {
  @override
  GoogleMapController? _controller;
  @override
  bool isLiked = false;
  getRestaurantslocation() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantsModel.rId)
        .get()
        .then((value) => {
              setState(() {
                geoPoint = value['location']['geopoint'];
              })
            });
  }

  GeoPoint? geoPoint;

  void initState() {
    // TODO: implement initState
    getRestaurantslocation();
    FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantsModel.rId)
        .collection('products')
        .doc(widget.productsModel.pId)
        .get()
        .then((documentSnapshot) {
      setState(() {
        isLiked = widget.productsModel.pLikes
            .contains(FirebaseAuth.instance.currentUser?.uid);
      });
    }).catchError((error) {
      // handle errors
    });

    _controller?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(geoPoint?.latitude ?? 0.0, geoPoint?.longitude ?? 0.0), 14));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  bool like = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: CustomText(
          text: 'Order Now',
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
          Consumer(builder: (_, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isLiked) {
                      FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(widget.restaurantsModel.rId)
                          .collection('products')
                          .doc(widget.productsModel.pId)
                          .update({
                        'pLikes': FieldValue.arrayRemove(
                            [FirebaseAuth.instance.currentUser?.uid])
                      });
                      setState(() {
                        isLiked = !isLiked;
                      });
                    } else {
                      FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(widget.restaurantsModel.rId)
                          .collection('products')
                          .doc(widget.productsModel.pId)
                          .update({
                        'pLikes': FieldValue.arrayUnion(
                            [FirebaseAuth.instance.currentUser?.uid])
                      });
                      setState(() {
                        isLiked = !isLiked;
                      });
                    }
                    // Update the state of the "like" variable based on the new like/dislike status
                    like = !isLiked;
                  });
                },
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_outline_rounded,
                  color: isLiked ? Colors.red : Colors.black,
                ),
              ),
            );
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.productsModel.pImages,
              placeholder: (context, url) => CupertinoActivityIndicator(
                radius: 5,
                color: Colors.black,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                width: getSizeWidth(context),
                height: getSizeHeight(context) * 0.30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                )),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              height: getSizeHeight(context) * 0.12,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomText(
                    text: widget.productsModel.pName,
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: widget.productsModel.pCategory,
                        size: 12,
                        weight: FontWeight.w400,
                      ),
                      Spacer(),
                      CustomText(
                        text: '\$${widget.productsModel.pPrice}',
                        size: 12,
                        weight: FontWeight.w600,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getSizeHeight(context) * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              height: getSizeHeight(context) * 0.18,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomText(
                    text: 'Others',
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: getSizeHeight(context) * 0.01,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(
                            'restaurants') // Replace with your Firestore collection name
                        .doc(widget.restaurantsModel.rId)
                        .collection('products')
                        .where('pCategory',
                            isEqualTo: widget.productsModel
                                .pCategory) // Replace with the ID of the document containing the image URL
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final products = snapshot.data!.docs
                            .where((document) {
                              ProductsModel productsModel =
                                  ProductsModel.fromJson(document.data());
                              return productsModel.status == 0;
                            })
                            .toList()
                            .cast<DocumentSnapshot>();

                        return Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  ProductsModel productsModel =
                                      ProductsModel.fromJson(
                                          products[index].data());
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OrderNow(
                                                    restaurantsModel:
                                                        widget.restaurantsModel,
                                                    productsModel:
                                                        productsModel,
                                                  )));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: productsModel.pImages,
                                            placeholder: (context, url) =>
                                                CupertinoActivityIndicator(
                                              radius: 5,
                                              color: Colors.black,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width:
                                                  getSizeWidth(context) * 0.2,
                                              height:
                                                  getSizeHeight(context) * 0.09,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: imageProvider,
                                                  )),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                getSizeHeight(context) * 0.01,
                                          ),
                                          CustomText(
                                            text: productsModel.pName,
                                            size: 12,
                                            weight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomText(
                  text: 'Location',
                  size: 16,
                  weight: FontWeight.w600,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: getSizeHeight(context) * 0.35,
                  width: getSizeWidth(context) * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: GoogleMap(
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(geoPoint?.latitude ?? 0.0,
                            geoPoint?.longitude ?? 0.0),
                        zoom: 14.4746,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId("Current"),
                          position: LatLng(geoPoint?.latitude ?? 0.0,
                              geoPoint?.longitude ?? 0.0),
                          infoWindow: InfoWindow(
                            title: widget.restaurantsModel.rName,
                          ),
                        ),
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                        controller?.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(geoPoint?.latitude ?? 0.0,
                                geoPoint?.longitude ?? 0.0),
                            14,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () {
                      _controller?.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(geoPoint?.latitude ?? 0.0,
                              geoPoint?.longitude ?? 0.0),
                          14,
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.my_location,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getSizeHeight(context) * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: CustomButton(
                  bordercolor: Colors.transparent,
                  radius: 30,
                  buttonText: 'Call To Order Now',
                  iconWidth: getSizeWidth(context) * 0.03,
                  phoneIcon: SvgPicture.asset(Assets.phone),
                  onTap: () async {
                    await launch("tel:${widget.restaurantsModel.rNumber}")
                        ? await launch("tel:${widget.restaurantsModel.rNumber}")
                        : throw " Could'nt Launch ${widget.restaurantsModel.rNumber}";
                  }),
            )
          ],
        ),
      ),
    );
  }
}
