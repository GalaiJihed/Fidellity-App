import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Screens/EventsScreen.dart';
import 'package:app/Screens/FidelBotScreen.dart';
import 'package:app/Screens/HomeScreen.dart';
import 'package:app/Screens/InfoScreen.dart';
import 'package:app/Screens/PayScreen.dart';
import 'package:app/Screens/ProfileScreen.dart';
import 'package:app/Screens/SettingScreen.dart';
import 'package:app/Screens/StoresScreen.dart';
import 'package:app/Screens/TransactionScreen.dart';
import 'package:app/models/Session.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../Screens/Report.dart';

class DrawerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  Future _currentUser;
  DBClient dbClient;
  Session session;
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbClient = new DBClient();
    _currentUser = dbClient.getCurrentUser();
    dbClient.getCurrentUser().then((onValue) {
      user = onValue;
    });
    session = new Session();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
// Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  // ignore: missing_return
                  FutureBuilder(
                      future: _currentUser,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return new Container();
                        else {
                          return new Container(
                            width: 70.0,
                            height: 70.0,
                            child: CachedNetworkImage(
                              imageUrl:
                                  AppConfig.URL_GET_IMAGE + snapshot.data.image,
                              //image builder
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(75.0),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.fill),
                                ),
                              ),

                              //placeholder
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Theme.mainColorAccent,
                                highlightColor: Theme.mainColorAccent,
                                child: Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    color: Theme.whiteColor,
                                    borderRadius: BorderRadius.circular(75.0),
                                  ),
                                ),
                              ),
                              //errorWidget
                              errorWidget: (context, url, error) =>
                                  Shimmer.fromColors(
                                baseColor: Theme.mainColorAccent,
                                highlightColor: Theme.mainColorAccent,
                                child: Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    color: Theme.whiteColor,
                                    borderRadius: BorderRadius.circular(75.0),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FutureBuilder(
                              future: _currentUser,
                              // ignore: missing_return
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text(Translations.of(context)
                                        .text("txt_none"));
                                    break;
                                  case ConnectionState.waiting:
                                    return Text(Translations.of(context)
                                        .text("txt_loading"));
                                    break;
                                  case ConnectionState.active:
                                    return Text(Translations.of(context)
                                        .text("txt_loading"));
                                    break;
                                  case ConnectionState.done:
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        snapshot.data.firstName.toString() +
                                            ' ' +
                                            snapshot.data.lastName.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xff30394B),
                                          fontSize: 18,
                                          fontFamily: 'Playfair',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                    break;
                                }
                              }),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 4),
                            child: Text(
                              Translations.of(context).text("txt_account_base"),
                              style: TextStyle(
                                color: Theme.mainColorAccent,
                                fontFamily: 'Playfair',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.whiteColor,
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 17.0),
                  child:
                      Text(Translations.of(context).text("app_drawer_logout")),
                ),
                Switch(
                  value: false,
                  activeColor: Theme.mainColorAccent,
                  onChanged: (bool value) {
                    if (value) {
                      Navigator.pop(context);
                      Navigator.pop(context);

                      dbClient.onDrop();
                      dbClient.onDropStore();
                      dbClient.onDropEvent();
                      dbClient.onDropProduct();
                      dbClient.onDropProductLine();
                      dbClient.onDropOrder();
                      dbClient.ReCreate();
                      session.removeToken();
                      session.setLoggedOut();
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, top: 10),
            child: Text(Translations.of(context).text("app_drawer_account")),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.home,
              color: Theme.mainColorAccent,
            ),
            title: Text(Translations.of(context).text("app_drawer_home")),
            trailing: FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.mainColorAccent,
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.userCircle,
              color: Theme.mainColorAccent,
            ),
            title: Text(Translations.of(context).text("app_drawer_profile")),
            trailing: FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.mainColorAccent,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.exchangeAlt,
              color: Theme.mainColorAccent,
            ),
            title:
                Text(Translations.of(context).text("app_drawer_transaction")),
            trailing: FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.mainColorAccent,
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => TransactionScreen()));
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.moneyBillWave,
              color: Theme.mainColorAccent,
            ),
            title: Text(Translations.of(context).text("app_drawer_payment")),
            trailing: FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.mainColorAccent,
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PayScreen()));
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.store,
              color: Theme.mainColorAccent,
            ),
            title: Text(Translations.of(context).text("app_drawer_my_stores")),
            trailing: FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.mainColorAccent,
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => StoreScreen()));
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.calendarDay,
              color: Theme.mainColorAccent,
            ),
            title: Text(Translations.of(context).text("app_drawer_events")),
            trailing: FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.mainColorAccent,
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => EventsScreen()));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, top: 10),
            child: Text('APP'),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.cog,
              color: Theme.mainColor,
            ),
            title: Text(Translations.of(context).text("app_drawer_settings")),
            trailing: FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.mainColor,
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SettingScreen()));
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.robot,
              color: Theme.mainColor,
            ),
            title:
                // Text(Translations.of(context).text("app_drawer_notifications")),
                Text("FidelBot Chat"),
            trailing: FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.mainColor,
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => FidelBotScreen(
                        user: user,
                      )));
            },
          ),
          ListTile(
              leading: FaIcon(
                FontAwesomeIcons.solidQuestionCircle,
                color: Theme.mainColor,
              ),
              title:
                  Text(Translations.of(context).text("app_drawer_help_center")),
              trailing: FaIcon(
                FontAwesomeIcons.angleRight,
                color: Theme.mainColor,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Report(),
                );
              }),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.infoCircle,
              color: Theme.mainColor,
            ),
            title: Text(Translations.of(context).text("app_drawer_info")),
            trailing: FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.mainColor,
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => InfoScreen()));
            },
          ),
        ],
      ),
    );
  }
}
