import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Widgets/DrawerWidget.dart';
import 'package:app/Widgets/HomeTopWidget.dart';
import 'package:app/models/Session.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shake/shake.dart';

import 'PayScreen.dart';
import 'PopUps/PopUp.dart';

void main() => runApp(MaterialApp(
      title: 'Home Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Theme.mainColor,
      ),
      home: SettingScreen(),
    ));

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  String token;
  Session session;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Theme.backgroundColor,
        drawer: DrawerWidget(),
        body: SafeArea(
          top: false,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  color: Theme.backgroundColor,
                  child: bodyContainer(context),
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
    session.getToken().then((value) {
      // Run extra code here
      this.token = value;
      print(value);
    }, onError: (error) {
      print(error);
    });

    print('start');
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('shake');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PayScreen()));
    });
  }

  updatePassword(var oldPassword, var newPassword) async {
    print(this.token);
    String url = AppConfig.URL_CHANGE_PASSWORD;
    String json =
        '{"oldPassword": "$oldPassword" , "newPassword": "$newPassword", "typeAccount": "CLIENT"}';
    // String token = this.token;
    final response = await http.post(url, body: json, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'auth': '$token',
    });

    int statusCode = response.statusCode;
    print(statusCode);
  }

  Column bodyContainer(BuildContext context) {
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
        SettingContent(context)

        //
        //StackedAreaLineChart.withSampleData(),
      ],
    );
  }

  SingleChildScrollView SettingContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.lock_outline,
                      color: Theme.mainColorAccent,
                    ),
                    title: Text(Translations.of(context)
                        .text("txt_settings_change_password")),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      showPasswordAlert(context);
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.language,
                      color: Theme.mainColorAccent,
                    ),
                    title: Text(Translations.of(context)
                        .text("txt_settings_change_language")),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      showChangeLanguageAlert(context);
                    },
                  ),
//                  _buildDivider(),
//                  ListTile(
//                    leading: Icon(
//                      Icons.location_on,
//                      color: Color(0xff2EC4B6),
//                    ),
//                    title: Text("Change Location"),
//                    trailing: Icon(Icons.keyboard_arrow_right),
//                    onTap: () {
//                      //open change location
//                    },
//                  ),
                ],
              ),
            ),
          ),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(32, 8, 32, 16.0),
//            child: Card(
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(10.0)),
//              child: Column(
//                children: <Widget>[
//                  const SizedBox(height: 10.0),
//                  Text(
//                    "General Settings",
//                    style: TextStyle(
//                      fontSize: 20.0,
//                      fontWeight: FontWeight.bold,
//                      color: Color(0xff548687),
//                    ),
//                  ),
//                  SwitchListTile(
//                    activeColor: Color(0xff2EC4B6),
//                    contentPadding: const EdgeInsets.only(left: 10),
//                    value: false,
//                    title: Text("NFC"),
//                    onChanged: (val) {},
//                  ),
//                  SwitchListTile(
//                    activeColor: Color(0xff2EC4B6),
//                    contentPadding: const EdgeInsets.only(left: 10),
//                    value: false,
//                    title: Text("GPS"),
//                    onChanged: (val) {},
//                  ),
//                  SwitchListTile(
//                    activeColor: Color(0xff2EC4B6),
//                    contentPadding: const EdgeInsets.only(left: 10),
//                    value: false,
//                    title: Text("Storage"),
//                    onChanged: (val) {},
//                  ),
//                  SwitchListTile(
//                    activeColor: Color(0xff2EC4B6),
//                    contentPadding: const EdgeInsets.only(left: 10),
//                    value: false,
//                    title: Text("SMS"),
//                    onChanged: (val) {},
//                  ),
//                  SwitchListTile(
//                    activeColor: Color(0xff2EC4B6),
//                    contentPadding: const EdgeInsets.only(left: 10),
//                    value: true,
//                    title: Text("Phone"),
//                    onChanged: null,
//                  ),
//                ],
//              ),
//            ),
//          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.solidBell,
                        color: Theme.mainColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        Translations.of(context).text("notification_setting"),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.mainColor,
                        ),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    activeColor: Theme.mainColorAccent,
                    contentPadding: const EdgeInsets.only(left: 10),
                    value: false,
                    title: Text(Translations.of(context)
                        .text("notification_setting_disable")),
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    activeColor: Theme.mainColorAccent,
                    contentPadding: const EdgeInsets.only(left: 10),
                    value: false,
                    title: Text(Translations.of(context)
                        .text("notification_setting_points")),
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    activeColor: Theme.mainColorAccent,
                    contentPadding: const EdgeInsets.only(left: 10),
                    value: false,
                    title: Text(Translations.of(context)
                        .text("notification_setting_discount")),
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    activeColor: Theme.mainColorAccent,
                    contentPadding: const EdgeInsets.only(left: 10),
                    value: true,
                    title: Text(Translations.of(context)
                        .text("notification_setting_offer")),
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    activeColor: Theme.mainColorAccent,
                    contentPadding: const EdgeInsets.only(left: 10),
                    value: true,
                    title: Text(Translations.of(context)
                        .text("notification_setting_maj")),
                    onChanged: null,
                  ),
                ],
              ),
            ),
          ),
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

  showPasswordAlert(BuildContext context) {
    Alert(
        context: context,
        title: "Change Password",
        style: AlertStyle(
          titleStyle: TextStyle(
            color: Theme.mainColorAccent,
          ),
        ),
        content: Column(
          children: <Widget>[
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Theme.mainColorAccent,
                ),
                labelText: 'Current Password',
              ),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock_open,
                  color: Theme.mainColorAccent,
                ),
                labelText: 'New Password',
              ),
            ),
            TextField(
              controller: confirmNewPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock_open,
                  color: Theme.mainColorAccent,
                ),
                labelText: 'Confirm New Password',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => updatepassword(
                newPasswordController.text.trim(),
                oldPasswordController.text.trim(),
                confirmNewPasswordController.text.trim()),
            child: Text(
              "Update",
              style: TextStyle(color: Theme.whiteColor, fontSize: 20),
            ),
            color: Theme.mainColorAccent,
          )
        ]).show();
  }

  updatepassword(
      String newPassword, String oldPassword, String confirmpassword) async {
    if (newPassword.toString().isEmpty ||
        oldPassword.toString().isEmpty ||
        confirmpassword.toString().isEmpty) {
      final action = await Dialogs.yesAbortDialog(
          context, '  Fields ', ' complete all fields', DialogType.error);
    } else if (newPassword.toString().isEmpty) {
      final action = await Dialogs.yesAbortDialog(
          context, ' Password ', 'new password is empty', DialogType.error);
    } else if (oldPassword.toString().isEmpty) {
      final action = await Dialogs.yesAbortDialog(
          context, 'Old password', 'old password is empty', DialogType.error);
    } else if (confirmpassword.toString().isEmpty) {
      print(" confirm password is empty ");
      final action = await Dialogs.yesAbortDialog(context, 'Retype Password',
          'Retype password is empty', DialogType.error);
    } else if (newPassword != confirmpassword) {
      final action = await Dialogs.yesAbortDialog(context, 'Error Matching',
          'Error matching passwords', DialogType.error);
    } else {
      updatePassword(oldPassword, newPassword);
      final action = await Dialogs.yesAbortDialog(
          context, 'Succces', 'Password Updated', DialogType.success);
      if (action == DialogAction.yes) {
        Navigator.pop(context);
      }
    }
  }

  showChangeLanguageAlert(BuildContext context) {
    List lang = ["English", "French", "Spanish", "Dutch"];
    List<DropdownMenuItem<String>> _dropDownMenuItems;
    String _selectedLang;

    List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List fruits) {
      List<DropdownMenuItem<String>> items = List();
      for (String fruit in fruits) {
        items.add(DropdownMenuItem(value: fruit, child: Text(fruit)));
      }
      return items;
    }

    void changedDropDownItem(String _selectedLang) {
      _selectedLang = _selectedLang;
    }

    _dropDownMenuItems = buildAndGetDropDownMenuItems(lang);
    _selectedLang = _dropDownMenuItems[0].value;

    Alert(
        context: context,
        title: "Select Language",
        style: AlertStyle(
          titleStyle: TextStyle(
            color: Theme.mainColorAccent,
          ),
        ),
        content: Column(
          children: <Widget>[
            DropdownButton(
              value: _selectedLang,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
            )
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Update",
              style: TextStyle(color: Theme.whiteColor, fontSize: 20),
            ),
            color: Theme.mainColorAccent,
          )
        ]).show();
  }
}
