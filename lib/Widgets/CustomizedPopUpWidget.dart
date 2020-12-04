import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';

class MyTemplate extends BeautifulPopupTemplate {
  final BeautifulPopup options;
  MyTemplate(this.options) : super(options);

  @override
  final illustrationPath = 'img/bg/success.png';
  @override
  Color get primaryColor => options.primaryColor ?? Color(0xff4ABDFE);
  @override
  final maxWidth = 400;
  @override
  final maxHeight = 588;
  @override
  final bodyMargin = 30;
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
        left: percentW(8),
        right: percentW(8),
        height: percentH(actions == null ? 40 : 24),
        child: content,
      ),
      Positioned(
        bottom: percentW(8),
        left: percentW(8),
        right: percentW(8),
        child: actions ?? Container(),
      ),
    ];
  }
}
