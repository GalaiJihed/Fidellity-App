import 'package:app/Animation/FadeAnimation.dart';
import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/models/Order.dart';
import 'package:app/utils/LoadImage.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:app/utils/Utils.dart';
import 'package:app/utils/custom_shape.dart';
import 'package:app/utils/responsive_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class TransactionDetailScreen extends StatefulWidget {
  Order order;
  TransactionDetailScreen({this.order});
  @override
  TransactionDetailScreenState createState() =>
      TransactionDetailScreenState(order);
}

class TransactionDetailScreenState extends State<TransactionDetailScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  Order order;
  int current_step = 0;

  TransactionDetailScreenState(this.order);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(order.productslines.length);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.chevron_left, size: 40.0, color: Theme.blackColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.whiteColor,
          title: Text(
            Translations.of(context).text("txt_transaction_details"),
            style: TextStyle(color: Theme.blackColor),
          ),
        ),
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(
                  opacity: 0.88,
                  child: Container(
                    height: _height / 20,
                    width: _width,
                    padding: EdgeInsets.only(left: 15, top: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Theme.mainColorAccent, Theme.mainColor]),
                    ),
                  ),
                ),
                clipShape(),
                SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                  1.2,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.shoppingBag,
                        color: Theme.mainColor,
                        size: 30,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        Translations.of(context).text("txt_product_bought"),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.mainColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FadeAnimation(1.3, GetProductList())
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
                  colors: [Theme.mainColorAccent, Theme.mainColor],
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
                  colors: [Theme.mainColorAccent, Theme.mainColor],
                ),
              ),
            ),
          ),
        ),
        FadeAnimation(
          1.1,
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
              height: _height / 3.5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.0,
                        color: Theme.shadowColor,
                        offset: Offset(1.0, 10.0),
                        blurRadius: 20.0),
                  ],
                  color: Theme.whiteColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new NetworkImage(
                            AppConfig.URL_GET_IMAGE + order.store.Image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Theme.blackColor, Colors.transparent],
                      ),
//                      boxShadow: [
//                        BoxShadow(
//                          spreadRadius: 0.0,
//                          color: Colors.black,
//                          offset: Offset(0.0, 0.0),
//                        )
//                        // blurRadius: 40.0),
//                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        new Positioned(
                          left: 10.0,
                          bottom: 30.0,
                          child: new Text(
                              order.store.StoreName +
                                  " " +
                                  Translations.of(context).text("txt_Receipt"),
                              style: new TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                                color: Theme.whiteColor,
                              )),
                        ),
                        new Positioned(
                          left: 10.0,
                          bottom: 10.0,
                          child: new Text(getAmount(),
                              style: new TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0,
                                color: Theme.whiteColor,
                              )),
                        ),
                        new Positioned(
                          right: 10.0,
                          bottom: 10.0,
                          child: new RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.whiteColor,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: Utils.convertDateFromString(
//                    order.date.toString(), "MMM dd"),
                                      order.date.toString(),
                                      "MMM dd"),
                                ),
                                TextSpan(
                                    text: " " +
                                        Translations.of(context)
                                            .text("txt_at") +
                                        " ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.whiteColor,
                                    )),
                                TextSpan(
                                  text: Utils.convertDateFromString(
//                    order.date.toString(), "hh:mm a"),
                                      order.date.toString(),
                                      "hh:mm a"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget GetProductList() {
    return Container(
        child: Timeline.builder(
      itemCount: order.productslines.length,
      itemBuilder: leftProductBuilder,
      position: TimelinePosition.Left,
      lineColor: Theme.mainColorAccent,
      lineWidth: 2,
      shrinkWrap: true,
    ));
  }

  TimelineModel leftProductBuilder(BuildContext context, int i) {
    final product = order.productslines[i].product;
    final productline = order.productslines[i];
    return TimelineModel(
        Card(
          elevation: 2,
          color: Theme.whiteColor,
          child: ListTile(
            title: Text(product.productName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Theme.mainColorAccent,
                )),
            leading: LoadImage(
              AppConfig.URL_GET_IMAGE + product.image,
              60,
              60,
              12,
              8,
              8,
            ),
            subtitle: new RichText(
              text: TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Theme.blackColor),
                children: <TextSpan>[
                  TextSpan(
                      text: Translations.of(context)
                              .text("txt_transaction_quantity") +
                          productline.quantity.toString()),
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    product.price.toString() + " TND",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    product.fp.round().toString() + " FP",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Theme.greenColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        isFirst: i == 0,
        isLast: i == order.productslines.length,
        iconBackground: Theme.mainColorAccent,
        icon: Icon(
          Icons.add_shopping_cart,
          color: Theme.whiteColor,
        )
        // iconBackground: doodle.iconBackground,
        );
  }

  String getAmount() {
    if (order.fPused) {
      return Translations.of(context).text("txt_new_total") +
          " : " +
          order.newTotalPrice.toString() +
          " TND";
    } else
      return Translations.of(context).text("txt_total") +
          " : " +
          order.totalprice.toString() +
          " TND";
  }
}
