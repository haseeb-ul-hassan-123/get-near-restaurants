import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class CustomCardRestaurant extends StatelessWidget {
  CustomCardRestaurant(
      {Key? key,
      required this.rImage,
      required this.rName,
      required this.rAddress,
      required this.rDistance,
      this.height,
      this.likes,
      this.icon,
      this.width,
      this.Iconpressd,
      this.tap})
      : super(key: key);
  final String rImage;
  final String rName;
  final String rAddress;
  final String rDistance;
  double? height, width;
  final IconData? icon;
  final String? likes;
  final VoidCallback? Iconpressd;
  final VoidCallback? tap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: kwhiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 0.5)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: tap,
              child: CachedNetworkImage(
                imageUrl: rImage,
                placeholder: (context, url) => CupertinoActivityIndicator(
                  radius: 5,
                  color: Colors.black,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider,
                      )),
                ),
              ),
            ),
          ),
          SizedBox(
            width: getSizeWidth(context) * 0.02,
          ),
          Expanded(
            flex: 5,
            child: InkWell(
              onTap: tap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomText(
                    text: rName,
                    size: 13,
                    weight: FontWeight.w600,
                  ),
                  Expanded(
                    child: CustomText(
                      text: rAddress,
                      size: 12,
                      maxLines: 2,
                      overFlow: TextOverflow.ellipsis,
                      weight: FontWeight.w400,
                    ),
                  ),
                  CustomText(
                    text: rDistance,
                    size: 12,
                    weight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: Iconpressd,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: Iconpressd,
                    child: Icon(
                      icon,
                      color: Colors.red,
                    ),
                  ),
                  CustomText(
                    text: likes,
                    size: 12,
                    color: kblackColor,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
