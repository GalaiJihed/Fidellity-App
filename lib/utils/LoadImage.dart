import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'Theme.dart' as Theme;

class LoadImage extends StatelessWidget {
  double width;
  double height;
  double padding;
  String imageUrl;
  double borderRadius;
  double imageBorderRadius;

  LoadImage(this.imageUrl, this.width, this.height, this.padding,
      this.borderRadius, this.imageBorderRadius);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          //image builder
          imageBuilder: (context, imageProvider) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(imageBorderRadius),
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
            ),
          ),

          //placeholder
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Theme.mainColorAccent,
            highlightColor: Theme.mainColorAccent,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Theme.whiteColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          //errorWidget
          errorWidget: (context, url, error) => Shimmer.fromColors(
            baseColor: Theme.mainColorAccent,
            highlightColor: Theme.mainColorAccent,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Theme.whiteColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
