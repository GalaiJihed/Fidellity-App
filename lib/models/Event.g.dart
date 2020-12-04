part of 'Event.dart';

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      id: json['event']['id'] as int,
      eventName: json['event']['eventName'] as String,
      eventType: json['event']['eventType'] as String,
      eventDate: json['event']['eventDate'] as String,
      dateCreation: json['event']['dateCreation'],
      date: json['date'],
      storeId: json['store']['id'] as int);
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'eventName': instance.eventName,
      'eventType': instance.eventType,
      'eventDate': instance.eventDate,
      'dateCreation': instance.dateCreation,
      'date': instance.date,
      'storeId': instance.storeId
    };
