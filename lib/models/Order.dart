import 'package:json_annotation/json_annotation.dart';

import 'Productsline.dart';
import 'Store.dart';

@JsonSerializable(nullable: true)
class Order {
  int id;
  bool fPused;
  double totalprice;
  double newTotalPrice;
  double fidelityPointsEarned;
  DateTime date;
  List<Productsline> productslines;
  Store store;
  int storeID;

  Order({
    this.id,
    this.fPused,
    this.totalprice,
    this.newTotalPrice,
    this.fidelityPointsEarned,
    this.date,
    this.productslines,
    this.store,
  });

  //factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        fPused: json["FPused"],
        totalprice: json["totalprice"].toDouble() as double,
        newTotalPrice: json["newTotalPrice"] == null
            ? null
            : json["newTotalPrice"].toDouble() as double,
        fidelityPointsEarned: json["fidelityPointsEarned"] == null
            ? null
            : json["fidelityPointsEarned"].toDouble() as double,
        date: DateTime.parse(json["date"]),
        productslines: List<Productsline>.from(json["productslines"]
            .map((x) => Productsline.fromJson(x, Store.fromJson(json)))),
        store: Store.fromJson(json),
      );

  Order.fromMap(
      Map<String, dynamic> map, List<Productsline> products, Store mystore) {
    id = map['id'] as int;
    totalprice = map['totalprice'].toDouble() as double;
    newTotalPrice = map['totalnewprice'] == null
        ? null
        : map["totalnewprice"].toDouble() as double;
    fidelityPointsEarned =
        map['fpgained'] == null ? null : map["fpgained"].toDouble() as double;
    fPused = (map['fpused'] == 1);
    date = fromTimestampToDateTime(map["date"]);
    storeID = map['storeid'] as int;
    store = mystore;
    productslines = products;
  }

  Map<String, dynamic> toMap(int idStore) => {
        "id": id,
        "date": date.millisecondsSinceEpoch,
        "storeId": store.id,
        "totalprice": totalprice,
        "totalnewprice": newTotalPrice,
        "fpgained": fidelityPointsEarned,
        "fpused": fPused,
        "storeid": idStore,
      };

  DateTime fromTimestampToDateTime(int date) {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
    return dateTime;
  }

  @override
  String toString() {
    // TODO: implement toString
    return id.toString() +
        " " +
        productslines.length.toString() +
        " " +
        store.StoreName;
  }
}
