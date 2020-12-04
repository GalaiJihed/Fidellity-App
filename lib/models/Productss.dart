import 'package:flutter/cupertino.dart';

class Productss {
  String lineItemId;
  int productId;
  String productName;
  List<Image> images;
  List<String> size;
  String shortDescription;
  String regularPrice;
  String salePrice;
  int discount;
  bool ifItemAvailable;
  bool ifAddedToCart;
  String description;
  int stockQuantity;
  int quantity;

  Productss(
      {this.lineItemId,
      this.productId,
      this.productName,
      this.images,
      this.size,
      this.shortDescription,
      this.regularPrice,
      this.salePrice,
      this.discount,
      this.ifItemAvailable,
      this.ifAddedToCart,
      this.description,
      this.stockQuantity,
      this.quantity});

  @override
  toString() => "productId: $productId , productName: $productName";
}
