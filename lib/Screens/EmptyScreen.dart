import 'package:app/Widgets/CreditCardWidget.dart';
import 'package:app/Widgets/DrawerWidget.dart';
import 'package:app/Widgets/HomeTopWidget.dart';
import 'package:app/Widgets/TransactionHeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../Widgets/StatsWidget.dart';
import '../Widgets/TransactionWidget.dart';
import '../utils/LoadImage.dart';
import 'PayScreen.dart';

void main() => runApp(MaterialApp(
  title: 'Home Screen',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  home: EmptyScreen(),
));

class EmptyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EmptyScreenState();
}

class EmptyScreenState extends State<EmptyScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      body: SafeArea(
        top: false,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                color: Color(0xffe8f2fc),
                child: bodyContainer(),
              ),
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
    print('start');
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('shake');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PayScreen()));
    });
  }
}

Column bodyContainer() {
  var data = [0.0,1.0,1.5,2.0,0.0,0.0,-0.5,-1.0,-0.5,0.0,1.75];
  return Column(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      //I have set Safe area top to false in the bottom_navigation_widget
      // so I need to make a space for it here.
      SizedBox(
        height: 20,

      ),
      HomeTopWidget(),


      //
      //StackedAreaLineChart.withSampleData(),
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
      TransactionsHeaderWidget(),
      TransactionsWidget(),

      //*******************credit card
    ],
  );
}


