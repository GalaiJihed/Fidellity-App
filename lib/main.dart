import 'dart:async';

import 'package:app/utils/Theme.dart' as Theme;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Helper/APPLIC.dart';
import 'Helper/DbClient.dart';
import 'Helper/translations.dart';
import 'Screens/loginScreen.dart';
import 'loader.dart';
import 'models/Session.dart';

void main() => runApp(MaterialApp(
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: applic.supportedLocales(),
      home: SplachScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
      },
    ));

class SplachScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartState();
  }
}

class StartState extends State<SplachScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  DBClient dbClient;
  Locale _locale;
  SpecificLocalizationDelegate _localeOverrideDelegate;
  List messages;
  String _title = '';
  String _body = '';
  Session session;
  String tokenNot='';
  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Future<void> initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> notification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  Future<void> notificationAfterSec() async {
    var timeDelayed = DateTime.now().add(Duration(seconds: 5));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(1, 'Hello there',
        'please subscribe my channel', timeDelayed, notificationDetails);
  }

  void _showNotifications(String title, String body) async {
    await notification(title, body);
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  @override
  void initState() {
    super.initState();
    initializing();
    firebaseCloudMessaging_Listeners();
    dbClient = new DBClient();
    dbClient.ReCreate();
    session = new Session();
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);
    startTimer();
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.whiteColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Theme.mainColor,
          Theme.mainColorAccent,
        ])),
        child: Center(
          child: Loader(),
        ),
      ),
    );
  }

  startTimer() async {
    var duration = Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/login');
  }

  void firebaseCloudMessaging_Listeners() {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.getToken().then((token) {
      print(token);
      this.tokenNot=token.toString();
      session.setTokenNotification(this.tokenNot);
      print("maindart :"+this.tokenNot.toString());
    });



    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        setState(() {
          _title = message["notification"]["title"];
          _body = message["notification"]["body"];
        });
        //_showNotificationsAfterSecond();
        _showNotifications(_title, _body);
      },
      onResume: (Map<String, dynamic> message) async {
        //  print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        // print('on launch $message');
      },
    );
  }
}
