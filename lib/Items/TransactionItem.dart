import 'package:app/App/AppConfig.dart';
import 'package:app/models/Order.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:app/utils/Utils.dart';
import 'package:flutter/material.dart';

import '../utils/LoadImage.dart';

class TransactionItem extends StatelessWidget {
  Order order = new Order();

  TransactionItem({this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        title: Text(
          Utils.capitalizeSentence(order.store.StoreName),
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Theme.blackColor),
        ),
        leading: LoadImage(
          AppConfig.URL_GET_IMAGE + order.store.Image,
          60,
          60,
          12,
          8,
          8,
        ),
        subtitle: new RichText(
          text: TextSpan(
            style:
                TextStyle(fontWeight: FontWeight.w600, color: Theme.blackColor),
            children: <TextSpan>[
              TextSpan(
                text: Utils.convertDateFromString(
                    order.date.toString(), "MMM dd"),
              ),
              TextSpan(
                  text: ', at ',
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.black54)),
              TextSpan(
                text: Utils.convertDateFromString(
                    order.date.toString(), "hh:mm a"),
              ),
            ],
          ),
        ),
        trailing: getPointsOrder(),
      ),
    );
  }

  getPointsOrder() {
    if (order.fPused) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Text(
              order.newTotalPrice.toString() + " TND",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text("- " + order.fidelityPointsEarned.toString() + " FP",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Theme.redColor)),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            Text(
              order.totalprice.toString() + " TND",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text("+ " + order.fidelityPointsEarned.toString() + " FP",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Theme.greenColor)),
          ],
        ),
      );
    }
  }
}
