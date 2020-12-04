import 'dart:async';
import 'dart:convert';

import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Screens/PopUps/PopUp.dart';
import 'package:app/Widgets/NotificationListWidget.dart';
import 'package:app/models/Notification.dart';
import 'package:app/models/Session.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/LoadImage.dart';

class HomeTopWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeTopWidgetState();
}

class HomeTopWidgetState extends State<HomeTopWidget> {
  Future _currentUser;
  DBClient _dbClient;
  Session session;
  User user;
  Future<List<MyNotification>> _mynotifs;
  // Connectivity Test Declaration
  var _connectionStatus;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription, firstCheck;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.whiteColor,
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Translations.of(context).text("app_top_nav_total_balance"),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Playfair',
                      fontWeight: FontWeight.w600,
                      color: Theme.blackColor),
                ),
                FutureBuilder(
                    future: _currentUser,
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text('0');
                          break;
                        case ConnectionState.waiting:
                          return Text(
                              Translations.of(context).text("txt_loading"));
                          break;
                        case ConnectionState.active:
                          return Text(
                              Translations.of(context).text("txt_loading"));
                          break;
                        case ConnectionState.done:
                          return Text(
                            snapshot.data.fidelityPoints.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Playfair',
                                fontWeight: FontWeight.w600,
                                color: Theme.mainColor),
                          );
                          break;
                      }
                    }),
              ],
            ),
            Row(
              children: <Widget>[
                FutureBuilder(
                  future: fetchNotificationsUserServer(),
                  builder: (context, snapshot) {
                    //  print(snapshot.hasData);
                    if (!snapshot.hasData) {
                      return GestureDetector(
                        onTap: () async {
                          if (_connectionStatus == ConnectivityResult.none) {
                            final action = await Dialogs.yesAbortDialog(
                                context,
                                'Internet Required ! ',
                                'Activate internet to access notifications.',
                                DialogType.offline);
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.bell,
                                color: Theme.mainColorAccent,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () async {
                          if (snapshot.data.length == 0) {
                            final action = await Dialogs.yesAbortDialog(
                                context,
                                'No notifications available',
                                'You currently have 0 notifications.',
                                DialogType.warning);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    children: <Widget>[
                                      NotificationList(
                                        items: snapshot.data,
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.bell,
                                color: Theme.mainColorAccent,
                                size: 25,
                              ),
                              getNotifications(snapshot.data.length)
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
                GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    // ignore: missing_return
                    child: FutureBuilder(
                        future: _currentUser,
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Container();
                              break;
                            case ConnectionState.waiting:
                              return Container();
                              break;
                            case ConnectionState.active:
                              return Container();
                              break;
                            case ConnectionState.done:
                              return LoadImage(
                                AppConfig.URL_GET_IMAGE + snapshot.data.image,
                                48,
                                48,
                                0,
                                8,
                                8,
                              );
                              break;
                          }
                        })),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session = new Session();
    this._dbClient = new DBClient();
    user = new User();
    _connectionStatus = ConnectivityResult.none;
    //Connectivity Code & Listener
    connectivity = new Connectivity();
    connectivity.checkConnectivity().then((onValue) {
      if (onValue == ConnectivityResult.wifi ||
          onValue == ConnectivityResult.mobile) {
        setState(() {
          _currentUser = fetchUserServer();
          //print("user Fetched from server");
        });
      } else {
        setState(() {
          _currentUser = this._dbClient.getCurrentUser();
          print("user Fetched from database");
        });
      }
    });
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result;
      //print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        final action = Dialogs.yesAbortDialog(
            context,
            Translations.of(context).text("txt_online_mode"),
            Translations.of(context).text("txt_internet_cnx_established"),
            DialogType.online);

        setState(() {
          _currentUser = fetchUserServer();
          print("user Fetched from server");
        });
      } else {
        final action = Dialogs.yesAbortDialog(
            context,
            Translations.of(context).text("txt_offline_mode"),
            Translations.of(context).text("txt_Entering_offline_mode"),
            DialogType.offline);
        setState(() {
          _currentUser = this._dbClient.getCurrentUser();
          print("user Fetched from database");
        });
      }
    });
    //Connectivity Code End
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  fetchUserServer() async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
    }, onError: (error) {
      print(error);
    });
    String url = AppConfig.URL_GET_CURRENT_CLIENT;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = this.token;
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'auth': '$tt',
    });

    int statusCode = response.statusCode;
    var data = jsonDecode(response.body);
    user.id = data["id"];
    user.firstName = data["firstName"];
    user.lastName = data["lastName"];
    user.password = data["password"];
    user.email = data["email"];
    user.address = data["address"];

    user.city = data["city"];
    user.country = data["country"];
    user.image = data["Image"];
    // user.countryCode = int.parse(data["countryCode"]);
    //print(data["countryCode"]);
    //_currentUser.verified = data["verified"];
    user.fidelityPoints = data["fidelityPoints"];
    user.phoneNumber = data["phoneNumber"];

    user.createdAt = convertStringToDateTime(data["createdAt"]);
    user.updatedAt = convertStringToDateTime(data["updatedAt"]);
    // _currentUser.birthDate = data["birthDate"] ;
    user.birthDate = convertStringToDateTime(data["birthDate"]);
    return (Future(() => user));
  }

  Future<List<MyNotification>> fetchNotificationsUserServer() async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
    }, onError: (error) {
      print(error);
    });
    String url = AppConfig.URL_GET_NOTIFICATIONS;
    var phoneNumber;
    await _currentUser.then((onValue) {
      phoneNumber = onValue.phoneNumber;
    });
    String body = '{"phoneNumber":"$phoneNumber"}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = this.token;
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'auth': '$tt',
        },
        body: body);
    List<MyNotification> _notifications = new List<MyNotification>();
    int statusCode = response.statusCode;
//    print('Notifs' + statusCode.toString());
    // print(response.body);
    List data = json.decode(response.body);
//    print(data.length);
    data.forEach((f) {
      // print(f);
      _notifications.add(MyNotification.fromJson(f));
    });
    _notifications.sort((a, b) => -a.createdAt.compareTo(b.createdAt));
    return (Future(() => _notifications));
  }

  DateTime convertStringToDateTime(String date) {
    DateTime dateTime = DateTime.parse(date);

    //print(dateTime);
    //print(dateTime);
    return dateTime;
  }

  Widget getNotificationNumber(int length) {
    if (length > 9) {
      return Positioned(
        left: 5,
        top: 5,
        child: Text(
          "9+",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.whiteColor,
              fontSize: 10),
        ),
      );
    } else {
      return Positioned(
        left: 7,
        top: 3,
        child: Text(
          length.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.whiteColor,
              fontSize: 12),
        ),
      );
    }
  }

  getNotifications(length) {
    if (length > 0) {
      return Positioned(
        left: 10.0,
        bottom: 17,
        child: Stack(children: [
          Icon(
            Icons.brightness_1,
            color: Theme.redColor,
            size: 20.0,
          ),
          getNotificationNumber(length),
        ]),
      );
    } else {
      return Container();
    }
  }
}
