import 'dart:convert';

import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Screens/EditProfileScreen.dart';
import 'package:app/Widgets/DrawerWidget.dart';
import 'package:app/Widgets/HomeTopWidget.dart';
import 'package:app/models/Session.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shake/shake.dart';
import 'package:shimmer/shimmer.dart';

import 'PayScreen.dart';

void main() => runApp(MaterialApp(
      title: 'Home Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Theme.mainColor,
      ),
      home: ProfileScreen(),
    ));

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Session session;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Theme.whiteColor,
        drawer: DrawerWidget(),
        body: SafeArea(
          top: false,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  color: Theme.backgroundColor,
                  child: bodyContainer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User> _currentUser;
  DBClient _dbClient;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session = new Session();
    this._dbClient = new DBClient();
    _currentUser = this._dbClient.getCurrentUser();
    ProfileDiscounts();
    print('start');
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('shake');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PayScreen()));
    });
  }

  Container bodyContainer() {
    return Container(
      color: Theme.mainColorAccent,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //I have set Safe area top to false in the bottom_navigation_widget
          // so I need to make a space for it here.
          SizedBox(
            height: 20,
          ),
          HomeTopWidget(),

          Container(
            color: Theme.mainColorAccent,
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      FutureBuilder(
                          future: _currentUser,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return new Container();
                            else {
                              return new Container(
                                width: 100.0,
                                height: 100.0,
                                child: CachedNetworkImage(
                                  imageUrl: AppConfig.URL_GET_IMAGE +
                                      snapshot.data.image,
                                  //image builder
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(75.0),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill),
                                    ),
                                  ),

                                  //placeholder
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Theme.mainColorAccent,
                                    highlightColor: Theme.mainColorAccent,
                                    child: Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: Theme.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(75.0),
                                      ),
                                    ),
                                  ),
                                  //errorWidget
                                  errorWidget: (context, url, error) =>
                                      Shimmer.fromColors(
                                    baseColor: Theme.mainColorAccent,
                                    highlightColor: Theme.mainColorAccent,
                                    child: Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: Theme.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(75.0),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder(
                                future: _currentUser,
                                // ignore: missing_return
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Text('0');
                                      break;
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      return Text(Translations.of(context)
                                          .text("txt_loading"));
                                      break;
                                    case ConnectionState.done:
                                      return Text(
                                        snapshot.data.firstName.toString() +
                                            " " +
                                            snapshot.data.lastName.toString(),
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            color: Theme.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      );
                                      break;
                                  }
                                }),
                            SizedBox(height: 5.0),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.facebookSquare,
                                    color: Theme.whiteColor,
                                    size: 20,
                                  ),
                                ),
                                Text(
                                  '@Sadoklao',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Theme.whiteColor,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Montserrat'),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FutureBuilder(
                            future: ProfileDiscounts(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      color: Theme.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                );
                              } else {
                                return Text(
                                  '0',
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      color: Theme.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                );
                              }
                            },
                          ),
                          Text(
                            Translations.of(context)
                                .text("app_profile_discounts"),
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Theme.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '0',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  color: Theme.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                            Text(
                              Translations.of(context)
                                  .text("app_profile_gained_points"),
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Theme.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat'),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() async {
                            await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => EditProfileScreen()))
                                .then((onValue) {
                              if (onValue != null) {
                                setState(() {
                                  _currentUser = Future(() => onValue);
                                  HomeTopWidgetState().reassemble();
                                });
                              }
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.whiteColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Translations.of(context)
                                    .text("app_profile_btn_edit_profile"),
                                style: TextStyle(
                                    color: Theme.whiteColor, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: new BoxDecoration(
                color: Theme.whiteColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30))),
            padding: EdgeInsets.only(top: 0, bottom: 30),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.phone,
                              color: Theme.mainColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 20,
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
                                    case ConnectionState.active:
                                      return Text(Translations.of(context)
                                          .text("txt_loading"));
                                      break;
                                    case ConnectionState.done:
                                      return Text(
                                        "+216 " +
                                            snapshot.data.phoneNumber
                                                .toString()
                                                .substring(0, 2) +
                                            " " +
                                            snapshot.data.phoneNumber
                                                .toString()
                                                .substring(2, 5) +
                                            " " +
                                            snapshot.data.phoneNumber
                                                .toString()
                                                .substring(5),
                                        style: TextStyle(
                                          color: Theme.mainColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Playfair',
                                        ),
                                      );
                                      break;
                                  }
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.mailBulk,
                              color: Theme.mainColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 20,
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
                                    case ConnectionState.active:
                                      return Text(Translations.of(context)
                                          .text("txt_loading"));
                                      break;
                                    case ConnectionState.done:
                                      return Text(
                                        snapshot.data.email.toString(),
                                        style: TextStyle(
                                          color: Theme.mainColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Playfair',
                                        ),
                                      );

                                      break;
                                  }
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.locationArrow,
                              color: Theme.mainColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 20,
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
                                    case ConnectionState.active:
                                      return Text(Translations.of(context)
                                          .text("txt_loading"));
                                      break;
                                    case ConnectionState.done:
                                      return Text(
                                        snapshot.data.city.toString() +
                                            "," +
                                            snapshot.data.address.toString(),
                                        style: TextStyle(
                                          color: Theme.mainColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Playfair',
                                        ),
                                      );
                                      break;
                                  }
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.calendar,
                              color: Theme.mainColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 20,
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
                                    case ConnectionState.active:
                                      return Text(Translations.of(context)
                                          .text("txt_loading"));
                                      break;
                                    case ConnectionState.done:
                                      return Text(
                                        (DateFormat.yMMMMd().format(
                                                snapshot.data.birthDate))
                                            .toString(),
                                        style: TextStyle(
                                          color: Theme.mainColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Playfair',
                                        ),
                                      );
                                      break;
                                  }
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 169,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          //
          //StackedAreaLineChart.withSampleData(),
        ],
      ),
    );
  }

  Future<String> ProfileDiscounts() async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
    }, onError: (error) {
      print(error);
    });
    User user = await _currentUser;
    var phone = user.phoneNumber;
    var body = '{"phoneNumber": "$phone"}';
    String url = AppConfig.URL_STAT_PROFILE;
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'auth': '$tt',
        },
        body: body);

    int statusCode = response.statusCode;

    if (statusCode == 403) {
      print(statusCode);

      print("ClientId doesnt exist ");
    } else if (statusCode == 200) {
      List data = json.decode(response.body);
      print(data[0]['nbr']);
      //int ordersFP = data as int;
      return (Future(() => data[0]['nbr']));
    }
  }
}
