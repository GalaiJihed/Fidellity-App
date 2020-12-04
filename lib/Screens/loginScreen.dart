import 'dart:convert';
import 'dart:convert';
import 'dart:ui';

import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Screens/PopUps/PopUp.dart';
import 'package:app/Screens/RegisterPhoneScreen.dart';
import 'package:app/models/Event.dart';
import 'package:app/models/Order.dart';
import 'package:app/models/Product.dart';
import 'package:app/models/Session.dart';
import 'package:app/models/Store.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Animation/FadeAnimation.dart';
import 'HomeScreen.dart';
import 'RecoverPasswordScreen.dart';

void main() => runApp(MaterialApp(
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomeScreen(),
      },
    ));

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginScreen> {
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  Session session;
  bool isLoggedIn;
  User _currentUser;
  DBClient _dbClient;
  List<Store> stores;
  List<Product> products;
  List<Event> events;
  List<Order> orders;
  bool isLoggedInF = false;
  var profileData;
  String tokenNotification;
  var facebookLogin = FacebookLogin();
  Connectivity connectivity;
  @override
  void initState() {
    super.initState();
    session = new Session();

    _currentUser = new User();
    _dbClient = new DBClient();
    orders = new List<Order>();
    products = new List<Product>();
    stores = new List<Store>();
    connectivity = new Connectivity();
    events = new List<Event>();
      session.isLoggedIn().then((value) {
        // Run extra code here
        if (value) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      }, onError: (error) {
        print(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        debugPrint('Back Button Pressed');
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Theme.mainColor,
            Theme.mainColorAccent,
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        1,
                        new Text(
                          Translations.of(context).text("app_login"),
                          style:
                              TextStyle(color: Theme.whiteColor, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          Translations.of(context).text("app_welcome"),
                          style:
                              TextStyle(color: Theme.whiteColor, fontSize: 18),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                          ),
                          FadeAnimation(
                              1.4,
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(84, 134, 135, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        controller: numberController,
                                        keyboardType: TextInputType.phone,
                                        // ignore: missing_return
                                        validator: (String value) {
                                          if (value.trim().isEmpty) {
                                            print('Phone Number is required');
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: Translations.of(context)
                                                .text("hint_phone_Number"),
                                            hintStyle: TextStyle(
                                                color: Theme.greyColor),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        controller: passwordController,
                                        obscureText: true,
                                        // ignore: missing_return
                                        validator: (String value) {
                                          if (value.trim().isEmpty) {
                                            print('Password is required');
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: Translations.of(context)
                                                .text("hint_password"),
                                            hintStyle: TextStyle(
                                                color: Theme.greyColor),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(
                              1.5,
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    Translations.of(context)
                                        .text("txt_forgot_password"),
                                    style: TextStyle(color: Theme.greyColor),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecoverPasswordScreen()
                                              // MyApp(),
                                              ));
                                    },
                                    child: FadeAnimation(
                                        1.5,
                                        Text(
                                          Translations.of(context)
                                              .text("txt_Recover"),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.mainColorAccent,
                                          ),
                                        )),
                                  )
                                ],
                              )),
                          SizedBox(
                            height: 40,
                          ),
                          new GestureDetector(
                            onTap: () async {
//                            Navigator.of(context).push(
//                                MaterialPageRoute(builder: (context) => MyApp()
//                                    // MyApp(),
//                                    ));
                              if (numberController.text.isEmpty ||
                                  passwordController.text.isEmpty) {
                                final action = await Dialogs.yesAbortDialog(
                                    context,
                                    'Fields ',
                                    'Complete all fields',
                                    DialogType.error);
                              } else if (numberController.text.trim().length >
                                  8) {
                                final action = await Dialogs.yesAbortDialog(
                                    context,
                                    'Over ',
                                    'Phone Number is Over 8 number',
                                    DialogType.error);
                              } else if (numberController.text.trim().length <
                                  8) {
                                final action = await Dialogs.yesAbortDialog(
                                    context,
                                    'Under ',
                                    'Phone Number is Under 8 number',
                                    DialogType.error);
                              } else {
                                connectivity
                                    .checkConnectivity()
                                    .then((onValue) {
                                  if (onValue == ConnectivityResult.wifi ||
                                      onValue == ConnectivityResult.mobile) {
                                    setState(() {
                                      _Login(numberController.text.trim(),
                                          passwordController.text.trim());
                                      print("Conx valid");
                                    });
                                  } else {
                                    setState(() {
                                      print("no cnx ");
                                    });
                                  }
                                });
                              }
                            },
                            child: FadeAnimation(
                                1.6,
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Theme.mainColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      Translations.of(context)
                                          .text("app_login"),
                                      style: TextStyle(
                                          color: Theme.whiteColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          new GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterPhoneScreen()
                                  // MyApp(),
                                  ));
                            },
                            child: FadeAnimation(
                                1.6,
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Theme.mainColorAccent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      Translations.of(context)
                                          .text("txt_register"),
                                      style: TextStyle(
                                          color: Theme.whiteColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          FadeAnimation(
                              1.7,
                              Text(
                                Translations.of(context)
                                    .text("txt_social_media"),
                                style: TextStyle(color: Theme.greyColor),
                              )),
                          SizedBox(
                            height: 30,
                          ),
//                          Row(
//                            children: <Widget>[
//                              Expanded(
//                                child: FadeAnimation(
//                                    1.8,
//                                    Container(
//                                      height: 50,
//                                      decoration: BoxDecoration(
//                                          borderRadius:
//                                              BorderRadius.circular(50),
//                                          color: Colors.blue),
//                                      child: Center(
//                                        child: IconButton(
//                                            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
//                                            icon: FaIcon(
//                                              FontAwesomeIcons.facebookF,
//                                              color: Theme.whiteColor,
//                                            ),
//                                            onPressed: () async {
//                                              initiateFacebookLogin();
//                                            }),
//                                      ),
//                                    )),
//                              ),
//                              SizedBox(
//                                width: 20,
//                              ),
////                              Expanded(
////                                child: FadeAnimation(
////                                    1.9,
////                                    Container(
////                                      height: 50,
////                                      decoration: BoxDecoration(
////                                          borderRadius:
////                                              BorderRadius.circular(50),
////                                          color: Colors.deepOrange),
////                                      child: Center(
////                                        child: IconButton(
////                                            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
////                                            icon: FaIcon(
////                                              FontAwesomeIcons.googlePlusG,
////                                              color: Theme.whiteColor,
////                                            ),
////                                            onPressed: () {
////                                              print("Pressed");
////                                            }),
////                                      ),
////                                    )),
////                              )
//                            ],
//                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //String phone,String password

  void updateNotification(var phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.tokenNotification = prefs.getString('token_notification');
    String url = AppConfig.URL_UPDATE_TOKEN_NOTIFICATION;
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"phoneNumber": "$phone" , "apptoken":"$tokenNotification"}';
    // make POST request
    var response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;

    // this API passes back the id of the new item added to the body
    //print(token);
    print(statusCode);
    print("update client notification token");
  }

  void _Login(var phone, var password) async {
    String url = AppConfig.URL_LOGIN;
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"phoneNumber": "$phone" , "password": "$password", "typeAccount": "CLIENT"}';
    // make POST request
    var response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;

    // this API passes back the id of the new item added to the body
    //print(token);
    print(statusCode);

    if (statusCode == 402) {
      final action = await Dialogs.yesAbortDialog(
          context, 'PhoneNumber', 'Wrong PhoneNumber', DialogType.error);
    } else if (statusCode == 403) {
      final action = await Dialogs.yesAbortDialog(
          context, 'Password', 'Wrong Password', DialogType.error);
    } else {
      var data = jsonDecode(response.body);
      var token = data["token"];
      session.setToken(token);
      await getCurrentUser();
      session.setLoggedIn();
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //print(prefs.getString('token'));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()
              // MyApp(),
              ));
    }
  }

  getCurrentUser() async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
    }, onError: (error) {
      print(error);
    });
    String url = AppConfig.URL_GET_CURRENT_CLIENT;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = this.token;
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'auth': '$tt',
    });

    int statusCode = response.statusCode;
    var data = jsonDecode(response.body);
    _currentUser.id = data["id"];
    _currentUser.firstName = data["firstName"];
    _currentUser.lastName = data["lastName"];
    _currentUser.password = data["password"];
    _currentUser.email = data["email"];
    _currentUser.address = data["address"];

    _currentUser.city = data["city"];
    _currentUser.country = data["country"];
    _currentUser.image = data["Image"];
    //_currentUser.countryCode = int.parse(data["countryCode"]);
    //print(data["countryCode"]);
    //_currentUser.verified = data["verified"];
    _currentUser.fidelityPoints = data["fidelityPoints"];
    _currentUser.phoneNumber = data["phoneNumber"];

    _currentUser.createdAt = convertStringToDateTime(data["createdAt"]);
    _currentUser.updatedAt = convertStringToDateTime(data["updatedAt"]);
    // _currentUser.birthDate = data["birthDate"] ;
    _currentUser.birthDate = convertStringToDateTime(data["birthDate"]);
    // print(_currentUser);

/*

    String formattedDate = DateFoonValuermat('yyyy-MM-dd – kk:mm:ss').format(_currentUser.birthDate);
    print(formattedDate);
    */
    /* print ('Datetime:');

    print(_currentUser.createdAt);
    print ('Before upload :');
    print(_currentUser.createdAt.millisecondsSinceEpoch);
    print ('After upload :');
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(_currentUser.createdAt.millisecondsSinceEpoch -3600000);
    print(dateTime);*/
    // this API passes back the id of the new item added to the body
    //print(token);
    //print(statusCode);
    // _dbClient.DropTableIfExistsThenReCreate();
    _dbClient.save(_currentUser);
    //  print(_currentUser);
    // getStores(_currentUser.id);
    /*Future<User> all = _dbClient.getCurrentUser();
   all.asStream().forEach((element) => print(element));*/
    getEvents(_currentUser.id);
    getStores(_currentUser.id);
    getOrders(_currentUser.id);
    updateNotification(_currentUser.phoneNumber);
    print("sucess");
  }

  getEvents(var ClientId) async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
    }, onError: (error) {
      print(error);
    });
    String body = '{"ClientId":"$ClientId"}';
    String url = AppConfig.URL_GET_EVENTS;
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
    } else {
      List data = json.decode(response.body);
      // print(data);
      List<Event> _events = data.map((json) => Event.fromJson(json)).toList();

      setState(() {
        events = _events;
        events.forEach((f) {
          _dbClient.saveEvent(f);
        });
        _dbClient.getEvents().then((onValue) {
          onValue.forEach((s) {
            // print(s);
          });
        });
      });
    }
    //print(statusCode);
  }

  getOrders(var ClientId) async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
      print('Your Token HERE : ---------------> ' + tt);
    }, onError: (error) {
      print(error);
    });
    String body = '{"ClientId":"$ClientId"}';
    String url = AppConfig.URL_GET_ALL_ORDER;
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
      // print(data);
      print("Orders Fetched from server ");
      List<Order> _orders = data.map((json) => Order.fromJson(json)).toList();

      _orders.forEach((f) {
        _dbClient.saveOrder(f, f.store.id);
      });

      _orders.forEach((f) {
        f.productslines.forEach((productline) {
          print(f.id);
          _dbClient.saveProductLine(productline, f.id);
        });
      });
      _dbClient.getAllOrders().then((onValue) {
        print("Length Orders " + onValue.length.toString());
        onValue.forEach((f) {
          print(f);
        });
      });
      setState(() {
        orders = _orders;
//        orders.forEach((f) {
//          _dbClient.saveEvent(f);
//        });
//        _dbClient.getEvents().then((onValue) {
//          onValue.forEach((s) {
//            print(s);
//          });
//        });
        print(orders);
      });
    } else {
      print('Error' + statusCode.toString());
    }
    print(statusCode);
  }

  saveProductsByStore(var StoreId, Store store) async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
    }, onError: (error) {
      print(error);
    });
    String body = '{"StoreId":"$StoreId"}';
    String url = AppConfig.URL_GET_PPRODUCT_BYSTORE;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = this.token;
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'auth': '$tt',
        },
        body: body);

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      List data = json.decode(response.body);
      // print(data);
      List<Product> _products =
          data.map((json) => Product.fromJson(json, store)).toList();

      setState(() {
        products = _products;
        products.forEach((f) {
          _dbClient.saveProduct(f, StoreId);
        });
      });
      print("Product by store Fetched from server ");
    } else {
      print("StoreID doesnt exist ");
    }
  }

  getStores(var ClientId) async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
    }, onError: (error) {
      print(error);
    });
    String body = '{"ClientId":"$ClientId"}';
    String url = AppConfig.URL_GET_STORES;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = this.token;
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'auth': '$tt',
        },
        body: body);

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      List data = json.decode(response.body);
      // print(data);
      List<Store> _stores = data.map((json) => Store.fromJson(json)).toList();

      setState(() {
        stores = _stores;
        stores.forEach((f) {
          _dbClient.saveStore(f);
          saveProductsByStore(f.id, f);
        });
        _dbClient.getStores().then((onValue) {
          onValue.forEach((s) {
            // print(s);
          });
        });
      });
      print("store Fetched from server ");
    } else {
      print("StoreID doesnt exist ");
    }

    //print(statusCode);
  }

  DateTime convertStringToDateTime(String date) {
    DateTime dateTime = DateTime.parse(date);

    //print(dateTime);
    //print(dateTime);
    return dateTime;
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  void initiateFacebookLogin() async {
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        onLoginStatusChanged(true, profileData: profile);
        break;
    }
  }

  _logout() async {
    await facebookLogin.logOut();
    onLoginStatusChanged(false);
    print("Logged out");
  }
}
