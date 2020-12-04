// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as int,
    productName: json['productName'] as String,
    reference: json['reference'] as String,
    price: json['price'] as double,
    promoPrice: json['promoPrice'] as double,
    reductionPerc: json['reductionPerc'] as int,
    image: json['image'] as String,
    fp: json['fp'] as double,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'reference': instance.reference,
      'price': instance.price,
      'promoPrice': instance.promoPrice,
      'reductionPerc': instance.reductionPerc,
      'image': instance.image,
      'fp': instance.fp,
    };
