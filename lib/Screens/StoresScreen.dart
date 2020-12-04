import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Screens/StoreDetailScreen.dart';
import 'package:app/Widgets/DrawerWidget.dart';
import 'package:app/Widgets/HomeTopWidget.dart';
import 'package:app/models/Store.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'PayScreen.dart';

void main() => runApp(MaterialApp(
      title: 'Home Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Theme.mainColor,
      ),
      home: StoreScreen(),
    ));

class StoreScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EmptyScreenState();
}

class EmptyScreenState extends State<StoreScreen> {
  DBClient _dbClient;
  Future<List<Store>> stores;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
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
    _dbClient = new DBClient();
    stores = _dbClient.getStores();
    print('start');
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('shake');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PayScreen()));
    });
  }

  Column bodyContainer() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        //I have set Safe area top to false in the bottom_navigation_widget
        // so I need to make a space for it here.
        SizedBox(
          height: 20,
        ),
        HomeTopWidget(),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(
              FontAwesomeIcons.store,
              color: Theme.mainColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              Translations.of(context).text("txt_stores_my_stores"),
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Playfair',
                  fontWeight: FontWeight.w600,
                  color: Theme.mainColor),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        FutureBuilder(
            future: stores,
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('None');
                  break;
                case ConnectionState.waiting:
                  return Text('Waiting');
                  break;
                case ConnectionState.active:
                  return Text('Active');
                  break;
                case ConnectionState.done:
                  return Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(snapshot.data.length, (index) {
                        return Container(
                          child: GestureDetector(
                            onTap: () async {
                              print(snapshot.data[index].id.toString());
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => StoreDetailScreen()));
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setInt('idStore', snapshot.data[index].id);
                            },
                            child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: AppConfig.URL_GET_IMAGE +
                                          snapshot.data[index].Image,
                                      //image builder
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 130,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill),
                                        ),
                                      ),

                                      //placeholder
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Theme.mainColorAccent,
                                        highlightColor: Theme.mainColorAccent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.whiteColor,
                                          ),
                                        ),
                                      ),
                                      //errorWidget
                                      errorWidget: (context, url, error) =>
                                          Shimmer.fromColors(
                                        baseColor: Theme.mainColorAccent,
                                        highlightColor: Theme.mainColorAccent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          snapshot.data[index].StoreName,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Playfair',
                                              fontWeight: FontWeight.w600,
                                              color: Theme.blackColor),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(snapshot
                                              .data[index].pointsInCurrentStore
                                              .toString() +
                                          " Points"),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      }),
                    ),
                  );
                  break;
              }
            }),
      ],
    );
  }
}
