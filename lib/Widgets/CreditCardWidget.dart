import 'package:app/Helper/DbClient.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';

class CreditCardWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreditCardWidgetState();
}

class CreditCardWidgetState extends State<CreditCardWidget> {
  Future _currentUser;
  DBClient dbClient;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbClient = new DBClient();
    _currentUser = dbClient.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, right: 16, left: 16, bottom: 38),
      child: Container(
        height: 220,
        decoration: new BoxDecoration(
          gradient: LinearGradient(begin: Alignment.centerLeft, colors: [
            Theme.cardBlackColor,
            Theme.cardGreyColor,
          ]),
          borderRadius: new BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Theme.shadowColor,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "••••• 3122",
                      style: TextStyle(
                        color: Theme.whiteColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Theme.shadowColor,
                          ),
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Theme.shadowColor,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints:
                          BoxConstraints(maxHeight: 80.0, maxWidth: 80.0),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Image.network(
                            'https://i.ibb.co/VBVqw1n/Fidelity-Icon.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: FutureBuilder(
                        future: _currentUser,
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text('None');
                              break;
                            case ConnectionState.waiting:
                              return Text('Loading');
                              break;
                            case ConnectionState.active:
                              return Text('Loading');
                              break;
                            case ConnectionState.done:
                              return Text(
                                snapshot.data.fidelityPoints.toString() +
                                    " Points",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.whiteColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 2.0,
                                      color: Theme.shadowColor,
                                    ),
                                  ],
                                ),
                              );
                              break;
                          }
                        }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
