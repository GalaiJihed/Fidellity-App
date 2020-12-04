import 'package:app/App/AppConfig.dart';
import 'package:app/utils/LoadImage.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:app/utils/Utils.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  Message({this.text, this.name, this.type, this.image, this.dateTime});

  final String text;
  final String name;
  final bool type;
  final String image;
  final DateTime dateTime;

  List<Widget> botMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          backgroundColor: Theme.mainColorAccent,
          child: Image.asset(image),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Theme.darkBlueColor)),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.mainColor),
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(
                text,
                style: TextStyle(color: Theme.whiteColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5),
              child: Text(
                Utils.convertDateFromString(dateTime.toString(), "hh:mm a"),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> userMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(this.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Theme.darkBlueColor)),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.mainColorAccent),
              margin: const EdgeInsets.only(top: 5.0),
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Text(
                text,
                style: TextStyle(color: Theme.whiteColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5),
              child: Text(
                Utils.convertDateFromString(dateTime.toString(), "hh:mm a"),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
            child: LoadImage(
          AppConfig.URL_GET_IMAGE + image,
          50,
          50,
          0,
          0,
          50,
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? userMessage(context) : botMessage(context),
      ),
    );
  }
}
