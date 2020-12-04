import 'dart:async';
import 'dart:convert';

import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/models/Order.dart';
import 'package:app/models/Product.dart';
import 'package:app/models/Session.dart';
import 'package:app/models/Store.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/LoadImage.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:app/utils/Utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'PayScreen.dart';
import 'TransactionDetailScreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Home Screen',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Theme.mainColor,
    ),
    home: StoreDetailScreen(),
  ));
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
}

class StoreDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EmptyScreenState();
}

class EmptyScreenState extends State<StoreDetailScreen>
    with TickerProviderStateMixin {
  final LatLng center = const LatLng(36.900286, 10.184786);
  final double Lat = 36.900286;
  final double Lng = 10.184786;
  Store _store;
  Future<List<Product>> _products;
  DBClient _dbClient;
  static int timeChecked = 0;
  TabController _controller;
  Future<List<Order>> ordersStore;
  Session session;
  User _currentUser;
  var _connectionStatus;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: screenHeight * 0.4,
            child: CachedNetworkImage(
              imageUrl: AppConfig.URL_GET_IMAGE + _store.Image,
              //image builder
              imageBuilder: (context, imageProvider) => Container(
                height: screenHeight * 0.4,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.fill),
                ),
              ),

              //placeholder
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Theme.mainColorAccent,
                highlightColor: Theme.mainColorAccent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.whiteColor,
                  ),
                ),
              ),
              //errorWidget
              errorWidget: (context, url, error) => Shimmer.fromColors(
                baseColor: Theme.mainColorAccent,
                highlightColor: Theme.mainColorAccent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.whiteColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.whiteColor,
                  size: 30,
                ),
                onPressed: () {
                  print("pop");
                  Navigator.of(context).pop();
                }),
          ),
          Container(
            margin: EdgeInsets.only(top: screenHeight * 0.3),
            child: Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80.0),
              ),
              child: Container(
                padding:
                    EdgeInsets.only(left: 40, top: 30, right: 10, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _store.StoreName,
                          style: TextStyle(
                            color: Theme.mainColorAccent,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            RatingBar(
                              initialRating: 3,
                              minRating: 1,
                              itemSize: 20,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('180')
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: FaIcon(
                              _store.getIcon(),
                              size: 15,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            getTranslatedStoreType(_store.StoreType),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    new Container(
                      child: TabBar(
                        controller: _controller,
                        labelColor: Theme.mainColor,
                        indicatorColor: Theme.mainColor,
                        tabs: <Widget>[
                          Tab(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(Translations.of(context)
                                    .text("txt_locations")),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.shopping_basket,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(Translations.of(context)
                                    .text("txt_products")),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.history,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(Translations.of(context)
                                    .text("txt_history")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: new Container(
                            height: 270.0,
                            child: new TabBarView(
                              controller: _controller,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          child: SizedBox(
                                            height: screenHeight * 0.3,
                                            width: 300,
                                            child: Center(
                                              child: MapboxMap(
                                                onMapCreated: onMapCreated,
                                                scrollGesturesEnabled: false,
                                                rotateGesturesEnabled: false,
                                                tiltGesturesEnabled: false,
                                                zoomGesturesEnabled: true,
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: center,
                                                  zoom: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        RaisedButton(
                                          textColor: Theme.whiteColor,
                                          color: Theme.mainColorAccent,
                                          onPressed: () {
                                            MapsLauncher.launchCoordinates(
                                                Lat, Lng);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(
                                                Icons.my_location,
                                                color: Theme.whiteColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Navigate'),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FutureBuilder(
                                        future: _products,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container();
                                          } else {
                                            return new Flexible(
                                              child: GridView.count(
                                                crossAxisCount: 2,
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                children: List.generate(
                                                    snapshot.data.length,
                                                    (index) {
                                                  return Container(
                                                    child: GestureDetector(
                                                      onTap: () async {},
                                                      child: Card(
                                                          semanticContainer:
                                                              true,
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          elevation: 5,
                                                          margin:
                                                              EdgeInsets.all(
                                                                  10),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Column(
                                                            children: <Widget>[
                                                              SizedBox(
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: AppConfig
                                                                          .URL_GET_IMAGE +
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .image,
                                                                  //image builder
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    height: 110,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .fitHeight),
                                                                    ),
                                                                  ),

                                                                  //placeholder
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Shimmer
                                                                          .fromColors(
                                                                    baseColor: Theme
                                                                        .mainColorAccent,
                                                                    highlightColor:
                                                                        Theme
                                                                            .mainColorAccent,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  //errorWidget
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Shimmer
                                                                          .fromColors(
                                                                    baseColor: Theme
                                                                        .mainColorAccent,
                                                                    highlightColor:
                                                                        Theme
                                                                            .mainColorAccent,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5.0),
                                                                  child: Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .productName,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Playfair',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black),
                                                                  )),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            2.0),
                                                                child: Text(snapshot
                                                                        .data[
                                                                            index]
                                                                        .price
                                                                        .toString() +
                                                                    " TND"),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ]),
                                FutureBuilder(
                                  future: ordersStore,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    } else {
                                      return LiquidPullToRefresh(
                                        showChildOpacityTransition: false,
                                        color: Theme.mainColorAccent,
                                        onRefresh: () {
                                          // ignore: missing_return
                                          if (_connectionStatus ==
                                              ConnectivityResult.none) {
                                            return _dbClient
                                                .getOrdersByStoreId(_store);
                                          } else {
                                            return getOrdersByStore(
                                                _currentUser.id, _store.id);
                                          }
                                        },
                                        child: ListView.builder(
                                            padding: EdgeInsets.only(
                                                right: 6, left: 6),
                                            scrollDirection: Axis.vertical,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TransactionDetailScreen(
                                                                order: snapshot
                                                                        .data[
                                                                    index],
                                                              )
                                                          // MyApp(),
                                                          ));
                                                },
                                                child: getCard(
                                                    snapshot.data[index]),
                                              );
                                            }),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getCard(Order order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 2,
        color: Theme.whiteColor,
        child: ListTile(
          title: getPointsOrder(order),
          leading: CarouselSlider.builder(
              itemCount: order.productslines.length,
              autoPlay: true,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              itemBuilder: (BuildContext context, int itemIndex) {
                return LoadImage(
                  AppConfig.URL_GET_IMAGE +
                      order.productslines[itemIndex].product.image,
                  60,
                  60,
                  12,
                  8,
                  8,
                );
              }),
          subtitle: new RichText(
            text: TextSpan(
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Theme.blackColor),
              children: <TextSpan>[
                TextSpan(
                  text: Utils.convertDateFromString(
//                    order.date.toString(), "MMM dd"),
                      new DateTime.now().toString(),
                      "MMM dd"),
                ),
                TextSpan(
                    text: ', at ',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black54)),
                TextSpan(
                  text: Utils.convertDateFromString(
//                    order.date.toString(), "hh:mm a"),
                      new DateTime.now().toString(),
                      "hh:mm a"),
                ),
              ],
            ),
          ),
          //  trailing: getPointsOrder(),
        ),
      ),
    );
  }

  getTranslatedStoreType(String type) {
    if (_store.StoreType.substring(0, 1).toLowerCase() == 'm') {
      return Translations.of(context).text("Store");
    } else if (_store.StoreType.substring(0, 1).toLowerCase() == 'c') {
      return Translations.of(context).text("Coffee");
    } else if (_store.StoreType.substring(0, 1).toLowerCase() == 'r') {
      return Translations.of(context).text("Restaurant");
    }
  }

  getPointsOrder(Order order) {
    if (order.fPused) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text("- " + order.fidelityPointsEarned.toString() + " FP",
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Theme.redColor)),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text("+ " + order.fidelityPointsEarned.toString() + " FP",
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Theme.greenColor)),
      );
    }
  }

  getIconName() {
    if (_store.StoreType.substring(0, 1).toLowerCase() == 'm') {
      return "shop-15";
    } else if (_store.StoreType.substring(0, 1).toLowerCase() == 'c') {
      return "cafe-15";
    } else if (_store.StoreType.substring(0, 1).toLowerCase() == 'r') {
      return "restaurant-15";
    }
  }

  void onMapCreated(MapboxMapController controller) {
    controller.addSymbol(SymbolOptions(
        geometry: LatLng(
          center.latitude,
          center.longitude,
        ),
        iconSize: 1.5,
        iconImage: getIconName()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dbClient = new DBClient();

    //_products = new Future<List<Product>>(()=>1);
    _store = new Store();
    _currentUser = new User();
    this.session = new Session();
    _connectionStatus = ConnectivityResult.none;
    //Connectivity Code & Listener
    connectivity = new Connectivity();
    _controller = new TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int storeId = prefs.getInt('idStore');
      print(storeId);
      await _dbClient.getStoreById(storeId).then((val) => setState(() {
            _store = val;
            print('Store:' + val.toString());
          }));
      Future<List<Product>> p = _dbClient.getProductsByStoreId(storeId);
      setState(() {
        _products = p;
      });
      Future<List<Order>> o = _dbClient.getOrdersByStoreId(_store);
      setState(() {
        ordersStore = o;
      });
//      setState(() {
//        ordersStore = _dbClient.getOrdersByStoreId(_store);
//        ordersStore.then((onValue) {
//          onValue.forEach((f) =>
//              print("Order Length : " + f.productslines.length.toString()));
//        });
//        //print("orders client store Fetched from database");
//      });

      connectivity.checkConnectivity().then((onValue) {
        if (onValue == ConnectivityResult.wifi ||
            onValue == ConnectivityResult.mobile) {
          this._dbClient.getCurrentUser().then((onValue) {
            _currentUser = onValue;
            Future<List<Order>> o =
                getOrdersByStore(_currentUser.id, _store.id);
            setState(() {
              ordersStore = o;
            });
          });
        } else if (onValue == ConnectivityResult.none) {
          Future<List<Order>> o = _dbClient.getOrdersByStoreId(_store);
          setState(() {
            ordersStore = o;
          });
        }
      });
      //print( ' ${_events.toString()} ');
    });

    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result;
      //print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        this._dbClient.getCurrentUser().then((onValue) {
          _currentUser = onValue;
          Future<List<Order>> o = getOrdersByStore(_currentUser.id, _store.id);
          setState(() {
            ordersStore = o;
          });
        });
      } else {
        Future<List<Order>> o = _dbClient.getOrdersByStoreId(_store);
        setState(() {
          ordersStore = o;
        });
      }
    });
    //print(_store);
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('shake');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PayScreen()));
    });
  }

  Future<List<Order>> getOrdersByStore(int ClientId, int StoreId) async {
    String tt;
    List<Order> _orders = new List<Order>();
    print(ClientId.toString() + " " + StoreId.toString());
    await session.getToken().then((value) {
      tt = value;
      print(value);
    }, onError: (error) {
      print(error);
    });

    String body = '{"ClientId":"$ClientId","StoreId":"$StoreId"}';
    String url = AppConfig.URL_GET_ALL_ORDER_CLIENT_STORE;
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'auth': '$tt',
        },
        body: body);

    int statusCode = response.statusCode;

    if (statusCode == 404) {
      print(statusCode);

      print("Orders doesnt exist ");
    } else if (statusCode == 200) {
      List data = json.decode(response.body);
      print(200);
      _orders = data.map((json) => Order.fromJson(json)).toList();
    }
    return (Future(() => _orders));
    //print(statusCode);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
