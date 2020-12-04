part of 'Store.dart';

Store _$StoreFromJson(Map<String, dynamic> json) {
  return Store(
    id: json['store']['id'] as int,
    StoreName: json['store']['StoreName'] as String,
    StoreAdress: json['store']['StoreAdress'] as String,
    StoreType: json['store']['StoreType'] as String,
    StoreNotes: json['store']['StoreNotes'] as int,
    Image: json['store']['Image'] as String,
    pointsInCurrentStore: json['pointsInCurrentStore'] as int,
  );
}

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'StoreName': instance.StoreName,
      'StoreAdress': instance.StoreAdress,
      'StoreType': instance.StoreType,
      'StoreNotes': instance.StoreNotes,
      'Image': instance.Image,
      'pointsInCurrentStore': instance.pointsInCurrentStore,
    };
