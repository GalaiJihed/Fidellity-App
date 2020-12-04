import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Widgets/CreditCardWidget.dart';
import 'package:app/Widgets/DrawerWidget.dart';
import 'package:app/Widgets/HomeTopWidget.dart';
import 'package:app/Widgets/LineChartWidget.dart';
import 'package:app/Widgets/TransactionWidget.dart';
import 'package:app/models/Session.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'PayScreen.dart';

void main() => runApp(MaterialApp(
      title: 'Home Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Theme.mainColor,
      ),
      home: HomeScreen(),
    ));

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  User _currentUser;
  DBClient _dbClient;
  String token;
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
                  child: SlidingUpPanel(
                    backdropEnabled: true,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0)),
                    panel: Center(
                      child: TransactionsContainer(),
                    ),
                    collapsed: Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            FaIcon(FontAwesomeIcons.creditCard,
                                color: Theme.darkBlueColor),
                            Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: Text(
                                Translations.of(context)
                                    .text("app_home_my_transactions"),
                                style: TextStyle(
                                  color: Theme.darkBlueColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    body: bodyContainer(_currentUser),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session = new Session();
    _currentUser = new User();
    _dbClient = new DBClient();

    print("Home Screen");
    print('start');
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('shake');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PayScreen()));
    });
  }
}

getAllOrder() {}
Column bodyContainer(User _currentUser) {
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 1.75];
  return Column(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      //I have set Safe area top to false in the bottom_navigation_widget
      // so I need to make a space for it here.
      SizedBox(
        height: 20,
      ),
      HomeTopWidget(),

      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
            child: LineChartSample1(),
          ),
          CreditCardWidget(),
        ],
      ),
    ],
  );
}

Column TransactionsContainer() {
  return Column(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      SizedBox(
        height: 64,
      ),
      TransactionsWidget(),

      //*******************credit card
    ],
  );
}
