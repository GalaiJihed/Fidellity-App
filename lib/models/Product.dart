import 'package:json_annotation/json_annotation.dart';

import 'Store.dart';

part 'Product.g.dart';

@JsonSerializable(nullable: true)
class Product {
  int id;
  String productName;
  String reference;
  double price;
  double promoPrice;
  int reductionPerc;
  String image;
  double fp;
  int storeId;

  Product({
    this.id,
    this.productName,
    this.reference,
    this.price,
    this.promoPrice,
    this.reductionPerc,
    this.image,
    this.fp,
    this.storeId,
  });

  //factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  factory Product.fromJson(Map<String, dynamic> json, Store storeId) => Product(
        id: json["id"] as int,
        productName: json["ProductName"],
        reference: json["Reference"],
        price: json["Price"].toDouble() as double,
        promoPrice: json["PromoPrice"].toDouble() as double,
        reductionPerc: json["ReductionPerc"],
        image: json["Image"],
        fp: json["FP"].toDouble() as double,
        storeId: storeId.id,
      );

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'] as int;
    productName = map["ProductName"] as String;
    reference = map["Reference"];
    price = map["Price"] as double;
    promoPrice = map["PromoPrice"] as double;
    image = map["Image"];
    fp = map["FP"] as double;
    storeId = map['storeId'] as int;
  }

  Map<String, dynamic> toMap(int storeId) => {
        "id": id,
        "ProductName": productName,
        "Reference": reference,
        "Price": price,
        "PromoPrice": promoPrice,
        "Image": image,
        "FP": fp,
        "storeId": storeId,
      };
}
