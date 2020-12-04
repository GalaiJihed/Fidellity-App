import 'package:app/Widgets/DrawerWidget.dart';
import 'package:app/Widgets/HomeTopWidget.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

import 'PayScreen.dart';

void main() => runApp(MaterialApp(
      title: 'Home Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationsSettingScreen(),
    ));

class NotificationsSettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationsSettingScreenState();
}

class NotificationsSettingScreenState
    extends State<NotificationsSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
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
      SettingContent()

      //
      //StackedAreaLineChart.withSampleData(),
    ],
  );
}

SingleChildScrollView SettingContent() {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
                Text(
                  "Notifications Settings",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff548687),
                  ),
                ),
                SwitchListTile(
                  activeColor: Color(0xff2EC4B6),
                  contentPadding: const EdgeInsets.only(left: 10),
                  value: false,
                  title: Text("Disable All"),
                  onChanged: (val) {},
                ),
                SwitchListTile(
                  activeColor: Color(0xff2EC4B6),
                  contentPadding: const EdgeInsets.only(left: 10),
                  value: false,
                  title: Text("Points Added Notifications"),
                  onChanged: (val) {},
                ),
                SwitchListTile(
                  activeColor: Color(0xff2EC4B6),
                  contentPadding: const EdgeInsets.only(left: 10),
                  value: false,
                  title: Text("Discount Activated Notifications"),
                  onChanged: (val) {},
                ),
                SwitchListTile(
                  activeColor: Color(0xff2EC4B6),
                  contentPadding: const EdgeInsets.only(left: 10),
                  value: true,
                  title: Text("Received Offer Notifications"),
                  onChanged: (val) {},
                ),
                SwitchListTile(
                  activeColor: Color(0xff2EC4B6),
                  contentPadding: const EdgeInsets.only(left: 10),
                  value: true,
                  title: Text("Received App Updates"),
                  onChanged: null,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 60.0),
      ],
    ),
  );
}

Container _buildDivider() {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    width: double.infinity,
    height: 1.0,
    color: Colors.grey.shade400,
  );
}
