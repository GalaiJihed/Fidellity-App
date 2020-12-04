import 'package:app/Helper/translations.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';

class TransactionsHeaderWidget extends StatefulWidget {
  @override
  _TransactionsHeaderWidgetState createState() =>
      _TransactionsHeaderWidgetState();
}

class _TransactionsHeaderWidgetState extends State<TransactionsHeaderWidget> {
  String dropdownValue = "Recent";

  String Recent, Oldest, Highest, Lowest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dropdownValue = Translations.of(context).text("Recent");
//    Recent= Translations.of(context).text("Recent");
//    Oldest= Translations.of(context).text("Oldest");
//    Highest= Translations.of(context).text("Highest");
//    Lowest= Translations.of(context).text("Lowest");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25.0),
      decoration: new BoxDecoration(
        color: Theme.whiteColor,
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          });
                        },
                        items: <String>['Oldest', 'Recent', 'Highest', 'Lowest']
                            .map<DropdownMenuItem<String>>((String value) {
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
    );
  }
}
