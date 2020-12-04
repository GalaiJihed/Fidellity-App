import 'package:json_annotation/json_annotation.dart';

import 'Product.dart';
import 'Store.dart';

part 'Productsline.g.dart';

@JsonSerializable(nullable: true)
class Productsline {
  int quantity;
  DateTime date;
  Product product;
  int productId;

  Productsline({
    this.quantity,
    this.date,
    this.product,
  });

  /* factory Productsline.fromRawJson(String str) =>
      Productsline.fromJson(json.decode(str));*/

  factory Productsline.fromJson(Map<String, dynamic> json, Store storeId) =>
      Productsline(
        quantity: json["quantity"],
        date: DateTime.parse(json["date"]),
        product: Product.fromJson(json["product"], storeId),
      );

  Productsline.fromMap(Map<String, dynamic> map, Product productinLine) {
    quantity = map['quantity'] as int;
    date = fromTimestampToDateTime(map["date"]);
    product = productinLine;
  }

  Map<String, dynamic> toMap(int orderId) => {
        "quantity": quantity,
        "date": date.millisecondsSinceEpoch,
        "productId": product.id,
        "orderId": orderId,
      };

  DateTime fromTimestampToDateTime(int date) {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
    return dateTime;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "ProductLine: \nQuantité: $quantity ";
  }
}
