import 'package:app/Helper/translations.dart';
import 'package:app/models/Event.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum DialogAction { yes, abort }
enum DialogType { error, warning, success }

class EventDetail extends StatefulWidget {
  var event;

  var store;

  EventDetail({this.event, this.store});

  @override
  _EventDetailState createState() => _EventDetailState(event, store);
}

class _EventDetailState extends State<EventDetail> {
  String buttonText;
  Image image;
  BuildContext context;
  final Event event;
  final Future store;

  _EventDetailState(this.event, this.store);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Theme.whiteColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Theme.shadowColor,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                event.eventName,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                event.eventType,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              FutureBuilder(
                  future: widget.store,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Text(Translations.of(context).text("txt_loading"));
                    else {
                      return Text(
                        snapshot.data.StoreName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24.0, fontStyle: FontStyle.italic),
                      );
                    }
                  }),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(
                    "Okay",
                    style: TextStyle(color: Theme.whiteColor),
                  ),
                  color: Theme.mainColorAccent,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: Theme.mainColorAccent,
            radius: Consts.avatarRadius,
            child: FaIcon(
              FontAwesomeIcons.calendarDay,
              color: Theme.whiteColor,
              size: 70,
            ),
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
