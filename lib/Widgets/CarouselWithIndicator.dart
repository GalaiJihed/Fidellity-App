import 'package:app/Helper/translations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_locale/flutter_device_locale.dart';

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  static Future<Locale> locale;
  static final List<String> imgList = [
    'assets/3x/info1.png',
    'assets/3x/info2.png',
    'assets/3x/info3.png',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      locale = DeviceLocale.getCurrentLocale();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
//      CarouselSlider(
//        height: 500,
//        items: imgList.map((i) {
//          return Builder(
//            builder: (BuildContext context) {
//              return Container(
//                margin: EdgeInsets.all(5.0),
//                child: ClipRRect(
//                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                  child: Column(children: <Widget>[
//                    Image.asset(
//                      i,
//                      fit: BoxFit.cover,
//                      width: 500.0,
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    Text(
//                      Translations.of(context)
//                          .text("txt_info_digital_fidelity_card"),
//                      style: TextStyle(
//                        fontSize: 20,
//                        fontWeight: FontWeight.w500,
//                      ),
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    Text(Translations.of(context)
//                        .text("txt_info_dfc_description")),
//                  ]),
//                ),
//              );
//            },
//          );
//        }).toList(),
//        autoPlay: true,
//        enlargeCenterPage: false,
//        aspectRatio: 2.0,
//        onPageChanged: (index) {
//          setState(() {
//            _current = index;
//          });
//        },
//      ),
      CarouselSlider.builder(
          height: 500,
          itemCount: imgList.length,
          itemBuilder: (BuildContext context, int indexItem) {
            return Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Column(children: <Widget>[
                  Image.asset(
                    imgList[indexItem],
                    fit: BoxFit.cover,
                    width: 500.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    getTitlewithIndex(indexItem),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(getDescriptionwithIndex(indexItem)),
                      )),
                ]),
              ),
            );
          },
          autoPlay: true,
          enlargeCenterPage: false,
          aspectRatio: 2.0,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          }),
    ]);
  }

  getTitlewithIndex(int i) {
    switch (i) {
      case 0:
        return Translations.of(context).text("txt_info_digital_fidelity_card");
        break;
      case 1:
        return Translations.of(context).text("txt_info_offers_and_discount");
        break;
      case 2:
        return Translations.of(context).text("txt_info_points_and_history");

        break;
    }
  }

  getDescriptionwithIndex(int i) {
    switch (i) {
      case 0:
        return Translations.of(context).text("txt_info_dfc_description");
        break;
      case 1:
        return Translations.of(context).text("txt_info_od_description");
        break;
      case 2:
        return Translations.of(context).text("txt_info_ph_description");

        break;
    }
  }
}
