import 'dart:convert';

class Point {
  int nbr;
  int mth;

  Point({
    this.nbr,
    this.mth,
  });

  factory Point.fromRawJson(String str) => Point.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        nbr: int.parse(json[0]),
        mth: json[1] as int,
      );

  Map<String, dynamic> toJson() => {
        "nbr": nbr,
        "mth": mth,
      };
}
