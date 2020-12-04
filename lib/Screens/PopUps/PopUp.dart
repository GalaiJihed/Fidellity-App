import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum DialogAction { yes, abort }
enum DialogType { error, warning, success, offline, online }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String body,
    DialogType type,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                getImageFromType(type),
                SizedBox(
                  height: 10,
                ),
                Text(
                  body,
                  style: TextStyle(
                    color: Theme.blackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Playfair',
                  ),
                ),
                //Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.yes),
              color: getColorFromType(type),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Theme.whiteColor,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }

  static Widget getImageFromType(DialogType type) {
    switch (type) {
      case DialogType.error:
        return FaIcon(
          FontAwesomeIcons.solidTimesCircle,
          color: Theme.redColor,
          size: 120,
        );
        break;
      case DialogType.warning:
        return FaIcon(
          FontAwesomeIcons.exclamationCircle,
          color: Theme.amberColor,
          size: 120,
        );
        break;
      case DialogType.success:
        return FaIcon(
          FontAwesomeIcons.solidCheckCircle,
          color: Theme.greenColor,
          size: 120,
        );
        break;
      case DialogType.offline:
        return Icon(
          Icons.signal_wifi_off,
          color: Theme.redColor,
          size: 120,
        );
        break;
      case DialogType.online:
        return FaIcon(
          FontAwesomeIcons.wifi,
          color: Theme.greenColor,
          size: 120,
        );
        break;
    }
  }

  static Color getColorFromType(DialogType type) {
    switch (type) {
      case DialogType.error:
        return Theme.redColor;
        break;
      case DialogType.warning:
        return Theme.amberColor;
        break;
      case DialogType.success:
        return Theme.greenColor;
        break;
      case DialogType.offline:
        return Theme.redColor;
        break;
      case DialogType.online:
        return Theme.greenColor;
        break;
    }
  }
}
