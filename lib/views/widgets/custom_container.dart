import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({
    Key? key,
    required this.rImage,
    required this.rName,
    required this.price,
    required this.color,
    this.height,
    this.width,
    this.icon,
    this.onpressed,
  }) : super(key: key);
  final String rImage;
  final String rName;
  final String price;
  final IconData? icon;
  final Color color;
  double? height, width;
  final VoidCallback? onpressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      height: height,
      width: width,
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: rImage,
                  placeholder: (context, url) => CupertinoActivityIndicator(
                    radius: 5,
                    color: Colors.black,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        )),
                  ),
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
                    text: rName,
                    size: 13,
                    weight: FontWeight.w600,
                  ),
                  CustomText(
                    text: price,
                    size: 12,
                    weight: FontWeight.w400,
                  ),
                ],
              )),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: onpressed,
              child: Icon(
                icon,
                color: color,
              ),
            ),
          )
        ],
      ),
    );
  }
}
