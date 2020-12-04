import 'package:app/Widgets/DrawerWidget.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';

import '../Widgets/CarouselWithIndicator.dart';
import 'PayScreen.dart';

void main() => runApp(MaterialApp(
      title: 'Home Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Theme.mainColor,
      ),
      home: InfoScreen(),
    ));

class InfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EmptyScreenState();
}

class EmptyScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      //I have set Safe area top to false in the bottom_navigation_widget
                      // so I need to make a space for it here.

                      SizedBox(
                        height: 40,
                      ),
                      //Image.asset('assets/3x/info1.png')
                      CarouselWithIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        backgroundColor: Theme.mainColorAccent,
                        child: FaIcon(FontAwesomeIcons.times),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )),
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
