import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Store.g.dart';

@JsonSerializable(nullable: true)
class Store {
  int id;
  String StoreName;
  String StoreAdress;
  String StoreType;
  int StoreNotes;
  String Image;
  int pointsInCurrentStore;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Store(
      {this.id,
      this.StoreName,
      this.StoreAdress,
      this.StoreType,
      this.StoreNotes,
      this.Image,
      this.pointsInCurrentStore});
  getIcon() {
    if (StoreType.substring(0, 1).toLowerCase() == 'm') {
      return FontAwesomeIcons.shoppingCart;
    } else if (StoreType.substring(0, 1).toLowerCase() == 'c') {
      return FontAwesomeIcons.coffee;
    } else if (StoreType.substring(0, 1).toLowerCase() == 'r') {
      return FontAwesomeIcons.pizzaSlice;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'StoreName': StoreName,
      'StoreAdress': StoreAdress,
      'StoreType': StoreType,
      'StoreNotes': StoreNotes,
      'Image': Image,
      'pointsInCurrentStore': pointsInCurrentStore
    };
    return map;
  }

  Store.fromMap(Map<String, dynamic> map) {
    id = map['id'] as int;
    StoreName = map['StoreName'];
    StoreAdress = map['StoreAdress'];
    StoreType = map['StoreType'];
    StoreNotes = map['StoreNotes'] as int;
    Image = map['Image'];
    pointsInCurrentStore = map['pointsInCurrentStore'] as int;
  }

  @override
  String toString() {
    // TODO: implement toString
    return id.toString() + " " + StoreName.toString();
  }
}
