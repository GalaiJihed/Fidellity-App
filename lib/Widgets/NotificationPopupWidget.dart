import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';

class NotificationPopup extends BeautifulPopupTemplate {
  final BeautifulPopup options;
  NotificationPopup(this.options) : super(options);

  @override
  Color get primaryColor => options.primaryColor ?? Color(0xff4ABDFE);
  @override
  final maxWidth = 400;
  @override
  final maxHeight = 588;
  @override
  final bodyMargin = 0;
  @override
  get layout {
    return [
      Positioned(
        child: background,
      ),
      Positioned(
        top: percentH(46),
        child: title,
      ),
      Positioned(
        top: percentH(58),
        left: percentW(0),
        right: percentW(0),
        height: percentH(actions == null ? 40 : 24),
        child: content,
      ),
      Positioned(
        bottom: percentW(0),
        left: percentW(0),
        right: percentW(0),
        child: actions ?? Container(),
      ),
    ];
  }
}
