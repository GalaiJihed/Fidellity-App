import 'package:app/Helper/translations.dart';
import 'package:app/Widgets/FlipedCreditCardWidget.dart';
import 'package:app/utils/Theme.dart' as theme;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'HomeScreen.dart';

void main() => runApp(MaterialApp(
      title: 'Pay Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: theme.mainColor,
      ),
      home: PayScreen(),
    ));

class PayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PayScreenState();
}

class PayScreenState extends State<PayScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
          top: false,
          child: Container(
            color: theme.backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Container(
                    child: FlippedCreditCardWidget(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Container(
                    //  width: 420,
                    //  height: 190,
                    decoration: BoxDecoration(
                      color: theme.whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0)),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          ButtonTheme(
                            minWidth: 300,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                              ),
                              color: theme.mainColor,
                              textColor: theme.whiteColor,
                              child: Text(
                                  Translations.of(context).text(
                                      "txt_btn_payment_activate_discount"),
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ButtonTheme(
                            minWidth: 300,
                            height: 40,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: theme.mainColor)),
                              onPressed: () {},
                              color: theme.whiteColor,
                              textColor: theme.mainColor,
                              child: Text(
                                  Translations.of(context)
                                      .text("txt_btn_payment_add_points"),
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FloatingActionButton(
                            backgroundColor: theme.mainColor,
                            child: FaIcon(FontAwesomeIcons.times),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
