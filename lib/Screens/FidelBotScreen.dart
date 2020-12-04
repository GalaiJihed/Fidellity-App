import 'package:app/Widgets/DrawerWidget.dart';
import 'package:app/Widgets/HomeTopWidget.dart';
import 'package:app/models/Message.dart';
import 'package:app/models/User.dart';
import 'package:app/utils/Theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';

import 'PayScreen.dart';

void main() => runApp(MaterialApp(
      title: 'Home Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FidelBotScreen(),
    ));

class FidelBotScreen extends StatefulWidget {
  final User user;

  const FidelBotScreen({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => FidelBotScreenState(user);
}

class FidelBotScreenState extends State<FidelBotScreen> {
  final List<Message> _messages = <Message>[];
  final TextEditingController _textController = new TextEditingController();
  final User user;

  FidelBotScreenState(this.user);

  Widget _queryInputWidget(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _submitQuery,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _submitQuery(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _dialogFlowResponse(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/fidelbot.json").build();
    Dialogflow dialogFlow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogFlow.detectIntent(query);
    Message message = Message(
      text: response.getMessage() ??
          CardDialogflow(response.getListMessage()[0]).title,
      name: "FidelBot",
      image: "assets/images/FidelBot.png",
      dateTime: DateTime.now(),
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _submitQuery(String text) {
    _textController.clear();
    Message message = new Message(
      text: text,
      name: user.firstName + " " + user.lastName,
      image: user.image,
      dateTime: DateTime.now(),
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _dialogFlowResponse(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      body: SafeArea(
        top: false,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                color: Color(0xffe8f2fc),
                child: bodyContainer(),
              ),
            ),
          ],
        ),
      ),
    );
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
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(
              FontAwesomeIcons.robot,
              color: Theme.mainColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "FidelBot Assistance",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Playfair',
                  fontWeight: FontWeight.w600,
                  color: Theme.mainColor),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true, //To keep the latest messages at the bottom
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        Divider(height: 1.0),
        Container(
          decoration: new BoxDecoration(color: Theme.backgroundColor),
          child: _queryInputWidget(context),
        ),
        //
        //StackedAreaLineChart.withSampleData(),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('start');
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('shake');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PayScreen()));
    });
  }
}
