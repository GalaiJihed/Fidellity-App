import 'package:app/App/AppConfig.dart';
import 'package:app/Screens/PopUps/PopUp.dart';
import 'package:app/models/Notification.dart';
import 'package:app/models/Session.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Items/NotificationItem.dart';

class NotificationList extends StatefulWidget {
  List<MyNotification> items;
  NotificationList({this.items});

  @override
  _NotificationListState createState() => _NotificationListState(items);
}

class _NotificationListState extends State<NotificationList> {
  List<MyNotification> items;
  Session session;
  _NotificationListState(this.items);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session = new Session();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.whiteColor,
      height: 500.0, // Change as per your requirement
      width: 400.0,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(items[index].id.toString()),
              child: NotificationItem(notification: items[index]),
              background: Container(
                  width: 50,
                  color: Theme.redColor,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.cancel,
                    color: Theme.whiteColor,
                  )),
              dismissThresholds: {DismissDirection.endToStart: 0.5},
              confirmDismiss: (DismissDirection dismissDirection) async {
                switch (dismissDirection) {
                  case DismissDirection.endToStart:
                    bool test = await deleteNotificationServer(items[index]);
                    switch (test) {
                      case true:
                        {
                          setState(() {
                            items.removeAt(index);
                          });
                        }
                        break;
                      case false:
                        {
                          final action = await Dialogs.yesAbortDialog(
                              context,
                              'Error Occured',
                              'An error has been occured while deleting a notification.',
                              DialogType.error);
                        }
                        break;
                    }

                    break;
                  case DismissDirection.startToEnd:
                  case DismissDirection.horizontal:
                  case DismissDirection.vertical:
                  case DismissDirection.up:
                  case DismissDirection.down:
                    assert(false);
                }
                return false;
              },
            );
          }),
    );
  }

  Future<bool> deleteNotificationServer(MyNotification myNotification) async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
    }, onError: (error) {
      print(error);
    });
    String url =
        AppConfig.URL_DELETE_NOTIFICATION + myNotification.id.toString();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'auth': '$tt',
      },
    );
    int statusCode = response.statusCode;
    if (statusCode == 204) {
      return (Future(() => true));
    } else {
      return (Future(() => false));
    }
  }
}
