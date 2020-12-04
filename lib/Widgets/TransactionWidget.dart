import 'dart:async';
import 'dart:convert';

import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Screens/TransactionDetailScreen.dart';
import 'package:app/models/Order.dart';
import 'package:app/models/Session.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../Items/TransactionItem.dart';

class TransactionsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TransactionWidgetState();
}

class TransactionWidgetState extends State<TransactionsWidget> {
  Future<List<Order>> orders;
  List<Order> _orders;
  DBClient _dbClient;
  String dropdownValue = "Recent";

  Session session;
  User _currentUser;
  var _connectionStatus;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription, firstCheck;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 25.0),
            decoration: new BoxDecoration(
              color: Theme.whiteColor,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    Translations.of(context).text("app_home_my_transactions"),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Theme.blackColor),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        Translations.of(context).text("app_home_sort_by"),
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Theme.backgroundColor,
                            borderRadius: new BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              elevation: 0,
                              underline: Container(
                                color: Theme.backgroundColor,
                              ),
                              style: TextStyle(color: Theme.deepPurpleColor),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                  orders = reorderList(newValue);
                                });
                              },
                              items: <String>[
                                'Oldest',
                                'Recent',
                                'Highest',
                                'Lowest'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Theme.blueColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: LiquidPullToRefresh(
                    showChildOpacityTransition: false,
                    color: Theme.mainColorAccent,
                    onRefresh: () {
                      // ignore: missing_return
                      if (_connectionStatus == ConnectivityResult.none) {
                        setState(() {
                          dropdownValue = "Recent";
                        });
                        return _dbClient.getAllOrders();
                      } else {
                        setState(() {
                          dropdownValue = "Recent";
                        });
                        return getOrders(_currentUser.id);
                      }
                    },
                    child: FutureBuilder(
                        future: orders,
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Container();
                              break;
                            case ConnectionState.waiting:
                              return Container();
                              break;
                            case ConnectionState.active:
                              return Container();
                              break;
                            case ConnectionState.done:
                              return ListView.builder(
                                  padding: EdgeInsets.only(right: 6, left: 6),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionDetailScreen(
                                                      order:
                                                          snapshot.data[index],
                                                    )
                                                // MyApp(),
                                                ));
                                      },
                                      child: TransactionItem(
                                          order: snapshot.data[index]),
                                    );
                                  });
                              break;
                          }
                        }),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Order>> reorderList(String text) async {
    List<Order> newList = new List<Order>();
    if (_connectionStatus != ConnectivityResult.none) {
      switch (text) {
        case 'Oldest':
          {
            newList = _orders;
            newList.sort((a, b) => a.date.compareTo(b.date));
            return (Future(() => newList));
          }
          break;
        case 'Recent':
          {
            newList = _orders;
            newList.sort((a, b) => -a.date.compareTo(b.date));
            return (Future(() => newList));
          }
          break;
        case 'Lowest':
          {
            newList = _orders;
            newList.sort((a, b) {
              if (a.fPused && b.fPused) {
                return a.newTotalPrice.compareTo(b.newTotalPrice);
              } else if (a.fPused && !b.fPused) {
                return a.newTotalPrice.compareTo(b.totalprice);
              } else if (!a.fPused && b.fPused) {
                return a.totalprice.compareTo(b.newTotalPrice);
              } else {
                return a.totalprice.compareTo(b.totalprice);
              }
            });
            return (Future(() => newList));
          }
          break;
        case 'Highest':
          {
            newList = _orders;
            newList.sort((a, b) {
              if (a.fPused && b.fPused) {
                return -a.newTotalPrice.compareTo(b.newTotalPrice);
              } else if (a.fPused && !b.fPused) {
                return -a.newTotalPrice.compareTo(b.totalprice);
              } else if (!a.fPused && b.fPused) {
                return -a.totalprice.compareTo(b.newTotalPrice);
              } else {
                return -a.totalprice.compareTo(b.totalprice);
              }
            });
            return (Future(() => newList));
          }
          break;
      }
    } else {
      switch (text) {
        case 'Oldest':
          {
            newList = await this._dbClient.getAllOrders();
            newList.sort((a, b) => a.date.compareTo(b.date));
            return (Future(() => newList));
          }
          break;
        case 'Recent':
          {
            newList = await this._dbClient.getAllOrders();
            newList.sort((a, b) => -a.date.compareTo(b.date));
            return (Future(() => newList));
          }
          break;
        case 'Lowest':
          {
            newList = await this._dbClient.getAllOrders();
            newList.sort((a, b) {
              if (a.fPused && b.fPused) {
                return a.newTotalPrice.compareTo(b.newTotalPrice);
              } else if (a.fPused && !b.fPused) {
                return a.newTotalPrice.compareTo(b.totalprice);
              } else if (!a.fPused && b.fPused) {
                return a.totalprice.compareTo(b.newTotalPrice);
              } else {
                return a.totalprice.compareTo(b.totalprice);
              }
            });
            return (Future(() => newList));
          }
          break;
        case 'Highest':
          {
            newList = await this._dbClient.getAllOrders();
            newList.sort((a, b) {
              if (a.fPused && b.fPused) {
                return -a.newTotalPrice.compareTo(b.newTotalPrice);
              } else if (a.fPused && !b.fPused) {
                return -a.newTotalPrice.compareTo(b.totalprice);
              } else if (!a.fPused && b.fPused) {
                return -a.totalprice.compareTo(b.newTotalPrice);
              } else {
                return -a.totalprice.compareTo(b.totalprice);
              }
            });
            return (Future(() => newList));
          }
          break;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._dbClient = new DBClient();
    this.session = new Session();
    _connectionStatus = ConnectivityResult.none;
    //Connectivity Code & Listener
    connectivity = new Connectivity();
    connectivity.checkConnectivity().then((onValue) {
      if (onValue == ConnectivityResult.wifi ||
          onValue == ConnectivityResult.mobile) {
        this._dbClient.getCurrentUser().then((onValue) {
          _currentUser = onValue;
          getOrders(_currentUser.id);
        });
      } else {
        setState(() {
          _orders = getOrdersDatabase();
          print(_orders.length);
          orders = this._dbClient.getAllOrders();
//          orders.then((onValue) =>
//              onValue.forEach((f) => print(f.productslines.length)));
        });
        print("Orders Fetched from database");
      }
    });
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result;
      //print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        this._dbClient.getCurrentUser().then((onValue) {
          _currentUser = onValue;
          getOrders(_currentUser.id);
        });
      } else {
        setState(() {
          _orders = getOrdersDatabase();
          orders = this._dbClient.getAllOrders();
          print("Orders Fetched from database");
        });
      }
    });
  }

  List<Order> getOrdersDatabase() {
    List<Order> or = new List<Order>();
    this._dbClient.getAllOrders().then((onValue) {
      or = onValue;
      print(onValue);
      return or;
    });
  }

  Future<List<Order>> getOrders(var ClientId) async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
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
      List<Order> _orderss = data.map((json) => Order.fromJson(json)).toList();

      _orderss.sort((a, b) => -a.date.compareTo(b.date));
      //_orders = _orders.reversed;

      setState(() {
        _orders = _orderss;
        orders = (Future(() => _orderss));
      });
      print("Orders Fetched from internet.");
    }

    //print(statusCode);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
