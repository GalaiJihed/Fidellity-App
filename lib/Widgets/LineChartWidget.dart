import 'dart:convert';

import 'package:app/App/AppConfig.dart';
import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/models/Point.dart';
import 'package:app/models/Session.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LineChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  bool isShowingMainData;
  List<Point> dataChart;
  Session session;
  Future<User> _currentUser;
  DBClient _dbClient;
  List<String> months;
  var All = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AOU",
    "SEP",
    "NOV",
    "DEC"
  ];
  int maxPoint, minPoint;
  final format = new DateFormat('MMM');
  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    session = new Session();
    this._dbClient = new DBClient();
    _currentUser = this._dbClient.getCurrentUser();
    dataChart = new List<Point>();
    months = new List<String>();
    minPoint = 0;
    maxPoint = 1;
    LoadData();
  }

  LoadData() async {
    String tt;

    session.getToken().then((value) {
      // Run extra code here
      tt = value;
    }, onError: (error) {
      print(error);
    });
    User user = await _currentUser;
    var phone = user.phoneNumber;
    var body = '{"phoneNumber": "$phone"}';
    String url = AppConfig.URL_STAT_CHART;
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'auth': '$tt',
        },
        body: body);

    int statusCode = response.statusCode;

    if (statusCode == 403) {
      print(statusCode);

      print("ClientId doesnt exist ");
    } else if (statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        dataChart = data.map((json) => Point.fromJson(json)).toList();
        // print(dataChart);
        dataChart.forEach((f) {
          if (f.nbr > maxPoint) {
            maxPoint = f.nbr;
          }
          months.add(All[f.mth - 1]);
        });
      });
    }
    print("Max Point " + maxPoint.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: const [
              Theme.darkBlueColor,
              Theme.mainColorAccent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Text(
                  Translations.of(context).text("app_home_monthly_history"),
                  style: TextStyle(
                      color: Theme.whiteColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      sampleData1(),
                      swapAnimationDuration: Duration(milliseconds: 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Theme.whiteColor.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {
          print(touchResponse);
        },
        handleBuiltInTouches: true,
      ),
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
            color: Theme.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'APR';
              case 7:
                return 'MAY';
              case 13:
                return 'JUIN';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Theme.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Theme.whiteColor,
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 14,
      maxY: 4,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  getMonthByValue() {}

  List<LineChartBarData> linesBarData1() {
    LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: const [
        FlSpot(0, 0),
        FlSpot(7, 1),
        FlSpot(14, 3),
      ],
      isCurved: true,
      colors: const [
        Theme.whiteColor,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true, dotColor: Theme.whiteColor),
      belowBarData: BarAreaData(show: true, colors: [
        Theme.whiteColor.withOpacity(0.4),
      ]),
    );
    return [
      lineChartBarData3,
    ];
  }
}
