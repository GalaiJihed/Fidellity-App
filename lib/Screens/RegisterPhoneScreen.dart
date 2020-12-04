import 'package:app/Animation/FadeAnimation.dart';
import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Screens/PinCodeScreen.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:app/utils/custom_shape.dart';
import 'package:app/utils/customappbar.dart';
import 'package:app/utils/responsive_ui.dart';
import 'package:app/utils/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PopUps/PopUp.dart';

class RegisterPhoneScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<RegisterPhoneScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController myphone = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                form(),

                SizedBox(
                  height: _height / 35,
                ),
                FadeAnimation(1.55, button()),

                //signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.mainColorAccent,
                    Theme.mainColor,
                  ],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.mainColorAccent,
                    Theme.mainColor,
                  ],
                ),
              ),
            ),
          ),
        ),

//        Positioned(
//          top: _height/8,
//          left: _width/1.75,
//          child: Container(
//            alignment: Alignment.center,
//            height: _height/23,
//            padding: EdgeInsets.all(5),
//            decoration: BoxDecoration(
//              shape: BoxShape.circle,
//              color:  Colors.orange[100],
//            ),
//            child: GestureDetector(
//                onTap: (){
//                  print('Adding photo');
//                },
//                child: Icon(Icons.add_a_photo, size: _large? 22: (_medium? 15: 13),)),
//          ),
//        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
        left: _width / 12.0,
        right: _width / 12.0,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Text(
              Translations.of(context).text("hint_phone_Number"),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.mainColorAccent),
            ),
            SizedBox(height: _height / 60.0),
            Text('Enter your phone number to get your request code.'),
            SizedBox(height: _height / 20.0),
            FadeAnimation(1.3, emailTextFormField()),
            SizedBox(height: _height / 60.0),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: myphone,
      keyboardType: TextInputType.phone,
      icon: Icons.phone,
      hint: Translations.of(context).text("hint_phone_Number"),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        String phone = myphone.text;
        if (myphone.text.length != 8) {
          final action = await Dialogs.yesAbortDialog(
              context,
              Translations.of(context).text("hint_phone_Number"),
              'Wrong phone number',
              DialogType.error);
        } else {
          String url = AppConfig.URL_NEW_CLIENT;
          Map<String, String> headers = {"Content-type": "application/json"};
          String json = '{"phoneNumber": "$phone"}';
          // make POST request
          var response = await post(url, headers: headers, body: json);
          // check the status code for the result
          int statusCode = response.statusCode;
          if (statusCode == 201) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("PhoneNumber", phone);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PinCodeScreen()
                    // MyApp(),
                    ));
          } else {
            print('Problem');
          }
        }
      },
      textColor: Theme.whiteColor,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Theme.mainColorAccent, Theme.mainColor],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'Get Code',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Theme.mainColorAccent,
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}
