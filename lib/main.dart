import 'package:facebook_reaction_animation/fb_reaction_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(new MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Facebook Reactions by Flutter',
        theme: new ThemeData(
            primaryColor: new Color(0xff3b5998),
            accentColor: new Color(0xff3b5998)),
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('MAIN'),
              centerTitle: true,
            ),
            body: new MainScreen()));
  }
}

class MainScreen extends StatefulWidget {
  @override
  State createState() => new MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  static List<double> timeDelays = [1.0, 2.0, 3.0, 4.0, 5.0];
  int selectedIndex = 0;

  onSpeedSettingPress(int index) {
    timeDilation = timeDelays[index];
    setState(() {
      selectedIndex = index;
    });
  }

  buildList() {
    final List<Widget> list = [
      new Text(
        'SPEED:',
        style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
      )
    ];

    timeDelays.asMap().forEach((index, delay) {
      list.add(Container(
        child: new GestureDetector(
          onTap: () => onSpeedSettingPress(index),
          child: new Container(
            child: new Text(delay.toString(),
                style: new TextStyle(color: Colors.white)),
            padding: new EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              color: index == selectedIndex
                  ? Color(0xff3b5998)
                  : Color(0xffDAA520),
              borderRadius: new BorderRadius.circular(20.0),
            ),
          ),
        ),
        margin: new EdgeInsets.all(5.0),
      ));
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Center(
          child: new Column(
        children: <Widget>[
          new Container(
            child: new Row(children: buildList()),
            margin: new EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
          ),
          new Container(
            height: 15.0,
          ),
          buildButton(
              context, 'Facebook reactions animation', new FbReactionBox())
        ],
      )),
    );
  }

  Widget buildButton(
      BuildContext context, String name, StatelessWidget screenTo) {
    return new FlatButton(
      onPressed: () => Navigator.push(
          context, new MaterialPageRoute(builder: (context) => screenTo)),
      child: new Container(
        child: new Text(
          name,
          style: new TextStyle(color: Colors.white, fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
        width: 270.0,
      ),
      color: new Color(0xff3b5998),
      highlightColor: new Color(0xff8b9dc3),
      padding: new EdgeInsets.all(12.0),
    );
  }
}
