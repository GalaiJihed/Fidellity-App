import 'package:app/Helper/DbClient.dart';
import 'package:app/Helper/translations.dart';
import 'package:app/Screens/EventDetailPopUp.dart';
import 'package:app/Widgets/DrawerWidget.dart';
import 'package:app/Widgets/HomeTopWidget.dart';
import 'package:app/models/Event.dart';
import 'package:app/models/Store.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shake/shake.dart';
import 'package:table_calendar/table_calendar.dart';

import 'PayScreen.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MaterialApp(
        title: 'Events Screen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Theme.mainColor,
        ),
        home: EventsScreen(),
      )));
}

class EventsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EmptyScreenState();
}

class EmptyScreenState extends State<EventsScreen> {
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  Future<List<Event>> myevents;

  List _selectedEvents;
  // AnimationController _animationController;
  DBClient _dbClient;
  Store store;
  Iterable<MapEntry<DateTime, List>> get newEntries => null;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Theme.whiteColor,
        drawer: DrawerWidget(),
        body: SafeArea(
          top: false,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  color: Theme.backgroundColor,
                  child: bodyContainer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<DateTime, List>> getTask1() async {
    Map<DateTime, List> mapFetch = {};
    List<Event> event = await _dbClient.getEvents();
    for (int i = 0; i < event.length; i++) {
      var createTime = DateTime(
          DateTime.parse(event[i].eventDate).year,
          DateTime.parse(event[i].eventDate).month,
          DateTime.parse(event[i].eventDate).day);
      var original = mapFetch[createTime];
      if (original == null) {
        print("null");
        mapFetch[createTime] = [event[i]];
      } else {
        print(event[i].eventName);
        mapFetch[createTime] = List.from(original)..addAll([event[i]]);
      }
    }

    return mapFetch;
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    String today =
        new DateFormat('y-MM-dd').format(new DateTime.now()).toString();
    DateTime todayDate = DateTime.parse(today);
    _events = new Map<DateTime, List<dynamic>>();

    //print(todayDate);
    final _selectedDay = todayDate;
    _dbClient = new DBClient();

    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTask1().then((val) => setState(() {
            _events = val;
          }));
      //print( ' ${_events.toString()} ');
    });

    /*

    // ignore: missing_return


    _dbClient.getEvents().then((onValue) {
      onValue.forEach((f) {
        int diffInDays =
            _selectedDay.difference(DateTime.parse(f.eventDate)).inDays;
        print(diffInDays);
        if (diffInDays == 0) {
          if (_events[_selectedDay]?.isNotEmpty ?? false) {
            List selectedDayEvents = new List();
            selectedDayEvents = _events[_selectedDay];
            selectedDayEvents.add(f.eventName);
            print(selectedDayEvents);
            _events[_selectedDay] = selectedDayEvents;
          } else {
            List selectedDayEvents = new List();
            selectedDayEvents = _events[_selectedDay];
            selectedDayEvents = new List();
            selectedDayEvents.add(f.eventName);
            _events[_selectedDay] = selectedDayEvents;
          }
        } else {
          if (_events[_selectedDay.add(Duration(days: diffInDays))]
                  ?.isNotEmpty ??
              false) {
            List selectedDayEvents = new List();
            selectedDayEvents =
                _events[_selectedDay.add(Duration(days: diffInDays))];
            selectedDayEvents.add(f.eventName);
            print(selectedDayEvents);
            _events[_selectedDay.add(Duration(days: diffInDays))] =
                selectedDayEvents;
          } else {
            List selectedDayEvents = new List();
            selectedDayEvents =
                _events[_selectedDay.add(Duration(days: diffInDays))];
            selectedDayEvents = new List();
            selectedDayEvents.add(f.eventName);
            _events[_selectedDay.add(Duration(days: diffInDays))] =
                selectedDayEvents;
          }
        }
      });
    });*/

    //print(_events);
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    //print('start');
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('shake');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PayScreen()));
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  getStore(var id) {
    _dbClient.getStoreById(id).then((value) {
      // Run extra code here
      store = value;
    }, onError: (error) {
      print(error);
    });
    return store;
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  Column bodyContainer() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        //I have set Safe area top to false in the bottom_navigation_widget
        // so I need to make a space for it here.
        SizedBox(
          height: 20,
        ),
        HomeTopWidget(),
        const SizedBox(height: 8.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(
              FontAwesomeIcons.solidCalendarCheck,
              color: Theme.mainColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              Translations.of(context).text("txt_events_my_events"),
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Playfair',
                  fontWeight: FontWeight.w600,
                  color: Theme.mainColor),
            ),
          ],
        ),
        _buildTableCalendar(),
        const SizedBox(height: 8.0),
        //_buildButtons(),
        const SizedBox(height: 8.0),
        Expanded(child: _buildEventList()),
        //
        //StackedAreaLineChart.withSampleData(),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Theme.whiteColor,
                    boxShadow: [
                      BoxShadow(blurRadius: 2.0, color: Colors.black12)
                    ]),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        event.eventName.toString(),
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat'),
                      ),
                      Text(
                        event.eventType.toString(),
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat'),
                      ),
                    ],
                  ),
                  leading: FaIcon(
                    FontAwesomeIcons.calendarDay,
                    color: Theme.mainColorAccent,
                  ),
                  trailing: FaIcon(
                    FontAwesomeIcons.arrowAltCircleRight,
                    color: Theme.mainColorAccent,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => EventDetail(
                        event: event,
                        store: Future(() => getStore(event.storeId)),
                      ),
                    );
                  },
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      locale: Translations.of(context).text("app_calendar"),
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Theme.mainColorAccent,
        todayColor: Theme.mainColor,
        markersColor: Theme.blackColor,
        outsideDaysVisible: true,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Theme.whiteColor, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Theme.mainColorAccent,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      availableCalendarFormats: {
        CalendarFormat.month:
            Translations.of(context).text("app_calendar_month"),
        CalendarFormat.twoWeeks:
            Translations.of(context).text("app_calendar_2_week"),
        CalendarFormat.week: Translations.of(context).text("app_calendar_week"),
      },
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  final Map<DateTime, List> _holidays = {
    DateTime(2019, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 1, 6): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 4, 21): ['Easter Sunday'],
    DateTime(2019, 4, 22): ['Easter Monday'],
  };
}
