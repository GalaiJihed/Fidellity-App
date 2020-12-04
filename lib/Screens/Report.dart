import 'package:app/Animation/FadeAnimation.dart';
import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/models/Session.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

enum DialogAction { yes, abort }

class Report extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<Report> {
  final descriptionController = TextEditingController();
  int ClientId;
  DBClient _dbclient;
  Session session;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dbclient = new DBClient();
    session = new Session();
    _dbclient.getCurrentUser().then((currentUser) {
      if (currentUser.id != null) {
        ClientId = currentUser.id;
      }
    });
  }

  addReport() async {
    if (descriptionController.text.isEmpty) {
      /* final action = await Dialogs.yesAbortDialog(
          context, 'Empty Field', 'Wrong PhoneNumber', DialogType.error);*/
    } else {
      String token;
      String url = AppConfig.URL_CONTACT_US;
      String Message = descriptionController.text.toString();
      // body Data
      String json = '{"Message": "$Message","ClientId":"$ClientId"}';

      // ignore: non_constant_identifier_names
      session.getToken().then((value) {
        // Run extra code here
        token = value;
        print(token);
      }, onError: (error) {
        print(error);
      });
      // make POST request
      final response = await post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'auth': '$token',
          },
          body: json);
      // check the status code for the result
      int statusCode = response.statusCode;

      // Check status code from server
      print(statusCode);
      print("Done");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Theme.whiteColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Theme.shadowColor,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                Translations.of(context).text("txt_report_send_report"),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[200]))),
                child: TextFormField(
                  // ignore: missing_return
                  controller: descriptionController,
                  autofocus: true,
                  cursorRadius: Radius.circular(16.0),
                  autocorrect: true,
                  cursorColor: Theme.mainColorAccent,

                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: Translations.of(context)
                          .text("txt_report_please_describe_your__report"),
                      hintStyle: TextStyle(color: Theme.greyColor),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(height: 12.0),
              new GestureDetector(
                onTap: () async {
                  addReport();

                  Navigator.pop(context);
                },
                child: FadeAnimation(
                    1.6,
                    Container(
                      height: 40,
                      width: 150,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.mainColorAccent,
                      ),
                      child: Center(
                        child: Text(
                          "Send",
                          style: TextStyle(
                              color: Theme.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ),
              SizedBox(height: 5.0),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: Theme.mainColorAccent,
            radius: Consts.avatarRadius,
            child: FaIcon(
              FontAwesomeIcons.paperPlane,
              color: Theme.whiteColor,
              size: 70,
            ),
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
