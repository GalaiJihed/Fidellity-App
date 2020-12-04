import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class MyNotification {
  int id;
  String titleNotification;
  String bodyNotification;
  DateTime createdAt;
  bool seen;

  MyNotification({
    this.id,
    this.titleNotification,
    this.bodyNotification,
    this.createdAt,
    this.seen,
  });

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    print(json["id"]);
    return MyNotification(
      id: json["id"] as int,
      titleNotification: json["TitleNotification"],
      bodyNotification: json["BodyNotification"],
      createdAt: DateTime.parse(json["createdAt"]),
      seen: false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "TitleNotification": titleNotification,
        "BodyNotification": bodyNotification,
        "createdAt": createdAt.toIso8601String(),
      };
}
