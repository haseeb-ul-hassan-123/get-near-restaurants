import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class ListingContainer extends StatelessWidget {
  ListingContainer({
    Key? key,
    required this.listImage,
    required this.ListName,
    required this.listPrice,
    required this.listType,
    this.height,
    this.width,
    required this.icon,
  }) : super(key: key);
  final String listImage;
  final String ListName;
  final String listPrice;
  final String listType;
  final Widget icon;

  double? height, width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        height: height,
        width: width,
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: listImage != null
                    ? CachedNetworkImage(
                        imageUrl: listImage,
                        placeholder: (context, url) =>
                            CupertinoActivityIndicator(
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
                      )
                    : Center(
                        child: CupertinoActivityIndicator(
                          color: kPrimaryColor,
                          radius: 20,
                        ),
                      )),
            SizedBox(
              width: getSizeWidth(context) * 0.02,
            ),
            Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomText(
                      text: ListName,
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                    CustomText(
                      text: listType,
                      size: 12,
                      weight: FontWeight.w400,
                    ),
                    CustomText(
                      text: listPrice,
                      size: 12,
                      weight: FontWeight.w400,
                    ),
                  ],
                )),
            Expanded(
              flex: 2,
              child: icon,
            )
          ],
        ),
      ),
    );
  }
}
