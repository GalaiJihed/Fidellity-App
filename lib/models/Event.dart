import 'package:json_annotation/json_annotation.dart';
part 'Event.g.dart';

@JsonSerializable(nullable: true)

class Event {
  int id;
  String eventName;
  String eventType;
  String eventDate;
  String dateCreation;
  String date;
  int storeId;
  factory Event.fromJson(Map<String,dynamic> json) => _$EventFromJson(json);

  Event({this.id,this.eventName, this.eventType, this.eventDate, this.dateCreation,this.date,this.storeId});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'eventName': eventName,
      'eventType': eventType,
      'eventDate': eventDate,
      'dateCreation': dateCreation,
      'date': date,
      'storeId':storeId
    };
    return map;
  }



  Event.fromMap(Map<String, dynamic> map) {
    id = map['id'] as int;
    eventName = map['eventName'];
    eventType = map['eventType'];
    eventDate = map['eventDate'];
    dateCreation = map['dateCreation'];
    date = map['date'];
    storeId= map['storeId'] as int ;



  }



  DateTime fromTimestampToDateTime(int date)
  {
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date );
    return dateTime;
  }

  @override
  String toString() {
    // TODO: implement toString
    return  "Event {id : "+id.toString()+
        "\n eventType : "+eventType.toString()+
        "\n eventName : "+eventName.toString()+
        "\n storeId : "+storeId.toString();
  }
}