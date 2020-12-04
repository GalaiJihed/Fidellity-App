import 'package:app/models/Notification.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:app/utils/Utils.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  MyNotification notification;

  NotificationItem({this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          enabled: true,
          leading: Icon(
            Icons.notifications_active,
            color: Theme.mainColor,
          ),
          title: Text(
            Utils.capitalizeSentence(this.notification.titleNotification),
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.mainColor,
                fontSize: 15),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(this.notification.bodyNotification),
              new RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.blackColor,
                      fontSize: 12),
                  children: <TextSpan>[
                    TextSpan(
                      text: Utils.convertDateFromString(
                          this.notification.createdAt.toString(), "MMM dd"),
                    ),
                    TextSpan(
                        text: ', at ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black54)),
                    TextSpan(
                      text: Utils.convertDateFromString(
                          notification.createdAt.toString(), "hh:mm a"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: getSeen(notification.seen)),
    );
  }
}

Widget getSeen(bool seen) {
  if (seen) {
    return Icon(
      Icons.panorama_fish_eye,
      color: Theme.mainColor,
      size: 15.0,
    );
  } else {
    return Icon(
      Icons.fiber_manual_record,
      color: Theme.mainColor,
      size: 15.0,
    );
  }
}
